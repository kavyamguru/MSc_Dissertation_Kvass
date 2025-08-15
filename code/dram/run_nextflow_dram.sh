#!/bin/bash

# Activate DRAM environment
source activate dram2_env

# Set key directories
READS_DIR="$HOME/Kvass_project/data/processed/host_filtered_reads"
ASSEMBLY_DIR="$HOME/Kvass_project/assemblies_host"
DRAM_OUTDIR="$HOME/Kvass_project/results/functional_profiling/dram_out_host"
DRAM_DB="$HOME/Kvass_project/dram_db"
CONFIG="$HOME/Kvass_project/scripts/nextflow.config"

# STEP 1: Assemble reads using MEGAHIT (one per sample)
mkdir -p "$ASSEMBLY_DIR"

for R1 in ${READS_DIR}/*_R1.filtered.fq.gz; do
    SAMPLE=$(basename "$R1" | cut -d'_' -f1)
    R2="${R1/_R1.filtered.fq.gz/_R2.filtered.fq.gz}"
    OUTDIR="${ASSEMBLY_DIR}/${SAMPLE}"
    mkdir -p "$OUTDIR"

    echo "Assembling $SAMPLE..."
    megahit -1 "$R1" -2 "$R2" -o "$OUTDIR" --out-prefix final --min-contig-len 2500 --presets meta-sensitive
done

# STEP 2: Run DRAM Nextflow pipeline
nextflow run WrightonLabCSU/DRAM -r v2.0.0-beta12 \
  -c "$CONFIG" \
  --input_fasta "${ASSEMBLY_DIR}/*/final.contigs.fa" \
  --outdir "$DRAM_OUTDIR" \
  --call all \
  --uniref_db "${DRAM_DB}/uniref90.20250717.mmsdb" \
  --pfam_mmseq_db "${DRAM_DB}/pfam.mmspro" \
  --kofam_db "${DRAM_DB}/kofam_profiles.hmm" \
  --kofam_list "${DRAM_DB}/kofam_ko_list.tsv" \
  --dbcan_db "${DRAM_DB}/dbCAN-HMMdb-V11.txt" \
  --dbcan_fam_activities "${DRAM_DB}/CAZyDB.08062022.fam-activities.txt" \
  --dbcan_subfam_activities "${DRAM_DB}/CAZyDB.08062022.fam.subfam.ec.txt" \
  --vog_db "${DRAM_DB}/vog_annotations_latest.tsv.gz" \
  --vog_list "${DRAM_DB}/vog_annotations_latest.tsv.gz" \
  --camper_hmm_db "${DRAM_DB}/camper/hmm/" \
  --camper_hmm_list "${DRAM_DB}/camper/hmm/camper_hmm_scores.tsv" \
  --camper_mmseqs_db "${DRAM_DB}/camper/mmseqs/" \
  --camper_mmseqs_list "${DRAM_DB}/camper/mmseqs/camper_scores.tsv" \
  --canthyd_hmm_db "${DRAM_DB}/canthyd/hmm/" \
  --cant_hyd_hmm_list "${DRAM_DB}/canthyd/hmm/cant_hyd_HMM_scores.tsv" \
  --canthyd_mmseqs_db "${DRAM_DB}/canthyd/mmseqs/" \
  --canthyd_mmseqs_list "${DRAM_DB}/canthyd/mmseqs/cant_hyd_BLAST_scores.tsv" \
  --fegenie_db "${DRAM_DB}/fegenie/" \
  --fegenie_list "${DRAM_DB}/fegenie/fegenie_iron_cut_offs.txt" \
  --sulfur_db "${DRAM_DB}/sulfur/" \
  --methyl_db "${DRAM_DB}/methyl/" \
  --sql_descriptions_db "${DRAM_DB}/description_db.sqlite" \
  --min_contig_len 2500 \
  --prodigal_trans_table 11

