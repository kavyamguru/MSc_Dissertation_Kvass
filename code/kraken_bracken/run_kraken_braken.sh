#!/bin/bash

# -------------------------------------------
# Kraken2 + Bracken Pipeline for Host-Filtered Shotgun Data
# Project: B269797 - Kvass & Sourdough Metagenomics
# Author: [Your Name]
# Date: [Date]
# -------------------------------------------

# ---------- Config Parameters ----------
THREADS=32
DB="/home/s2754638/kraken2_db"    # Path to Kraken2/Bracken database
INPUT_LINKS="../../raw_data_links/shotgun_host_filtered_links.txt"  # Tab-separated list of sample, R1, R2
OUTPUT_DIR="../../results/kraken_bracken/tables"
READ_LEN=150
CONFIDENCE=0.2
BRACKEN_THRESH=0.001

mkdir -p "$OUTPUT_DIR"

# ---------- Main Processing Loop ----------
while IFS=$'\t' read -r SAMPLE R1 R2; do
  echo "🚀 Processing $SAMPLE..."

  # ---------- Kraken2 ----------
  kraken2 \
    --db "$DB" \
    --threads "$THREADS" \
    --paired "$R1" "$R2" \
    --report "$OUTPUT_DIR/${SAMPLE}_kraken2_report_conf${CONFIDENCE}.txt" \
    --output "$OUTPUT_DIR/${SAMPLE}_kraken2_output_conf${CONFIDENCE}.txt" \
    --use-names \
    --report-minimizer-data \
    --confidence "$CONFIDENCE" \
    --minimum-base-quality 20 \
    --gzip-compressed

  # ---------- Bracken: Species ----------
  bracken -d "$DB" \
    -i "$OUTPUT_DIR/${SAMPLE}_kraken2_report_conf${CONFIDENCE}.txt" \
    -o "$OUTPUT_DIR/${SAMPLE}_bracken_species_conf${CONFIDENCE}.txt" \
    -r "$READ_LEN" -l S -t "$THREADS"
  awk 'NR==1 || $5 >= '"$BRACKEN_THRESH" "$OUTPUT_DIR/${SAMPLE}_bracken_species_conf${CONFIDENCE}.txt" \
    > "$OUTPUT_DIR/${SAMPLE}_bracken_species_conf${CONFIDENCE}_thr${BRACKEN_THRESH}.txt"

  # ---------- Bracken: Genus ----------
  bracken -d "$DB" \
    -i "$OUTPUT_DIR/${SAMPLE}_kraken2_report_conf${CONFIDENCE}.txt" \
    -o "$OUTPUT_DIR/${SAMPLE}_bracken_genus_conf${CONFIDENCE}.txt" \
    -r "$READ_LEN" -l G -t "$THREADS"
  awk 'NR==1 || $5 >= '"$BRACKEN_THRESH" "$OUTPUT_DIR/${SAMPLE}_bracken_genus_conf${CONFIDENCE}.txt" \
    > "$OUTPUT_DIR/${SAMPLE}_bracken_genus_conf${CONFIDENCE}_thr${BRACKEN_THRESH}.txt"

  # ---------- Bracken: Phylum ----------
  bracken -d "$DB" \
    -i "$OUTPUT_DIR/${SAMPLE}_kraken2_report_conf${CONFIDENCE}.txt" \
    -o "$OUTPUT_DIR/${SAMPLE}_bracken_phylum_conf${CONFIDENCE}.txt" \
    -r "$READ_LEN" -l P -t "$THREADS"
  awk 'NR==1 || $5 >= '"$BRACKEN_THRESH" "$OUTPUT_DIR/${SAMPLE}_bracken_phylum_conf${CONFIDENCE}.txt" \
    > "$OUTPUT_DIR/${SAMPLE}_bracken_phylum_conf${CONFIDENCE}_thr${BRACKEN_THRESH}.txt"

  echo "✅ Finished: $SAMPLE"

done < "$INPUT_LINKS"

# ---------- Final Table Merge ----------
echo "🧩 Merging species tables into a unified abundance table..."

python3 <<EOF
import os
import pandas as pd

input_dir = "$OUTPUT_DIR"
confidence = "$CONFIDENCE"
threshold = "$BRACKEN_THRESH"
out_file = os.path.join(input_dir, f"species_table_bracken_{confidence}.tsv")

# Collect all filtered species files
species_files = [f for f in os.listdir(input_dir) if f.endswith(f"species_conf{confidence}_thr{threshold}.txt")]

merged = pd.DataFrame()

for file in species_files:
    sample = file.split("_bracken")[0]
    df = pd.read_csv(os.path.join(input_dir, file), sep="\t")
    df = df[["name", "fraction_total_reads"]]
    df.columns = ["species", sample]
    df.set_index("species", inplace=True)

    if merged.empty:
        merged = df
    else:
        merged = merged.join(df, how="outer")

merged.fillna(0, inplace=True)
merged = merged.round(6)
merged.to_csv(out_file, sep="\t")
print(f"✅ Merged species table written to: {out_file}")
EOF

echo "🎯 All samples processed and species table created."

