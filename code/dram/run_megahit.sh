#!/usr/bin/env bash
set -euo pipefail

echo "🛠️ Starting MEGAHIT assemblies..."

PROJECT_ROOT=~/Kvass_project
READS_DIR="${PROJECT_ROOT}/data/processed/host_filtered_reads"
ASSEMBLY_DIR="${PROJECT_ROOT}/assemblies_host"
THREADS=32

mkdir -p "$ASSEMBLY_DIR"

for fq1 in "${READS_DIR}"/*_R1.filtered.fq.gz; do
  base=$(basename "$fq1")
  sample_long=${base%%_R1.filtered.fq.gz}
  sample_short=${sample_long%%_*}
  fq2="${READS_DIR}/${sample_long}_R2.filtered.fq.gz"
  asm_dir="${ASSEMBLY_DIR}/${sample_short}"

  # Clean up empty directories that block MEGAHIT
  if [[ -d "$asm_dir" && ! -f "$asm_dir/final.contigs.fa" ]]; then
    echo "⚠️  Empty output directory found for $sample_short — removing it"
    rm -rf "$asm_dir"
  fi

  if [[ -f "${asm_dir}/final.contigs.fa" ]]; then
    echo "✅ Skipping $sample_short: assembly already exists"
  else
    echo "🚀 Assembling $sample_short"
    megahit \
      -1 "$fq1" \
      -2 "$fq2" \
      -o "$asm_dir" \
      --min-contig-len 1000 \
      -t "$THREADS"
  fi
  echo ""
done

