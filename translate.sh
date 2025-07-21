#!/bin/bash

# This script translates markdown files from English to Chinese,
# skipping any files that have already been translated.

# --- Configuration ---
SRC_DIR="/src/OEBPS/markdown_en"
DEST_DIR="/src/OEBPS/markdown_zh"

# --- Function Definition ---

# Function to translate a single file if its Chinese version doesn't exist.
# @param $1: The source (English) markdown file path.
translate_if_needed() {
  local src_file="$1"
  # Derives the destination path by replacing the source directory with the destination directory.
  local dest_file="${DEST_DIR}/$(basename "$src_file")"

  if [ -f "$dest_file" ]; then
    echo "Skipping: $(basename "$src_file") (translation already exists)."
  else
    echo "Translating: $(basename "$src_file")"
    # Execute the translation command in a non-interactive mode.
    gemini -p "
Your task is to read the file at '${src_file}', translate its content to Chinese, and then use the \`write_file\` tool to save the translated text to '${dest_file}'.
Do not attempt to call any external resource or service. Read the file, then translate.
You must only write the translated content to the file, with no extra commentary or text.
" -y
    echo "--- Finished $(basename "$src_file") ---"
    sleep 30s
  fi
}

# --- Main Execution ---

# Ensure the destination directory exists.
mkdir -p "$DEST_DIR"

# List of all source files to process.
# We are defining the list explicitly to ensure the script is robust.
files_to_translate=(
  "Karp_9780593798706_epub3_ack_r1.md"
  "Karp_9780593798706_epub3_ata_r1.md"
  "Karp_9780593798706_epub3_bib_r1.md"
  "Karp_9780593798706_epub3_c001_r1.md"
  "Karp_9780593798706_epub3_c002_r1.md"
  "Karp_9780593798706_epub3_c003_r1.md"
  "Karp_9780593798706_epub3_c004_r1.md"
  "Karp_9780593798706_epub3_c005_r1.md"
  "Karp_9780593798706_epub3_c006_r1.md"
  "Karp_9780593798706_epub3_c007_r1.md"
  "Karp_9780593798706_epub3_c008_r1.md"
  "Karp_9780593798706_epub3_c009_r1.md"
  "Karp_9780593798706_epub3_c010_r1.md"
  "Karp_9780593798706_epub3_c011_r1.md"
  "Karp_9780593798706_epub3_c012_r1.md"
  "Karp_9780593798706_epub3_c013_r1.md"
  "Karp_9780593798706_epub3_c014_r1.md"
  "Karp_9780593798706_epub3_c015_r1.md"
  "Karp_9780593798706_epub3_c016_r1.md"
  "Karp_9780593798706_epub3_c017_r1.md"
  "Karp_9780593798706_epub3_c018_r1.md"
  "Karp_9780593798706_epub3_cop_r1.md"
  "Karp_9780593798706_epub3_cre_r1.md"
  "Karp_9780593798706_epub3_cvi_r1.md"
  "Karp_9780593798706_epub3_ded_r1.md"
  "Karp_9780593798706_epub3_epi_r1.md"
  "Karp_9780593798706_epub3_fsq_r1.md"
  "Karp_9780593798706_epub3_idx_r1.md"
  "Karp_9780593798706_epub3_loi_r1.md"
  "Karp_9780593798706_epub3_nts_r1.md"
  "Karp_9780593798706_epub3_p001_r1.md"
  "Karp_9780593798706_epub3_p002_r1.md"
  "Karp_9780593798706_epub3_p003_r1.md"
  "Karp_9780593798706_epub3_p004_r1.md"
  "Karp_9780593798706_epub3_prf_r1.md"
  "Karp_9780593798706_epub3_toc_r1.md"
  "Karp_9780593798706_epub3_tp_r1.md"
  "next-reads.md"
)

# Loop through the list and call the translation function for each file.
for file in "${files_to_translate[@]}"; do
  translate_if_needed "${SRC_DIR}/${file}"
done

echo "Translation script finished. All files have been processed."
