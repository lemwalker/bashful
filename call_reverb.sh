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

# TODO: delete
#fields=(
#    'TotalPrice:((.price.amount_cents + .shipping.rates[0].rate.amount_cents) / 100)'
#    'Condition:.condition.slug'
#    'PreferredSeller:.shop.preferred_seller'
#    'ListingURL:._links.web.href'
#    'CreatedAt:.created_at'
#)

listing_fields=(
  "rates:.shipping.rates[]"
  "id"
  "display_price:.price.display"
  "price:.price.amount_cents"
  "condition:.condition.slug"
  "make"
  "model"
  "_url:._links.web.href"
  "posted:.created_at"
  "pref_shop:.shop.preferred_seller"
)

# | select(.rates.region_code=="US_CON")
# | . += {_total:((.rates.rate.amount_cents + .price) / 100) } 
#| del(.rates,.price) ' JSON

# jq commands to be applied to the listings
#   only output objects that ship to US_CON
#   add the price and shipping to get the total
#   delete the rates and price objects
_filters=(
  'select(.rates.region_code=="US_CON")'
  '| . += {_total:((.rates.rate.amount_cents + .price) / 100)}'
  '| del(.rates,.price)'
)
# transform fields array to comma-separated line
obj_filter=$(printf "%s,"  "${listing_fields[@]}" | sed 's/,$//')
# filters as one space-separated value
_qf=$(printf "%s " "${_filters[@]}")

_tmp=$(mktemp -t "${qname}_XXXX")

# make the initial call
s_cmd=$(printf "curl %s -X GET '%s'" "$header" "$url")
resp=$(eval "$s_cmd" 2>/dev/null)

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

while [[ "$page" -le "$total_pages" ]]; do

    error "# reading page $page of $total_pages"
    # output raw response to tmp file
    echo "$resp" >> "$_tmp"

    # get the next page if it exists
    if [[ -n "$next_url" && "$next_url" != 'null'  ]]; then
        # reset the command with the next url
        s_cmd=$(printf "curl %s -X GET '%s'" "$header" "$next_url")
        resp=$(eval "$s_cmd" 2>/dev/null)
        page=$(get_element ".current_page" "$resp")
        next_url=$(get_element "._links.next.href" "$resp")
    else
        #error "# end of the line "
        # end the loop if the next url is not found
        break
    fi

done

# read all listings with jq
jq -Sc ".listings[] | { ${obj_filter} } | ${_qf}" "$_tmp"

# TODO: remove temp file
#[[ -f "$_tmp" ]] && rm "$_tmp"
#TODO: print
error "command:\njq -Sc '.listings[] | { ${obj_filter} } | ${_qf}' $_tmp"

