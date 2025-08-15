# =========================
# PHAGC KO heatmap (rows Z-scored, YlGnBu)
# Thesis-consistent ordering for samples, categories, and rows
# =========================
library(tidyverse)
library(ComplexHeatmap)
library(circlize)
library(RColorBrewer)

# ---- I/O ----
infile     <- "phagc_summary_hits_nonzero_v4.tsv"
out_prefix <- "phagc_heatmap_KOids_ylgnbu_rowsZ_THESIS"

# ---- Read ----
raw <- read_tsv(infile, comment = "#", show_col_types = FALSE)

# ---- Thesis order for samples (columns) ----
sample_order <- c("SDX","STDkvassX","LSFkvassX","LSGFkvassX","SDY","LSFkvassY")
missing <- setdiff(sample_order, names(raw))
if (length(missing)) stop("Missing expected sample columns: ", paste(missing, collapse = ", "))

# ---- Keep, numeric, collapse duplicates ----
keep_cols <- c("gene_id","PHAGC_Category","PHAGC_Function","gene_description","Matched_Term", sample_order)
dat_sum <- raw %>%
  select(any_of(keep_cols)) %>%
  mutate(across(all_of(sample_order), ~ suppressWarnings(as.numeric(.x)))) %>%
  mutate(across(all_of(sample_order), ~ replace_na(.x, 0))) %>%
  group_by(gene_id, PHAGC_Category, PHAGC_Function) %>%
  summarise(across(all_of(sample_order), max), .groups = "drop") %>%
  filter(rowSums(across(all_of(sample_order))) > 0)

# ---- Thesis order for PHAGC categories (legend & row-grouping) ----
cat_order <- c("Colonisation","Modulation","Survival")
# fall back gracefully if any missing
cat_levels <- intersect(cat_order, unique(dat_sum$PHAGC_Category))
dat_sum$PHAGC_Category <- factor(dat_sum$PHAGC_Category, levels = cat_levels, ordered = TRUE)

# ---- Optional: exact thesis order for KOs (rows)
# Fill this vector if you want a fixed order; otherwise leave character(0)
ko_order <- c(
  # e.g. "K01193","K05847","K05845","K02001","K02002","K09690","K00925","K03778"
)
if (length(ko_order)) {
  dat_sum <- dat_sum %>%
    mutate(gene_id = factor(gene_id, levels = ko_order, ordered = TRUE)) %>%
    arrange(gene_id)
} else {
  # default: order by category then KO ID (stable & reproducible)
  dat_sum <- dat_sum %>% arrange(PHAGC_Category, gene_id)
}

# ---- Build matrix (KO IDs as row names) ----
mat <- dat_sum %>% select(all_of(sample_order)) %>% as.matrix()
rownames(mat) <- as.character(dat_sum$gene_id)

# ---- Row-wise Z-scores ----
row_z <- t(scale(t(mat)))
row_z[!is.finite(row_z)] <- 0

# ---- Row annotations (PHAGC category) ----
cat_palette <- setNames(
  brewer.pal(max(3, min(8, length(cat_levels))), "Set2")[seq_along(cat_levels)],
  cat_levels
)
left_annot <- rowAnnotation(
  PHAGC_Category = dat_sum$PHAGC_Category,
  col = list(PHAGC_Category = cat_palette),
  annotation_legend_param = list(title = "PHAGC_Category")
)

# ---- Colours ----
ylgnbu <- brewer.pal(9, "YlGnBu")
col_fun <- colorRamp2(c(-2, 0, 2), c(ylgnbu[2], ylgnbu[5], ylgnbu[9]))

# ---- Heatmap (NO clustering; preserves thesis order) ----
ht_main <- Heatmap(
  row_z,
  name = "Z-score",
  col = col_fun,
  cluster_rows = FALSE,          # keep thesis row order
  cluster_columns = FALSE,       # keep thesis column order
  show_row_names = TRUE,
  row_names_side = "right",
  show_column_names = TRUE,
  column_names_rot = 0,
  column_names_centered = TRUE,
  column_names_side = "bottom"
)

ht <- left_annot + ht_main

# ---- Save PNG ----
png(paste0(out_prefix, ".png"), width = 10, height = 9, units = "in", res = 600, bg = "white")
draw(ht, heatmap_legend_side = "right", annotation_legend_side = "right")
dev.off()

# ---- Save TIFF (LZW) ----
if (requireNamespace("ragg", quietly = TRUE)) {
  ragg::agg_tiff(paste0(out_prefix, ".tiff"), width = 10, height = 9, units = "in",
                 res = 600, compression = "lzw", background = "white")
  draw(ht, heatmap_legend_side = "right", annotation_legend_side = "right")
  dev.off()
} else {
  tiff(paste0(out_prefix, ".tiff"), width = 10, height = 9, units = "in",
       res = 600, compression = "lzw", bg = "white")
  draw(ht, heatmap_legend_side = "right", annotation_legend_side = "right")
  dev.off()
}

# ---- (Optional) export Z-scores used in the plot ----
write_tsv(tibble(KO = rownames(row_z)) %>% bind_cols(as_tibble(row_z)),
          paste0(out_prefix, "_zscores.tsv"))
