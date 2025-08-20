# Shotgun Taxonomic Profiling – Kaiju (Kvass Dissertation 2025)

This directory contains the **Kaiju taxonomic profiling results** for kvass samples. Kaiju was run with the `nr_euk` database, providing protein-level classification.

---

## 📂 Directory Overview

results/kaiju/
├── figures/ # Visualisations and R scripts
├── tables/ # Abundance tables (phylum-level)
└── README.md # Master documentation


---

## 🔬 Kaiju Outputs

### Tables (`tables/`)
- `phylum_table_kaiju.tsv`  
  → Phylum-level abundance table from Kaiju classifications.

---

## 📊 Figures (`figures/`)

- `phylum_barplot_kaiju.png`  
  → Stacked barplot of relative abundance at the phylum level.  

- `phylum_barplot.R`  
  → Script used to generate the phylum-level barplot.

---

## 📝 Notes

- Kaiju was run using the **greedy algorithm**, `-e 10`, `-s 65`, and the `nr_euk` database.  
- Current outputs focus on **phylum-level** summaries. Species-level tables can be exported if needed.  
- Only final processed results (tables + figures) are included here.

