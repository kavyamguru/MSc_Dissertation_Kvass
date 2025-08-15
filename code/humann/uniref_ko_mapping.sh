#!/usr/bin/env bash
set -euo pipefail

# ======================= CONFIGURE THESE PATHS ==========================
# Input: merged HUMAnN UniRef90 gene-family table (unstratified recommended)
INPUT_GF="/home/s2754638/Kvass_project/results/humann3/host/host_statq020/tmp/inputs/merged_raw/merged_genefamilies.tsv"

# HUMAnN utility mapping directory (you showed this exists)
UTIL="/home/s2754638/humann_db/utility_mapping"

# Outputs will be written here
OUTDIR="/home/s2754638/Kvass_project/results/humann3/host/host_statq020/tmp/inputs/ko"
mkdir -p "$OUTDIR"

# Fractional regrouping to avoid double-counting multi-mapped UniRef90s
#   true  -> split a UniRef90 feature's abundance equally across all KOs it maps to
#   false -> default sum (full abundance to each KO it maps to; can inflate totals)
FRACTIONAL=true
# =======================================================================

echo "▶ KO regrouping starting"
echo "   Input:  $INPUT_GF"
echo "   Util:   $UTIL"
echo "   Outdir: $OUTDIR"
echo "   Mode:   $( $FRACTIONAL && echo 'fractional' || echo 'sum (non-fractional)' )"

# 0) Preflight
[[ -f "$INPUT_GF" ]] || { echo "❌ Missing INPUT_GF: $INPUT_GF"; exit 1; }
[[ -f "$UTIL/map_ko_uniref90.txt.gz" ]] || { echo "❌ Missing KO mapping: $UTIL/map_ko_uniref90.txt.gz"; exit 1; }
[[ -f "$UTIL/map_ko_name.txt.gz"    ]] || { echo "❌ Missing KO name map: $UTIL/map_ko_name.txt.gz"; exit 1; }

# 1) Fill blanks with zeros so HUMAnN tools never choke on empty cells
echo "🛠  Filling empty cells with 0"
python3 - "$INPUT_GF" "$OUTDIR/filled_genefamilies.tsv" <<'PY'
import pandas as pd, sys
inp, out = sys.argv[1], sys.argv[2]
df = pd.read_csv(inp, sep='\t', dtype=str).fillna("0")
df.to_csv(out, sep='\t', index=False)
PY

# 2) Regroup UniRef90 → KO
#    - Using mapping file explicitly for provenance
#    - FRACTIONAL splits abundances across multiple KOs to avoid double-counting
REGROUP_OPTS=( --groups uniref90_ko --mapping "$UTIL/map_ko_uniref90.txt.gz" )
$FRACTIONAL && REGROUP_OPTS+=( --fractional )

echo "🔁 Regrouping UniRef90 → KO ($([[ $FRACTIONAL == true ]] && echo 'fractional' || echo 'sum'))"
humann_regroup_table \
  --input  "$OUTDIR/filled_genefamilies.tsv" \
  --output "$OUTDIR/gf_ko.tsv" \
  "${REGROUP_OPTS[@]}"

# 3) Attach KO names (optional but nice for figures)
echo "🏷  Adding KO names"
humann_rename_table \
  --input  "$OUTDIR/gf_ko.tsv" \
  --names  "$UTIL/map_ko_name.txt.gz" \
  --output "$OUTDIR/gf_ko_named.tsv"

# 4) Renormalise KO tables to CPM and relab
echo "🔄 Renormalising KO tables (CPM and relab)"
humann_renorm_table --input "$OUTDIR/gf_ko.tsv"       --output "$OUTDIR/gf_ko_cpm.tsv"   --units cpm
humann_renorm_table --input "$OUTDIR/gf_ko.tsv"       --output "$OUTDIR/gf_ko_relab.tsv" --units relab
humann_renorm_table --input "$OUTDIR/gf_ko_named.tsv" --output "$OUTDIR/gf_ko_named_cpm.tsv"   --units cpm
humann_renorm_table --input "$OUTDIR/gf_ko_named.tsv" --output "$OUTDIR/gf_ko_named_relab.tsv" --units relab

# 5) Produce “clean” versions (drop UNMAPPED / UNINTEGRATED) for plotting
echo "🧹 Making cleaned KO tables (drop UNMAPPED/UNINTEGRATED)"
python3 - "$OUTDIR" <<'PY'
import pandas as pd, sys, pathlib
drop = ("UNMAPPED","UNINTEGRATED")
outdir = pathlib.Path(sys.argv[1])
for fn in ["gf_ko_cpm.tsv","gf_ko_relab.tsv","gf_ko_named_cpm.tsv","gf_ko_named_relab.tsv"]:
    p = outdir/fn
    if not p.exists(): continue
    df = pd.read_csv(p, sep='\t')
    idcol = df.columns[0]
    mask = ~df[idcol].str.contains("|".join(drop), case=False, na=False)
    df[mask].to_csv(outdir/(p.stem+"_clean.tsv"), sep='\t', index=False)
PY

echo "✅ Done. Key outputs:"
echo "   • $OUTDIR/gf_ko.tsv                        (KO regrouped)"
echo "   • $OUTDIR/gf_ko_named.tsv                  (with KO names)"
echo "   • $OUTDIR/gf_ko_cpm.tsv / gf_ko_relab.tsv  (normalised)"
echo "   • $OUTDIR/gf_ko_*_clean.tsv                (cleaned for figures)"

