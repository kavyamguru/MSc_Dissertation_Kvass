# Shotgun Metagenomics — Kraken2 + Bracken Workflow

This directory contains scripts for **taxonomic profiling** of host-filtered shotgun metagenomic reads using **Kraken2** for classification and **Bracken** for abundance re-estimation.  
It follows the B269797 project structure and generates merged species-, genus-, and phylum-level tables for downstream analyses.

---

## 📜 Script

### `run_kraken_braken.sh`
Runs **Kraken2 + Bracken** on paired-end host-filtered reads.  
**Main steps:**
1. Run Kraken2 on each sample (paired FASTQ).  
2. Generate per-sample reports and classification outputs.  
3. Run Bracken at **species, genus, and phylum levels**.  
4. Apply abundance threshold filter (`--t ≥ 0.001`).  
5. Merge all **species-level Bracken outputs** into a single abundance table (`species_table_bracken_0.2.tsv`).  

Outputs are saved under:
- `results/kraken_bracken/tables/`

---

## 📂 Input Files (relative to project root)

- `raw_data_links/shotgun_host_filtered_links.txt`  
  → Tab-separated file listing: **SampleID, R1_path, R2_path**  

- `kraken2_db/`  
  → Kraken2/Bracken database (built in advance)  

---

## 📂 Output Structure


results/
└── kraken_bracken/
└── tables/
├── <Sample>_kraken2_output_conf0.2.txt
├── <Sample>_kraken2_report_conf0.2.txt
├── <Sample>_bracken_species_conf0.2.txt
├── <Sample>_bracken_species_conf0.2_thr0.001.txt
├── <Sample>_bracken_genus_conf0.2.txt
├── <Sample>_bracken_genus_conf0.2_thr0.001.txt
├── <Sample>_bracken_phylum_conf0.2.txt
├── <Sample>_bracken_phylum_conf0.2_thr0.001.txt
└── species_table_bracken_0.2.tsv # merged species-level table


---

## 🛠 Requirements

### **Software**
- Kraken2 (v2.1.2 or later)  
- Bracken (v2.8 or later)  
- Python ≥ 3.8 with `pandas`  
- Standard Linux utilities (`awk`, `bash`)  

### **Environment Setup**
```bash
# Create conda environment
conda create -n kraken_bracken python=3.9
conda activate kraken_bracken

# Install tools
conda install -c bioconda kraken2 bracken
pip install pandas

