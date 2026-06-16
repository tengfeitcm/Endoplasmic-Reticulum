suppressPackageStartupMessages({
  library(pROC)
  library(sva)
  library(ggplot2)
  library(dplyr)
  library(readr)
  library(tibble)
})

root_dir <- "E:/房颤验证集/新增验证_GSE14975_Enet02/GSE14975_only_publication_consistent"
table_dir <- file.path(root_dir, "tables")
figure_dir <- file.path(root_dir, "figures")
doc_dir <- file.path(root_dir, "docs")

locked_genes <- c(
  "AADAC", "ALOX5AP", "BCHE", "CXCL1", "CXCR4", "HLA-DPB1", "HLA-DQA1",
  "IER3", "MGAM", "NCF2", "RAC2", "RPS11", "S100A4", "S100A8", "S100A9",
  "TYROBP", "UTS2", "WT1"
)

dev_path <- "E:/房颤验证集/房颤205.geoML(1)/205.geoML(1)/06.sva/merge.normalize.txt"
gse14975_path <- "E:/房颤验证集/GSE14975.normalize.txt"

dev_mat <- read.table(dev_path, header = TRUE, sep = "\t", check.names = FALSE, row.names = 1)
gse14975_mat <- read.table(gse14975_path, header = TRUE, sep = "\t", check.names = FALSE, row.names = 1)
common_genes <- intersect(rownames(dev_mat), rownames(gse14975_mat))
combined_mat <- cbind(dev_mat[common_genes, , drop = FALSE], gse14975_mat[common_genes, , drop = FALSE])
batch <- c(rep("Development", ncol(dev_mat)), rep("GSE14975", ncol(gse14975_mat)))
combat_mat <- ComBat(as.matrix(combined_mat), batch = batch, par.prior = TRUE)

valid_id <- colnames(gse14975_mat)
valid_y <- ifelse(grepl("_Treat$", valid_id), 1, 0)
valid_x <- as.data.frame(t(combat_mat[locked_genes, valid_id, drop = FALSE]), check.names = FALSE)

roc_list <- lapply(locked_genes, function(gene) {
  score <- valid_x[[gene]]
  roc_forward <- roc(valid_y, score, quiet = TRUE, direction = "<")
  auc_forward <- as.numeric(auc(roc_forward))
  roc_reverse <- roc(valid_y, -score, quiet = TRUE, direction = "<")
  auc_reverse <- as.numeric(auc(roc_reverse))

  if (auc_reverse > auc_forward) {
    roc_obj <- roc_reverse
    auc_val <- auc_reverse
    direction_used <- "lower_expression_indicates_AF"
  } else {
    roc_obj <- roc_forward
    auc_val <- auc_forward
    direction_used <- "higher_expression_indicates_AF"
  }

  tibble(
    Gene = gene,
    AUC = auc_val,
    Direction = direction_used,
    FPR = 1 - roc_obj$specificities,
    TPR = roc_obj$sensitivities
  )
})
roc_df <- bind_rows(roc_list)

auc_tbl <- roc_df %>%
  distinct(Gene, AUC, Direction) %>%
  arrange(desc(AUC)) %>%
  mutate(Label = sprintf("%s (AUC=%.2f)", Gene, AUC))
write_csv(auc_tbl, file.path(table_dir, "GSE14975_18_gene_ROC_AUC_same_plot.csv"))

roc_df <- roc_df %>%
  left_join(auc_tbl %>% select(Gene, Label), by = "Gene") %>%
  mutate(Label = factor(Label, levels = auc_tbl$Label))

palette <- c(
  "#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", "#8c564b",
  "#e377c2", "#7f7f7f", "#bcbd22", "#17becf", "#4e79a7", "#f28e2b",
  "#59a14f", "#e15759", "#b07aa1", "#9c755f", "#edc948", "#76b7b2"
)

p <- ggplot(roc_df, aes(x = FPR, y = TPR, color = Label)) +
  geom_line(linewidth = 0.9, alpha = 0.95) +
  geom_abline(intercept = 0, slope = 1, linetype = 2, color = "grey65") +
  coord_equal() +
  scale_color_manual(values = palette) +
  labs(
    title = "Single-gene ROC curves of the 18-gene signature in GSE14975",
    x = "1 - Specificity",
    y = "Sensitivity"
  ) +
  theme_bw(base_size = 11) +
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.title = element_blank(),
    legend.position = "right",
    legend.text = element_text(size = 8)
  )

ggsave(file.path(figure_dir, "GSE14975_18_gene_ROC_same_plot.pdf"), p, width = 9.5, height = 7.2, device = cairo_pdf)
ggsave(file.path(figure_dir, "GSE14975_18_gene_ROC_same_plot.png"), p, width = 9.5, height = 7.2, dpi = 320)

note <- c(
  "18-gene single-gene ROC plot note:",
  "1) The plot uses the same GSE14975 validation set after the manuscript-consistent unsupervised ComBat harmonization.",
  "2) For single-gene ROC display, each gene was oriented to show its discriminative ability regardless of whether higher or lower expression was associated with AF.",
  "3) This is appropriate for biomarker-level visualization but should be described as single-gene discriminative ability, not as independent model validation.",
  "4) The model-level validation result remains the fixed 18-gene signature AUC = 0.840 in GSE14975."
)
writeLines(note, file.path(doc_dir, "GSE14975_18_gene_ROC_note.txt"))

message("Completed 18-gene ROC same-plot generation.")
