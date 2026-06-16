min.selected.var =2   

library(tgp)
library(openxlsx)       
library(seqinr)         
library(plyr)          
library(randomForestSRC) 
library(glmnet)          
library(plsRglm)         
library(gbm)             
library(caret)          
library(mboost)         
library(e1071)         
library(BART)            
library(MASS)          
library(snowfall)        
library(xgboost)        
library(ComplexHeatmap) 
library(RColorBrewer)   
library(pROC)           
library(circlize)

RunML <- function(method, Train_set, Train_label, mode = "Model", classVar){
  method = gsub(" ", "", method) 
  method_name = gsub("(\\w+)\\[(.+)\\]", "\\1", method)  
  method_param = gsub("(\\w+)\\[(.+)\\]", "\\2", method) 
  
  method_param = switch(
    EXPR = method_name,
    "Enet" = list("alpha" = as.numeric(gsub("alpha=", "", method_param))),
    "Stepglm" = list("direction" = method_param),
    NULL  
  )
  
  message("Run ", method_name, " algorithm for ", mode, "; ",
          method_param, ";",
          " using ", ncol(Train_set), " Variables")
  
  args = list("Train_set" = Train_set,
              "Train_label" = Train_label,
              "mode" = mode,
              "classVar" = classVar)
  args = c(args, method_param)
  
  obj <- do.call(what = paste0("Run", method_name),
                 args = args) 
  
  if(mode == "Variable"){
    message(length(obj), " Variables retained;\n")
  }else{message("\n")}
  return(obj)
}

RunEnet <- function(Train_set, Train_label, mode, classVar, alpha){
  cv.fit = cv.glmnet(x = Train_set,
                     y = Train_label[[classVar]],
                     family = "binomial", alpha = alpha, nfolds = 10)
  fit = glmnet(x = Train_set,
               y = Train_label[[classVar]],
               family = "binomial", alpha = alpha, lambda = cv.fit$lambda.min)
  fit$subFeature = colnames(Train_set)
  if (mode == "Model") return(fit)
  if (mode == "Variable") return(ExtractVar(fit))
}

RunLasso <- function(Train_set, Train_label, mode, classVar){
  RunEnet(Train_set, Train_label, mode, classVar, alpha = 1)
}

RunRidge <- function(Train_set, Train_label, mode, classVar){
  RunEnet(Train_set, Train_label, mode, classVar, alpha = 0)
}

RunStepglm <- function(Train_set, Train_label, mode, classVar, direction){
  fit <- step(glm(formula = Train_label[[classVar]] ~ .,
                  family = "binomial", 
                  data = as.data.frame(Train_set)),
              direction = direction, trace = 0)
  fit$subFeature = colnames(Train_set)
  if (mode == "Model") return(fit)
  if (mode == "Variable") return(ExtractVar(fit))
}

RunSVM <- function(Train_set, Train_label, mode, classVar){
  data <- as.data.frame(Train_set)
  data[[classVar]] <- as.factor(Train_label[[classVar]])
  fit = svm(formula = eval(parse(text = paste(classVar, "~."))),
            data= data, probability = T)
  fit$subFeature = colnames(Train_set)
  if (mode == "Model") return(fit)
  if (mode == "Variable") return(ExtractVar(fit))
}

RunLDA <- function(Train_set, Train_label, mode, classVar){
  data <- as.data.frame(Train_set)
  data[[classVar]] <- as.factor(Train_label[[classVar]])
  fit = train(eval(parse(text = paste(classVar, "~."))), 
              data = data, 
              method="lda",
              trControl = trainControl(method = "cv"))
  fit$subFeature = colnames(Train_set)
  if (mode == "Model") return(fit)
  if (mode == "Variable") return(ExtractVar(fit))
}

