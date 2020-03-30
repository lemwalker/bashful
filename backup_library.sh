#!/bin/bash

# Full path of directory to back up. Do NOT include trailing '/'
library_root=""
# Full path of target directory. Do NOT include trailing '/'
backup_root=""
# mail recipient(s)
mail_to=""
mail_sender_name="${USER}@$(hostname)"
mail_subject="Media Backup of '$(hostname):${library_root}'"
# mail_message is populated during the backup
mail_message=""

# Sub directories under library_root. INCLUDE trailing '/'
library_dirs=(
    #Populate this array with subdirectories of library_root that are to be backed up
)

function error() { echo -e "$1" >&2; }
function die() { error "$1" && exit 1; }
function date_str() { date "+%Y%m%d_%H%M%S"; }

script_start=$(date "+%s")

dry_run=0

# add log messages here. they are printed in sequence after syncing is complete
messages=()
warnings=()
completed=0
# check for TEST argument
if [[ -n "$1" ]]; then
    if [[ "${1,,}" == 'test' ]]; then
        dry_run=1
        msg=$'\n'"Test argument detected. No files will be transferred."$'\n'$'\n'
        messages+=("$msg")
        mail_subject="TEST: ${mail_subject}"
    fi
fi

# Skip processing if directories are not found
if [[ ! -d "$library_root" ]]; then
    warn=$(printf "Library root '%s' is not found." "$library_root")
    warnings+=("$warn")
    # clear this array to skip processing
    library_dirs=()
fi
if [[ ! -d "$backup_root" ]]; then
    warn=$(printf "Target root '%s' is not found." "$backup_root")
    warnings+=("$warn")
    # clear this array to skip processing
    library_dirs=()
fi

##  Start converting
for d in "${library_dirs[@]}"; do
    start_time=$(date "+%s")
    msg=$(printf "dir:%-16s, start:%s" "'$d'" "$(date_str)" )

    src=$(printf "%s/%s" "$library_root" "$d")
    dest=$(printf "%s/%s" "$backup_root" "$d")
    if [[ ! -d "$src" ]]; then
        warnings+=("Cannot find source directory '$src'.")
        continue
    fi
    if [[ ! -d "$dest" ]]; then
        warnings+=("Cannot find dest directory '$src'")
        continue
    fi

    src_count=$(find "$src" -type f | wc -l)
    dest_count=$(find "$dest" -type f | wc -l)
    msg+=$(printf ", file_count:%8d" "$src_count")

    if [[ "$dry_run" == 0 ]]; then
        # we're doing this for real
        rsync  -av  "$src" "$dest"
        rc=$?
    else
        # dry-run
        rsync --dry-run -av  "$src" "$dest"
        rc=$?
    fi

    end_time=$(date "+%s")
    elap=$( date -ud @$(( $end_time  - $start_time )) "+%H:%M:%S")
    msg+=", end:$(date_str), elap:${elap}, result:"

    if [[ $rc == 0 ]]; then
        msg+="'SUCCESS'"
        ((completed++))
    else
        msg+="'FAILED'"
        warn=$(printf "Failed to sync $src to $dest")
        warnings+=("$warn")
    fi

    messages+=("$msg")
done

msg=$(printf $'\n'$'\n'"%d of %d directories synced successfully" "$completed" "${#library_dirs[@]}")
messages+=("$msg")

script_end=$(date "+%s")
script_time=$(date -ud @$(( $script_end  - $script_start)) "+%H:%M:%S")
messages+=($'\n'"Total elapsed time: $script_time")
printf "\n\n"

printf "\nMessages:\n"
for line in "${messages[@]}"; do
    # trim extra spaces
    printf "    %s\n" "$line"
    mail_message+=$(echo "$line" | sed -r -e 's| +,|,|g' -e 's|: +|: |g')
    mail_message+=$'\n'
done

if [[ "${#warnings[@]}" -ge 1 ]]; then
    mail_message+=$'\n'"Warnings:"$'\n'
    printf "Warnings:\n"
    mail_subject="${mail_subject} -- WARNINGS!"
    for line in "${warnings[@]}"; do
        printf "  %s\n" "$line"
        # trim extra spaces
        mail_message+=$(echo "$line" | sed -r -e 's| +,|,|g' -e 's|: +|: |g')
        mail_message+=$'\n'
    done
fi

# Add this script's path to the message
mail_message+=$'\n'$'\n'"$(realpath $0)"

# Email results
mail_body=$(printf "Subject: %s\n\n%s\n" "$mail_subject" "$mail_message")
echo "$mail_body" | sendmail -F "$mail_sender_name" "$mail_to"
[[ $? == 0 ]] && error "Email sent successfully"

