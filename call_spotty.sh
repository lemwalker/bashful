#!/bin/bash
function error() { echo -e "$1" >&2; }

APP_NAME=$(echo 'c3BvdGlmeQo=' | base64 -d)
PROFILE_URL=$(printf 'https://api.%s.com/v1/me' "$APP_NAME")
API_URL=$(printf 'https://api.%s.com/v1' "$APP_NAME")
TOKEN_URL=$(printf "https://accounts.%s.com/api/token" "$APP_NAME")
market_id='US'
secret_file=~/.spotty_secret   # path to file containing client_secret
id_file=~/.spotty_id           # path to file containing client_id
token_file=~/.spotty_token     # path to file containing temporary bearer token

# TODO: Set one of these variables
artist_id=''        # argument for get_artist_albums()
album_query=''      # argument for get_album_search()

if [[ -n "$artist_id" ]] ; then
  artist_endpoint=$(printf '%s/artists' "$API_URL")
  artist_url=$(printf '%s/%s' "$artist_endpoint" "$artist_id")
fi

IS_MACOS=0
if [[ $(uname -a) =~ Darwin ]]; then
    IS_MACOS=1
fi

secret=''
client_id=''

function get_token_cmd() {
    local _id="$1"
    local _secret="$2"
    if [[ -z "$_id" || -z "$_secret"  ]]; then
        error "missing arguments"
        error "arg1: client id: $_id"
        error "arg2: secret: $_secret"
        return 1
    fi
    local _data=$(printf 'grant_type=client_credentials&client_id=%s&client_secret=%s' "$_id" "$_secret")
    local _head="Content-Type: application/x-www-form-urlencoded"
    local _cmd=$(printf 'curl -X POST "%s" -H "%s" -d "%s"' "$TOKEN_URL" "$_head" "$_data" )
    echo "$_cmd"
}

# validate required variables
if [[ -r "$secret_file" ]]; then
    secret=$(head -n1 "$secret_file")
fi
if [[ -r "$id_file" ]]; then
    client_id=$(head -n1 "$id_file")
fi
if [[ -z "$secret" ]]; then
    error "Client secret not found"
    exit 1
fi
if [[ -z "$client_id" ]]; then
    error "Client ID not found"
    exit 1
fi

####  Authorize
##  check for recent token file. create new one if needed
##  only get a new token when needed
has_token=0
bearer_token=''

# TODO: `stat` is different between linux and osx
if [[ -f "$token_file" ]] ; then
    if [[ "$IS_MACOS" == 1 ]]; then
        mtime=$(stat --format '%Y' "$token_file") # osx version of stat
    else
        mtime=$(stat -f '%m' "$token_file")  # gnu/linux version of stat
    fi
    existing_token="$(head -n1 $token_file)"

    expire_time=$(( mtime + 3600 ))
    now=$(date +%s)
    seconds_left=$(( expire_time - now ))
    if [[ -n "$existing_token" && "$seconds_left" -ge 30 ]]; then
        bearer_token="$existing_token"
        has_token=1
    #else error "need a new token. sec remain: $seconds_left token: $existing_token"
    fi
fi

if [[ "$has_token" != 1  ]]; then
    # get a new token
    t_cmd=$(get_token_cmd "$client_id" "$secret")
    t_response=$(eval "$t_cmd")
    bearer_token=$(echo "$t_response" | sed -En 's/.*"access_token":"([^"]+)".*/\1/p')
    if [[ -n "$bearer_token" ]]; then
        echo "$bearer_token" > "$token_file"
        #error "updated token file $token_file"
        has_token=1
    else
        error "Failed to get bearer token from response"
        error "request:"
        error "$t_cmd"
        error "response:"
        error "$t_response"
    fi
fi

if [[ -z "$bearer_token" ]]; then
    error "Failed to get bearer token"
    exit 1
fi
####

header=$(printf 'Authorization: Bearer  %s' "$bearer_token")

function get_album_search() {
    # TODO - proper utf8 encoding
    local _query=$(echo "$1" | sed -E 's/[^A-Za-z0-9_]/%20/g')
    local _header="$2"
    local _type='album'
    #local _url=$(printf '%s/search?q=%s&type=%s' "$API_URL" "$_query" "$_type")
    local _url=$(printf '%s/search?q=%s&type=%s&market=%s' "$API_URL" "$_query" "$_type" "$market_id")
    printf "curl --request GET --url '%s' --header '%s'" "$_url" "$_header"
}

## search artist alumns
function get_artist_albums() {
    local _artist_id="$1" # TODO validate id value
    local _header="$2"
    local _url=$(printf '%s/artists/%s/albums?include_groups=album&market=%s' "$API_URL" "$_artist_id" "$market_id")
    printf "curl --request GET --url '%s' --header '%s'" "$_url" "$_header"
}

if [[ -n "$artist_id" ]]; then
    _cmd=$(get_artist_albums "$artist_id" "$header")
elif [[ -n "$album_query" ]]; then
    _cmd=$(get_album_search  "$album_query"  "$header")
else
    error "# Set variable artist_id to search for albums by artist"
    error "# Set variable album_query to search for albums by name"
fi

error "# $_cmd" # print the command

response=$(eval "$_cmd") # make the call
rc=$? # TODO: replace with check for  status codes '200' et al
if [[ "$rc" == 0 ]]; then
    echo "$response"
else
    error "return code $rc"
fi
exit $rc