RunglmBoost <- function(Train_set, Train_label, mode, classVar){
  data <- cbind(Train_set, Train_label[classVar])
  data[[classVar]] <- as.factor(data[[classVar]])
  fit <- glmboost(eval(parse(text = paste(classVar, "~."))),
                  data = data,
                  family = Binomial())
  cvm <- cvrisk(fit, papply = lapply,
                folds = cv(model.weights(fit), type = "kfold"))
  fit <- glmboost(eval(parse(text = paste(classVar, "~."))),
                  data = data,
                  family = Binomial(), 
                  control = boost_control(mstop = max(mstop(cvm), 40)))
  fit$subFeature = colnames(Train_set)
  if (mode == "Model") return(fit)
  if (mode == "Variable") return(ExtractVar(fit))
}

RunplsRglm <- function(Train_set, Train_label, mode, classVar){
  cv.plsRglm.res = cv.plsRglm(formula = Train_label[[classVar]] ~ ., 
                              data = as.data.frame(Train_set),
                              nt=10, verbose = FALSE)
  fit <- plsRglm(Train_label[[classVar]], 
                 as.data.frame(Train_set), 
                 modele = "pls-glm-logistic",
                 verbose = F, sparse = T)
  fit$subFeature = colnames(Train_set)
  if (mode == "Model") return(fit)
  if (mode == "Variable") return(ExtractVar(fit))
}

RunRF <- function(Train_set, Train_label, mode, classVar){
  rf_nodesize = 5 # 可根据需要调整
  Train_label[[classVar]] <- as.factor(Train_label[[classVar]])
  fit <- rfsrc(formula = formula(paste0(classVar, "~.")),
               data = cbind(Train_set, Train_label[classVar]),
               ntree = 1000, nodesize = rf_nodesize,
               importance = T,
               proximity = T,
               forest = T)
  fit$subFeature = colnames(Train_set)
  if (mode == "Model") return(fit)
  if (mode == "Variable") return(ExtractVar(fit))
}

RunGBM <- function(Train_set, Train_label, mode, classVar){
  fit <- gbm(formula = Train_label[[classVar]] ~ .,
             data = as.data.frame(Train_set),
             distribution = 'bernoulli',
             n.trees = 10000,
             interaction.depth = 3,
             n.minobsinnode = 10,
             shrinkage = 0.001,
             cv.folds = 10,n.cores = 6)
  best <- which.min(fit$cv.error)
  fit <- gbm(formula = Train_label[[classVar]] ~ .,
             data = as.data.frame(Train_set),
             distribution = 'bernoulli',
             n.trees = best,
             interaction.depth = 3,
             n.minobsinnode = 10,
             shrinkage = 0.001, n.cores = 8)
  fit$subFeature = colnames(Train_set)
  if (mode == "Model") return(fit)
  if (mode == "Variable") return(ExtractVar(fit))
}

RunXGBoost <- function(Train_set, Train_label, mode, classVar){
  indexes = createFolds(Train_label[[classVar]], k = 5, list=T)
  CV <- unlist(lapply(indexes, function(pt){
    dtrain = xgb.DMatrix(data = Train_set[-pt, ], 
                         label = Train_label[-pt, ])
    dtest = xgb.DMatrix(data = Train_set[pt, ], 
                        label = Train_label[pt, ])
    watchlist <- list(train=dtrain, test=dtest)
    
    bst <- xgb.train(data=dtrain, 
                     max.depth=2, eta=1, nthread = 2, nrounds=10, 
                     watchlist=watchlist, 
                     objective = "binary:logistic", verbose = F)
    which.min(bst$evaluation_log$test_logloss)
  }))
  
  nround <- as.numeric(names(which.max(table(CV))))
  fit <- xgboost(data = Train_set, 
                 label = Train_label[[classVar]], 
                 max.depth = 2, eta = 1, nthread = 2, nrounds = nround, 
                 objective = "binary:logistic", verbose = F)
  fit$subFeature = colnames(Train_set)
  
  if (mode == "Model") return(fit)
  if (mode == "Variable") return(ExtractVar(fit))
}

