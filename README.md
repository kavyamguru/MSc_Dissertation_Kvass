<<<<<<< HEAD
# Kvass Microbiome Dissertation – 2025

This repository contains the full analysis workflow and results for **microbiome profiling of kvass fermentation**.  
It integrates **16S rRNA sequencing** and **shotgun metagenomics** across multiple tools for **taxonomic and functional profiling**.

---

## 📂 Project Structure

Dissertation-2025/
├── code/ # Analysis and pipeline scripts
├── metadata/ # Sample metadata and manifests
├── raw_data_links/ # Links to raw and processed sequencing data
├── results/ # Processed results (taxonomic + functional)
└── README.md # Master documentation (this file)


---

## 🧩 1. Code (`code/`)

Contains scripts for running each tool, plus plotting and post-processing.

- **16S (QIIME2)** → `code/16s_qiime2/`  
  - `run_qiime_v3v4.sh` → Core 16S pipeline (import, DADA2, taxonomy, diversity).  
  - `qiime2_16s_core_metrics.sh` / `qiime2_16s_coremetrics_permanova.sh` → Diversity metrics and statistical tests.  
  - `genus_heatmap_barplot.R` → R script for heatmaps/barplots.  
  - `requirements_environment.md` → Software and environment setup.  

- **Shotgun Taxonomy**  
  - `code/metaphlan/run_metaphlan.sh`  
  - `code/kraken_bracken/run_kraken_braken.sh`  
  - `code/kaiju/run_kaiju.sh`  

- **Functional Profiling**  
  - `code/humann/run_humann.sh` + `humann_prepare_tables.sh` → HUMAnN3 workflow.  
  - `code/dram/run_nextflow_dram.sh` + `run_megahit.sh` → DRAM v2 workflow.  
  - R scripts for heatmaps: `ko_hits_heatmap.R`, `pathway_heatmap.R`, `cazy_heatmap.R`, `phagc_heatmap.R`.  

Each tool folder also has a **README.md** describing usage.

---

## 🧾 2. Metadata (`metadata/`)

Sample information and sequencing manifests.

- **16S rRNA** → `metadata/16s/`  
  - `16s_metadata.tsv` → Sample metadata with experimental variables.  
  - `manifest_16S_raw.tsv` / `manifest_16S_trimmed.tsv` → Paths to FASTQ files.  

- **Shotgun metagenomics** → `metadata/shotgun/`  
  - `shotgun_metadata.tsv` → Sample metadata.  
  - `manifest_shotgun_raw.tsv` / `manifest_shotgun_trimmed.tsv` / `manifest_shotgun_host_filtered.tsv`.  

---

## 🔗 3. Raw Data Links (`raw_data_links/`)

Text files with symbolic links or remote references to sequencing files.  
Includes:
- `16s_raw_links.txt`, `16s_trimmed_trimmomatic_links.txt`  
- `shotgun_raw_links.txt`, `shotgun_trimmed_fastp_links.txt`, `shotgun_host_filtered_links.txt`  

---

## 📊 4. Results (`results/`)

All processed outputs, structured by tool:

### **A. 16S rRNA – QIIME2 (`results/16s/`)**
- **qc/** → MultiQC reports (raw + trimmed FASTQ).  
- **qiime2/** → Core QIIME2 outputs (DADA2, taxonomy, exports, phylogenetic tree, diversity).  
- **figures/** → Alpha diversity, beta diversity PCoA plots, heatmaps, barplots, taxonomy barplots.  
- **tables/** → Genus- and phylum-level abundance tables, metadata summaries.  
- **archives/** → Archived full GTDB classifier results.  

### **B. Shotgun Taxonomy**
- **MetaPhlAn (`results/metaphlan/`)**  
  - Figures: species barplots, heatmaps.  
  - QC: `multiqc_raw/`, `multiqc_trimmed/`.  
  - Tables: `species_table_metaphlan_0.2.tsv`.  

- **Kraken2 + Bracken (`results/kraken_bracken/`)**  
  - Figures: species barplot.  
  - Tables: `species_table_bracken_0.2.tsv`.  

- **Kaiju (`results/kaiju/`)**  
  - Figures: phylum-level barplot.  
  - Tables: `phylum_table_kaiju.tsv`.  

### **C. Functional Profiling**
- **HUMAnN3 (`results/humann/`)**  
  - **tables/** → Gene families, pathway abundances, log2 fold-change results, curated outputs.  
  - **qiime_alpha/** and **qiime_beta/** → Converted HUMAnN outputs into QIIME2 diversity formats.  
  - **figures/** → Plots (heatmaps, diversity, pathway barplots).  

- **DRAM v2 (`results/dram/`)**  
  - **tables/** → CAZyme matrices, pathway hits, genome summaries, overlaps with HUMAnN.  
  - **figures/** → CAZyme and pathway heatmaps, PHAGC gene panels.  

---

## 🛠️ 5. Requirements

- **QIIME2 2024.2** + plugins  
- **HUMAnN3 (biobakery3)**  
- **DRAM v2.0.0** (Nextflow pipeline)  
- **Kraken2 v2.1.3**, **Bracken v2.8**  
- **Kaiju v1.9.2**  
- **MetaPhlAn 4.0**  
- **R 4.3** (ggplot2, pheatmap, vegan, etc.)  
- **Python 3.8+** (pandas, matplotlib, seaborn)  

Environment setup scripts are provided in each `code/` subdirectory.  

---

## 📝 Notes

- All `README.md` files in subfolders provide local documentation; this file provides the **global overview**.  
- Figures and tables are harmonised for downstream analysis and inclusion in the dissertation.  
- Archived GTDB QIIME2 results are preserved under `results/16s/archives/`.  
- Custom R scripts for plotting (`code/*/*.R`) and helper Python scripts (`log2foldchange.py`, `heatmap_cazyme.py`) are included.  

---

📌 This structure ensures **reproducibility and traceability** from raw data through to processed figures/tables used in the dissertation.


d traceability** from raw data through to processed figures/tables used in the dissertation.
>>>>>>> origin/main
