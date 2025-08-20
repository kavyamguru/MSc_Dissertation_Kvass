# Functional Profiling — DRAM v2 Workflow

This directory contains scripts for **functional annotation** of metagenome assemblies using **DRAM v2 (Nextflow)** and for generating publication-ready heatmaps of **CAZymes** and **PHAGC genes**.

---

## 📜 Scripts

### `run_megahit.sh`
Runs **MEGAHIT** assemblies on host-filtered paired-end reads.

- Input: `~/Kvass_project/data/processed/host_filtered_reads/*_R1.filtered.fq.gz`  
- Output: `~/Kvass_project/assemblies_host/<Sample>/final.contigs.fa`  

Features:  
- Skips already-completed assemblies.  
- Cleans up empty output directories.  
- Uses: `--min-contig-len 1000 -t 32`  

---

### `run_nextflow_dram.sh`
Runs the **DRAM v2 Nextflow pipeline** on assembled contigs.

**Steps:**
1. Assembles each sample with MEGAHIT (`--min-contig-len 2500 --presets meta-sensitive`).  
2. Executes DRAM v2.0.0-beta12 with `--call all`.  
3. Uses local DRAM database (`~/Kvass_project/dram_db`).  

Key DBs included: UniRef90, Pfam, KOfam, dbCAN, VOG, CaMPER, Canthyd, FeGenie, sulfur/methyl metabolism, SQLite descriptions.  

Output:  
- `~/Kvass_project/results/functional_profiling/dram_out_host/`

---

### `cazy_heatmap.R`
Generates a **CAZyme heatmap** (row Z-scored, `YlGnBu` palette).  
- Input: curated CAZyme hit table (TSV).  
- Output: `CAZy_heatmap.png`, `CAZy_heatmap.tiff` (600 dpi, LZW compression).  
- Thesis-consistent ordering for samples and categories.  

---

### `phagc_heatmap.R`
Generates a **PHAGC KO heatmap**.  
Two versions are maintained:  

- `cazy_heatmap.R` → newer **ComplexHeatmap-based** script (strict thesis order, no clustering, better legends).  
- `phagc_heatmap.R` → older **pheatmap-based** script (includes starter/sample annotation).  

**Both scripts:**
- Input: `phagc_summary_hits_nonzero_v4.tsv`  
- Output: heatmap PNG (row Z-scored, `YlGnBu` palette, annotated by PHAGC category).  

---

## 📂 Input Files

- `~/Kvass_project/data/processed/host_filtered_reads/` → Host-filtered paired-end FASTQ files.  
- `~/Kvass_project/assemblies_host/` → MEGAHIT assemblies.  
- `~/Kvass_project/dram_db/` → DRAM databases (UniRef, Pfam, KOfam, dbCAN, VOG, etc.).  
- `phagc_summary_hits_nonzero_v4.tsv` → curated PHAGC gene hits (for heatmaps).  
- Curated CAZy tables (TSVs) → for CAZyme heatmap.  

---

## 📂 Output Structure

results/
└── functional_profiling/
└── dram_out_host/
├── annotations/ # DRAM annotations
├── genome_summaries/ # Functional summaries per genome
└── product/ # Final reports
assemblies_host/
└── <Sample>/final.contigs.fa
figures/
└── DRAM/
├── CAZy_heatmap.png / .tiff
└── PHAGC_heatmap.png / .tiff


---

## 🛠 Requirements

### Software
- MEGAHIT (v1.2+)  
- DRAM v2.0.0-beta12 (Nextflow implementation)  
- Nextflow ≥ 23  
- Conda environment `dram2_env` with DRAM dependencies  
- R ≥ 4.0 with `tidyverse`, `ComplexHeatmap`, `circlize`, `RColorBrewer`, `pheatmap`, `matrixStats`  

### Environment Setup
```bash
# Conda for DRAM2
conda create -n dram2_env python=3.9
conda activate dram2_env
conda install -c bioconda megahit nextflow dram

# R packages
install.packages(c("tidyverse","ComplexHeatmap","circlize","RColorBrewer","pheatmap","matrixStats"))