RunNaiveBayes <- function(Train_set, Train_label, mode, classVar){
  data <- cbind(Train_set, Train_label[classVar])
  data[[classVar]] <- as.factor(data[[classVar]])
  fit <- naiveBayes(eval(parse(text = paste(classVar, "~."))), 
                    data = data)
  fit$subFeature = colnames(Train_set)
  if (mode == "Model") return(fit)
  if (mode == "Variable") return(ExtractVar(fit))
}

quiet <- function(..., messages=FALSE, cat=FALSE){
  if(!cat){
    sink(tempfile()) 
    on.exit(sink()) 
  }
  out <- if(messages) eval(...) else suppressMessages(eval(...))
  out
}

standarize.fun <- function(indata, centerFlag, scaleFlag) {  
  scale(indata, center=centerFlag, scale=scaleFlag)
}

scaleData <- function(data, cohort = NULL, centerFlags = NULL, scaleFlags = NULL){
  samplename = rownames(data)  
  if (is.null(cohort)){
    data <- list(data); names(data) = "training"
  }else{
    data <- split(as.data.frame(data), cohort) 
  }
  
  if (is.null(centerFlags)){
    centerFlags = F; message("No centerFlags found, set as FALSE")
  }
  if (length(centerFlags)==1){
    centerFlags = rep(centerFlags, length(data)); message("set centerFlags for all cohort as ", unique(centerFlags))
  }
  if (is.null(names(centerFlags))){
    names(centerFlags) <- names(data); message("match centerFlags with cohort by order\n")
  }
  
  if (is.null(scaleFlags)){
    scaleFlags = F; message("No scaleFlags found, set as FALSE")
  }
  if (length(scaleFlags)==1){
    scaleFlags = rep(scaleFlags, length(data)); message("set scaleFlags for all cohort as ", unique(scaleFlags))
  }
  if (is.null(names(scaleFlags))){
    names(scaleFlags) <- names(data); message("match scaleFlags with cohort by order\n")
  }
  
  centerFlags <- centerFlags[names(data)]; scaleFlags <- scaleFlags[names(data)]
  outdata <- mapply(standarize.fun, indata = data, centerFlag = centerFlags, scaleFlag = scaleFlags, SIMPLIFY = F)

  outdata <- do.call(rbind, outdata)
  outdata <- outdata[samplename, ]
  return(outdata)
}

ExtractVar <- function(fit){
  Feature <- quiet(switch(
    EXPR = class(fit)[1],
    "lognet" = rownames(coef(fit))[which(coef(fit)[, 1]!=0)], # 从Elastic Net模型中提取非零系数的变量
    "glm" = names(coef(fit)), # 从广义线性模型中提取变量
    "svm.formula" = fit$subFeature, # SVM模型中未进行变量选择，使用所有变量
    "train" = fit$coefnames, # 训练集中使用的变量
    "glmboost" = names(coef(fit)[abs(coef(fit))>0]), # 从GLMBoost模型中提取系数非零的变量
    "plsRglmmodel" = rownames(fit$Coeffs)[fit$Coeffs!=0], # 从PLSRGLM模型中提取系数非零的变量
    "rfsrc" = names(which(fit$importance[,1] > 0.01)), 
    
    "gbm" = rownames(summary.gbm(fit, plotit = F))[summary.gbm(fit, plotit = F)$rel.inf>0], # 从GBM模型中提取重要的变量
    "xgb.Booster" = fit$subFeature, # XGBoost模型中使用的所有变量
    "naiveBayes" = fit$subFeature # 朴素贝叶斯模型中使用的所有变量
  ))
  
  Feature <- setdiff(Feature, c("(Intercept)", "Intercept"))
  return(Feature)
}

