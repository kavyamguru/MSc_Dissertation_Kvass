# ================================
# Curated MetaCyc Pathways Heatmap
# Row-wise z-scored abundances
# ================================

graphics.off()

suppressPackageStartupMessages({
  library(tidyverse)
  library(ComplexHeatmap)
  library(circlize)
  library(RColorBrewer)
  library(grid)
})

# ---------- Input ----------
pw_fp <- "curated_pathway_hits.tsv"   # col1 = "P461-PWY: hexitol fermentation ..."

# ---------- Read & tidy ----------
pw_hits <- read_delim(pw_fp, delim = "\t", col_types = cols()) |>
  rename(Pathway = 1) |>
  mutate(
    Pathway_ID   = str_extract(Pathway, "^[^:]+"),
    Pathway_Name = str_remove(Pathway, "^[^:]+:\\s*")
  )

# exact mapping
name_map <- c(
  "AA_combined_Abundance" = "SDX",
  "B1_combined_Abundance" = "SDY",
  "C1_combined_Abundance" = "LSGFkvassX",
  "D1_combined_Abundance" = "STDkvassX",
  "E1_combined_Abundance" = "LSFkvassX",
  "F1_combined_Abundance" = "LSFkvassY"
)

sel_cols <- intersect(names(name_map), names(pw_hits))
stopifnot(length(sel_cols) == 6)

mat <- pw_hits |>
  select(all_of(sel_cols)) |>
  mutate(across(everything(), as.numeric)) |>
  as.matrix()

# ---------- Row-wise z-score ----------
mat_z <- t(scale(t(mat)))                 # mean 0, sd 1 per pathway
colnames(mat_z) <- unname(name_map[colnames(mat_z)])

# enforce exact column order
order_vec <- c("SDX","SDY","LSGFkvassX","STDkvassX","LSFkvassX","LSFkvassY")
mat_z <- mat_z[, order_vec, drop = FALSE]

# ---------- Row order & labels ----------
ord <- order(pw_hits$Category)
mat_z <- mat_z[ord, , drop = FALSE]

wrap_width <- 48
row_lab <- paste0(
  pw_hits$Pathway_ID[ord], ":\n",
  map_chr(pw_hits$Pathway_Name[ord], ~ paste(strwrap(.x, width = wrap_width, exdent = 2), collapse = "\n"))
)

# ---------- Annotations ----------
cats     <- unique(pw_hits$Category)
pal_cat  <- setNames(RColorBrewer::brewer.pal(length(cats), "Set2"), cats)

# left: Category strip
ha_left <- rowAnnotation(
  Category = pw_hits$Category[ord],
  col = list(Category = pal_cat),
  width = unit(3, "mm")
)

# right: pathway labels as text (so we can hide default row names)
ha_right <- rowAnnotation(
  `Pathway` = anno_text(row_lab, just = "left", gp = gpar(fontsize = 7)),
  width = max_text_width(row_lab, gp = gpar(fontsize = 7))
)

# ---------- Colors ----------
pal_heat <- circlize::colorRamp2(seq(-2, 2, length.out = 9), RColorBrewer::brewer.pal(9, "YlGnBu"))

# ---------- Heatmap ----------
ht <- Heatmap(
  mat_z,
  name = "Row z-score (RPK)",
  col  = pal_heat,
  cluster_rows = FALSE,
  cluster_columns = FALSE,
  column_order = order_vec,
  
  # >>> column labels EXACTLY under columns <<<
  column_names_side    = "bottom",
  column_names_rot     = 0,                 # horizontal
  column_names_centered = TRUE,             # ensure centered under each column
  column_names_gp      = gpar(fontsize = 10),
  
  show_row_names   = FALSE,                 # we draw them in ha_right
  left_annotation  = ha_left,               # attach annotations to THIS heatmap
  right_annotation = ha_right,
  
  column_title    = "Curated MetaCyc Pathways (Z-scored Abundance)",
  column_title_gp = gpar(fontsize = 12, fontface = "bold")
)

# ---------- Save ----------
tiff("Curated_Pathways_Heatmap.tiff", width = 12, height = 7, units = "in",
     res = 600, compression = "lzw", bg = "white")
draw(ht, heatmap_legend_side = "right", annotation_legend_side = "right")
dev.off()
