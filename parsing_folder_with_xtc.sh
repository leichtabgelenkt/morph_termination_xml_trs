#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <folder_path>"
  exit 1
fi

# Assign command-line arguments to variables
FOLDER_PATH="$1"
PROGRAM="xsltproc"
STYLE_SHEET="xtc2tpdb.xsl"


# xsltproc ../xtc2tpdb.xsl ../SK90/2.01.xml > 2.01.trs

# Check if the specified folder exists
if [ ! -d "$FOLDER_PATH" ]; then
  echo "Error: Folder '$FOLDER_PATH' does not exist."
  exit 1
fi

# Check if the program is installed
if ! command -v "$PROGRAM" &> /dev/null; then
    echo "Error: Program '$PROGRAM' is not installed. Please install it and try again."
    exit 1
fi

# create a folder for the trs files
mkdir -p "$FOLDER_PATH/trs_files"

# Iterate over all files in the folder
for FILE in "$FOLDER_PATH"/*; do
  # Check if it is a regular file
  if [ -f "$FILE" ]; then
    echo "Processing file: $FILE"
    OUTPUT_FILE="$FOLDER_PATH/trs_files/$(basename "${FILE%.xml}.trs")"
    echo "Creating file: $OUTPUT_FILE"
    "$PROGRAM" "$STYLE_SHEET" "$FILE" > "$OUTPUT_FILE"
    if [ $? -ne 0 ]; then
      echo "Error: Script failed for file $FILE"
    fi
  fi
done

echo "Processing completed."