CalPredictScore <- function(fit, new_data, type = "lp"){
  new_data <- new_data[, fit$subFeature]
  RS <- quiet(switch(
    EXPR = class(fit)[1],
    "lognet"      = predict(fit, type = 'response', as.matrix(new_data)), # 使用Elastic Net模型进行响应预测
    "glm"         = predict(fit, type = 'response', as.data.frame(new_data)), # 使用广义线性模型进行响应预测
    "svm.formula" = predict(fit, as.data.frame(new_data), probability = T), # 使用SVM模型进行概率预测
    "train"       = predict(fit, new_data, type = "prob")[[2]], # 使用train函数进行概率预测
    "glmboost"    = predict(fit, type = "response", as.data.frame(new_data)), # 使用GLMBoost进行响应预测
    "plsRglmmodel" = predict(fit, type = "response", as.data.frame(new_data)), # 使用PLSRGLM进行响应预测
    "rfsrc"        = predict(fit, as.data.frame(new_data))$predicted[, "1"], # 使用随机森林进行预测
    "gbm"          = predict(fit, type = 'response', as.data.frame(new_data)), # 使用GBM进行响应预测
    "xgb.Booster" = predict(fit, as.matrix(new_data)), # 使用XGBoost进行预测
    "naiveBayes" = predict(object = fit, type = "raw", newdata = new_data)[, "1"] # 使用朴素贝叶斯进行原始概率预测
    # "drf" = predict(fit, functional = "mean", as.matrix(new_data))$mean # 使用DRF进行预测，当前版本已注释
  ))
  RS = as.numeric(as.vector(RS))
  names(RS) = rownames(new_data)
  return(RS)
}

PredictClass <- function(fit, new_data){
  new_data <- new_data[, fit$subFeature]
  label <- quiet(switch(
    EXPR = class(fit)[1],
    "lognet"      = predict(fit, type = 'class', as.matrix(new_data)), # 使用Elastic Net进行类别预测
    "glm"         = ifelse(test = predict(fit, type = 'response', as.data.frame(new_data))>0.5, 
                           yes = "1", no = "0"), # 使用广义线性模型进行响应预测，并根据阈值分类
    "svm.formula" = predict(fit, as.data.frame(new_data), decision.values = T), # 使用SVM进行决策值预测
    "train"       = predict(fit, new_data, type = "raw"), # 使用train函数进行原始预测
    "glmboost"    = predict(fit, type = "class", as.data.frame(new_data)), # 使用GLMBoost进行类别预测
    "plsRglmmodel" = ifelse(test = predict(fit, type = 'response', as.data.frame(new_data))>0.5, 
                            yes = "1", no = "0"), # 使用PLSRGLM进行响应预测，并根据阈值分类
    "rfsrc"        = predict(fit, as.data.frame(new_data))$class, # 使用随机森林进行类别预测
    "gbm"          = ifelse(test = predict(fit, type = 'response', as.data.frame(new_data))>0.5,
                            yes = "1", no = "0"), # 使用GBM进行响应预测，并根据阈值分类
    "xgb.Booster" = ifelse(test = predict(fit, as.matrix(new_data))>0.5,
                           yes = "1", no = "0"), # 使用XGBoost进行预测，并根据阈值分类
    "naiveBayes" = predict(object = fit, type = "class", newdata = new_data) # 使用朴素贝叶斯进行类别预测
    # "drf" = predict(fit, functional = "mean", as.matrix(new_data))$mean # 使用DRF进行预测，当前版本已注释
  ))
  label = as.character(as.vector(label))
  names(label) = rownames(new_data)
  return(label)
}

