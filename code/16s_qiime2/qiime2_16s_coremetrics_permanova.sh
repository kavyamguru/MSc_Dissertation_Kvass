#!/bin/bash

# =============================================================================
# Run PERMANOVA on multiple metadata columns and distance metrics
# (B269797 project structure - relative paths)
# =============================================================================

# ----------- Base Paths -----------
BASE_DIR="$(dirname "$(dirname "$(dirname "$(realpath "$0")")")")"
METADATA="$BASE_DIR/metadata/16s/16s_metadata.tsv"
METRIC_DIR="$BASE_DIR/results/16s/qiime2_gtdb/core_metrics"

# ----------- Metadata Columns to Test -----------
metadata_columns=("Starter_Identity" "Sample_Type" "Inulin" "Ginger" "Sugar_Content")

# ----------- Distance Metrics to Test -----------
declare -A distance_metrics=(
  ["weighted_unifrac"]="weighted_unifrac_distance_matrix.qza"
  ["unweighted_unifrac"]="unweighted_unifrac_distance_matrix.qza"
  ["bray_curtis"]="bray_curtis_distance_matrix.qza"
  ["jaccard"]="jaccard_distance_matrix.qza"
)

# ----------- Run PERMANOVA for Each Metadata Column -----------
for column in "${metadata_columns[@]}"; do
  echo "🔬 Running PERMANOVA for metadata column: $column"

  # Create output directory for this column
  output_dir="$METRIC_DIR/permanova_$column"
  mkdir -p "$output_dir"

  # Run PERMANOVA for each distance metric
  for metric in "${!distance_metrics[@]}"; do
    input="$METRIC_DIR/${distance_metrics[$metric]}"
    output="$output_dir/${metric}_permanova.qzv"

    echo "▶️ Running PERMANOVA on $metric for $column"
    qiime diversity beta-group-significance \
      --i-distance-matrix "$input" \
      --m-metadata-file "$METADATA" \
      --m-metadata-column "$column" \
      --p-method permanova \
      --o-visualization "$output"

    echo "✅ Saved: $output"
  done

  echo "📁 Completed PERMANOVA for $column. Results saved in: $output_dir"
done

echo "🎯 All PERMANOVA analyses completed."

