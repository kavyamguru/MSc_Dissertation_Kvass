#!/usr/bin/env Rscript
# phagc_heatmap_ordered.R

# install.packages(c("readr","dplyr","tibble","pheatmap","matrixStats","RColorBrewer"))
library(readr)
library(dplyr)
library(tibble)
library(pheatmap)
library(matrixStats)
library(RColorBrewer)

# 1) Read your table
df <- read_tsv("phagc_summary_hits_nonzero_v4.tsv", col_types = cols())

# 2) Define your six samples (must exactly match the TSV header) and plot order
all.samples <- c("SDX","SDY","LSGFKvassX","STDKvassX","LSFKvassX","LSFKvassY")
# Here’s the order you want on the x-axis:
plot.order  <- c("SDX","SDY","LSGFKvassX","STDKvassX","LSFKvassX","LSFKvassY")

# 3) Build the KO × sample matrix (sum duplicates)
mat <- df %>%
  select(gene_id, all_of(all.samples)) %>%
  group_by(gene_id) %>%
  summarize(across(all_of(all.samples), sum, na.rm=TRUE),
            .groups="drop") %>%
  column_to_rownames("gene_id") %>%
  as.matrix()

# 4) Row‐wise Z‐score
mat_z <- t((t(mat) - rowMeans(mat)) / rowSds(mat))
mat_z[is.na(mat_z)] <- 0

# 5) Make a tiny column‐metadata frame for Fermentation
#    **YOU MUST** flip these to your real categories per sample
ferment <- c(
  SDX        = "Starter",
  SDY        = "Starter",
  LSGFKvassX = "Sample",
  STDKvassX  = "Sample",
  LSFKvassX  = "Sample",
  LSFKvassY  = "Sample"
)
col.meta <- data.frame(
  Fermentation = factor(ferment[all.samples],
                        levels = c("Starter","Sample")),
  row.names = all.samples,
  stringsAsFactors = FALSE
)

# 6) Reorder your matrix columns by that metadata order
mat_z <- mat_z[, plot.order]

# 7) Prepare your PHAGC_Category annotation (must be in same row order)
row.ann <- df %>%
  distinct(gene_id, PHAGC_Category) %>%
  column_to_rownames("gene_id") %>%
  .[rownames(mat_z), , drop=FALSE]

ann.cols <- list(
  PHAGC_Category = c(
    Colonisation = "#1b9e77",
    Survival     = "#d95f02",
    Modulation   = "#7570b3"
  ),
  Fermentation = c(
    Starter     = brewer.pal(3,"Set1")[1],
    Sample = brewer.pal(3,"Set1")[2]
  )
)

# 8) Draw & save
png("phagc_heatmap_ordered.png", width=1800, height=1200, res=200)
pheatmap(
  mat_z,
  color             = colorRampPalette(brewer.pal(9,"YlGnBu"))(100),
  annotation_row    = row.ann,
  annotation_col    = col.meta,
  annotation_colors = ann.cols,
  cluster_rows      = TRUE,
  cluster_cols      = FALSE,   # <-- keeps your left→right order
  show_rownames     = TRUE,
  show_colnames     = TRUE,
  fontsize_row      = 8,
  fontsize_col      = 10,
  border_color      = NA,
  main              = "PHAGC KO hits (row-z-scored)"
)
dev.off()

