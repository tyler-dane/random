#!/bin/bash
#
# Usage:
# - copy this file to the directory that has .gifs in it
# - run bash <thisfile>
# Behavior:
# - GIFs moved to a new GIFs folder
# - converted MP4s saved in current dir

# Create the GIFs directory if it doesn't exist
mkdir -p GIFs

# Loop through all .gif files in the current directory
for gif_file in *.gif; do
    # Check if the file exists
    if [ -f "$gif_file" ]; then
        # Extract the file name without the extension
        base_name="${gif_file%.gif}"

        # Define the output mp4 file name
        mp4_file="${base_name}.mp4"

        # Run the ffmpeg command to convert the .gif to .mp4
        ffmpeg -i "$gif_file" -movflags faststart -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "G$mp4_file"

        # Check if the ffmpeg command was successful
        if [ $? -eq 0 ]; then
            # Output a log statement
            echo "Converting $gif_file to $mp4_file"

            # Move the original .gif file to the "GIFs" directory
            mv "$gif_file" "GIFs/"
        else
            echo "Error converting $gif_file to $mp4_file"
        fi
    fi
done