RunEval <- function(fit, 
                    Test_set = NULL, 
                    Test_label = NULL, 
                    Train_set = NULL, 
                    Train_label = NULL, 
                    Train_name = NULL,
                    cohortVar = "Cohort",
                    classVar){
  
  if(!is.element(cohortVar, colnames(Test_label))) {
    stop(paste0("There is no [", cohortVar, "] indicator, please fill in one more column!"))
  } 
  
  if((!is.null(Train_set)) & (!is.null(Train_label))) {
    new_data <- rbind.data.frame(Train_set[, fit$subFeature],
                                 Test_set[, fit$subFeature])
    
    if(!is.null(Train_name)) {
      Train_label$Cohort <- Train_name
    } else {
      Train_label$Cohort <- "Training"
    }
    colnames(Train_label)[ncol(Train_label)] <- cohortVar
    Test_label <- rbind.data.frame(Train_label[,c(cohortVar, classVar)],
                                   Test_label[,c(cohortVar, classVar)])
    Test_label[,1] <- factor(Test_label[,1], 
                             levels = c(unique(Train_label[,cohortVar]), setdiff(unique(Test_label[,cohortVar]),unique(Train_label[,cohortVar]))))
  } else {
    new_data <- Test_set[, fit$subFeature]
  }
  
  RS <- suppressWarnings(CalPredictScore(fit = fit, new_data = new_data))
  
  Predict.out <- Test_label
  Predict.out$RS <- as.vector(RS)
  Predict.out <- split(x = Predict.out, f = Predict.out[,cohortVar])
  unlist(lapply(Predict.out, function(data){
    as.numeric(auc(suppressMessages(roc(data[[classVar]], data$RS))))
  }))
}

SimpleHeatmap <- function(Cindex_mat, avg_Cindex, 
                          CohortCol, barCol,
                          cellwidth = 1, cellheight = 0.5, 
                          cluster_columns, cluster_rows){
  col_ha = columnAnnotation("Cohort" = colnames(Cindex_mat),
                            col = list("Cohort" = CohortCol),
                            show_annotation_name = F)
  
  row_ha = rowAnnotation(bar = anno_barplot(avg_Cindex, bar_width = 0.8, border = FALSE,
                                            gp = gpar(fill = barCol, col = NA),
                                            add_numbers = T, numbers_offset = unit(-10, "mm"),
                                            axis_param = list("labels_rot" = 0),
                                            numbers_gp = gpar(fontsize = 9, col = "white"),
                                            width = unit(3, "cm")),
                         show_annotation_name = F)
  
  Heatmap(as.matrix(Cindex_mat), name = "AUC",
          right_annotation = row_ha, 
          top_annotation = col_ha,
          col = c("#4195C1", "#FFFFFF", "#FFBC90"), # 定义颜色，从蓝到红通过白色渐变
          rect_gp = gpar(col = "black", lwd = 1), # 设置边框颜色为黑色
          cluster_columns = cluster_columns, cluster_rows = cluster_rows, # 是否对行和列进行聚类
          show_column_names = FALSE, 
          show_row_names = TRUE,
          row_names_side = "left",
          width = unit(cellwidth * ncol(Cindex_mat) + 2, "cm"),
          height = unit(cellheight * nrow(Cindex_mat), "cm"),
          column_split = factor(colnames(Cindex_mat), levels = colnames(Cindex_mat)), 
          column_title = NULL,
          cell_fun = function(j, i, x, y, w, h, col) { # 在每个格子中添加文本
            grid.text(label = format(Cindex_mat[i, j], digits = 3, nsmall = 3),
                      x, y, gp = gpar(fontsize = 10))
          }
  )
}

Train_data <- read.table("data.train.txt", header = T, sep = "\t", check.names=F, row.names=1, stringsAsFactors=F)
Train_expr=Train_data[,1:(ncol(Train_data)-1),drop=F]
Train_class=Train_data[,ncol(Train_data),drop=F]

Test_data <- read.table("data.test.txt", header=T, sep="\t", check.names=F, row.names=1, stringsAsFactors = F)
Test_expr=Test_data[,1:(ncol(Test_data)-1),drop=F]
Test_class=Test_data[,ncol(Test_data),drop=F]
Test_class$Cohort=gsub("(.*)\\_(.*)\\_(.*)", "\\1", row.names(Test_class))
Test_class=Test_class[,c("Cohort", "Type")]
comgene <- intersect(colnames(Train_expr), colnames(Test_expr))
Train_expr <- as.matrix(Train_expr[,comgene])
Test_expr <- as.matrix(Test_expr[,comgene])
Train_set = scaleData(data=Train_expr, centerFlags=T, scaleFlags=T) 


