#!/bin/bash

# TODO: make sure that the HL directory is on the same disk as the movies
# TODO: make this a general solution to go move/sync a flat library to a structured one
#       use a pattern that controls the directory structure
# TODO: flags, interactive mode, dry run, verbose

# radarr requieres that movies be in subfolders matching the file name:
#   /Movies/
#   /Movies/Argo (2012)/
#     Argo (2012).mkv
#   /Movies/Logan (2017)/
#     Logan (2017).mkv
#   /Movies/Up (2009)/
#     Up (2009).mkv

# That is terrible. Need to make it work with a flat library
# /Movies/
#   Argo (2012).mkv
#   Logan (2017).mkv
#   Up (2009).mkv

# Workaround: Use hard links to trick radarr

function error() { echo -e "$1" 2>&1;}

movie_dir="/4TB/Videos/Movies"
hardlink_dir="/4TB/Videos/radarr/lib"
ext_pattern='.+\.(mp4|mkv|avi)'

error "\nChecking $hardlink_dir"

# make sure all files downloaded by radarr are moved into movie_dir
find "$hardlink_dir" -type f -regextype egrep -regex "$ext_pattern" -printf "%i %p\n" | sort -k 2 | \
    while read inode file; do

        # check to see if the file exists in movie_dir
        linked_file=$(find "$movie_dir" -inum "$inode" 2>/dev/null)

        if [[ -z "$linked_file" ]]; then
            base=$(basename  "$file")
            if ln "$file" "$movie_dir"; then
                echo "  Added link to '$base' in '$movie_dir'"
            else
                error "  Failed to add link"
            fi
        fi
    done

error "Checking $movie_dir"

# make sure all files in movie_dir are added to a subfolder in hardlink_dir
find "$movie_dir" -type f -regextype egrep -regex "$ext_pattern" -printf "%i %p\n" | sort -k 2 | \
    while read inode file; do
        linked_file=$(find "$hardlink_dir" -inum "$inode" 2>/dev/null)
        if [[ -z "$linked_file" ]]; then
            base=$(basename  "$file")
            file_dir="${hardlink_dir}/${base%.*}"
            if [[ ! -d "$file_dir" ]]; then
                # create the directory
                mkdir "$file_dir" || error "Failed to create directory '$file_dir'"
            fi

            # create the hard link
            if ln "$file" "$file_dir"; then
                echo "  Added link to '$base' in '$file_dir'"
            else
                error "Failed to add link for $base"
            fi
        fi
    done

error "$0 end"

