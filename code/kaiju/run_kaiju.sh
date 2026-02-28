#!/bin/bash

# Activate conda environment with Kaiju

# Define Kaiju DB and taxonomy paths
KAIJU_DB="/home/s2754638/kaiju_db/nr_euk/kaiju_db_nr_euk.fmi"
TAX_NODES="/home/s2754638/kaiju_db/nodes.dmp"
TAX_NAMES="/home/s2754638/kaiju_db/names.dmp"

# Input directories
HOST_DIR="/home/s2754638/Kvass_project/data/processed/host_filtered_reads"
YEAST_DIR="/home/s2754638/Kvass_project/data/processed/yeast_filtered_reads_paired"

# Output directories
OUT_DIR="/home/s2754638/Kvass_project/results/kaiju"
mkdir -p "$OUT_DIR/host/raw" "$OUT_DIR/host/table"
mkdir -p "$OUT_DIR/yeast/raw" "$OUT_DIR/yeast/table"

# Use more threads now
THREADS=32

# -------------------------
# Function to run Kaiju + Table
# -------------------------
run_kaiju () {
    local r1=$1
    local r2=$2
    local sample=$3
    local label=$4  # "host" or "yeast"

    echo "→ Running Kaiju on $sample [$label]"

    # Classification
    kaiju -t "$TAX_NODES" -f "$KAIJU_DB" -i "$r1" -j "$r2" \
          -o "$OUT_DIR/$label/raw/${sample}_kaiju.out" \
          -z $THREADS -a greedy -e 10 -s 65

    # Create summary table
    kaiju2table -t "$TAX_NODES" -n "$TAX_NAMES" -r species \
          -o "$OUT_DIR/$label/table/${sample}_kaiju_species.tsv" \
          "$OUT_DIR/$label/raw/${sample}_kaiju.out"

    return 0
}

# -------------------------
# Host-filtered samples
# -------------------------
echo "=== 🧫 Host-filtered Kvass Samples ==="
for R1 in "$HOST_DIR"/*_R1.filtered.fq.gz; do
    SAMPLE=$(basename "$R1" _R1.filtered.fq.gz)
    R2="$HOST_DIR/${SAMPLE}_R2.filtered.fq.gz"

    if [[ -f "$R2" ]]; then
        run_kaiju "$R1" "$R2" "$SAMPLE" "host"
    else
        echo "⚠️  Skipping $SAMPLE: R2 missing"
    fi
done

# -------------------------
# Yeast-filtered samples
# -------------------------
echo "=== 🍷 Yeast-filtered Kvass Samples ==="
for R1 in "$YEAST_DIR"/*_R1.fq.gz; do
    SAMPLE=$(basename "$R1" _R1.fq.gz)
    R2="$YEAST_DIR/${SAMPLE}_R2.fq.gz"

    if [[ -f "$R2" ]]; then
        run_kaiju "$R1" "$R2" "$SAMPLE" "yeast"
    else
        echo "⚠️  Skipping $SAMPLE: R2 missing"
    fi
done

echo "✅ Kaiju classification (32 threads) complete for all Kvass samples!"

