# Shotgun Metagenomics — MetaPhlAn4 Workflow

This directory contains scripts for **taxonomic profiling** of host-filtered shotgun metagenomic reads using **MetaPhlAn4**.  
It follows the B269797 project structure and generates merged species-level tables for downstream analyses.

---

## 📜 Script

### `run_metaphlan.sh`
Runs **MetaPhlAn4** with `stat_q=0.2` on paired-end host-filtered reads.  
**Main steps:**
1. Run MetaPhlAn4 on each sample (paired-end FASTQ).  
2. Save per-sample species profiles (`*_profile.txt`).  
3. Merge all profiles into a single abundance table (`merged_abundance.tsv`).  
4. Generate a summary file with non-zero **species and genus counts per sample**.  
5. Extract species-only abundance table (`species_table_metaphlan_0.2.tsv`) for downstream use.  

Outputs are saved under:
- `results/metaphlan/host_filtered/statq_0.2/`
- `results/metaphlan/tables/`

---

## 📂 Input Files (relative to project root)

- `data/processed/host_filtered_reads/` → Host-filtered paired-end FASTQ files (`*_R1.fq.gz` / `*_R2.fq.gz`)  
- `databases/metaphlan_db/` → MetaPhlAn4 database  
- Database index: `mpa_vJan25_CHOCOPhlAnSGB_202503`

---

## 📂 Output Structure

results/
└── metaphlan/
├── host_filtered/
│ └── statq_0.2/
│ ├── profiles/
│ │ ├── <sample1>_profile.txt
│ │ ├── <sample2>_profile.txt
│ │ └── ...
│ ├── bowtie2out/
│ │ ├── <sample1>.bt2.bz2
│ │ ├── <sample2>.bt2.bz2
│ │ └── ...
│ ├── merged_abundance.tsv
│ └── merged_abundance_summary.tsv
└── tables/
└── species_table_metaphlan_0.2.tsv


---

## 🛠 Requirements

### **Software**
- MetaPhlAn4 (latest version, tested with `stat_q=0.2`)  
- Bowtie2  
- Python ≥ 3.8 with `pandas`  
- Standard Linux utilities (bash, sed, gzip)  

### **Environment Setup**
```bash
# Example conda environment for MetaPhlAn4
conda create -n metaphlan4 python=3.9
conda activate metaphlan4

# Install MetaPhlAn4 + Bowtie2
conda install -c bioconda metaphlan bowtie2

# Install Python packages
pip install pandas