set.seed(123)  
noise <- matrix(rnorm(n = nrow(Train_set) * ncol(Train_set), mean = 0, sd = 0.01), 
                nrow = nrow(Train_set), ncol = ncol(Train_set))
Train_set <- Train_set + noise
set.seed(456)  
Test_set = scaleData(data = Test_expr, cohort = Test_class$Cohort, centerFlags = T, scaleFlags = T)
noise_test <- matrix(rnorm(n = nrow(Test_set) * ncol(Test_set), mean = 0, sd = 0.01), 
                     nrow = nrow(Test_set), ncol = ncol(Test_set))
Test_set <- Test_set + noise_test


methodRT <- read.table("refer.txt", header=T, sep="\t", check.names=F)
methods=methodRT$Model
methods <- gsub("-| ", "", methods) # 清理方法名称中的连字符和空格

classVar = "Type"         # 设置类变量的名称
Variable = colnames(Train_set)
preTrain.method =  strsplit(methods, "\\+") # 分解方法名称中的组合
preTrain.method = lapply(preTrain.method, function(x) rev(x)[-1]) # 反转并移除第一个元素
preTrain.method = unique(unlist(preTrain.method)) # 去除重复的方法名称

preTrain.var <- list()       # 初始化保存变量选择结果的列表
set.seed(seed = 123)         # 设置随机种子以保证结果的可重复性
for (method in preTrain.method){
  preTrain.var[[method]] = RunML(method = method,              # 指定机器学习方法
                                 Train_set = Train_set,        # 提供训练数据
                                 Train_label = Train_class,    # 提供类别标签
                                 mode = "Variable",            # 设置模式为变量选择
                                 classVar = classVar)          # 指定类变量
}
preTrain.var[["simple"]] <- colnames(Train_set) # 将简单模型的变量也保存下来
model <- list()            # 初始化保存模型结果的列表
set.seed(seed = 123)       # 再次设置随机种子
Train_set_bk <- Train_set  # 备份原始训练集

for (method in methods) {
  cat(match(method, methods), ":", method, "\n")
  
  parts <- strsplit(method, "\\+")[[1]]
  if (length(parts) == 1) parts <- c("simple", parts)
  
  vars <- preTrain.var[[ parts[1] ]]
  vars <- gsub("`", "", vars) # 核心修复代码，修复下标越界问题
  
  if (length(vars) <= min.selected.var) {
    message("  SKIP ", parts[1], " → only ", length(vars), " variables\n")
    next
  }
  
  ts <- Train_set_bk[, vars, drop = FALSE]
  fit <- RunML(method      = parts[2],
               Train_set   = ts,
               Train_label = Train_class,
               mode        = "Model",
               classVar    = classVar)
  
  if (length(ExtractVar(fit)) <= min.selected.var) {
    message("  DROP ", method, " → only ", length(ExtractVar(fit)), " vars after modelling\n")
  } else {
    model[[ method ]] <- fit
  }
}

Train_set <- Train_set_bk
rm(Train_set_bk)

saveRDS(model, "model.MLmodel.rds")


FinalModel <- "multiLogistic"   # 或者 "panML"，按你设计的选项来
if (FinalModel == "multiLogistic"){
  logisticmodel <- lapply(model, function(fit){
    # 1) 先把模型给出的变量名和训练集的列名做个交集
    vars <- intersect(ExtractVar(fit), colnames(Train_set))
    
    # （可选：如果交集太少，可以选择跳过这个模型）
    # if (length(vars) <= 1) return(NULL)
    
    # 2) 用交集后的变量重新拟合 logistic
    tmp <- glm(formula = Train_class[[classVar]] ~ .,
               family = "binomial",
               data   = as.data.frame(Train_set[, vars, drop = FALSE]))
    
    tmp$subFeature <- vars
    return(tmp)
  })
}
saveRDS(logisticmodel, "model.logisticmodel.rds")

