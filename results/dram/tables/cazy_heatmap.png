#!/usr/bin/env python3
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# 1) Load your TSV (or CSV) into a DataFrame
#   — if it’s tab-delimited, use sep="\t"
df = pd.read_csv("cazyme_abundance_matrix.tsv", sep="\t", index_col="CAZy")

# 2) Z-score each row (pathway) so they all live on the same scale
df_z = df.sub(df.mean(axis=1), axis=0).div(df.std(axis=1), axis=0)

# 3) (Optional) sort by variance so the most dynamic CAZy families rise to the top
order = df_z.var(axis=1).sort_values(ascending=False).index
df_z = df_z.loc[order]

# 4) Plot
fig, ax = plt.subplots(figsize=(8, 12))
im = ax.imshow(df_z.values, aspect='auto', interpolation='nearest', cmap='viridis')
cbar = fig.colorbar(im, ax=ax)
cbar.set_label('Z-score relative abundance', rotation=270, labelpad=15)

# 5) Ticks & labels
ax.set_xticks(np.arange(len(df_z.columns)))
ax.set_xticklabels(df_z.columns, rotation=45, ha='right', fontsize=10)
ax.set_yticks(np.arange(len(df_z.index)))
ax.set_yticklabels(df_z.index, fontsize=8)
ax.invert_yaxis()  # so highest-variance CAZy are at the top
ax.set_title("Heatmap of CAZy Family Relative Profiles", pad=20)

plt.tight_layout()
plt.savefig("cazy_heatmap.png", dpi=300)
plt.show()
