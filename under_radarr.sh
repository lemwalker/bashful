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


# Idea: Use hard links to trick radarr

function error() { echo -e "$1" 2>&1;}

movie_dir="/4TB/Videos/Movies"
hardlink_dir="/4TB/Videos/radarr/lib"
ext_pattern='.+\.(mp4|mkv|avi)'


error "Checking $hardlink_dir"

# make sure all files downloaded by radarr are moved into movie_dir
find "$hardlink_dir" -type f -regextype egrep -regex "$ext_pattern" | \
    while read file; do

        base=$(basename  "$file")
        target="${movie_dir}/${base}"
        #error "Check for $target"
        if [[ -f "$target" ]]; then
            #error "EXISTS: $target"
            printf ""
        else
            error "--  Adding link for $base"
            ln "$file" -T "$target"
        fi
    done


error "checking $movie_dir"


# make sure all files in movie_dir are added to a subfolder in hardlink_dir
find "$movie_dir" -type f -regextype egrep -regex "$ext_pattern" | \
    while read file; do
        # TODO: print
        #error "$file"

        base=$(basename  "$file")
        dir="${hardlink_dir}/${base%.*}"
        hl="${dir}/${base}"
        if [[ -f "$hl" ]]; then
            error "--  Link $base already exists"
            #error "  base:$base\n  dir:$dir\n  hl:$hl\n"
        else
            # check if the hl directory exists
            if [[ ! -d "$dir" ]]; then
                # create directory
                mkdir "$dir"
            fi

            # create the hard link
            ln "$file" "$dir"
            #error "  ln $file $dir"
            sleep 0.5
        fi
    done

