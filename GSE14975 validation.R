suppressPackageStartupMessages({
  library(pROC)
  library(sva)
  library(ggplot2)
  library(dplyr)
  library(readr)
  library(tibble)
})

options(stringsAsFactors = FALSE)
set.seed(20260614)

root_dir <- "E:/房颤验证集/新增验证_GSE14975_Enet02/GSE14975_only_publication_consistent"
script_dir <- file.path(root_dir, "scripts")
result_dir <- file.path(root_dir, "results")
table_dir <- file.path(root_dir, "tables")
figure_dir <- file.path(root_dir, "figures")
doc_dir <- file.path(root_dir, "docs")
for (d in c(result_dir, table_dir, figure_dir, doc_dir)) {
  if (!dir.exists(d)) dir.create(d, recursive = TRUE, showWarnings = FALSE)
}

locked_genes <- c(
  "AADAC", "ALOX5AP", "BCHE", "CXCL1", "CXCR4", "HLA-DPB1", "HLA-DQA1",
  "IER3", "MGAM", "NCF2", "RAC2", "RPS11", "S100A4", "S100A8", "S100A9",
  "TYROBP", "UTS2", "WT1"
)

dev_path <- "E:/房颤验证集/房颤205.geoML(1)/205.geoML(1)/06.sva/merge.normalize.txt"
gse14975_path <- "E:/房颤验证集/GSE14975.normalize.txt"

read_matrix <- function(path) {
  read.table(path, header = TRUE, sep = "\t", check.names = FALSE, row.names = 1)
}

get_y <- function(sample_names) {
  ifelse(grepl("_Treat$", sample_names), 1, 0)
}

safe_auc <- function(y, p) {
  as.numeric(auc(roc(y, p, quiet = TRUE)))
}

auc_ci <- function(y, p) {
  as.numeric(ci.auc(roc(y, p, quiet = TRUE)))
}

best_threshold <- function(y, p) {
  as.numeric(coords(roc(y, p, quiet = TRUE), x = "best", best.method = "youden", ret = "threshold", transpose = FALSE)[1])
}

classification_metrics <- function(y, p, threshold) {
  pred <- ifelse(p >= threshold, 1, 0)
  tp <- sum(pred == 1 & y == 1)
  tn <- sum(pred == 0 & y == 0)
  fp <- sum(pred == 1 & y == 0)
  fn <- sum(pred == 0 & y == 1)
  tibble(
    N = length(y),
    Cases = sum(y == 1),
    Controls = sum(y == 0),
    AUC = safe_auc(y, p),
    CI_lower = auc_ci(y, p)[1],
    CI_upper = auc_ci(y, p)[3],
    Threshold = threshold,
    Sensitivity = ifelse((tp + fn) == 0, NA_real_, tp / (tp + fn)),
    Specificity = ifelse((tn + fp) == 0, NA_real_, tn / (tn + fp)),
    Accuracy = mean(pred == y),
    PPV = ifelse((tp + fp) == 0, NA_real_, tp / (tp + fp)),
    NPV = ifelse((tn + fn) == 0, NA_real_, tn / (tn + fn)),
    Brier = mean((p - y)^2)
  )
}

single_gene_auc <- function(x, y, cohort) {
  bind_rows(lapply(colnames(x), function(gene) {
    p <- x[[gene]]
    roc_obj <- roc(y, p, quiet = TRUE)
    tibble(
      Cohort = cohort,
      Gene = gene,
      Mean_Control = mean(p[y == 0]),
      Mean_AF = mean(p[y == 1]),
      Difference_AF_minus_Control = mean(p[y == 1]) - mean(p[y == 0]),
      AUC = as.numeric(auc(roc_obj))
    )
  }))
}

message("Reading development and GSE14975 matrices...")
dev_mat <- read_matrix(dev_path)
gse14975_mat <- read_matrix(gse14975_path)

missing_dev <- setdiff(locked_genes, rownames(dev_mat))
missing_ext <- setdiff(locked_genes, rownames(gse14975_mat))
if (length(missing_dev) > 0) stop("Missing development genes: ", paste(missing_dev, collapse = ", "))
if (length(missing_ext) > 0) stop("Missing GSE14975 genes: ", paste(missing_ext, collapse = ", "))

common_genes <- intersect(rownames(dev_mat), rownames(gse14975_mat))
combined_mat <- cbind(dev_mat[common_genes, , drop = FALSE], gse14975_mat[common_genes, , drop = FALSE])
batch <- c(rep("Development", ncol(dev_mat)), rep("GSE14975", ncol(gse14975_mat)))

