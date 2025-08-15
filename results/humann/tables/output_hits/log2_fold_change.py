#!/usr/bin/env python3
import pandas as pd
import numpy as np

EPS = 1e-9  # pseudocount

# Define all comparisons you want (A vs B)
comparisons = [
    ("AA", "B1"),
    ("AA", "D1"),
    ("B1", "F1"),
    ("D1", "C1"),
    ("D1", "E1"),
    ("E1", "F1"),
]

def read_table(path: str) -> pd.DataFrame:
    # Read even if first header starts with "#"
    df = pd.read_csv(path, sep="\t", comment=None)
    cols = list(df.columns)
    if cols and str(cols[0]).startswith("#"):
        df.columns = [c.lstrip("# ").strip() for c in cols]
    return df

def find_sample_col(columns, sample_id):
    """
    Find the column for a given sample ID.
    Works for both:
      - AA_combined_Abundance
      - AA_combined_Abundance-RPKs
    Returns the first match.
    """
    for c in columns:
        if c.startswith(f"{sample_id}_combined_Abundance"):
            return c
    return None

def add_log2fc_columns(df: pd.DataFrame, sample_pairs) -> pd.DataFrame:
    out = df.copy()
    for A, B in sample_pairs:
        colA = find_sample_col(out.columns, A)
        colB = find_sample_col(out.columns, B)
        if colA is None or colB is None:
            raise ValueError(f"Could not find columns for {A} or {B}. "
                             f"Available columns include: {[c for c in out.columns if '_combined_Abundance' in c]}")
        colname = f"log2FC_{A}_vs_{B}"
        out[colname] = np.log2((out[colA].astype(float) + EPS) / (out[colB].astype(float) + EPS))
    return out

def main():
    # ---- KOs ----
    ko_in  = "ko_hits.tsv"
    ko_out = "ko_hits_log2FC_multi.tsv"
    ko_df  = read_table(ko_in)
    ko_df  = add_log2fc_columns(ko_df, comparisons)
    ko_df.to_csv(ko_out, sep="\t", index=False)
    print(f"Wrote {ko_out}")

    # ---- Pathways ----
    pw_in  = "curated_pathway_hits.tsv"
    pw_out = "curated_pathway_hits_log2FC_multi.tsv"
    pw_df  = read_table(pw_in)
    pw_df  = add_log2fc_columns(pw_df, comparisons)
    pw_df.to_csv(pw_out, sep="\t", index=False)
    print(f"Wrote {pw_out}")

if __name__ == "__main__":
    main()

