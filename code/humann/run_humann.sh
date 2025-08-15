#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Run HUMAnN3 on Host-Filtered Reads only, with stat_q=0.20
# Project root assumed to be two levels up: B269797/
# =============================================================================

# ─── 1) Project root and environments ────────────────────────────────────────
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
# Uncomment to auto-activate conda if you haven’t already
# source ~/miniconda3/etc/profile.d/conda.sh
# conda activate humann-metaphlan-env

# ─── 2) Directories ──────────────────────────────────────────────────────────
HOST_DIR="$PROJECT_ROOT/data/processed/host_filtered_reads"
OUTDIR_BASE="$PROJECT_ROOT/results/humann"
mkdir -p "$OUTDIR_BASE/host_q20"

# ─── 3) Databases (adjust if you’ve moved these under PROJECT_ROOT) ───────────
DB_CHOCO="/home/s2754638/humann_db/chocophlan"
DB_UNIREF="/home/s2754638/humann_db/uniref"
DB_META="/home/s2754638/humann_db/metaphlan_db_2023"
DB_INDEX="mpa_vJun23_CHOCOPhlAnSGB_202307"

# ─── 4) Samples ──────────────────────────────────────────────────────────────
samples=(AA B1 C1 D1 E1 F1)
stat_q=0.20
prefix="host"

# ─── 5) Loop samples ─────────────────────────────────────────────────────────
for sample in "${samples[@]}"; do
  echo "🚀 Processing $sample (host-filtered, stat_q=$stat_q)…"
  sample_out="$OUTDIR_BASE/${prefix}_q20/${sample}"
  mkdir -p "$sample_out"

  # Locate the host-filtered R1/R2
  R1=$(ls "${HOST_DIR}/${sample}"*"_R1.filtered.fq.gz" 2>/dev/null) 
  R2=$(ls "${HOST_DIR}/${sample}"*"_R2.filtered.fq.gz" 2>/dev/null)

  if [[ -f "$R1" && -f "$R2" ]]; then
    merged="$sample_out/${sample}_host_combined.fastq"
    echo "   ⏳ Decompressing & merging → $(basename "$merged")"
    zcat "$R1" "$R2" > "$merged"
    input_fastq="$merged"
  else
    echo "⚠️ Missing host-filtered pairs for $sample; skipping."
    continue
  fi

  echo "   ▶ Running HUMAnN3 → $sample_out"
  humann3 \
    --input "$input_fastq" \
    --output "$sample_out" \
    --nucleotide-database "$DB_CHOCO" \
    --protein-database   "$DB_UNIREF" \
    --metaphlan-options "--bowtie2db $DB_META --index $DB_INDEX --stat_q $stat_q" \
    --threads 32

  echo "✅ Done: $sample → $sample_out"
done

echo "🎉 All host-filtered HUMAnN3 runs complete."