message("Running unsupervised ComBat harmonization consistent with the manuscript workflow...")
combat_mat <- ComBat(as.matrix(combined_mat), batch = batch, par.prior = TRUE)

train_id <- colnames(dev_mat)
valid_id <- colnames(gse14975_mat)
train_y <- get_y(train_id)
valid_y <- get_y(valid_id)

train_x <- as.data.frame(t(combat_mat[locked_genes, train_id, drop = FALSE]), check.names = FALSE)
valid_x <- as.data.frame(t(combat_mat[locked_genes, valid_id, drop = FALSE]), check.names = FALSE)

message("Fitting Enet[alpha=0.2]-derived 18-gene logistic scoring model on development samples only...")
fit <- suppressWarnings(glm(train_y ~ ., data = data.frame(train_y = train_y, train_x, check.names = FALSE), family = binomial()))
train_prob <- suppressWarnings(as.numeric(predict(fit, type = "response")))
valid_prob <- suppressWarnings(as.numeric(predict(fit, newdata = data.frame(valid_x, check.names = FALSE), type = "response")))
threshold <- best_threshold(train_y, train_prob)

coef_tbl <- tibble(
  Gene = gsub("`", "", names(coef(fit))),
  Coefficient = as.numeric(coef(fit))
) %>%
  filter(Gene != "(Intercept)") %>%
  mutate(Abs_Coefficient = abs(Coefficient)) %>%
  arrange(desc(Abs_Coefficient))
write_csv(coef_tbl, file.path(table_dir, "GSE14975_only_model_coefficients.csv"))

metric_tbl <- bind_rows(
  classification_metrics(train_y, train_prob, threshold) %>% mutate(Cohort = "Development", .before = 1),
  classification_metrics(valid_y, valid_prob, threshold) %>% mutate(Cohort = "GSE14975", .before = 1)
)
write_csv(metric_tbl, file.path(table_dir, "GSE14975_only_validation_metrics.csv"))

sample_score_tbl <- tibble(
  Sample = valid_id,
  Group = ifelse(valid_y == 1, "AF", "Control"),
  TrueLabel = valid_y,
  PredictedProbability = valid_prob,
  PredictedClass = ifelse(valid_prob >= threshold, 1, 0)
)
write_csv(sample_score_tbl, file.path(table_dir, "GSE14975_sample_predicted_probabilities.csv"))

gene_tbl <- bind_rows(
  single_gene_auc(train_x, train_y, "Development"),
  single_gene_auc(valid_x, valid_y, "GSE14975")
)
write_csv(gene_tbl, file.path(table_dir, "GSE14975_gene_level_consistency.csv"))

roc_dev <- roc(train_y, train_prob, quiet = TRUE)
roc_valid <- roc(valid_y, valid_prob, quiet = TRUE)
roc_df <- bind_rows(
  tibble(FPR = 1 - roc_dev$specificities, TPR = roc_dev$sensitivities,
         Cohort = sprintf("Development (AUC = %.3f)", as.numeric(auc(roc_dev)))),
  tibble(FPR = 1 - roc_valid$specificities, TPR = roc_valid$sensitivities,
         Cohort = sprintf("GSE14975 (AUC = %.3f)", as.numeric(auc(roc_valid))))
)
roc_plot <- ggplot(roc_df, aes(FPR, TPR, color = Cohort)) +
  geom_line(linewidth = 1.1) +
  geom_abline(intercept = 0, slope = 1, linetype = 2, color = "grey60") +
  coord_equal() +
  scale_color_manual(values = c("#1f77b4", "#d62728")) +
  labs(title = "GSE14975 external validation",
       subtitle = "Enet[alpha=0.2]-derived 18-gene signature",
       x = "1 - Specificity", y = "Sensitivity") +
  theme_bw(base_size = 12) +
  theme(legend.title = element_blank(), plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5))
ggsave(file.path(figure_dir, "GSE14975_ROC_external_validation.pdf"), roc_plot, width = 8.2, height = 6.2, device = cairo_pdf)