model <- readRDS("model.MLmodel.rds")            # 加载机器学习模型
#model <- readRDS("model.logisticmodel.rds")     # 加载逻辑回归模型
methodsValid <- names(model)                     # 获取有效的模型名称
RS_list <- list()
for (method in methodsValid){
  RS_list[[method]] <- CalPredictScore(fit = model[[method]], new_data = rbind.data.frame(Train_set,Test_set))
}
riskTab=as.data.frame(t(do.call(rbind, RS_list)))
riskTab=cbind(id=row.names(riskTab), riskTab)
write.table(riskTab, "model.riskMatrix.txt", sep="\t", row.names=F, quote=F)

# 使用保存的模型预测每个样本的类别
Class_list <- list()
for (method in methodsValid){
  Class_list[[method]] <- PredictClass(fit = model[[method]], new_data = rbind.data.frame(Train_set,Test_set))
}
Class_mat <- as.data.frame(t(do.call(rbind, Class_list)))
classTab=cbind(id=row.names(Class_mat), Class_mat)
write.table(classTab, "model.classMatrix.txt", sep="\t", row.names=F, quote=F)

fea_list <- list()
for (method in methodsValid) {
  fea_list[[method]] <- ExtractVar(model[[method]])
}
fea_df <- lapply(model, function(fit){
  data.frame(ExtractVar(fit))
})
fea_df <- do.call(rbind, fea_df)
fea_df$algorithm <- gsub("(.+)\\.(.+$)", "\\1", rownames(fea_df))
colnames(fea_df)[1] <- "features"
write.table(fea_df, file="model.genes.txt", sep = "\t", row.names = F, col.names = T, quote = F)

AUC_list <- list()
for (method in methodsValid){
  AUC_list[[method]] <- RunEval(fit = model[[method]],      # 使用机器学习模型
                                Test_set = Test_set,        # 提供测试数据
                                Test_label = Test_class,    # 提供测试标签
                                Train_set = Train_set,      # 提供训练数据
                                Train_label = Train_class,  # 提供训练标签
                                Train_name = "Train",       # 指定训练标签
                                cohortVar = "Cohort",       # 指定队列变量
                                classVar = classVar)        # 指定类变量
}
AUC_mat <- do.call(rbind, AUC_list)
aucTab=cbind(Method=row.names(AUC_mat), AUC_mat)
write.table(aucTab, "model.AUCmatrix.txt", sep="\t", row.names=F, quote=F)

AUC_mat <- read.table("model.AUCmatrix.txt", header=T, sep="\t", check.names=F, row.names=1, stringsAsFactors=F)

avg_AUC <- apply(AUC_mat, 1, mean)
avg_AUC <- sort(avg_AUC, decreasing = T)
AUC_mat <- AUC_mat[names(avg_AUC),]
# 获取最佳模型的变量选择结果
fea_sel <- fea_list[[rownames(AUC_mat)[1]]]
avg_AUC <- as.numeric(format(avg_AUC, digits = 3, nsmall = 3))

# 重新定义热图的颜色
CohortCol <- brewer.pal(n = max(3, ncol(AUC_mat)), name = "Paired")
names(CohortCol) <- colnames(AUC_mat)

# 【核心修改 1】：强制只取有名字的部分，去掉那个 <NA>
CohortCol <- CohortCol[colnames(AUC_mat)]

# 【核心修改 2】：给 avg_AUC 补回行名（format 之后行名会丢失，不补会报错或条形图无数据）
names(avg_AUC) <- rownames(AUC_mat)

