# Shotgun Metagenomics — Kaiju Workflow

This directory contains scripts for **taxonomic classification** of shotgun metagenomic reads using **Kaiju** with the `nr_euk` database.  
Both **host-filtered** and **yeast-filtered** reads are processed.  

---

## 📜 Script

### `run_kaiju.sh`
Runs **Kaiju** classification on paired-end FASTQ files.  
**Main steps:**
1. Run Kaiju (greedy mode, `-a greedy`, match score ≥ 65, e-value ≤ 10).  
2. Classify both **host-filtered** and **yeast-filtered** Kvass samples.  
3. Write raw classification outputs (`*.out`).  
4. Convert results into **species-level tables** using `kaiju2table`.  

Outputs are separated into:  
- `results/kaiju/host/`  
- `results/kaiju/yeast/`

---

## 📂 Input Files (relative to project root)

- `data/processed/host_filtered_reads/` → Host-filtered paired-end FASTQ files (`*_R1.filtered.fq.gz`, `*_R2.filtered.fq.gz`)  
- `data/processed/yeast_filtered_reads_paired/` → Yeast-filtered paired-end FASTQ files (`*_R1.fq.gz`, `*_R2.fq.gz`)  
- `kaiju_db/nr_euk/kaiju_db_nr_euk.fmi` → Kaiju database (nr + eukaryotes)  
- `kaiju_db/nodes.dmp` → Taxonomy nodes file  
- `kaiju_db/names.dmp` → Taxonomy names file  

---

## 📂 Output Structure

results/
└── kaiju/
├── host/
│ ├── raw/
│ │ ├── <sample>_kaiju.out
│ └── table/
│ └── <sample>_kaiju_species.tsv
└── yeast/
├── raw/
│ ├── <sample>_kaiju.out
└── table/
└── <sample>_kaiju_species.tsv


- `raw/` → Raw Kaiju classification output (per read)  
- `table/` → Species-level abundance summary (per sample)  

---

## 🛠 Requirements

### **Software**
- Kaiju (v1.9.2 or later)  
- Kaiju database (`nr_euk`)  
- Conda environment with Kaiju installed  

### **Environment Setup**
```bash
# Example conda environment for Kaiju
conda create -n kaiju_env -c bioconda kaiju
conda activate kaiju_env

# Database (nr_euk) should be downloaded & built beforehand
# Example structure:
#   kaiju_db/
#     ├── kaiju_db_nr_euk.fmi
#     ├── nodes.dmp
#     └── names.dmp

