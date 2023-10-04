#!/usr/bin/env bash

# Extract the timestamp into a variable
TMP_DECRYPT_TIMESTAMP="$(date +%Y%m%d%H%M%S)"
mkdir -p "/tmp/decrypted/$TMP_DECRYPT_TIMESTAMP"

# Use the variable in the find and gpg commands
find . -type f -name "*.gpg" -exec bash -c 'for file do
  dir="/tmp/decrypted/$1/$(dirname "$file")"
  mkdir -p "$dir"
  gpg -o "$dir/$(basename "$file" .gpg)" -d "$file"
done' _ "$TMP_DECRYPT_TIMESTAMP" {} +

# Display a completion message
echo "Files have been decrypted and are located in /tmp/decrypted/$TMP_DECRYPT_TIMESTAMP"

# Change the current directory to the decryption folder
cd "/tmp/decrypted/$TMP_DECRYPT_TIMESTAMP" || exit 1
