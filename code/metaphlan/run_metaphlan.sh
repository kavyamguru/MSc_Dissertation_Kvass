#!/bin/bash
set -euo pipefail

################################################################################
# Script: run_metaphlan4_host_statq02.sh
#
# Purpose:
#   - Run MetaPhlAn4 (stat_q=0.2) on host-filtered paired-end metagenomic reads.
#   - Generates per-sample species profiles, merged abundance table, summary, 
#     and final species-level table for downstream use.
#
# Author: [Your Name]
# Date: [Date]
################################################################################

# ----------------------------- CONFIGURATION -------------------------------- #

READ_DIR="../data/processed/host_filtered_reads"
OUT_DIR="../results/metaphlan/host_filtered/statq_0.2"
TABLE_DIR="../results/metaphlan/tables"
DB_META="../../databases/metaphlan_db"
DB_INDEX="mpa_vJan25_CHOCOPhlAnSGB_202503"
THREADS=16

# --------------------------- RUN METAPhLAN4 --------------------------------- #

mkdir -p "$OUT_DIR/profiles" "$OUT_DIR/bowtie2out" "$TABLE_DIR"

echo "▶ Starting MetaPhlAn4 (stat_q=0.2) on host-filtered paired-end reads..."

for fq1 in "$READ_DIR"/*_R1*.fq.gz; do
  base=$(basename "$fq1" | sed -E 's/_R1(\.filtered)?\.fq\.gz//')
  fq2=$(ls "$READ_DIR/${base}"*_R2*.fq.gz 2>/dev/null || true)

  if [[ ! -f "$fq1" || ! -f "$fq2" ]]; then
    echo "⚠️  Skipping $base – missing R1 or R2 read file."
    continue
  fi

  echo "🔬 Processing sample: $base"

  metaphlan "$fq1","$fq2" \
    --input_type fastq \
    --nproc "$THREADS" \
    --stat_q 0.2 \
    --bowtie2db "$DB_META" \
    --index "$DB_INDEX" \
    --bowtie2out "$OUT_DIR/bowtie2out/${base}.bt2.bz2" \
    -o "$OUT_DIR/profiles/${base}_profile.txt"
done

echo "✅ MetaPhlAn4 profiling complete for all samples."

# -------------------- MERGE PROFILES INTO TABLE ----------------------------- #

MERGED_FILE="${OUT_DIR}/merged_abundance.tsv"
SUMMARY_FILE="${OUT_DIR}/merged_abundance_summary.tsv"
SPECIES_FILE="${TABLE_DIR}/species_table_metaphlan_0.2.tsv"

echo "📁 Merging individual profiles into: $MERGED_FILE"
merge_metaphlan_tables.py "$OUT_DIR"/profiles/*.txt > "$MERGED_FILE"

# -------------------- GENERATE SUMMARY PER SAMPLE -------------------------- #

echo "📊 Calculating non-zero species/genus counts for each sample..."

python3 - <<EOF
import pandas as pd

df = pd.read_csv("$MERGED_FILE", sep='\t', index_col=0)
summary = []

for sample in df.columns:
    nonzero = df[sample][df[sample] > 0]
    species = nonzero[nonzero.index.str.contains('s__') & ~nonzero.index.str.contains('\\|t__')].count()
    genus = nonzero[nonzero.index.str.contains('g__') & ~nonzero.index.str.contains('s__')].count()
    summary.append({'Sample': sample, 'Species_Count': species, 'Genus_Count': genus})

pd.DataFrame(summary).to_csv("$SUMMARY_FILE", sep='\t', index=False)
EOF

echo "✅ Summary file saved: $SUMMARY_FILE"

# -------------------- EXTRACT SPECIES-ONLY TABLE ---------------------------- #

echo "🧪 Extracting species-level abundance table → $SPECIES_FILE"

python3 - <<EOF
import pandas as pd

df = pd.read_csv("$MERGED_FILE", sep='\t', index_col=0)

# Filter only species rows: contain "s__" but not "|t__"
species_df = df[df.index.str.contains('s__') & ~df.index.str.contains('\\|t__')]

# Optional: sort rows alphabetically
species_df = species_df.sort_index()

# Save as tab-separated file
species_df.to_csv("$SPECIES_FILE", sep='\t')
EOF

echo "🎉 All done! Final species-level table saved to: $SPECIES_FILE"