score_plot_df <- bind_rows(
  tibble(Cohort = "Development", Group = ifelse(train_y == 1, "AF", "Control"), PredictedProbability = train_prob),
  tibble(Cohort = "GSE14975", Group = ifelse(valid_y == 1, "AF", "Control"), PredictedProbability = valid_prob)
)
score_plot <- ggplot(score_plot_df, aes(Group, PredictedProbability, fill = Group)) +
  geom_boxplot(width = 0.55, outlier.shape = NA, alpha = 0.75) +
  geom_jitter(width = 0.10, size = 1.8, alpha = 0.75) +
  facet_wrap(~ Cohort, nrow = 1) +
  scale_fill_manual(values = c("Control" = "#8da0cb", "AF" = "#fc8d62")) +
  labs(x = NULL, y = "Predicted probability") +
  theme_bw(base_size = 12) +
  theme(legend.position = "none", strip.background = element_rect(fill = "white"))
ggsave(file.path(figure_dir, "GSE14975_predicted_probability_boxplot.pdf"), score_plot, width = 8.5, height = 4.3, device = cairo_pdf)

coef_plot <- coef_tbl %>%
  mutate(Gene = factor(Gene, levels = rev(Gene))) %>%
  ggplot(aes(Gene, Coefficient, fill = Coefficient > 0)) +
  geom_col(width = 0.7) +
  coord_flip() +
  scale_fill_manual(values = c("TRUE" = "#d62728", "FALSE" = "#1f77b4")) +
  labs(x = NULL, y = "Coefficient", title = "Coefficient ranking of the 18-gene signature") +
  theme_bw(base_size = 11) +
  theme(legend.position = "none", plot.title = element_text(hjust = 0.5))
ggsave(file.path(figure_dir, "GSE14975_model_coefficients.pdf"), coef_plot, width = 7.2, height = 6.2, device = cairo_pdf)

auc_heat <- gene_tbl %>%
  mutate(Cohort = factor(Cohort, levels = c("Development", "GSE14975")),
         Gene = factor(Gene, levels = rev(coef_tbl$Gene))) %>%
  ggplot(aes(Cohort, Gene, fill = AUC)) +
  geom_tile(color = "white") +
  geom_text(aes(label = sprintf("%.2f", AUC)), size = 3) +
  scale_fill_gradient2(low = "#4575b4", mid = "white", high = "#d73027", midpoint = 0.65, limits = c(0.3, 1)) +
  labs(x = NULL, y = NULL, fill = "AUC", title = "Single-gene AUC consistency") +
  theme_bw(base_size = 10.5) +
  theme(panel.grid = element_blank(), plot.title = element_text(hjust = 0.5))
ggsave(file.path(figure_dir, "GSE14975_gene_AUC_heatmap.pdf"), auc_heat, width = 6.6, height = 7.2, device = cairo_pdf)

note <- c(
  "GSE14975-only publication-consistent validation note",
  "1) Only GSE14975 was newly analyzed in this reanalysis; GSE115574 was not re-analyzed here because it had already been included in the manuscript.",
  "2) GSE14975 contains 10 left atrial appendage samples: 5 AF and 5 sinus rhythm/control samples.",
  "3) The 18 genes of the Enet[alpha=0.2]-derived signature were all available in GSE14975.",
  "4) Development data and GSE14975 were harmonized using unsupervised ComBat with batch labels only, consistent with the manuscript's cross-cohort preprocessing logic. Disease/control labels from GSE14975 were not used in feature selection, model fitting, coefficient estimation, threshold selection, or hyperparameter tuning.",
  "5) The model was fitted only on development samples after harmonization and then applied to GSE14975.",
  sprintf("6) GSE14975 AUC = %.3f (95%% CI %.3f-%.3f).", metric_tbl$AUC[metric_tbl$Cohort == "GSE14975"], metric_tbl$CI_lower[metric_tbl$Cohort == "GSE14975"], metric_tbl$CI_upper[metric_tbl$Cohort == "GSE14975"]),
  sprintf("7) At the development-derived threshold %.6f, GSE14975 sensitivity = %.3f, specificity = %.3f, and accuracy = %.3f.", threshold, metric_tbl$Sensitivity[metric_tbl$Cohort == "GSE14975"], metric_tbl$Specificity[metric_tbl$Cohort == "GSE14975"], metric_tbl$Accuracy[metric_tbl$Cohort == "GSE14975"]),
  "8) Because GSE14975 has only 10 samples, confidence intervals are wide and the result should be described as supportive external validation rather than definitive clinical validation."
)
writeLines(note, file.path(doc_dir, "GSE14975_only_methodology_audit_note.txt"))
writeLines(capture.output(sessionInfo()), file.path(doc_dir, "sessionInfo.txt"))

message("Completed GSE14975-only publication-consistent validation.")
