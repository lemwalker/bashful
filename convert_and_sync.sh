#!/bin/bash

function error() { echo -e "$1" >&2; }
function die() {
    error "$1"
    exit 1
}

kill_file= #file to create to stop the process after converting and transferring the current file
[[ -e "$kill_file" ]] && rm "$kill_file"

function stop_when_killed() {
    if [[ -e "$kill_file" ]]; then
        rm "$kill_file"
        die "Stopping $0 because $kill_file was found"
    fi
}

lib_dir= #Parent directory of all input files
convert_dir= # temp directory for converted files
convert_preset= # HandBrake preset value. E.g. "AppleTV 2"
convert_ext=".mp4"
file_pattern='^(.+)\.(avi|mkv|mp4)$'

libraries=(
    # Populate with subdirectories of $lib_dir. E.g. "TV"
)

target_dir= # parent library on the remote server
target_user= # username for ssh calls
target_server= # IP address of remote server
target_port= # ssh port of remote server

function exec_ssh() {
    [[ -z "$@" ]] && return 1
    ssh -n -p "$target_port" "${target_user}@${target_server}" $@
}

[[ ! -d "$convert_dir" ]] && die "Cannot see directory $convert_dir"


# Create an array of all media files
files_to_convert=()
for lib in "${libraries[@]}"; do
    while read f; do
        files_to_convert+=("$f")
    done < <(find "${lib_dir}/${lib}" -type f -regextype posix-egrep -regex "$file_pattern" | sort)
done

counter=0
files_converted=0
files_transferred=0
for f in "${files_to_convert[@]}"; do
    stop_when_killed
    ((counter++))
    file_ext=$(echo "$f" |  grep -Eo "\.[^\.]+$")
    file_title=$(basename "$f" "$file_ext")
    # all of the directories above the file
    input_file=$(realpath "$f")
    file_path=$(dirname "$f" | sed -r "s|^${lib_dir}/*||")
    conv_path=$(printf "%s/%s%s" "$convert_dir" "$file_title" "$convert_ext")
    target_path=$(printf "%s/%s/%s%s" "$target_dir" "$file_path" "$file_title" "$convert_ext")
    target_subdir=$(dirname "$target_path")
    [[ -z "$input_file" ]] && die "$f   input_file fail"
    [[ -z "$file_path" ]] && die "$f    file_path fail"
    [[ -z "$conv_path" ]] && die "$f    conv_path fail"
    [[ -z "$target_path" ]] && die "$f    target_path fail"

    check_file_cmd=$(printf "test -f \"%s\"" "$target_path")
    convert_cmd=$(printf "HandBrakeCLI -Z \"%s\" -i \"%s\" -o \"%s\"" "$convert_preset" "$input_file" "$conv_path" )
    check_dir_cmd=$(printf "test -d \"%s\"" "$target_subdir")
    create_dir_cmd=$(printf "mkdir -p \"%s\"" "$target_subdir")
    file_transfer_cmd=$(printf "scp -P %s \"%s\"  \"%s@%s:\\\\\"%s\\\\\"\""  "$target_port"  "$conv_path" "$target_user" "$target_server" "$target_path")

    # Does the file need to be converted?
    if exec_ssh "$check_file_cmd"; then
        printf "    Converted file exists: '%s'\n" "$target_path"
        continue
    fi
    if ! exec_ssh "$check_dir_cmd"; then
        if exec_ssh "$create_dir_cmd"; then
           printf "    Target dir created for %s\n" "$target_path" 
        else
            printf "   Failed to create target directory for %s\n" "$target_path"
            printf "       create_dir_cmd: '%s'\n" "$create_dir_cmd"
            continue
        fi
    else
        printf "    Failed to run command '%s'\n" "$check_dir_cmd"
    fi

    # convert the file
    if [[ ! -e "$conv_path" ]]; then
        if eval "$convert_cmd"; then
            ((files_converted++))
        else
            printf "Failed to convert file %s\n" "$conv_path"
            continue
        fi
    else
        # file already converted
        printf "    File already converted: %s\n" "$conv_path"
    fi

    # transfer the file
    printf "\n    File Transfer:\n\n\t%s\n\n" "$file_transfer_cmd"
    if eval "$file_transfer_cmd"; then
        ((files_transferred++))
        rm "$conv_path"
        printf "    File transfer completed for '%s'\n" "$file_title"
    else
        printf "    Failed to transfer file '%s'\n\n" "$conv_path"
    fi

    # exit early
    #[[ $files_converted -ge 10 ]] && break
done

printf "%4d files read\n" $counter
printf "%4d files converted\n" "$files_converted"
printf "%4d files tranferred\n" "$files_transferred"

