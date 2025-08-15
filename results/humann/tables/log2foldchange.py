#!/usr/bin/env python3
# compute_log2fc.py

import pandas as pd
import numpy as np

EPS = 1e-6  # pseudocount to avoid divide-by-zero

# ---- EDIT THESE COMPARISONS (sample A vs sample B) ----
# Sample codes from your project:
# AA=SDX, B1=SDY, C1=LSGF-Kvass-X, D1=STD-Kvass-X, E1=LSF-Kvass-X, F1=LSF-Kvass-Y
comparisons = [
    ("E1_vs_AA", "E1", "AA"),  # LSF-Kvass-X vs SDX
    ("F1_vs_B1", "F1", "B1"),  # LSF-Kvass-Y vs SDY
    ("D1_vs_AA", "D1", "AA"),  # STD-Kvass-X vs SDX
    ("C1_vs_D1", "C1", "D1"),  # LSGF-Kvass-X vs STD-Kvass-X
]

def load_table(path: str) -> pd.DataFrame:
    df = pd.read_csv(path, sep="\t")
    # If first column name starts with "# ", strip it (e.g., "# Gene Family" -> "Gene Family")
    first = df.columns[0]
    if first.startswith("#"):
        df = df.rename(columns={first: first.lstrip("# ").strip()})
    return df

def find_col(cols, sample_code):
    """Find the column that belongs to the sample code (handles both file types)."""
    candidates = [
        f"{sample_code}_combined_Abundance-RPKs",  # gene family file
        f"{sample_code}_combined_Abundance",       # pathways file
    ]
    for cand in candidates:
        if cand in cols:
            return cand
    # Fallback: any column starting with "<code>_combined_Abundance"
    for c in cols:
        if c.startswith(f"{sample_code}_combined_Abundance"):
            return c
    raise KeyError(f"Could not find column for sample '{sample_code}' in columns: {cols}")

def add_log2fc(df: pd.DataFrame, id_col: str, tag: str) -> pd.DataFrame:
    out = df.copy()
    for name, a_code, b_code in comparisons:
        col_a = find_col(out.columns, a_code)
        col_b = find_col(out.columns, b_code)
        new_col = f"log2FC_{name}"
        out[new_col] = np.log2((out[col_a].astype(float) + EPS) / (out[col_b].astype(float) + EPS))
    # Move ID column to front, keep everything else afterwards
    cols = [id_col] + [c for c in out.columns if c != id_col]
    return out[cols]

def main():
    # ---- Gene families (KOs) ----
    gf_path = "gf_ko_cpm.tsv"
    gf_df = load_table(gf_path)
    gf_id = gf_df.columns[0]  # "Gene Family"
    gf_out = add_log2fc(gf_df, gf_id, tag="ko")
    gf_out.to_csv("gf_ko_cpm_log2fc.tsv", sep="\t", index=False)

    # ---- Pathways ----
    pw_path = "pathways_cpm_clean.tsv"
    pw_df = load_table(pw_path)
    pw_id = pw_df.columns[0]  # "Pathway"
    pw_out = add_log2fc(pw_df, pw_id, tag="pwy")
    pw_out.to_csv("pathways_cpm_clean_log2fc.tsv", sep="\t", index=False)

if __name__ == "__main__":
    main()

