#!/bin/bash

function error() { echo -e "$1" >&2; }

function get_element() {
    # 1: field, 2: JSON (as String)
    [[ -z "$1"  || -z "$2" ]] && echo "" || \
        echo "$2" | jq "$1" 2>/dev/null | sed 's/"//g'
}

# make sure jq is installed
if ! which jq > /dev/null ; then
    error "Install jq before running."
    exit 1
fi

if [[ -n "$1" ]]; then
    # replace spaces with '%20'
    query=$(echo "$1" | sed -r "s/ /%20/g")
    qname=$(echo "$1" | sed -r "s/ /_/g")
else
    error "USAGE: $0 'QUERY'"
    exit 1
fi

# TODO: put this somewhere better; rename $token
if ! source ./reverb_token ; then
    error "Failed to read token"
    exit 1
fi

header_args=(
    "Authorization: Bearer ${token}"
    "Content-Type: application/hal+json"
    "Accept-Version: 3.0"
    "Accept: application/hal+json"
)

base_url="https://api.reverb.com/api"
url=$(printf "%s/listings/?query=%s" "$base_url" "$query" )
header=$(printf " -H '%s' " "${header_args[@]}")

fields=(
    'TotalPrice:((.price.amount_cents + .shipping.rates[0].rate.amount_cents) / 100)'
    'Condition:.condition.slug'
    'PreferredSeller:.shop.preferred_seller'
    'ListingURL:._links.web.href'
    'CreatedAt:.created_at'
)

_tmp=$(mktemp -t "${qname}_XXXX")
echo "Temp file: $_tmp"

# build filter from array
# TODO: better to use an array of strings formatted as 'key:value'
#   translates better to `jq '.listings[] | {key1:value1}'`

# transform fields array to comma-separated line
obj_filter=$(printf "%s,"  "${fields[@]}" | sed 's/,$//')


len="${#labels[@]}"

# TODO: print
#val_filter=$(printf "%s\n" "${fields[@]}" | sed "s/^.*://" | tr $'\n' ',' | sed "s/, *$//")
#error "val filter: '$val_filter'"
error "obj filter: '$obj_filter'"


# make the initial call
s_cmd=$(printf "curl %s -X GET '%s'" "$header" "$url")
resp=$(eval "$s_cmd" 2>/dev/null)
#resp=$(eval "$s_cmd")

if [[ -z "$resp" ]]; then
    error "No response exeuting command '$s_cmd'"
    exit 1
fi

page=$(get_element ".current_page" "$resp")
error "# first page: $page"
next_url=$(get_element "._links.next.href" "$resp")
total_pages=$(get_element ".total_pages"  "$resp" )
result_count=$(get_element ".total" "$resp")

if [[ $result_count -lt 1 ]]; then
    error "No results found for query '$1'"
    exit 2
fi

#error "# current page $page\n# next page $next_url\n"

while [[ "$page" -le "$total_pages" ]]; do

    # output raw response to tmp file
    echo "$resp" >> "$_tmp"

    # output one object per line to stdout
    #echo "$resp" | jq -c ".listings[] | { ${obj_filter} }"

    # get the next page if it exists
    if [[ -n "$next_url" && "$next_url" != 'null'  ]]; then
        # reset the command with the next url
        s_cmd=$(printf "curl %s -X GET '%s'" "$header" "$next_url")
        resp=$(eval "$s_cmd" 2>/dev/null)
        page=$(get_element ".current_page" "$resp")
        next_url=$(get_element "._links.next.href" "$resp")
        #error "# next: $next_url"
        error "# reading page $page of $total_pages"
    else
        #error "# end of the line "
        # end the loop if the next url is not found
        break
    fi
done

# output all listings
jq -c ".listings[] | { ${obj_filter} }" "$_tmp"

# TODO: remove temp file
# [[ -f "$_tmp" ]] && rm "$_tmp"
