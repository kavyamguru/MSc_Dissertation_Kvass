# Shotgun Taxonomic Profiling – Kraken2 + Bracken (Kvass Dissertation 2025)

This directory contains the **Kraken2 + Bracken species-level profiling results** for kvass samples. Bracken was used to re-estimate species abundances from Kraken2 assignments.

---

## 📂 Directory Overview

results/kraken_bracken/
├── figures/ # Visualisations and R scripts
├── tables/ # Species-level abundance tables
└── README.md # Master documentation


---

## 🔬 Kraken2 + Bracken Outputs

### Tables (`tables/`)
- `species_table_bracken_0.2.tsv`  
  → Species-level abundance estimates (confidence threshold `0.2`).

This table is the main input for visualisations and downstream statistical analysis.

---

## 📊 Figures (`figures/`)

- `species_barplot.png`  
  → Stacked barplot of species-level relative abundance per sample.

- `species_barplot_kraken.R`  
  → Script used to generate the barplot.

---

## 📝 Notes

- Kraken2 was used for taxonomic assignment.  
- Bracken adjusted the abundance estimates at the species level (`stat_q=0.2`).  
- Only final processed results (tables + figures) are included here.  

