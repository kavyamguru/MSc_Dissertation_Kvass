# -----------------------------
# KO heatmap (thesis-ready)
# - Sample names horizontal & centered under columns
# - KO ID + (italic gene) shown on the right
# -----------------------------
suppressPackageStartupMessages({
  library(tidyverse)
  library(ComplexHeatmap)
  library(circlize)
  library(RColorBrewer)
  library(grid)
})

ko_fp <- "curated_ko_hits.tsv"  # needs: "Gene Family" (KO), Gene_Short, Category, and *-RPKs columns

# --- Read & tidy
ko_hits <- read_tsv(ko_fp, col_types = cols()) |>
  rename_with(~ sub("^#\\s*", "", .x)) |>
  rename(KO = matches("^Gene Family$")) |>
  mutate(across(ends_with("-RPKs"), as.numeric))

rpk_cols <- grep("-RPKs$", names(ko_hits), value = TRUE)
stopifnot(length(rpk_cols) > 0)

# --- Matrix & row z-scores
ko_mat   <- as.matrix(ko_hits[, rpk_cols])
ko_mat_z <- t(scale(t(ko_mat)))  # mean 0, sd 1 per KO

# --- Map columns to thesis sample IDs and order them (your order)
sample_map <- c(AA="SDX", B1="SDY", C1="LSGFkvassX", D1="STDkvassX", E1="LSFkvassX", F1="LSFkvassY")
keys <- stringr::str_extract(colnames(ko_mat_z), "^[^_]+")
colnames(ko_mat_z) <- unname(sample_map[keys])

thesis_order <- c("SDX","STDkvassX","LSFkvassX","LSGFkvassX","SDY","LSFkvassY")
ko_mat_z <- ko_mat_z[, thesis_order[thesis_order %in% colnames(ko_mat_z)], drop = FALSE]

# --- Order rows by Category and collect labels
ord       <- order(ko_hits$Category)
ko_mat_z  <- ko_mat_z[ord, , drop = FALSE]
cat_vec   <- ko_hits$Category[ord]
ko_ids    <- ko_hits$KO[ord]
gene_nm   <- replace_na(ko_hits$Gene_Short[ord], "")

# --- Colors
pal_heat <- circlize::colorRamp2(seq(-2, 2, length.out = 9), RColorBrewer::brewer.pal(9, "YlGnBu"))
cat_levels <- unique(cat_vec)
pal_cat <- setNames(RColorBrewer::brewer.pal(length(cat_levels), "Set2"), cat_levels)

# --- Row annotations
# Left: Category strip
ha_left <- rowAnnotation(
  Category = cat_vec,
  col = list(Category = pal_cat),
  annotation_name_gp = gpar(fontsize = 10),
  width = unit(3, "mm")
)

# Right: KO ID and gene (italic) side-by-side
gene_lab <- ifelse(is.na(gene_nm) | gene_nm == "", "", paste0(" (", gene_nm, ")"))
ha_right <- rowAnnotation(
  `KO`   = anno_text(ko_ids,   just = "left", gp = gpar(fontsize = 8)),
  `Gene` = anno_text(gene_lab, just = "left", gp = gpar(fontsize = 8, fontface = "italic")),
  width  = max_text_width(paste0(ko_ids, gene_lab), gp = gpar(fontsize = 8))
)

bottom_anno <- HeatmapAnnotation(
  which = "column",
  spacer = anno_empty(height = unit(3, "mm"), border = FALSE),  # <- disable border
  labels = anno_text(colnames(ko_mat_z), rot = 0, just = "center",
                     gp = gpar(fontsize = 10)),
  annotation_name_gp = gpar(col = NA),
  annotation_height = unit.c(
    unit(3, "mm"),
    max_text_width(colnames(ko_mat_z), gp = gpar(fontsize = 10))
  )
)


# --- Heatmap (attach annotations; hide default column names)
ht <- Heatmap(
  ko_mat_z,
  name = "Row z-score (RPK)",
  col  = pal_heat,
  cluster_rows = FALSE, cluster_columns = FALSE,
  show_row_names = FALSE,                        # we label rows via ha_right
  show_column_names = FALSE,                     # we draw our own labels below
  bottom_annotation  = bottom_anno,              # labels exactly under columns
  left_annotation    = ha_left,
  right_annotation   = ha_right,
  column_title       = "Curated KO Families (Z-scored RPKs)",
  column_title_gp    = gpar(fontsize = 12, fontface = "bold"),
  heatmap_legend_param = list(direction = "vertical")
)

# --- Save (TIFF, 600 dpi, LZW)
tiff("Curated_KO_Heatmap.tiff", width = 9, height = 5.2, units = "in",
     res = 600, compression = "lzw", type = "cairo", bg = "white")
draw(ht, heatmap_legend_side = "right", annotation_legend_side = "right")
dev.off()



