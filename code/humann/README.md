# Shotgun Metagenomics — HUMAnN3 Workflow

This directory contains scripts for **functional profiling** of host-filtered shotgun metagenomic reads using **HUMAnN3**, as well as post-processing utilities for KEGG/KO mapping, QIIME2 diversity analysis, and visualisation.  
It follows the B269797 project structure and produces curated pathway/gene tables and publication-quality figures.

---

## 📜 Scripts

### `run_humann.sh`
Runs **HUMAnN3** on host-filtered paired-end reads (`stat_q=0.20`).  
**Steps:**
1. Merge host-filtered R1/R2 reads per sample.  
2. Run HUMAnN3 with ChocoPhlAn + UniRef databases.  
3. Uses MetaPhlAn options: `--stat_q 0.20`.  
4. Outputs per-sample pathway and gene-family tables.  

Outputs → `results/humann/host_q20/<Sample>/`

---

### `humann_prepare_tables.sh`
Prepares merged HUMAnN3 tables for QIIME2 input.  
**Steps:**
1. Take merged **pathway abundance** and **gene-family** tables.  
2. Renormalise to relative abundances.  
3. Remove leading `#` symbols.  
4. Save in `prepared_for_qiime/`.  

Outputs:  
- `merged_pathabundance_relab.tsv`  
- `merged_genefamilies_relab.tsv`  

---

### `qiime_humann_diversity.sh`
Computes **α- and β-diversity** in QIIME2 using HUMAnN3-prepared tables.  
**Steps:**
- α-diversity: Observed Features & Shannon index.  
- α-group-significance: tested against metadata (`Starter`, `Sample_Type`, `Formulation`, `Inulin`, `Ginger`, `Sugar`).  
- β-diversity: Bray–Curtis PCoA + Emperor plots.  

Outputs →  
- `results/humann3/.../qiime_alpha/`  
- `results/humann3/.../qiime_beta/`  

---

### `uniref_ko_mapping.sh`
Regroups HUMAnN UniRef90 gene families into **KEGG Orthologs (KOs)**.  
**Steps:**
1. Fill blanks with zeros.  
2. Regroup UniRef90 → KO using HUMAnN’s mapping (`map_ko_uniref90.txt.gz`).  
3. Optionally use **fractional regrouping** to avoid double-counting.  
4. Rename KOs with gene names.  
5. Renormalise to CPM and relative abundances.  
6. Produce *cleaned* tables (drop UNMAPPED / UNINTEGRATED).  

Outputs:  
- `gf_ko.tsv` (KO regrouped)  
- `gf_ko_named.tsv` (with KO names)  
- `gf_ko_cpm.tsv`, `gf_ko_relab.tsv` (normalised)  
- `gf_ko_*_clean.tsv` (ready for figures)  

---

### `run_extract_curated.sh`
Extracts **curated lists** of KO/pathway hits for downstream visualisation.  
- Reads curated KO and pathway lists from `data/humann/curated/`.  
- Produces filtered tables in `results/humann/curated_hits/`.  

---

### `ko_hits_heatmap.R`
Generates a **publication-ready KO heatmap**.  
- Input: `curated_ko_hits.tsv`  
- Row-wise z-scored RPK values.  
- Annotations: KO ID, gene short name (italic), functional category.  
- Custom sample ordering (SDX, STDkvassX, …).  
- Outputs: `Curated_KO_Heatmap.tiff` (600 dpi, LZW compression).  

---

### `pathway_heatmap.R`
Generates a **publication-ready MetaCyc pathway heatmap**.  
- Input: `curated_pathway_hits.tsv`  
- Row-wise z-scored abundances.  
- Annotations: pathway categories + full pathway names.  
- Custom sample ordering.  
- Outputs: `Curated_Pathways_Heatmap.tiff` (600 dpi, LZW compression).  

---

## 📂 Input Files (relative to project root)

- `data/processed/host_filtered_reads/` → Host-filtered paired-end FASTQ files.  
- `humann_db/chocophlan/` → Nucleotide database.  
- `humann_db/uniref/` → Protein database.  
- `humann_db/metaphlan_db_2023/` → MetaPhlAn database.  
- `data/humann/curated/` → Curated KO and pathway target lists.  
- `metadata/shotgun/shotgun_metadata.tsv` → Sample metadata (for QIIME2 diversity).  

---

## 📂 Output Structure

results/
└── humann3/
├── host_q20/
│ ├── <Sample>/ # per-sample HUMAnN3 outputs
│ ├── merged_genefamilies.tsv
│ ├── pa_abundance_unstratified.tsv
│ ├── prepared_for_qiime/
│ │ ├── merged_pathabundance_relab.tsv
│ │ └── merged_genefamilies_relab.tsv
│ ├── tmp/inputs/ko/ # KO regrouped tables
│ ├── curated_hits/ # Extracted curated KO/pathway hits
│ ├── qiime_alpha/ # HUMAnN α-diversity results
│ └── qiime_beta/ # HUMAnN β-diversity results


---

## 🛠 Requirements

### **Software**
- HUMAnN3 (v3.9 or later)  
- MetaPhlAn4 (with HUMAnN-compatible database)  
- Bowtie2  
- Python ≥ 3.8 with `pandas`  
- QIIME2 (2024.2 tested)  
- R ≥ 4.0 with packages: `tidyverse`, `ComplexHeatmap`, `circlize`, `RColorBrewer`, `grid`  

### **Environment Setup**
```bash
# Conda environment for HUMAnN3 + MetaPhlAn
conda create -n humann_env python=3.9
conda activate humann_env
conda install -c bioconda humann metaphlan bowtie2

# QIIME2 environment
wget https://data.qiime2.org/distro/core/qiime2-2024.2-py38-linux-conda.yml
conda env create -n qiime2-2024.2 --file qiime2-2024.2-py38-linux-conda.yml

# R packages (install inside R)
install.packages(c("tidyverse","ComplexHeatmap","circlize","RColorBrewer"))

