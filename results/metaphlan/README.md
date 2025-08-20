
---

## 🧪 Quality Control

### Raw reads (`multiqc_raw/`)
- `multiqc_report.html` → interactive QC report.
- `multiqc_data/` → per-base quality, GC %, sequence counts, duplication, adapter content, overrepresented sequences, and summary stats.

### Trimmed reads (`multiqc_trimmed/`)
- `multiqc_report.html` → QC after trimming.
- `multiqc_data/` → improved sequence quality, reduced adapters, normalised length distribution.

---

## 🔬 MetaPhlAn4 Outputs

### Tables (`tables/`)
- `species_table_metaphlan_0.2.tsv`  
  → Species-level relative abundances (filtered at `stat_q=0.2`).

➡ This table is the main input for downstream visualisations and statistical analysis.

---

## 📊 Figures (`figures/`)

- `species_barplot_metaphlan.png`  
  → Stacked barplot of species-level relative abundance per sample.

- `species_barplot.R`  
  → Script to generate the species barplot (ggplot2-based).

- `species_heatmap.R`  
  → Script to generate species-level heatmaps.

---

## 📝 Notes

- **QC (MultiQC)** is provided both pre- and post-trimming for transparency.  
- **Final taxonomic profiling table**: `tables/species_table_metaphlan_0.2.tsv`.  
- **Figures** are generated from the filtered species table using R.  
- All `.R` scripts are included for reproducibility of visualisations.  

---

