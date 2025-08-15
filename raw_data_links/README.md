# 🔗 Raw Data Links

This directory contains text files listing **download links** for all raw and processed sequencing data used in this project.  
Links are placeholders until data is uploaded to a public repository.

---

## 📂 Files

### **16S rRNA Amplicon Sequencing**
- `16s_raw_links.txt` → Links to raw paired-end FASTQ files from sequencing provider (Novogene).
- `16s_trimmed_trimmomatic_links.txt` → Links to trimmed paired-end FASTQ files (processed with Trimmomatic via QIIME2).

### **Shotgun Metagenomic Sequencing**
- `shotgun_raw_links.txt` → Links to raw paired-end FASTQ files from sequencing provider (Novogene).
- `shotgun_trimmed_fastp_links.txt` → Links to quality-trimmed paired-end FASTQ files (processed via Fastp).
- `shotgun_host_filtered_links.txt` → Links to host-filtered paired-end FASTQ files (processed via Bowtie2).

---

## 🛠 Usage
- Replace `[ADD LINK HERE]` placeholders with actual public URLs before sharing the repository.
- Recommended public repositories:
  - **NCBI SRA** (Sequence Read Archive)
  - **Zenodo**
  - **OneDrive / Google Drive** (for large non-SRA-compatible files)
- Example entry:
  ```
  SDX_R1.fastq.gz - https://example.com/download/SDX_R1.fastq.gz
  ```

---

## 🔔 Notes
- File naming matches **sample IDs** used in metadata and manifests.
- Links should point directly to downloadable files (no login required).
- For reproducibility, include both raw and processed datasets if possible.