# 再次检查（现在不应该有 NA 了）
print(CohortCol)
# 绘制热图
cellwidth = 1; cellheight = 0.5
hm <- SimpleHeatmap(Cindex_mat = AUC_mat,       # AUC矩阵
                    avg_Cindex = avg_AUC,       # AUC平均值
                    CohortCol = CohortCol,      # 数据集的颜色
                    barCol = "steelblue",       # 条形图的颜色
                    cellwidth = cellwidth, cellheight = cellheight,    # 设置单元格的宽度和高度
                    cluster_columns = F, cluster_rows = F)      # 设置是否对列和行进行聚类

pdf(file="model.AUCheatmap.pdf", width=cellwidth * ncol(AUC_mat) + 6, height=cellheight * nrow(AUC_mat) * 0.45)
draw(hm, heatmap_legend_side="right", annotation_legend_side="right")
dev.off()



# 1. 汇总所有模型的已选变量（fea_list已在你流程生成）
all_features <- unlist(fea_list, use.names = FALSE)
top_genes_tab <- sort(table(all_features), decreasing = TRUE)
top_genes <- names(top_genes_tab)[1:10]   # 取出现次数最多的前10个基因
importance_mat <- matrix(0, nrow = length(methodsValid), ncol = length(top_genes))
rownames(importance_mat) <- methodsValid
colnames(importance_mat) <- top_genes

for (m in methodsValid) {
  fit <- model[[m]]
  cls <- class(fit)[1]
  imp <- rep(0, length(top_genes)); names(imp) <- top_genes  # 初始化为0
  if (cls == "lognet") {
    coefs <- coef(fit)
    coef_val <- as.numeric(coefs)
    names(coef_val) <- rownames(coefs)
    imp_val <- coef_val[top_genes]
    imp[!is.na(imp_val)] <- imp_val[!is.na(imp_val)]
  } else if (cls == "glm") {
    coefs <- coef(fit)
    coef_val <- as.numeric(coefs)
    names(coef_val) <- names(coefs)
    imp_val <- coef_val[top_genes]
    imp[!is.na(imp_val)] <- imp_val[!is.na(imp_val)]
  } else if (cls == "glmboost") {
    coefs <- coef(fit)
    imp_val <- as.numeric(coefs[top_genes])
    imp[!is.na(imp_val)] <- imp_val[!is.na(imp_val)]
  } else if (cls == "rfsrc") {
    if (!is.null(fit$importance)) {
      use_genes <- intersect(top_genes, rownames(fit$importance))
      if (length(use_genes) > 0) {
        imp_val <- fit$importance[use_genes, 1]
        imp[use_genes] <- imp_val
      }
    }
  } else if (cls == "gbm") {
    gbm_imp <- summary.gbm(fit, plotit = FALSE)
    vals <- gbm_imp$rel.inf
    names(vals) <- gbm_imp$var
    imp_val <- vals[top_genes]
    imp[!is.na(imp_val)] <- imp_val[!is.na(imp_val)]
  } else if (cls == "xgb.Booster") {
    imp_tab <- xgb.importance(feature_names = fit$subFeature, model = fit)
    vals <- imp_tab$Gain
    names(vals) <- imp_tab$Feature
    imp_val <- vals[top_genes]
    imp[!is.na(imp_val)] <- imp_val[!is.na(imp_val)]
  }
  importance_mat[m, ] <- imp  # 每一行都严格对齐top_genes
}


importance_mat[is.na(importance_mat)] <- 0

pdf("model.keyGeneModelHeatmap.pdf", width = 16, height = 20)
Heatmap(importance_mat,
        name = "Importance",
        col = colorRamp2(c(min(importance_mat), 0, max(importance_mat)), c("blue", "white", "red")),
        cluster_rows = TRUE,
        cluster_columns = TRUE,
        column_title = "Top 10 Key Genes",
        row_title = "Model",
        heatmap_legend_param = list(title = "Importance"),
        cell_fun = function(j, i, x, y, w, h, col) {
          grid.text(sprintf("%.2f", importance_mat[i, j]), x, y, gp = gpar(fontsize = 8))
        }
)
dev.off()
