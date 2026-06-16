#以下是环境配置
unlink("/mnt/nas00_userhome/rs202505230068/R/x86_64-pc-linux-gnu-library/4.4/00LOCK-SeuratObject",
       recursive = TRUE, force = TRUE)
unlink("/mnt/nas00_userhome/rs202505230068/R/x86_64-pc-linux-gnu-library/4.4/00LOCK-Seurat",
       recursive = TRUE, force = TRUE)

# 如果当前 session 里已经 library(Seurat) 过，先 detach
if ("package:Seurat" %in% search()) {
  detach("package:Seurat", unload = TRUE, character.only = TRUE)
}

remove.packages("Seurat")
"Seurat" %in% rownames(installed.packages())

if ("SeuratObject" %in% rownames(installed.packages())) {
  remove.packages("SeuratObject")
}
"SeuratObject" %in% rownames(installed.packages())
# 确保 remotes 已安装
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}

# 先装 SeuratObject 4.1.4
remotes::install_version(
  "SeuratObject",
  version = "4.1.4",
  repos   = c("https://satijalab.r-universe.dev", getOption("repos")),
  upgrade = "never"  # 关键：不要顺便升级其他包，也就不会再弹那个选择菜单
)

# 再装 Seurat 4.4.0
remotes::install_version(
  "Seurat",
  version = "4.4.0",
  repos   = c("https://satijalab.r-universe.dev", getOption("repos")),
  upgrade = "never"
)



## 1. 如果当前已经加载过 scCustomize，先卸载
if ("package:scCustomize" %in% search()) {
  detach("package:scCustomize", unload = TRUE, character.only = TRUE)
}

## 2. 如果系统里已经装过一个新版 scCustomize，先删掉
if ("scCustomize" %in% rownames(installed.packages())) {
  remove.packages("scCustomize")
}

## 3. 确保有 remotes 包
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}

## 4. 安装老版本 scCustomize 1.1.3（兼容 Seurat v4）
remotes::install_version(
  "scCustomize",
  version = "1.1.3",
  repos   = c("https://cloud.r-project.org", getOption("repos")),
  upgrade = "never"   # 关键：不要顺便升级别的依赖
)

## 5. 加载并检查版本
library(scCustomize)
packageVersion("scCustomize")









# devtools::install_github(repo = "samuel-marsh/scCustomize")
# devtools::install_github(repo = "samuel-marsh/scCustomize")
# # 安装 scCustomize
# BiocManager::install("scCustomize")

#remotes::install_version("Seurat", "4.4.0", repos = c("https://satijalab.r-universe.dev", getOption("repos")))


#devtools::install_github('JiekaiLab/dior')

#以上是环境配置



# setwd("~/project/20250401_021/03.scRNA/")
#setwd("~/R/R/COAD data")
#x修改igraph 
#remove.packages("igraph")
#install.packages("~/project/20250401_021/03.scRNA/igraph_2.0.3.tar.gz", repos = NULL, type = "source")
# dir.create("./results/")
# remove.packages("Seurat")
# 
# BiocManager::install("Seurat")
# 
# remove.packages(c("Seurat","SeuratObject"))
# install.packages('Seurat', repos = c('https://satijalab.r-universe.dev'))# 检查版本# packageVersion("Seurat")# [1] ‘4.4.0’
# ..
# 
# install.packages("scCustomize")# 检查版本
# packageVersion("Seurat")# [1] ‘5.0.0’
# 
# remove.packages(c("SeuratObject"))
# 
# 
# #（1）重装Matrix
# remove.packages("Matrix")
# remotes::install_version("Matrix", version = "1.6-1.1")
# 
# #（2）设置CRNA
# options(repos="https://mirrors.tuna.tsinghua.edu.cn/CRAN/") 
# 
# # 若步骤（1）无法安装，则可以用以下命令安装
# url <- 'https://mirrors.tuna.tsinghua.edu.cn/CRAN/src/contrib/Archive/Matrix/Matrix_1.6-1.1.tar.gz'
# install.packages(url, repos=NULL, type="source")

# #（3）重装SeuratObject
# remove.packages('SeuratObject')
# url <- "https://mirrors.tuna.tsinghua.edu.cn/CRAN/src/contrib/Archive/SeuratObject/SeuratObject_4.1.4.tar.gz" 
# install.packages(url, repos=NULL, type="source")
# 
# #（4）重装 Seurat
# remove.packages('Seurat')
# url <- "https://mirrors.tuna.tsinghua.edu.cn/CRAN/src/contrib/Archive/Seurat/Seurat_4.4.0.tar.gz"
# install.packages(url, repos=NULL, type="source")
# 
# install.packages('Seurat', repos = c('https://satijalab.r-universe.dev'))# 检查版本# packageVersion("Seurat")# [1] ‘4.4.0’
# 
# remove.packages("Seurat")
# 
# .libPaths()
# 
# install.packages('Seurat', repos = c('https://satijalab.r-universe.dev'))
# 
# 
# BiocManager::install("Seurat", version = "3.16")  # 确保安装的是 Seurat v4 版本
# 
# # 重装
# remove.packages("scCustomize")
# url <- 'https://mirrors.tuna.tsinghua.edu.cn/CRAN/src/contrib/Archive/scCustomize/scCustomize_1.1.0.tar.gz'
# install.packages(url, repos=NULL, type="source")
# # BiocManager::install("scCustomize")
# options(stringsAsFactors = F)
library(Seurat)
library(dplyr)
library(ggplot2)
library(magrittr)
library(gtools)
library(stringr)
library(Matrix)
library(tidyverse)
library(patchwork)
library(data.table)
library(RColorBrewer)
library(ggpubr)
library(data.table)
library(RColorBrewer)
library(ggpubr)
library(ggsci)
library(viridis)
library(scCustomize)
library(dior)
# 如未安装 remotes，先安装
install.packages("remotes")

# 从 GitHub 安装 dior
remotes::install_github("JiekaiLab/dior")
## 1. 找到 sccell 目录下所有 *.count.csv.gz 文件
## 如果你的文件就在 sccell/ 这一层，比如：
## sccell/Sample1.count.csv.gz
## sccell/Sample2.count.csv.gz
files <- list.files("sccell", pattern = "\\.count\\.csv\\.gz$", 
                    full.names = TRUE)

## 如果你的文件是在子目录里，比如
## sccell/Sample1/Sample1.count.csv.gz
## sccell/Sample2/Sample2.count.csv.gz
## 就把上面那行换成：
# files <- list.files("sccell", pattern = "\\.count\\.csv\\.gz$", 
#                     full.names = TRUE, recursive = TRUE)

## 2. 提取样本名（去掉路径和后缀）
sample_names <- basename(files)
sample_names <- sub("\\.count\\.csv\\.gz$", "", sample_names)

## 3. 循环读取每个样本，创建 Seurat 对象
datalist <- vector("list", length(files))

for (i in seq_along(files)) {
  message("正在读取: ", files[i])
  
  # 假设：第 1 列是基因名，列是细胞 -> 行 = 基因，列 = 细胞
  counts <- read.csv(files[i], row.names = 1, check.names = FALSE)
  
  # 如果你的文件实际上是「行 = 细胞，列 = 基因」
  # （比如第一列是 cell1、cell2…），就在这里加一行：
  # counts <- t(counts)
  
  # 给细胞名加上样本前缀，防止不同样本重复
  colnames(counts) <- paste0(sample_names[i], "_", colnames(counts))
  
  # 创建 Seurat 对象
  seu <- CreateSeuratObject(
    counts = counts,
    project = sample_names[i],
    min.cells = 5,
    min.features = 300
  )
  seu$Samples <- sample_names[i]
  
  datalist[[i]] <- seu
}

names(datalist) <- sample_names








#如果是三联套数据从230行开始run
library(dior)
dir_name=list.dirs('sccell/',full.names = F,recursive = F)
dir_name
datalist=list()
#读取10x的数据创建CreateSeuratObject对象
for (i in 1:length(dir_name)){
  dir.10x = paste0("sccell/",dir_name[i])
  my.data <- Read10X(data.dir = dir.10x) 
  #细胞增加标签
  colnames(my.data)=paste0(dir_name[i],colnames(my.data))
  datalist[[i]]=CreateSeuratObject(counts = my.data, project = dir_name[i], min.cells = 5, min.features = 300)
  datalist[[i]]$Samples=dir_name[i]
}
names(datalist)=dir_name








#批量计算线粒体和rRNA的含量
for (i in 1:length(datalist)){
  sce <- datalist[[i]]
  sce[["percent.mt"]] <- PercentageFeatureSet(sce, pattern = "^MT-")# 计算线粒体占比
  sce[["percent.Ribo"]] <- PercentageFeatureSet(sce, pattern = "^RP[SL]")# 计算rRNA占比
  datalist[[i]] <- sce
  rm(sce)
}

#合并所有的数据
sce <- merge(datalist[[1]],y=datalist[2:length(datalist)])
#细胞数的统计
raw_cell=sce@meta.data
raw_count <- table(raw_cell$orig.ident)
raw_count
sum(raw_count)#107789已改

mito_genes=rownames(sce)[grep("^MT-", rownames(sce))] 
mito_genes #13个线粒体基因
sce=PercentageFeatureSet(sce, "^MT-", col.name = "percent_mito")
fivenum(sce@meta.data$percent_mito)

#计算核糖体基因比例
ribo_genes=rownames(sce)[grep("^Rp[sl]", rownames(sce),ignore.case = T)]
ribo_genes
sce=PercentageFeatureSet(sce, "^RP[SL]", col.name = "percent_ribo")
fivenum(sce@meta.data$percent_ribo)
#计算红血细胞基因比例
rownames(sce)[grep("^Hb[^(p)]", rownames(sce),ignore.case = T)]
sce=PercentageFeatureSet(sce, "^HB[^(P)]", col.name = "percent_hb")
fivenum(sce@meta.data$percent_hb)
#可视化细胞的上述比例情况
raster=FALSE
feats <- c("nFeature_RNA", "nCount_RNA", "percent_mito", "percent_ribo", "percent_hb")
feats <- c("nFeature_RNA", "nCount_RNA")
p1=VlnPlot(sce, group.by = "orig.ident", features = feats, pt.size = 0, ncol = 2) + 
  NoLegend()
p1

feats <- c("percent_mito", "percent_ribo", "percent_hb")
p2=VlnPlot(sce, group.by = "orig.ident", features = feats, pt.size = 0, ncol = 3, same.y.lims=T) + 
  scale_y_continuous(breaks=seq(0, 100, 5)) +
  NoLegend()
p2	

p3=FeatureScatter(sce, "nCount_RNA", "nFeature_RNA", group.by = "orig.ident", pt.size = 0.5)
p3

#根据上述指标，过滤低质量细胞/基因
#过滤指标1:最少表达基因数的细胞&最少表达细胞数的基因
selected_c <- WhichCells(sce, expression = nFeature_RNA > 500&
                           nCount_RNA<5000)
selected_f <- rownames(sce)[Matrix::rowSums(sce@assays$RNA@counts > 0 ) > 3]

sce.all.filt <- subset(sce, features = selected_f, cells = selected_c)
dim(sce) 
# 24169 27187
dim(sce.all.filt) 
# 24169 17372


#过滤指标2:线粒体/核糖体基因比例(根据上面的violin图)
selected_mito <- WhichCells(sce.all.filt, expression = percent_mito < 25)
selected_ribo <- WhichCells(sce.all.filt, expression = percent_ribo > 3)
selected_hb <- WhichCells(sce.all.filt, expression = percent_hb < 1 )
length(selected_hb) # 48574
length(selected_ribo) # 48039
length(selected_mito) # 47210


sce.all.filt <- subset(sce.all.filt, cells = selected_mito)
sce.all.filt <- subset(sce.all.filt, cells = selected_ribo)
sce.all.filt <- subset(sce.all.filt, cells = selected_hb)
dim(sce.all.filt)
#23961 47010
table(sce.all.filt$orig.ident) 
#过滤指标3:过滤特定基因
# Filter MALAT1 管家基因
sce.all.filt <- sce.all.filt[!grepl("MALAT1", rownames(sce.all.filt),ignore.case = T), ]
# Filter Mitocondrial 线粒体基因
sce.all.filt <- sce.all.filt[!grepl("^MT-", rownames(sce.all.filt),ignore.case = T), ]
# 当然，还可以过滤更多
dim(sce.all.filt) 
# 23947 47010已改

#细胞周期评分
sce.all.filt = NormalizeData(sce.all.filt)
s.genes=Seurat::cc.genes.updated.2019$s.genes
g2m.genes=Seurat::cc.genes.updated.2019$g2m.genes
sce.all.filt=CellCycleScoring(object = sce.all.filt, 
                              s.features = s.genes, 
                              g2m.features = g2m.genes, 
                              set.ident = TRUE)
sce.all.filt@meta.data  %>% ggplot(aes(S.Score,G2M.Score))+geom_point(aes(color=Phase))+
  theme_minimal()
#保存数据
sce=sce.all.filt
sce <- NormalizeData(sce, 
                     normalization.method = "LogNormalize",
                     scale.factor = 1e4) 
sce <- FindVariableFeatures(sce)
sce <- ScaleData(sce)
sce <- RunPCA(sce, features = VariableFeatures(object = sce))

library(harmony)
seuratObj <- RunHarmony(sce, "orig.ident")
names(seuratObj@reductions)
seuratObj <- RunUMAP(seuratObj,  dims = 1:15, 
                     reduction = "harmony")
DimPlot(seuratObj,reduction = "umap",label=T,group.by = "orig.ident" ) 

sce=seuratObj
sce <- FindNeighbors(sce, reduction = "harmony",
                     dims = 1:15) 
sce.all=sce
#设置不同的分辨率，观察分群效果(选择哪一个？)
for (res in c(0.01, 0.05, 0.1, 0.2, 0.3, 0.5,0.8,1)) {
  sce.all=FindClusters(sce.all, #graph.name = "CCA_snn", 
                       resolution = res, algorithm = 1)
}
colnames(sce.all@meta.data)
apply(sce.all@meta.data[,grep("RNA_snn",colnames(sce.all@meta.data))],2,table)
sel.clust = "RNA_snn_res.0.5"
sce.all <- SetIdent(sce.all, value = sel.clust)
table(sce.all@active.ident) 
DimPlot(sce.all,reduction = "umap",label = T,raster=FALSE)

#去除双细胞
#remotes::install_github('lzmcboy/DoubletFinder_204_fix')
library(DoubletFinder)
seurat_object <- SplitObject(sce.all, split.by = "orig.ident")

#函数
ks_detectDoublet <- function(obj, #seurat obj
                             dims, #Pc数目
                             estDubRate, #期望双细胞率，该值最好通过细胞在10X/Drop-Seq装置上的负载密度来估计
                             ncores=1,#线程数
                             SCTransform,#True or False
                             Homotypic=F,#是否需要优化同源双细胞
                             annotation){ #听说最好是celltype
  #use DoubletFinder packages
  require(DoubletFinder)#2.0.4
  
  #select pK
  sweep.res.list <- paramSweep(obj, PCs=dims, sct=SCTransform, num.cores=ncores)
  sweep.stats <- summarizeSweep(sweep.res.list, GT=FALSE)
  bcmvn <- find.pK(sweep.stats)
  pK <- bcmvn$pK[which.max(bcmvn$BCmetric)] %>% as.character() %>% as.numeric()
  message(sprintf("Using pK = %s...", pK))
  
  
  #Doublet Proportion Estimate
  if(Homotypic==F){
    
    nExp_poi <- round(estDubRate * length(Cells(obj)))
    
  }else{
    
    homotypic.prop <- modelHomotypic(obj@meta.data[,annotation])
    nExp_poi <- round(estDubRate * length(Cells(obj)))
    nExp_poi  <- round(nExp_poi*(1-homotypic.prop))
  }
  
  # DoubletFinder:
  obj <- doubletFinder(obj, PCs = dims, pN = 0.25, pK = pK, nExp = nExp_poi, reuse.pANN = FALSE, sct = SCTransform)
  
  # Rename results into more useful annotations
  pann <- grep(pattern="^pANN", x=names(obj@meta.data), value=TRUE)
  message(sprintf("Using pANN = %s...", pann))
  classify <- grep(pattern="^DF.classifications", x=names(obj@meta.data), value=TRUE)
  obj$pANN <- obj[[pann]]
  obj$DF.classify <- obj[[classify]]
  obj[[pann]] <- NULL
  obj[[classify]] <- NULL
  
  return(obj)
}

#循环跑
for (i in 1:length(seurat_object)) {
  table_value <- table(seurat_object[[i]]$orig.ident)
  
  if (table_value < 4000) {
    estDubRate <- 0.025
  } else if (table_value > 4000 && table_value < 8000) {
    estDubRate <- 0.05
  } else if (table_value > 8000) {
    estDubRate <- 0.065
  }
  
  seurat_object[[i]] <- ks_detectDoublet(seurat_object[[i]], dims = 1:30, estDubRate = estDubRate,
                                         ncores = 8, SCTransform = F, Homotypic = F, annotation = "seurat_clusters")
}
duPlot <- list()
for (i in seq_along(seurat_object)) {
  p = DimPlot(seurat_object[[i]], group.by = "DF.classify")+ggtitle(unique(seurat_object[[i]]$orig.ident))
  duPlot[[i]] <- p
}
library(cowplot)
plot_grid(duPlot[[1]],duPlot[[2]],duPlot[[3]], ncol = 3)
###remove Doublet
for (i in seq_along(seurat_object)) {
  seurat_object[[i]] <- subset(seurat_object[[i]], subset = (DF.classify == "Singlet"))
}

#重新整合##########
sce <- merge(seurat_object[[1]],y=seurat_object[2:length(seurat_object)])
dim(sce) #28966 90302


sce <- NormalizeData(sce, 
                     normalization.method = "LogNormalize",
                     scale.factor = 1e4) 
sce <- FindVariableFeatures(sce)
sce <- ScaleData(sce)
sce <- RunPCA(sce, features = VariableFeatures(object = sce))

library(harmony)
seuratObj <- RunHarmony(sce, "orig.ident")
names(seuratObj@reductions)
seuratObj <- RunUMAP(seuratObj,  dims = 1:15, 
                     reduction = "harmony")
DimPlot(seuratObj,reduction = "umap",label=T ) 

sce=seuratObj
sce <- FindNeighbors(sce, reduction = "harmony",
                     dims = 1:15) 
sce.all=sce
#设置不同的分辨率，观察分群效果(选择哪一个？)
for (res in c(0.01, 0.05, 0.1, 0.2, 0.3, 0.5,0.8,1)) {
  sce.all=FindClusters(sce.all, #graph.name = "CCA_snn", 
                       resolution = res, algorithm = 1)
}




colnames(sce.all@meta.data)
apply(sce.all@meta.data[,grep("RNA_snn",colnames(sce.all@meta.data))],2,table)
sel.clust = "RNA_snn_res.0.5"
sce.all <- SetIdent(sce.all, value = sel.clust)
table(sce.all@active.ident) 
DimPlot(sce.all,reduction = "umap",label = T,raster=FALSE)


#去污染
#BiocManager::install('enrichR')
#BiocManager::install('celda')
#BiocManager::install('decontX')



# 如果还没有 BiocManager，先安装
#if (!requireNamespace("BiocManager", quietly = TRUE)) {
#  install.packages("BiocManager")
#}

# 安装 decontX
#BiocManager::install("decontX")

# 载入测试
library(decontX)








library(decontX)
# 提取矩阵(genes x cells)
# 需要注意的是，你应该查看你的矩阵是否已经注释了行名和列明，以及如果你的矩阵是scanpy对象中提取的矩阵应该行列转置
counts <- sce.all@assays$RNA@counts
# 需要把结果储存在新变量
decontX_results <- decontX(counts)# 我们可以直接把他写入metadata
sce.all$Contamination =decontX_results$contamination
head(sce.all@meta.data) # 可以查看一下结果，这里就不展示了 
sce.all = sce.all[,sce.all$Contamination < 0.2] #保留小于等于0.2的细胞
dim(sce.all)
#result[1] [1] 23947 40886

#再走一遍流程
sce <- NormalizeData(sce.all, 
                     normalization.method = "LogNormalize",
                     scale.factor = 1e4) 
sce <- FindVariableFeatures(sce)
sce <- ScaleData(sce)
sce <- RunPCA(sce, features = VariableFeatures(object = sce))

library(harmony)
seuratObj <- RunHarmony(sce, "orig.ident")
names(seuratObj@reductions)
seuratObj <- RunUMAP(seuratObj,  dims = 1:15, 
                     reduction = "harmony")
DimPlot(seuratObj,reduction = "umap",label=T ) 

sce=seuratObj
sce <- FindNeighbors(sce, reduction = "harmony",
                     dims = 1:15) 
sce.all=sce
#设置不同的分辨率，观察分群效果(选择哪一个？)
for (res in c(0.01, 0.05, 0.1, 0.2, 0.3, 0.5,0.8,1)) {
  sce.all=FindClusters(sce.all, #graph.name = "CCA_snn", 
                       resolution = res, algorithm = 1)
}
colnames(sce.all@meta.data)
apply(sce.all@meta.data[,grep("RNA_snn",colnames(sce.all@meta.data))],2,table)
sel.clust = "RNA_snn_res.0.05"
sce.all <- SetIdent(sce.all, value = sel.clust)
table(sce.all@active.ident) 
DimPlot(sce.all,reduction = "umap",label = T,raster=FALSE)
dim(sce.all)
#23947 40886
saveRDS(sce.all,file = "results/sce_filtered.RDS")
rm(list = ls())
library(Seurat)
library(dplyr)
library(ggplot2)
library(magrittr)
library(gtools)
library(stringr)
library(Matrix)
library(tidyverse)
library(patchwork)
library(data.table)
library(RColorBrewer)
library(ggpubr)
library(ggsci)
library(ggplot2)
library(viridis)
library(scCustomize)
sce=readRDS("./results/sce_filtered.RDS")
sce <- RunUMAP(sce,  dims = 1:15,
               reduction = "harmony")


#sce=RunTSNE(sce,  dims = 1:15, 
#            reduction = "harmony")


table(sce$RNA_snn_res.0.05)
sce$seurat_clusters=sce$RNA_snn_res.0.05
library(ggplot2) 
#genes_to_check = c('PTPRC','CD3D','CD3E','CD3G',#T C
#                   'IGKC','IGHG1','CD19','CD79A',#B
#                   "MKI67","TOP2A",#Cycel
#                   'LYZ','CD68','CD14','C1QA','C1QB', #MAC
#                   'CX3CR1','TMEM119',#Microgla
#                   "HLA−DQA1","HLA-DPB1",#DC
#                   'S100A9', 'S100A8', 'MMP19',# monocyte
#                   "ACTA2","PDGFRB",##Pericyte
#                   'DCN','LUM','PDGFRA','MME',#fibroblas
#                   'OLIG2','MBP','MOG','CLDN11',#Oligodendrocytes
#                   'SOX2','OLIG1','GFAP','S100B'#Malignant

#)





genes_to_check =  c("CD3D","LYZ","CD3E",
                    "NKG7","NCAM1","TRDC","KLRG1","GNLY", # NK cells
                    "CD4","CD8A","CD8B",
                    "CD14","FCGR3A","CD68","CD163","FCN1",
                    "PPBP","PF4", # Megakaryocyte
                    "CD79A","MS4A1", # B cells
                    "MZB1","XBP1", # Plasma B
                    "FCGR3B", "CXCR2","S100A8","MPO", # Neutrophil
                    "TPSB2", # Mast
                    "LILRA4","CD1C","XCR1", # DC
                    "TBX21", # Th1
                    "TRAV1-2", # MAIT cells
                    "TRDV2","TRGV9", # gamma T
                    "IL7R","GATA3","RORC","AREG","KIT") # ILCs


#T cell('CD2','CD3D','CD3E','CD3G'),CD4 T ('CD3D','CD4'),CD8 T('CD3D','CD8A','CD8B','GZMA'),Macrophage('CD163','CD68','CD14'),Monocyte('VCAN'),B cell('CD19','CD79A','MS4A1'),Plasma cell('CD79A','JSRP1'),Epithelial cell(EPCAM),Fibroblast('ACTA2','PDGFRB','NOTCH3'),Endothelial cell(PECAM1)
library(stringr)  
Idents(sce)='seurat_clusters'
p <- DotPlot(sce, features = unique(genes_to_check),
             assay='RNA')  + coord_flip()

p 

p <- DotPlot(
  sce,
  features = unique(genes_to_check),
  assay = "RNA"
) +
  coord_flip() +
  theme(
    panel.grid  = element_blank(),
    axis.text.x = element_text(angle = 45, hjust = 0.5, vjust = 0.5)
  ) +
  labs(x = NULL, y = NULL) +
  guides(size = guide_legend("Percent Expression")) +
  scale_color_gradientn(colours = c("#330066", "#336699", "#66CC66", "#FFCC33"))
p




## 1. 差异分析参数
Logfc  <- 0.5
Minpct <- 0.35

## 2. 设置默认 assay 为 RNA
DefaultAssay(sce) <- "RNA"

## 3. 用 seurat_clusters 作为分组（默认 0,1,2,...）
##   如果前面改过 Idents，这里再强制设回聚类
Idents(sce) <- "seurat_clusters"

## 4. 计算每个 cluster 的 marker 基因（只要上调基因）
sce.markers <- FindAllMarkers(
  object          = sce,
  logfc.threshold = Logfc,
  min.pct         = Minpct,
  only.pos        = TRUE
)

## 5. 新增一列：pct.diff = pct.1 - pct.2
sce.markers[,"pct.diff"] <- sce.markers$pct.1 - sce.markers$pct.2

## 6. 只保留校正后 p 值 < 0.05 的基因
sce.markers <- sce.markers[sce.markers$p_val_adj < 0.05, ]

## 看一下有多少个基因被选中、前几行长什么样
length(unique(sce.markers$gene))
head(sce.markers)

## 7. 创建结果目录（如果已经有就不会报 warning）
dir.create("results", showWarnings = FALSE)

## 8. 把 marker 表格保存成 tab 分隔的 txt 文件
write.table(
  sce.markers,
  file      = "results/scRNA_marker_gene.txt",
  quote     = FALSE,
  row.names = FALSE,
  sep       = "\t"
)
#####1201新改代码以上筛选diff.maker



pdf("umap.pdf", width = 8, height = 8)
DimPlot(sce, reduction = "umap", label = TRUE, pt.size = 0.5)
dev.off()



table(sce$seurat_clusters)
celltype=data.frame(ClusterID=0:7,
                    celltype= 0:7) 
celltype[celltype$ClusterID %in% c(0),2]='T Cell'
celltype[celltype$ClusterID %in% c(1),2]='NK Cell'
celltype[celltype$ClusterID %in% c(2),2]='Monocyte-macrophage'
celltype[celltype$ClusterID %in% c(3),2]='Endothelial Cell'
celltype[celltype$ClusterID %in% c(4),2]='Vascular Smooth Muscle Cell'
celltype[celltype$ClusterID %in% c(5),2]='Fibroblast'
celltype[celltype$ClusterID %in% c(6),2]='B Cell'
celltype[celltype$ClusterID %in% c(7),2]='Inflammatory Activated Myeloid Cell'



head(celltype)
#celltype
#install.packages("tidydr")



table(celltype$celltype)
#sce@meta.data$celltype = "NA"
#table(sce$celltype)

for(i in 1:nrow(celltype)){
  sce@meta.data[which(sce@meta.data$seurat_clusters == celltype$ClusterID[i]),'celltype'] <- celltype$celltype[i]}
table(sce@meta.data$celltype)


DimPlot(sce,group.by = "celltype",label = T,reduction = "umap")
newcolour <- c("#FF5E33","#FFBE7A","#82B0D2","#2878b5","#f8ac8c","#BEB8DC",
               "#6A5ACD","#D2B48C","#FF336E","#40E0D0","#D2691E","#8ECFC9",
               "#DEB887","#c82423","#ff8884","#A1A9D0","#9ac9db","#E7DAD2",
               "#F0988C","#B883D4","#9E9E9E","#CFEAF1","#C4A5DE","#98FB98",
               "#228B22", "#FFD700")
library(ggplot2)
library(tidydr)
# Create UMAP plot
t1 <- DimPlot(sce, reduction = 'umap', 
              cols = newcolour,
              repel = T,
              label.size = 3.5,
              label = TRUE,
              pt.size = 0.01, 
              raster = F,group.by = "celltype") +
  theme_dr(xlength = 0.2, ylength = 0.3, arrow = arrow(length = unit(0.2, "inches"), type = "closed")) +
  theme(panel.grid = element_blank(), axis.title = element_text(hjust = 0.03)) +
  NoLegend() + ggtitle("  ") + 
  theme(text = element_text(size = 12, family = "serif"))
t1






table(sce$celltype)
#gene=c('CD3D','CD79A','CD68','TMEM119','ACTA2','DCN','OLIG2','SOX2')

#gene=c('CERS6','CLIP3','CTSK','FMO3','GALC','LPL','NPHS1','PLCE1')
gene=c('AADAC','ALOX5AP','BCHE','CXCL1','CXCR4','HLA-DPB1','HLA-DQA1','IER3','MGAM','NCF2','RAC2','RPS11','S100A4','S100A8','S100A9','TYROBP','UTS2','WT1')




#new.cluster.ids <- c("T Cell", "Malignant Cell","Cycling epithelial Cell","Monocyte-macrophage Cell","B Cell", 
#                     "Fibroblast Cell", "Plasmacytoid dendritic cell",
#                        "Plasma Cell","Muscle-related Cell","Vascular endothelial Cell")
#names(new.cluster.ids) <- levels(sce)
#sce <- RenameIdents(sce, new.cluster.ids)

#pdf("umap.pdf", width = 15, height = 8)
#DimPlot(sce, reduction = "umap", label = TRUE, pt.size = 0.5)


#11-23修改后

# ---- 你已有的重命名（保留）----
#new.cluster.ids <- c("T Cell", "Malignant Cell","Cycling epithelial Cell","Monocyte-macrophage Cell",
#                     "B Cell", "Fibroblast Cell", "Plasmacytoid dendritic cell",
#                     "Plasma Cell","Muscle-related Cell","Vascular endothelial Cell")
# 建议：names 应对应旧水平
# names(new.cluster.ids) <- levels(Idents(sce))
#names(new.cluster.ids) <- levels(sce)  # 若你之前就是这样，这行也可保留
#sce <- RenameIdents(sce, new.cluster.ids)

# 让 meta 列与 Idents 完全一致（后面所有代码都将用这个）
#sce$celltype <- factor(as.character(Idents(sce)), levels = levels(Idents(sce)))

# 若你此处想直接用 Idents 画图（不指定 group.by 也行）
DimPlot(sce, reduction = "umap", label = TRUE, pt.size = 0.5)
print(last_plot())   # 把图真正画到pdf设备
dev.off()            # 关闭设备，文件才能正常打开
# ================= 后续代码（已适配新分群名）=================

# FeaturePlot 网格
plots <- list()
for (i in seq_along(gene)) {
  plots[[i]] <- FeaturePlot_scCustom(
    seurat_object = sce,
    colors_use    = viridis_magma_dark_high,
    features      = gene[i],
    reduction     = "umap"
  ) + NoLegend() + NoAxes() +
    theme(panel.border = element_rect(fill = NA, color = "black", size = 1.5, linetype = "solid"))
}
library(patchwork)
p <- wrap_plots(plots, ncol = 4)
p
ggsave(file = "./results/fig3F.pdf", p, width = 10, height = 4)

Idents(sce) <- 'celltype'   # 明确以新 celltype 为分组
levels(Idents(sce))

# 保存对象
saveRDS(sce, file = "results/sce_celltype.RDS")

# ===== 差异分析用新的 celltype 列 =====
#Logfc  <- 0.5
#Minpct <- 0.35
#DefaultAssay(sce) <- "RNA"
#sce.markers <- FindAllMarkers(object = sce, logfc.threshold = Logfc, min.pct = Minpct, only.pos = TRUE)
#sce.markers[["pct.diff"]] <- sce.markers$pct.1 - sce.markers$pct.2
#sce.markers <- subset(sce.markers, p_val_adj < 0.05)
#length(unique(sce.markers$gene))
#head(sce.markers)

#dir.create("results", showWarnings = FALSE)
#write.table(sce.markers, 'results/scRNA_marker_gene.txt', quote = FALSE, row.names = FALSE, sep = '\t')

library(ClusterGVis)
library(org.Hs.eg.db)

# 每个 cluster 取 top20 marker
pbmc.markers <- sce.markers %>%
  dplyr::group_by(cluster) %>%
  dplyr::slice_max(order_by = avg_log2FC, n = 20, with_ties = FALSE)
head(pbmc.markers)

# 富集准备 + 富集
st.data <- prepareDataFromscRNA(object = sce, diffData = pbmc.markers, showAverage = TRUE)

library(clusterProfiler)
enrich <- enrichCluster(object = st.data,
                        OrgDb = org.Hs.eg.db,
                        type = "BP",
                        organism = "hsa",
                        pvalueCutoff = 0.5,
                        topn = 5)

set.seed(123)
markGenes <- unique(pbmc.markers$gene)
markGenes <- markGenes[sample(seq_along(markGenes), 40, replace = FALSE)]

# 线图/热图
visCluster(object = st.data, plot.type = "line")

pdf('results/fig3g.pdf', height = 10, width = 8, onefile = FALSE)
print(
  visCluster(object = st.data,
             plot.type = "heatmap",
             column_names_rot = 45,
             markGenes = markGenes,
             cluster.order = c(1:8))
)

dev.off()

gene=read.csv("./coxgene.csv",row.names = 1)
gene=rownames(gene)
geneset=list(gene)
names(geneset)='Hub_genes'
#
sce=readRDS("./results/sce_celltype.RDS")

library(UCell)
library(irGSEA)
library(AUCell)
## 1. AUCell 
cells_rankings <- AUCell_buildRankings(sce@assays$RNA@data,  nCores=12, plotStats=TRUE) 

cells_AUC <- AUCell_calcAUC(geneset, cells_rankings,nCores =12, aucMaxRank=nrow(cells_rankings)*0.1)

aucs <- as.numeric(getAUC(cells_AUC)['Hub_genes', ])


## 2. Ucells and singscore
scRNA <- irGSEA.score(object = sce, assay = "RNA",
                      slot = "data", seeds = 123, ncores = 12,msigdb = F,
                      custom = T, geneset = geneset,
                      method = c('UCell','singscore'),
                      kcdf = 'Gaussian')

uc=as.data.frame(scRNA@assays$UCell@counts)
uc=as.data.frame(t(uc))

singscore=as.data.frame(scRNA@assays$singscore@counts)
singscore=as.data.frame(t(singscore))


## 3. GSVA
exp<- as.matrix(sce@assays$RNA@data)


library(GSVA)

# 创建ssgsea参数对象（移除非必要参数）
param <- ssgseaParam(
  exprData = exp, 
  geneSets = geneset,
  minSize = 1  # 必需参数：设置基因集最小基因数
)

# 执行GSVA分析
matrix <- gsva(param)

# 转置结果
ssgsea <- as.data.frame(t(matrix))

# 查看结果
print(ssgsea)

#ssgsea=as.data.frame(t(matrix))



# 5. addmodulescore自带函数
sce=AddModuleScore(sce,features = geneset,name = 'Add')

# 组合
score=data.frame(AUCell=aucs,ssgsea=ssgsea$Hub_genes,Add=sce$Add1)

# scale 标准化
score<- scale(score)

# 0-1标准化

normalize=function(x){
  return((x-min(x))/(max(x)-min(x)))}

score=apply(score, 2, normalize)
score=as.data.frame(score)
score$Scoring=rowSums(score)
colnames(scRNA@meta.data)

sce$Add1=NULL

# 将score添加入metadata，需要充分理解 
sce@meta.data=cbind(sce@meta.data,score)

library(RColorBrewer) 
library(viridis)
library(wesanderson)

# n <- 30
# qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
# col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
# pie(rep(1,n), col=sample(col_vector, n))
# color = grDevices::colors()[grep('gr(a|e)y', grDevices::colors(), invert = T)]
# pie(rep(6,n), col=sample(color, n))
# col_vector
# col_vector =c(wes_palette("Darjeeling1"), wes_palette("GrandBudapest1"), wes_palette("Cavalcanti1"), wes_palette("GrandBudapest2"), wes_palette("FantasticFox1"))
# pal <- wes_palette("Zissou1", 12, type = "continuous")
# pal2 <- wes_palette("Zissou1", 5, type = "continuous")
# pal[3:12]


dev.off()
library(ggplot2)
pdf("results/fig3h104.pdf", width=8, height=4)

DotPlot(sce, features = colnames(score)) +
  RotatedAxis() +
  theme(axis.text.x = element_text(angle = 30, hjust=1),
        axis.text.y = element_text(face="bold"),
        legend.position="right") +
  scale_color_gradient2(low = "navy", mid = "white", high = "#B40F20", midpoint = 0) +
  labs(title = "cluster markers", y = "", x = "")

dev.off()

saveRDS(sce,file = "results/sce_score.RDS")
#rm(list = ls())
#gc()
library(monocle)
sce=readRDS('results/sce_score.RDS')
#发现其富集主要集中在monocyte /T Cell
table(sce$celltype)

#拟时序
scRNAsub=subset(sce,celltype=='Monocyte-macrophage')

## 可以记忆这样的分细胞亚组的形式
scRNAsub$Hub_genes=ifelse(scRNAsub$Scoring > median(scRNAsub$Scoring),'High_Hub_genes','Low_Hub_genes')
data=as.matrix(scRNAsub@assays$RNA@counts)
data <- as(data, 'sparseMatrix')
pd <- new('AnnotatedDataFrame', data = scRNAsub@meta.data)
fData <- data.frame(gene_short_name = row.names(data), row.names = row.names(data))
fd <- new('AnnotatedDataFrame', data = fData)
## 以下代码一律不得修改 ！
mycds <- newCellDataSet(data,
                        phenoData = pd,
                        featureData = fd,
                        expressionFamily = negbinomial.size())

mycds <- estimateSizeFactors(mycds)
mycds <- estimateDispersions(mycds, cores=5, relative_expr = TRUE)

##使用monocle选择的高变基因，不修改
disp_table <- dispersionTable(mycds)
disp.genes <- subset(disp_table, mean_expression >= 0.1 & dispersion_empirical >= 1 * dispersion_fit)$gene_id
mycds <- setOrderingFilter(mycds, disp.genes)
plot_ordering_genes(mycds)

#降维
mycds <- reduceDimension(mycds, max_components = 2, method = 'DDRTree')
#排序
mycds <- orderCells(mycds)
dev.off()









gene=read.csv("./coxgene.csv")[,1]
my_pseudotime_cluster <- plot_pseudotime_heatmap(mycds[gene,],
                                                 # num_clusters = 2, # add_annotation_col = ac,
                                                 show_rownames = TRUE,
                                                 return_heatmap = TRUE)
pdf("./results/fig4a.pdf",he=6,wi=4)
my_pseudotime_cluster 
dev.off()

#State轨迹分布图
plot1 <- plot_cell_trajectory(mycds, color_by = "Hub_genes")
plot1

plot4 <- plot_cell_trajectory(mycds, color_by = "Pseudotime")
plot4

##合并出图
plotc <- plot1|plot4
pdf("./results/fig4bc.pdf",he=4,wi=8)
plotc
dev.off()


library(CellChat)
library(patchwork)
source('source.R')
table(sce$celltype)
scRNA_other=subset(sce,celltype != 'Monocyte−macrophage')
scRNA_other$Hub_genes=scRNA_other$celltype
scRNA_chat=merge(scRNAsub,scRNA_other)


meta =scRNA_chat@meta.data # a dataframe with rownames containing cell mata data

data_input <- as.matrix(scRNA_chat@assays$RNA@data)
#data_input=data_input[,rownames(meta)]

table(meta$Hub_genes_group)

meta=meta[order(meta$Hub_genes),]

cellchat <- createCellChat(object = data_input[,rownames(meta)], meta = meta, group.by = "Hub_genes")

CellChatDB <- CellChatDB.human 
groupSize <- as.numeric(table(cellchat@idents))
CellChatDB.use <- subsetDB(CellChatDB, search = "Secreted Signaling") 
cellchat@DB <- CellChatDB.use 

dplyr::glimpse(CellChatDB$interaction)##配体-受体分析
# 提取数据库支持的数据子集
cellchat <- subsetData(cellchat)
# 识别过表达基因
cellchat <- identifyOverExpressedGenes(cellchat)
# 识别配体-受体对
cellchat <- identifyOverExpressedInteractions(cellchat)
# 将配体、受体投射到PPI网络
cellchat <- projectData(cellchat, PPI.human)
table(cellchat@idents)
cellchat@meta$NMF_celltype=as.character(cellchat@meta$Hub_genes)
table(cellchat@idents)
cellchat <- computeCommunProb(cellchat)


# Filter out the cell-cell communication if there are only few number of cells in certain cell groups
cellchat <- filterCommunication(cellchat, min.cells = 10)
cellchat <- computeCommunProbPathway(cellchat)

df.net<- subsetCommunication(cellchat)

cellchat <- aggregateNet(cellchat)
groupSize <- as.numeric(table(cellchat@idents))

pdf('results/fig4d.pdf',height = 8,width = 8)
netVisual_circle(cellchat@net$count, vertex.weight = groupSize,
                 weight.scale = T, label.edge= T,
                 title.name = "Number of interactions")
dev.off()

p_bubble= netVisual_bubble(cellchat,
                           sources.use = c('High_Hub_genes','Low_Hub_genes'),
                           remove.isolate = FALSE)+coord_flip()
p_bubble
ggsave('results/fig4f.pdf',p_bubble,height = 6,width = 8)

p_bubble2= netVisual_bubble(cellchat,
                            targets.use = c('High_Hub_genes','Low_Hub_genes'),
                            remove.isolate = FALSE)+coord_flip()
p_bubble2
ggsave('results/fig4g.pdf',p_bubble2,height = 6,width = 8)

dev.off()

cellchat <- netAnalysis_computeCentrality(cellchat, slot.name = "netP")


h1=netAnalysis_signalingRole_heatmap(cellchat, pattern = "outgoing")
h2=netAnalysis_signalingRole_heatmap(cellchat, pattern = "incoming")
pdf('results/fig4e.pdf',height = 7,width = 12)
h1 + h2
dev.off()












sce=readRDS("./sce_celltype.RDS")


# 8. SUBSET ANALYSIS SETUP
# ================================================================================

# Extract T cells for detailed analysis
  Tcells_filtered <- subset(sce, celltype %in% "T Cell")



Tcells_filtered <- NormalizeData(Tcells_filtered)

# 寻找高变基因
Tcells_filtered <- FindVariableFeatures(Tcells_filtered, selection.method = "vst", nfeatures = 2000)

# 数据标准化
Tcells_filtered <- ScaleData(Tcells_filtered, verbose = FALSE)

# PCA分析
Tcells_filtered <- RunPCA(Tcells_filtered, verbose = FALSE)


#install.packages("harmony")
library(harmony)

# Harmony批次效应校正
Tcells_filtered <- RunHarmony(Tcells_filtered, c("orig.ident"))

# 生成ElbowPlot并保存

print(ElbowPlot(Tcells_filtered, ndims = 50))

#setwd("~/jwqdxb/滕飞亚组Bcells")

# UMAP降维
Tcells_filtered <- RunUMAP(Tcells_filtered, reduction = "harmony", dims = 1:40)

# 寻找邻居和聚类
Tcells_filtered <- FindNeighbors(Tcells_filtered, reduction = "harmony", dims = 1:40)

Tcells_filtered <- FindClusters(Tcells_filtered, resolution = 0.4)

# 生成UMAP图并保存
# 基础UMAP图
p1 <- DimPlot(Tcells_filtered, label = TRUE, raster = FALSE)
p1


newcolour <- c("#FF5E33","#FFBE7A","#82B0D2","#2878b5","#f8ac8c","#BEB8DC",
               "#6A5ACD","#D2B48C","#FF336E","#40E0D0","#D2691E","#8ECFC9",
               "#DEB887","#c82423","#ff8884","#A1A9D0","#9ac9db","#E7DAD2",
               "#F0988C","#B883D4","#9E9E9E","#CFEAF1","#C4A5DE","#98FB98",
               "#228B22", "#FFD700")
library(ggplot2)
library(tidydr)
# Create UMAP plot
t1 <- DimPlot(
  Tcells_filtered, reduction = "umap",
  cols = newcolour,
  label = TRUE, repel = TRUE, label.size = 3.5,
  pt.size = 0.01, raster = FALSE
) +
  NoLegend()
t1



ggsave("umapTcells_filtered-new0111-0.4.pdf", t1, width = 10, height = 8)


save(Tcells_filtered,file='Tcells_filtered.Rdata')

Tmarkers <- FindAllMarkers(object = Tcells_filtered, test.use="wilcox" ,
                           only.pos = TRUE,
                           logfc.threshold = 0.25)   
Tall.markers =Tmarkers %>% dplyr::select(gene, everything()) %>% subset(p_val<0.05)
Ttop50 = Tall.markers %>% group_by(cluster) %>% top_n(n = 50, wt = avg_log2FC)

write.csv(Ttop50,"T_50.csv",row.names = FALSE)

save(Tall.markers,file='Tall_markers.Rdata')
save(Tmarkers,file='Tmarkers.Rdata')

#移出群6和群8
#########修改移除19,24群#######
# 首先检查Tcells对象中的metadata列名
print("Tcells对象中的所有metadata列名:")



print(colnames(Tcells_filtered@meta.data))
# 查找包含cluster信息的列

cluster_cols <- colnames(Tcells_filtered@meta.data)[
  grepl("cluster|snn_res", colnames(Tcells_filtered@meta.data), ignore.case = TRUE)
]


#print(colnames(Bcells@meta.data))
#cluster_cols <- colnames(Bcells@meta.data)[grepl("cluster|snn_res", colnames(Bcells@meta.data), ignore.case = TRUE)]
print("包含cluster信息的列:")
print(cluster_cols)

# 检查默认的cluster信息
print("默认的cluster信息 (Idents):")
print(table(Idents(Tcells_filtered)))

# 定义要移除的cluster
clusters_to_remove <- c("6","8")

Tcells_filtered <- subset(Tcells_filtered, idents = clusters_to_remove, invert = TRUE)

# 关键步骤：移除未使用的levels
Tcells_filtered$seurat_clusters <- droplevels(Tcells_filtered$seurat_clusters)

# 现在重新编号
current_clusters <- levels(Tcells_filtered$seurat_clusters)
new_cluster_names <- 0:(length(current_clusters)-1)
names(new_cluster_names) <- current_clusters

Tcells_filtered$seurat_clusters_renumbered <- plyr::mapvalues(
  Tcells_filtered$seurat_clusters, 
  from = current_clusters, 
  to = new_cluster_names
)

Tcells_filtered$seurat_clusters_renumbered <- as.factor(Tcells_filtered$seurat_clusters_renumbered)

# 将重新编号的cluster设置为默认的seurat_clusters
Tcells_filtered$seurat_clusters <- Tcells_filtered$seurat_clusters_renumbered
Tcells_filtered$seurat_clusters_renumbered <- NULL  # 删除临时列


p2 <- DimPlot(Tcells_filtered, label = TRUE, raster = FALSE)
p2


newcolour <- c("#FF5E33","#FFBE7A","#82B0D2","#2878b5","#f8ac8c","#BEB8DC",
               "#6A5ACD","#D2B48C","#FF336E","#40E0D0","#D2691E","#8ECFC9",
               "#DEB887","#c82423","#ff8884","#A1A9D0","#9ac9db","#E7DAD2",
               "#F0988C","#B883D4","#9E9E9E","#CFEAF1","#C4A5DE","#98FB98",
               "#228B22", "#FFD700")
library(ggplot2)
library(tidydr)
# Create UMAP plot
t2 <- DimPlot(
  Tcells_filtered, reduction = "umap",
  cols = newcolour,
  label = TRUE, repel = TRUE, label.size = 3.5,
  pt.size = 0.01, raster = FALSE
) +
  NoLegend()
t2

ggsave("umapTcells_filtered-new0111-0.4-LAST.pdf", t2, width = 10, height = 8)



cluster_annotations <- c(
  "0"  = "CD8+ T cells",
  "1"  = "Memory T cells",
  "2"  = "CD8+ T cells",
  "3"  = "Treg cells",
  "4"  = "Exhausted T cells",
  "5"  = "Th17 cells",
  "6"  = "Type I interferon–stimulated T cells"
)

Tcells_filtered <- AddMetaData(
  Tcells_filtered,
  metadata = cluster_annotations[as.character(Tcells_filtered$seurat_clusters)],
  col.name = "cell_type"
)
save(Tcells_filtered, file = "Tcells_anno.Rdata")

Tcells_filtered <- AddMetaData(Tcells_filtered, 
                               metadata = cluster_annotations[as.character(Tcells_filtered$seurat_clusters)], 
                               col.name = "cell_type")
save(Tcells_filtered,file='Tcells_anno.Rdata')


# Define color palette
newcolour <- c("#FF5E33","#FFBE7A","#82B0D2","#2878b5","#f8ac8c","#BEB8DC",
               "#6A5ACD","#D2B48C","#FF336E","#40E0D0","#D2691E","#8ECFC9",
               "#DEB887","#c82423","#ff8884","#A1A9D0","#9ac9db","#E7DAD2",
               "#F0988C","#B883D4","#9E9E9E","#CFEAF1","#C4A5DE","#98FB98",
               "#228B22", "#FFD700")
library(ggplot2)
library(tidydr)
# Create UMAP plot
t3 <- DimPlot(Tcells_filtered, reduction = 'umap', 
              cols = newcolour,
              repel = T,
              label.size = 3.5,
              label = TRUE,
              pt.size = 0.01, 
              raster = F,group.by = "cell_type") +
  theme_dr(xlength = 0.2, ylength = 0.3, arrow = arrow(length = unit(0.2, "inches"), type = "closed")) +
  theme(panel.grid = element_blank(), axis.title = element_text(hjust = 0.03)) +
  NoLegend() + ggtitle("  ") + 
  theme(text = element_text(size = 12, family = "serif"))
t3
Idents(Tcells_filtered) <- Tcells_filtered$cell_type

###以下是做的hub-gene在耗竭T和CD8+T中的区别01-12

library(Seurat)
library(dplyr)
library(ggplot2)


# 1) 确保用 RNA 做差异表达（如果你之前用了 integrated/SCT，这一步很关键）
DefaultAssay(Tcells_filtered) <- "RNA"
# 如果你是 SCT workflow，放开下面两行
# DefaultAssay(Tcells_filtered) <- "SCT"
# Tcells_filtered <- PrepSCTFindMarkers(Tcells_filtered)

# 先确认 cell_type 确实存在
stopifnot("cell_type" %in% colnames(Tcells_filtered@meta.data))

# 把 Idents 设置为 cell_type（推荐这种写法）
Idents(Tcells_filtered) <- "cell_type"

# 看看当前有哪些身份标签（这一步能立刻定位拼写/空格问题）
print(levels(Idents(Tcells_filtered)))
print(table(Idents(Tcells_filtered), useNA = "ifany"))

# 如果确实存在这两个标签，就可以 subset
obj_de <- subset(
  Tcells_filtered,
  idents = c("Exhausted T cells", "CD8+ T cells")
)

# 再确认一下两组数量
table(Idents(obj_de))


# 后续差异分析
DefaultAssay(obj_de) <- "RNA"
de_exh_vs_cd8 <- FindMarkers(
  obj_de,
  ident.1 = "Exhausted T cells",
  ident.2 = "CD8+ T cells",
  test.use = "wilcox",
  logfc.threshold = 0.25,
  min.pct = 0.10
)
de_exh_vs_cd8$gene <- rownames(de_exh_vs_cd8)

e_exh_vs_cd8 <- de_exh_vs_cd8[order(-de_exh_vs_cd8$avg_log2FC), ]

write.csv(de_exh_vs_cd8, "DE_Exhausted_vs_CD8.csv", row.names = FALSE)

top_exhausted <- de_exh_vs_cd8 %>% filter(avg_log2FC > 0) %>% slice_head(n = 30)
top_cd8       <- de_exh_vs_cd8 %>% filter(avg_log2FC < 0) %>% slice_tail(n = 30)

top_exhausted[1:10, c("gene","avg_log2FC","p_val_adj")]
top_cd8[1:10, c("gene","avg_log2FC","p_val_adj")]



library(dplyr)
library(ggplot2)
library(ggrepel)

genes_to_label <- c(
  "GSTP1","COL17A1","IMPDH2","CYP3A5","EDN3","LAMB3","SOX4","SNAI2",
  "MME","CCK","KRT13","SFN","ANXA2","KRT14"
)

# 单细胞火山图常用阈值
logFCfilter <- 0.25   # avg_log2FC阈值（常用）
adjPfilter  <- 1   # FDR阈值（常用）

rt <- de_exh_vs_cd8
if (!"gene" %in% colnames(rt)) rt$gene <- rownames(rt)

rt <- rt %>%
  mutate(
    id = gene,
    logFC = avg_log2FC,
    adj.P.Val = p_val_adj,
    negLog10AdjP = -log10(adj.P.Val + 1e-300),
    Sig = ifelse(
      (adj.P.Val < adjPfilter) & (abs(logFC) > logFCfilter),
      ifelse(logFC > logFCfilter, "Up", "Down"),
      "Not"
    )
  )

showData <- rt %>% filter(id %in% genes_to_label)

missing_genes <- setdiff(genes_to_label, showData$id)
if (length(missing_genes) > 0) {
  message("以下基因不在差异结果中（可能未检测到或被过滤）：",
          paste(missing_genes, collapse = ", "))
}

p <- ggplot(rt, aes(x = logFC, y = negLog10AdjP)) +
  geom_point(aes(color = Sig), size = 1) +
  scale_color_manual(values = c("Down" = "#5E3C99", "Not" = "#d8d8d8", "Up" = "#E66101")) +
  labs(
    title = "Exhausted vs CD8 (volcano)",
    x = "avg_log2FC (Exhausted - CD8)",
    y = "-log10(adj p-value)"
  ) +
  theme_bw() +
  theme(plot.title = element_text(size = 16, hjust = 0.5, face = "bold"))

p1 <- p +
  geom_point(data = showData, size = 1.8) +
  geom_label_repel(
    data = showData,
    aes(label = id),
    box.padding = 0.25,
    point.padding = 0.20,
    min.segment.length = 0.10,
    size = 3,
    max.overlaps = Inf
  )

ggsave("volcano_Exhausted_vs_CD8_scThreshold_label14genes.pdf", p1, width = 6, height = 5)
p1


###重新尝试
DefaultAssay(obj_de) <- "RNA"
Idents(obj_de) <- "cell_type"

de_all <- FindMarkers(
  obj_de,
  ident.1 = "Exhausted T cells",
  ident.2 = "CD8+ T cells",
  test.use = "wilcox",
  logfc.threshold = 0,
  min.pct = 0,
  return.thresh = 1
)
de_all$gene <- rownames(de_all)

library(dplyr)
library(ggplot2)
library(ggrepel)

genes_to_label <- c(
  "GSTP1","COL17A1","IMPDH2","CYP3A5","EDN3","LAMB3","SOX4","SNAI2",
  "MME","CCK","KRT13","SFN","ANXA2","KRT14"
)

logFCfilter <- 0.25
adjPfilter  <- 0.05

rt <- de_all %>%
  mutate(
    id = gene,
    logFC = avg_log2FC,
    adj.P.Val = pmax(p_val_adj, 1e-300),  # 防止0导致无穷大
    negLog10AdjP = -log10(adj.P.Val),
    Sig = ifelse(
      (adj.P.Val < adjPfilter) & (abs(logFC) > logFCfilter),
      ifelse(logFC > 0, "Up", "Down"),
      "Not"
    ),
    id_upper = toupper(id)
  )

# 大小写不敏感匹配，避免 Col17a1 vs COL17A1 这种问题
showData <- rt %>% filter(id_upper %in% toupper(genes_to_label))

missing_genes <- setdiff(toupper(genes_to_label), unique(showData$id_upper))
if (length(missing_genes) > 0) {
  message("仍未出现在DE表里的基因：", paste(missing_genes, collapse = ", "))
}

p <- ggplot(rt, aes(x = logFC, y = negLog10AdjP)) +
  geom_point(aes(color = Sig), size = 1) +
  geom_vline(xintercept = c(-logFCfilter, logFCfilter), linetype = "dashed") +
  geom_hline(yintercept = -log10(adjPfilter), linetype = "dashed") +
  scale_color_manual(values = c("Down" = "#5E3C99", "Not" = "#d8d8d8", "Up" = "#E66101")) +
  labs(
    title = "Exhausted vs CD8 (volcano)",
    x = "avg_log2FC (Exhausted - CD8)",
    y = "-log10(adj p-value)"
  ) +
  theme_bw() +
  theme(plot.title = element_text(size = 16, hjust = 0.5, face = "bold")) +
  coord_cartesian(ylim = c(0, 50))  # 可选：把y轴截断，图更好读

p1 <- p +
  geom_point(data = showData, size = 1.8) +
  geom_label_repel(
    data = showData,
    aes(label = id),
    box.padding = 0.25,
    point.padding = 0.20,
    min.segment.length = 0.10,
    size = 3,
    max.overlaps = Inf
  )

ggsave("volcano_Exhausted_vs_CD8_scThreshold_label14genes.pdf", p1, width = 6, height = 5)
p1


##到此处暂停以上部分

#以下部分为拟时序寻找起点
rm(list=ls())


remotes::install_github("digitalcytometry/cytotrace2", upgrade = "never")

library(Seurat)
library(tidyverse)
library(CytoTRACE2)
library(paletteer)
library(BiocParallel)

# 并行（Linux/macOS推荐 MulticoreParam；Windows 用 SnowParam）
# register(MulticoreParam(workers = 8, progressbar = TRUE))
register(SnowParam(workers = 8, progressbar = TRUE))

# 1) 读入你的 Seurat 对象
load("Tcells_anno.Rdata")   # 注意：load 会把对象加载到环境中

# 2) 自动找到环境里的 Seurat 对象（避免你忘记对象叫啥）
seurat_objs <- ls()[sapply(ls(), function(x) inherits(get(x), "Seurat"))]
stopifnot(length(seurat_objs) >= 1)
sub_data <- get(seurat_objs[1])  # 默认取第一个 Seurat 对象
cat("Loaded Seurat object:", seurat_objs[1], "\n")

# 3) 检查元数据里有没有 cell_type
stopifnot("cell_type" %in% colnames(sub_data@meta.data))

# 建议把 Idents 设置成 cell_type 便于检查/画图
Idents(sub_data) <- "cell_type"
print(table(Idents(sub_data), useNA = "ifany"))

















######################### 09Dotplot ##########################
markers_for_dotplot <- c(
  # Naive T cells
  "CCR7", "SELL", "IL7R", "TCF7", "LEF1", "LTB", "FOXO1", "GZMK",
  
  # Activated T cells
  "CD40LG", "ANXA1", "IL2RA", "CD69",
  
  # Memory T cells
  "NR4A1", "MYADM", "GATA3", "TBX21",
  
  # Effector T cells
  "BATF3", "IFNG", "IRF4", "MYC", "SLC7A5", "SLC7A1", "XCL1",
  "GZMB", "CCL3", "CCL4", "IL2", "PRF1", "NKG7", "GNLY",
  
  # Tolerant T cells
  "EGR2", "IKZF2", "IZUMO1R", "CD200", "DGKZ", "BTLA", "TOX", "CTLA4",
  
  # Exhausted T cells
  "PDCD1", "LAG3", "HAVCR2", "CD244", "CD160", "IL10RA", "EOMES", "NR4A2",
  "PTGER4", "TOX2", "TIGIT", "ENTPD1",
  
  # Proliferating T cells
  "MKI67", "TK1", "STMN1",
  
  # Cytotoxic T cells
  "GZMA",
  
  # Regulatory T cells
  "FOXP3", "TNFRSF18", "IL10", "CCR8",
  
  # Early Memory T cells
  "CCR2", "CX3CR1", "IL18RAP", "ZEB2",
  
  #new
  "CD3D", "LYZ", "CD3E", 
  "NKG7","NCAM1","TRDC","KLRG1","GNLY", # NK cells
  "CD4","CD8A","CD8B",
  "CD14","FCGR3A","CD68","CD163","FCN1"
)

all_markers <- unlist(markers_for_dotplot, use.names = FALSE)
all_markers <- unique(all_markers)



#1月11号新增如下：
markers_for_dotplot <- c(
  # Pan-T / T lineage (建议补上，便于确认T细胞主群)
  "TRAC", "TRBC1", "TRBC2", "CD3D", "CD3E",
  
  # CD4 / CD8 lineage
  "CD4", "CD8A", "CD8B",
  
  # Naive T cells (CD4/CD8 naive 常用)
  "CCR7", "SELL", "IL7R", "TCF7", "LEF1", "LTB", "FOXO1",
  
  # Memory T cells (resting / general memory 常用)
  "IL32", "S100A4", "GZMK", "NR4A1", "MYADM", "GATA3", "TBX21",
  
  # Activated T cells (activation / costimulation / immediate early)
  "CD69", "CD40LG", "ICOS", "TNFRSF4", "IRF4", "MYC", "IL2",
  
  # Tfh (T cells follicular helper)
  "CXCR5", "PDCD1", "BCL6", "SH2D1A", "IL21",
  
  # Effector / Cytotoxic T cells (CD8/CTL 常用)
  "IFNG", "XCL1", "PRF1", "NKG7", "GNLY",
  "GZMB", "GZMA", "CTSW", "FGFBP2",
  "CCL3", "CCL4", "CCL5",
  
  # Tolerant / anergy-like (可用于区分低反应/耐受样状态)
  "EGR2", "IKZF2", "IZUMO1R", "CD200", "DGKZ", "BTLA", "TOX", "CTLA4",
  
  # Exhausted T cells (exhaustion program 常用)
  "PDCD1", "LAG3", "HAVCR2", "CD244", "CD160", "IL10RA", "EOMES", "NR4A2",
  "PTGER4", "TOX2", "TIGIT", "ENTPD1", "CXCL13",
  
  # Proliferating T cells
  "MKI67", "TK1", "STMN1", "TOP2A",
  
  # Regulatory T cells (Tregs)
  "FOXP3", "IL2RA", "TNFRSF18", "CCR8", "IL10",
  
  # Gamma-delta T cells
  "TRDC", "TRGC1", "TRGC2",
  
  # Early Memory / TEMRA-like (你原有分组保留；CX3CR1/KLRG1更偏终末效应表型)
  "CCR2", "CX3CR1", "IL18RAP", "ZEB2", "KLRG1",
  
  # Myeloid / NK markers (用于排查混杂/双细胞；你原有分组保留并略补充)
  "LYZ",
  "NCAM1", "KLRD1",
  "CD14", "FCGR3A", "CD68", "CD163", "FCN1"
)

all_markers <- unlist(markers_for_dotplot, use.names = FALSE)
all_markers <- unique(all_markers)



#1月11号新增如上↑



# 创建dotplot
# 假设您的Seurat对象名为 'scRNA_harmony'，cluster信息存储在 'seurat_clusters' 中

# 方法1: 基础dotplot
p1 <- DotPlot(Tcells_filtered, 
              features = all_markers,
              group.by = "seurat_clusters") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
  scale_colour_gradient2(low = "blue", mid = "white", high = "red") +
  labs(title = "Marker genes expression across clusters",
       subtitle = "Sjögren's syndrome scRNA_harmony scRNA-seq") +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5))
p1
p2 <- DotPlot(Tcells_filtered, 
              features = all_markers,
              group.by = "seurat_clusters",
              dot.scale = 8) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 10),
        axis.text.y = element_text(size = 12),
        legend.title = element_text(size = 10),
        legend.text = element_text(size = 9)) +
  scale_colour_gradient2(low = "#2166AC", mid = "white", high = "#B2182B", 
                         midpoint = 0, name = "Average\nExpression") +
  labs(title = "  ",
       x = "Marker genes", y = "Clusters") +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        panel.background = element_rect(fill = "white"),
        plot.background = element_rect(fill = "white")) +
  guides(size = guide_legend(title = "Percent\nExpressed", 
                             title.theme = element_text(size = 10),
                             label.theme = element_text(size = 9)))
p2













cluster_annotations <- c(
  "0"  = "Activated TCM (early)",
  "1"  = "Immediate-early activated T (FOS/JUN)",
  "2"  = "CCR6+ memory T (Th17-like)",
  "3"  = "Resting TCM/naive-like",
  "4"  = "Cytotoxic TEMRA (NK-like)",
  "5"  = "Treg (FOXP3+)",
  "6"  = "Naive/TCM (CCR7+ IL7R+)",
  "7"  = "Activated TCM",
  "8"  = "Activated effector memory",
  "9"  = "CD8 effector memory",
  "10" = "Activated cytotoxic CD8",
  "11" = "Gamma delta T cells T cells",
  "12" = "Unassigned (QC/doublets)",
  "13" = "Innate-like cytotoxic (Gamma delta T cells/NKT-like)",
  "14" = "CD16+ NK-like cytotoxic (HAVCR2+)",
  "15" = "TRM-like cytotoxic T"
)

Tcells_filtered <- AddMetaData(
  Tcells_filtered,
  metadata = cluster_annotations[as.character(Tcells_filtered$seurat_clusters)],
  col.name = "cell_type"
)
save(Tcells_filtered, file = "Tcells_anno.Rdata")

Tcells_filtered <- AddMetaData(Tcells_filtered, 
                               metadata = cluster_annotations[as.character(Tcells_filtered$seurat_clusters)], 
                               col.name = "cell_type")
save(Tcells_filtered,file='Tcells_anno.Rdata')


# Define color palette
newcolour <- c("#FF5E33","#FFBE7A","#82B0D2","#2878b5","#f8ac8c","#BEB8DC",
               "#6A5ACD","#D2B48C","#FF336E","#40E0D0","#D2691E","#8ECFC9",
               "#DEB887","#c82423","#ff8884","#A1A9D0","#9ac9db","#E7DAD2",
               "#F0988C","#B883D4","#9E9E9E","#CFEAF1","#C4A5DE","#98FB98",
               "#228B22", "#FFD700")
library(ggplot2)
library(tidydr)
# Create UMAP plot
t1 <- DimPlot(Tcells_filtered, reduction = 'umap', 
              cols = newcolour,
              repel = T,
              label.size = 3.5,
              label = TRUE,
              pt.size = 0.01, 
              raster = F,group.by = "cell_type") +
  theme_dr(xlength = 0.2, ylength = 0.3, arrow = arrow(length = unit(0.2, "inches"), type = "closed")) +
  theme(panel.grid = element_blank(), axis.title = element_text(hjust = 0.03)) +
  NoLegend() + ggtitle("  ") + 
  theme(text = element_text(size = 12, family = "serif"))
t1
Idents(Tcells_filtered) <- Tcells_filtered$cell_type

# 如果已经 library(monocle) 过
detach("package:monocle", unload = TRUE, character.only = TRUE)

# 如有需要，也可把相关依赖一起卸载（非必需，遇到冲突再说）
# detach("package:Biobase", unload=TRUE)
# detach("package:VGAM", unload=TRUE)


#cytoTRACE2
rm(list=ls())

library(Seurat)
library(tidyverse)
library(CytoTRACE2)
library(paletteer)
library(BiocParallel)

# 并行（Linux/macOS推荐 MulticoreParam；Windows 用 SnowParam）
# register(MulticoreParam(workers = 8, progressbar = TRUE))
register(SnowParam(workers = 8, progressbar = TRUE))

# 1) 读入你的 Seurat 对象
load("Tcells_anno.Rdata")   # 注意：load 会把对象加载到环境中
ls()                       # 你应该能看到 Tcells_filtered

sub_data <- Tcells_filtered

stopifnot("cell_type" %in% colnames(sub_data@meta.data))
table(sub_data$cell_type, useNA = "ifany")
Idents(sub_data) <- "cell_type"


# 2) 检查
stopifnot(inherits(sub_data, "Seurat"))
stopifnot("cell_type" %in% colnames(sub_data@meta.data))
Idents(sub_data) <- "cell_type"
print(table(Idents(sub_data), useNA = "ifany"))

# 3) 跑 CytoTRACE2（human + counts）
DefaultAssay(sub_data) <- "RNA"
cytotrace2_res <- cytotrace2(
  sub_data,
  is_seurat = TRUE,
  slot_type = "counts",
  species = "human"
)

# 4) 可视化
#annotation <- data.frame(phenotype = sub_data@meta.data$cell_type) %>%
#  tibble::rownames_to_column("cell") %>%
#  tibble::column_to_rownames("cell")


annotation <- sub_data@meta.data[, "cell_type", drop = FALSE]
colnames(annotation) <- "phenotype"

# 检查是否完全对齐（必须 TRUE）
stopifnot(identical(rownames(annotation), colnames(sub_data)))

plots <- plotData(
  cytotrace2_result = cytotrace2_res,
  annotation = annotation,
  is_seurat = TRUE
)

dir.create("./13-monocle", showWarnings = FALSE)
ggsave("./13-monocle/CytoTRACE2_UMAP.pdf", plots$CytoTRACE2_UMAP, width = 9, height = 7, dpi = 300)
ggsave("./13-monocle/CytoTRACE2_Potency_UMAP.pdf", plots$CytoTRACE2_Potency_UMAP, width = 9, height = 7, dpi = 300)
ggsave("./13-monocle/CytoTRACE2_Relative_UMAP.pdf", plots$CytoTRACE2_Relative_UMAP, width = 9, height = 7, dpi = 300)
ggsave("./13-monocle/Phenotype_UMAP.pdf", plots$Phenotype_UMAP, width = 9, height = 7, dpi = 300)
ggsave("./13-monocle/CytoTRACE2_Boxplot_byPheno.pdf", plots$CytoTRACE2_Boxplot_byPheno, width = 9, height = 7, dpi = 300)

##再次取子集CD8 记忆 耗竭T

rm(list=ls())
gc()

library(Seurat)
library(tidyverse)
library(CytoTRACE2)
library(BiocParallel)

register(SnowParam(workers = 8, progressbar = TRUE))  # 服务器/Windows都能用
# 如果是 Linux 且支持 fork，可用：
# register(MulticoreParam(workers = 8, progressbar = TRUE))

# 1) 读取对象
load("Tcells_anno.Rdata")
sub_data <- Tcells_filtered

DefaultAssay(sub_data) <- "RNA"
stopifnot("cell_type" %in% colnames(sub_data@meta.data))

# 2) 取子集：CD8 + Memory + Exhausted
types_keep <- c("CD8+ T cells", "Memory T cells", "Exhausted T cells")
obj_ct2 <- subset(sub_data, subset = cell_type %in% types_keep)

# 检查
table(obj_ct2$cell_type, useNA = "ifany")

# 3) 跑 CytoTRACE2（counts + human）
ct2_res <- cytotrace2(
  obj_ct2,
  is_seurat = TRUE,
  slot_type = "counts",
  species = "human"
)

# 4) 构建 annotation（行名必须=细胞名）
annotation <- obj_ct2@meta.data[, "cell_type", drop = FALSE]
colnames(annotation) <- "phenotype"
stopifnot(identical(rownames(annotation), colnames(obj_ct2)))

plots <- plotData(
  cytotrace2_result = ct2_res,
  annotation = annotation,
  is_seurat = TRUE
)

# 5) 输出图
dir.create("./13-monocle/CytoTRACE2_CD8_Memory_Exhausted", recursive = TRUE, showWarnings = FALSE)

ggsave("./13-monocle/CytoTRACE2_CD8_Memory_Exhausted/CytoTRACE2_UMAP.pdf",
       plots$CytoTRACE2_UMAP, width = 9, height = 7, dpi = 300)
ggsave("./13-monocle/CytoTRACE2_CD8_Memory_Exhausted/CytoTRACE2_Potency_UMAP.pdf",
       plots$CytoTRACE2_Potency_UMAP, width = 9, height = 7, dpi = 300)
ggsave("./13-monocle/CytoTRACE2_CD8_Memory_Exhausted/CytoTRACE2_Relative_UMAP.pdf",
       plots$CytoTRACE2_Relative_UMAP, width = 9, height = 7, dpi = 300)
ggsave("./13-monocle/CytoTRACE2_CD8_Memory_Exhausted/Phenotype_UMAP.pdf",
       plots$Phenotype_UMAP, width = 9, height = 7, dpi = 300)
ggsave("./13-monocle/CytoTRACE2_CD8_Memory_Exhausted/CytoTRACE2_Boxplot_byPheno.pdf",
       plots$CytoTRACE2_Boxplot_byPheno, width = 9, height = 7, dpi = 300)



# obj_ct2: 已经 subset 出来的对象（CD8/Memory/Exhausted）
DefaultAssay(obj_ct2) <- "RNA"
stopifnot("cell_type" %in% colnames(obj_ct2@meta.data))

# 只在 Memory + CD8 里选起点候选（排除 Exhausted）
cand_cells <- colnames(obj_ct2)[obj_ct2$cell_type %in% c("Memory T cells", "CD8+ T cells")]

# naive-like 与 effector-like 基因集
naive_genes <- list(c("TCF7","IL7R","CCR7","LTB"))
eff_genes   <- list(c("NKG7","PRF1","GZMB","GNLY"))

obj_ct2 <- AddModuleScore(obj_ct2, features = naive_genes, name = "naive")
obj_ct2 <- AddModuleScore(obj_ct2, features = eff_genes,   name = "eff")

# 评分：naive 高、eff 低 越像起点
score <- obj_ct2$naive1[cand_cells] - obj_ct2$eff1[cand_cells]

# 取 top 2%（至少 100 个）作为 root_cells
k <- max(100, ceiling(length(cand_cells) * 0.02))
root_cells <- cand_cells[order(score, decreasing = TRUE)][1:k]

# 可视化检查：root 是否集中在“早期端”
obj_ct2$root_flag <- ifelse(colnames(obj_ct2) %in% root_cells, "root", "other")
DimPlot(obj_ct2, group.by = "root_flag", pt.size = 0.2) + NoLegend()

# 保存给 monocle3 用
writeLines(root_cells, "./13-monocle/monocle3_root_cells_CD8Memory.txt")


# =========================
# 6) monocle3：构建 cds + 学习轨迹 + 用 root_cells 定方向
# =========================
library(monocle3)
library(Matrix)

# 6.1 把 Seurat 转成 monocle3 的 cell_data_set（手动，不需要 SeuratWrappers）
DefaultAssay(obj_ct2) <- "RNA"
expr <- GetAssayData(obj_ct2, assay = "RNA", slot = "counts")  # genes x cells

cell_meta <- obj_ct2@meta.data
gene_meta <- data.frame(gene_short_name = rownames(expr), row.names = rownames(expr))

cds <- new_cell_data_set(
  expression_data = expr,
  cell_metadata   = cell_meta,
  gene_metadata   = gene_meta
)

# 6.2 monocle3 标准流程（monocle3 自己的 UMAP 空间里学 graph）
set.seed(123)
cds <- preprocess_cds(cds, num_dim = 50)
cds <- reduce_dimension(cds, reduction_method = "UMAP")
cds <- cluster_cells(cds)
cds <- learn_graph(cds)

# 6.3 用 root_cells 排序（定义起点）
cds <- order_cells(cds, root_cells = root_cells)



library(monocle3)
library(paletteer)
library(Seurat)
library(monocle3)
library(dplyr)
library(BiocParallel)
library(ggplot2)
register(MulticoreParam(workers = 4, progressbar = TRUE))
#setwd("~/jwqdxb/Harmony")
# 载入你保存的对象文件
load("Tcells_anno.Rdata")

# 检查：pSS_hamony_annotated.Rdata 是否已加载
ls()                 # 你会看到 pSS_hamony_annotated.Rdata
class(Tcells_filtered)    # 应该是 "Seurat"


DimPlot(Tcells_filtered, pt.size = 0.8, group.by = "ident", label = TRUE,raster = FALSE)

newcolour <- c("#FF5E33","#FFBE7A","#82B0D2","#2878b5","#f8ac8c","#BEB8DC",
               "#6A5ACD","#D2B48C","#FF336E","#40E0D0","#D2691E","#8ECFC9",
               "#DEB887","#c82423","#ff8884","#A1A9D0","#9ac9db","#E7DAD2",
               "#F0988C","#B883D4","#9E9E9E","#CFEAF1","#C4A5DE","#98FB98",
               "#228B22", "#FFD700")
library(ggplot2)
library(tidydr)
# Create UMAP plot
t1 <- DimPlot(Tcells_filtered, reduction = 'umap', 
              cols = newcolour,
              repel = T,
              label.size = 3.5,
              label = TRUE,
              pt.size = 0.01, 
              raster = F,group.by = "cell_type") +
  theme_dr(xlength = 0.2, ylength = 0.3, arrow = arrow(length = unit(0.2, "inches"), type = "closed")) +
  theme(panel.grid = element_blank(), axis.title = element_text(hjust = 0.03)) +
  NoLegend() + ggtitle("  ") + 
  theme(text = element_text(size = 12, family = "serif"))
t1


Idents(Tcells_filtered) <- "cell_type"
levels(Idents(Tcells_filtered)) #打出来细胞类型供复制
# [1] "CD4+ T-cells"      "Fibroblasts"       "B-cells"          
# [4] "CD8+ T-cells"      "Neutrophils"       "Monocytes"        
# [7] "Adipocytes"        "NK cells"          "Endothelial cells"

# 重设等级也可以不设
# scRNA$celltype <- factor(scRNA$celltype,
#                          levels = c("Endothelial cells"))

#Idents(pSS_hamony) <- pSS_hamony$celltype

expression_matrix <- GetAssayData(Tcells_filtered, assay = 'RNA',layer  = 'counts')
cell_metadata <- Tcells_filtered@meta.data 
gene_annotation <- data.frame(gene_short_name = rownames(expression_matrix))
rownames(gene_annotation) <- rownames(expression_matrix)
cds <- new_cell_data_set(expression_matrix,
                         cell_metadata = cell_metadata,
                         gene_metadata = gene_annotation)


#install.packages("remotes")
#remotes::install_version("Matrix", version = "1.6-5",
#                         repos = "https://cloud.r-project.org",
#                         upgrade = "never")
#remotes::install_version("Matrix", version = "1.6-1.1")
#install.packages("irlba", type = "source")
#install.packages("RSpectra", type = "source")



library(monocle3)

#cds <- monocle3::preprocess_cds(cds, num_dim = 50)  # 建议先 50，更稳更快
#monocle3::plot_pc_variance_explained(cds)

#cds <- monocle3::reduce_dimension(cds, reduction_method = "UMAP", preprocess_method = "PCA")
#cds <- monocle3::cluster_cells(cds, reduction_method = "UMAP")
#cds <- monocle3::learn_graph(cds, use_partition = TRUE)


# 归一化/预处理数据
# cds <- preprocess_cds(cds, num_dim = 100)
# 这个函数用于确认设定的dim数是否足够代表主要变异
# plot_pc_variance_explained(cds)

# 降维聚类，可选择UMAP、PCA或者TSNE
# cds <- reduce_dimension(cds,reduction_method='UMAP',
#                        preprocess_method = 'PCA')
# cds <- cluster_cells(cds) #cluster your cells

# 轨迹推断
# cds <- learn_graph(cds,verbose=T,
#                   use_partition=T, #默认是T，T时是顾及全局的情况
#                   # )

plot_cells(cds, 
           color_cells_by = 'cell_type',
           label_groups_by_cluster=FALSE,
           cell_size=1,group_label_size=4,
           trajectory_graph_color='#023858',
           trajectory_graph_segment_size = 1)
# 定义root cell, 推断拟时方向

# 例如把 DC 当作起点（先验）
#root_cells <- colnames(cds)[cds@colData$cell_type == "Naive/TCM (CCR7+ IL7R+)"]
#cds <- order_cells(cds, root_cells = root_cells)
# 结合先验知识自定(示例数据)
#cds <- order_cells(cds) 
cds <- order_cells(cds, root_cells = root_cells)

# 可视化
plot_cells(cds, label_cell_groups = F, 
           color_cells_by = "pseudotime", 
           label_branch_points = F, 
           graph_label_size = 0, 
           cell_size=2, 
           trajectory_graph_color='black',
           trajectory_graph_segment_size = 2)


# 6.4 输出 monocle3 UMAP 图（两张：按 cell_type / 按 pseudotime）
dir.create("./13-monocle/monocle3_CD8_Memory_Exhausted", recursive = TRUE, showWarnings = FALSE)

p_celltype <- plot_cells(cds, color_cells_by = "cell_type",
                         label_groups_by_cluster = FALSE, label_leaves = FALSE, label_branch_points = FALSE)
p_pt <- plot_cells(cds, color_cells_by = "pseudotime",
                   label_groups_by_cluster = FALSE, label_leaves = FALSE, label_branch_points = FALSE)

ggsave("./13-monocle/monocle3_CD8_Memory_Exhausted/monocle3_UMAP_byCellType.pdf",
       p_celltype, width = 7, height = 6)
ggsave("./13-monocle/monocle3_CD8_Memory_Exhausted/monocle3_UMAP_byPseudotime.pdf",
       p_pt, width = 7, height = 6)

# 6.5 验证拟时序方向是否合理（强烈建议）
pdf("./13-monocle/monocle3_CD8_Memory_Exhausted/markers_in_pseudotime.pdf", width = 8, height = 10)
print(plot_genes_in_pseudotime(cds[c("TCF7","IL7R","CCR7","LTB"), ]))            # 早期/naive-like
print(plot_genes_in_pseudotime(cds[c("NKG7","PRF1","GZMB","GNLY"), ]))            # 效应/细胞毒
print(plot_genes_in_pseudotime(cds[c("PDCD1","TOX","LAG3","HAVCR2"), ]))          # 耗竭末端
print(plot_genes_in_pseudotime(cds[c("ANXA2","GSTP1"), ]))                        # Hub_genes
dev.off()

# 6.6 把 monocle3 的 pseudotime 写回 Seurat（用你原来的 Seurat UMAP 展示）
pt <- pseudotime(cds)
obj_ct2$pseudotime_m3 <- pt[colnames(obj_ct2)]


pt <- monocle3::pseudotime(cds)

# 把 Inf/NaN 置为 NA
pt[!is.finite(pt)] <- NA_real_

# 写回 Seurat
obj_ct2$pseudotime_m3 <- pt[colnames(obj_ct2)]

# 只用有 pseudotime 的细胞画图
cells_use <- colnames(obj_ct2)[is.finite(obj_ct2$pseudotime_m3)]
obj_plot <- subset(obj_ct2, cells = cells_use)

p_seurat_pt <- FeaturePlot(obj_plot, features = "pseudotime_m3", reduction = "umap", pt.size = 0.2)
ggsave("./13-monocle/monocle3_CD8_Memory_Exhausted/SeuratUMAP_pseudotime_fromMonocle3.pdf",
       p_seurat_pt, width = 7, height = 6)


BiocParallel::register(BiocParallel::SerialParam())

saveRDS(obj_ct2, "./13-monocle/monocle3_CD8_Memory_Exhausted/obj_ct2_with_pseudotime.rds")
saveRDS(cds,     "./13-monocle/monocle3_CD8_Memory_Exhausted/cds_monocle3.rds")

# 6.7 保存对象（方便后续继续分析）
saveRDS(obj_ct2, "./13-monocle/monocle3_CD8_Memory_Exhausted/obj_ct2_with_pseudotime.rds")

# 1) 先把 pseudotime 写进 colData（确保一起保存）
pt <- monocle3::pseudotime(cds)
pt[!is.finite(pt)] <- NA_real_
colData(cds)$pseudotime <- pt[colnames(cds)]

# 2) 轻量化打包
m3_out <- list(
  colData = as.data.frame(colData(cds)),
  rowData = as.data.frame(rowData(cds)),
  umap = reducedDims(cds)$UMAP,
  clusters = monocle3::clusters(cds),
  partitions = monocle3::partitions(cds),
  principal_graph_umap = monocle3::principal_graph(cds)$UMAP
)

# 3) 保存轻量对象（一般不会栈溢出）
saveRDS(
  m3_out,
  "./13-monocle/monocle3_CD8_Memory_Exhausted/monocle3_outputs_light.rds",
  compress = FALSE
)

##提取关键基因在不同轨迹上的差异


library(monocle3)
library(dplyr)

# 你感兴趣的基因
genes_interest <- c(
  "GSTP1","COL17A1","IMPDH2","CYP3A5","EDN3","LAMB3",
  "SOX4","SNAI2","MME","CCK","KRT13","SFN","ANXA2","KRT14"
)


# 1) 把基因名统一成 cds 里的 gene_short_name 口径（避免大小写/别名问题）
gene_map <- rowData(cds) %>%
  as.data.frame() %>%
  dplyr::mutate(gene_upper = toupper(gene_short_name))

genes_use <- gene_map %>%
  dplyr::filter(gene_upper %in% toupper(genes_interest)) %>%
  dplyr::pull(gene_short_name) %>%
  unique()

missing <- setdiff(toupper(genes_interest), toupper(genes_use))
if (length(missing) > 0) {
  message("这些基因在 cds 的 gene_short_name 里没找到（可能未检测到/命名不同）： ",
          paste(missing, collapse = ", "))
}

# 2) 在拟时序上画表达趋势（最常用）
p_pt <- plot_genes_in_pseudotime(
  cds[ rowData(cds)$gene_short_name %in% genes_use, ],
  color_cells_by = "cell_type",     # 也可以换成 "pseudotime" 或你的分组列
  min_expr = 0.1                    # 可调：过滤掉非常低的表达噪音
)
p_pt

# 保存
ggsave("./13-monocle/monocle3_CD8_Memory_Exhausted/genes_interest_in_pseudotime.pdf",
       p_pt, width = 7, height = max(4, 1.2 * length(genes_use)))

# 3) 可选：在 monocle3 的 UMAP 上看这些基因的空间表达（每次多基因会出一组图）
p_umap <- plot_cells(
  cds,
  genes = genes_use,
  show_trajectory_graph = TRUE,
  label_cell_groups = FALSE,
  label_leaves = FALSE,
  label_branch_points = FALSE,
  cell_size = 0.6
)
p_umap

ggsave("./13-monocle/monocle3_CD8_Memory_Exhausted/genes_interest_on_monocle3_umap.pdf",
       p_umap, width = 10, height = 8)


# 细胞映射
plot_cells(cds, genes= genes_use,
           cell_size=1, 
           show_trajectory_graph=FALSE,
           label_cell_groups=FALSE,
           label_leaves=FALSE)



# 提取不同轨迹的差异基因/并选择前12个
# neighbor_graph="principal_graph"提取轨迹上相似位置是否有相关的表达
trace_genes <- graph_test(cds, 
                          neighbor_graph = "principal_graph", 
                          cores = 4)

track_genes_sig <- trace_genes %>%
  top_n(n=12, morans_I) %>%
  pull(gene_short_name) %>%
  as.character()

# 差异基因绘制
levels(Idents(Tcells_filtered)) #打出来细胞类型供复制
# [1] "CD4+ T-cells"      "Fibroblasts"       "B-cells"          
# [4] "CD8+ T-cells"      "Neutrophils"       "Monocytes"        
# [7] "Adipocytes"        "NK cells"          "Endothelial cells"


pt <- monocle3::pseudotime(cds)
table(colData(cds)$cell_type[!is.na(pt)])



#根据拟时序的结果选择关注的细胞谱系
lineage_cds <- cds[rowData(cds)$gene_short_name %in% track_genes_sig,
                   colData(cds)$cell_type %in% c(
                                                "Activated cytotoxic CD8",
                                                "Activated effector memory",
                                                "Activated TCM",
                                                "Activated TCM (early)",
                                                "CCR6+ memory T (Th17-like)",
                                                "CD16+ NK-like cytotoxic (HAVCR2+)",
                                                "CD8 effector memory",
                                                "Cytotoxic TEMRA (NK-like)",
                                                "Gamma delta T cells T cells",
                                                "Immediate-early activated T (FOS/JUN)",
                                                "Innate-like cytotoxic (Gamma delta T cells/NKT-like)",
                                                "Naive/TCM (CCR7+ IL7R+)",
                                                "Resting TCM/naive-like",
                                                "Treg (FOXP3+)",
                                                "TRM-like cytotoxic T",
                                                "Unassigned (QC/doublets)"
                                                )]
#lineage_cds <- order_cells(lineage_cds)
plot_genes_in_pseudotime(lineage_cds,
                         color_cells_by="cell_type",
                         min_expr=0.5)

# 细胞映射
plot_cells(cds, genes= track_genes_sig,
           cell_size=1, 
           show_trajectory_graph=FALSE,
           label_cell_groups=FALSE,
           label_leaves=FALSE)


下边不要

####修复R包部分###12-22滕飞  以下
## 0) 固定库路径（确保你想用的库优先）
LIB1 <- "/home/data/biolab001/Rlib_r45"
LIB2 <- "/home/data/biolab001/Rlib"
LIB3 <- "/usr/local/lib/R/library"

.libPaths(c(LIB1, LIB2, LIB3))
.libPaths()

## 如果不小心加载过 irlba，先卸载（新会话一般不用）
if ("package:irlba" %in% search()) {
  detach("package:irlba", unload = TRUE, character.only = TRUE)
}

## 尽量用 remove.packages 卸载（可能失败也没关系）
for (lib in c(LIB1, LIB2)) {
  try(remove.packages("irlba", lib = lib), silent = TRUE)
  dir_to_wipe <- file.path(lib, "irlba")
  if (dir.exists(dir_to_wipe)) {
    unlink(dir_to_wipe, recursive = TRUE, force = TRUE)
  }
}

## 确认系统里是否还能找到 irlba（理想情况下这行应报错）
try(find.package("irlba"), silent = TRUE)

install.packages("irlba",
                 lib  = LIB1,
                 repos = "https://cloud.r-project.org",
                 type = "source")

stopifnot(find.package("irlba") == file.path(LIB1, "irlba"))

library(irlba)

set.seed(1)
test <- irlba::irlba(matrix(rnorm(200), 20, 10), nv = 3)
str(test)

library(monocle3)
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(version = "3.21")
BiocManager::install("monocle3")

dir.create("~/R/library", recursive = TRUE, showWarnings = FALSE)
.libPaths(c("~/R/library", .libPaths()))
.libPaths()
install.packages("BiocManager", lib="~/R/library")
BiocManager::install("monocle3", lib="~/R/library")
library(monocle3)

# 4) 加载
library(monocle3)
packageVersion("monocle3")

dir.create("~/R/library", recursive = TRUE, showWarnings = FALSE)
.libPaths(c("~/R/library", .libPaths()))

options(repos = BiocManager::repositories())  # 恢复 Bioconductor 仓库

install.packages("remotes", lib="~/R/library")
remotes::install_github("cole-trapnell-lab/monocle3", lib="~/R/library")

library(monocle3)

.libPaths(c("~/R/library", .libPaths()))
library(remotes)

# 建议指定下载方式（有些服务器默认方法会失败）
options(download.file.method = "libcurl")

remotes::install_url(
  "https://codeload.github.com/cole-trapnell-lab/monocle3/tar.gz/refs/heads/master",
  lib = "~/R/library",
  dependencies = TRUE
)

library(monocle3)
packageVersion("monocle3")
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install(version = "3.20")

BiocManager::install(c(
  "BiocGenerics","DelayedArray","DelayedMatrixStats","limma","lme4",
  "S4Vectors","SingleCellExperiment","SummarizedExperiment","batchelor",
  "Matrix.utils","HDF5Array","ggrastr"
), ask = FALSE, update = TRUE)

install.packages("remotes")
remotes::install_github("cole-trapnell-lab/monocle3", dependencies = TRUE)

library(monocle3)
packageVersion("monocle3")



###聚类热图
library(monocle3)
library(SummarizedExperiment)  # 提供 rowData/colData
library(ClusterGVis)
library(org.Hs.eg.db)

# A) 把 genes_use（gene_short_name）映射到 cds 的行名（gene_id）
rd <- as.data.frame(rowData(cds))
if (!"gene_short_name" %in% colnames(rd)) stop("rowData(cds) 中没有 gene_short_name 列。")

gene_id_use <- rownames(rd)[toupper(rd$gene_short_name) %in% toupper(genes_use)]
gene_id_use <- unique(gene_id_use)

if (length(gene_id_use) == 0) {
  stop("genes_use 在 rowData(cds)$gene_short_name 中未匹配到任何基因，无法生成拟时序矩阵。")
}

# B) 提取拟时序表达矩阵（兼容：函数可能未导出）
pre_pseudotime_matrix <- getFromNamespace("pre_pseudotime_matrix", "ClusterGVis")
mat <- pre_pseudotime_matrix(cds_obj = cds, gene_list = gene_id_use)
mat <- as.data.frame(mat)



# mat: genes x cells (现在是 14 x 23342)

# 1) 取每个细胞的 pseudotime，并对齐到 mat 的列顺序
pt <- monocle3::pseudotime(cds)
pt <- pt[colnames(mat)]
pt[!is.finite(pt)] <- NA_real_

# 2) 只保留有 pseudotime 的细胞列
keep <- which(is.finite(pt))
mat2 <- mat[, keep, drop = FALSE]
pt2  <- pt[keep]


# mat: genes x cells（列通常已按拟时序顺序排列）
nbin <- 200
bins <- cut(seq_len(ncol(mat)), breaks = nbin, include.lowest = TRUE)

mat_bin <- sapply(levels(bins), function(b) {
  idx <- which(bins == b)
  if (length(idx) == 1) as.numeric(mat[, idx])
  else rowMeans(as.matrix(mat)[, idx, drop = FALSE])
})

rownames(mat_bin) <- rownames(mat)
mat <- as.data.frame(mat_bin)


# C) kmeans 聚类（8 类可改）
ck <- ClusterGVis::clusterData(
  obj = mat,
  cluster.method = "kmeans",
  cluster.num = 8
)

# D) 富集分析
# 这里的基因ID是 cds 的行名（常见是 ENSEMBL / gene_id），因此需要告诉 enrichCluster 如何转 ID
# 更稳妥：先判断像不像 ENSEMBL
fromType_guess <- "SYMBOL"
if (all(grepl("^ENS", gene_id_use))) fromType_guess <- "ENSEMBL"

enrich <- enrichCluster(
  object = ck,
  OrgDb = org.Hs.eg.db,
  type = "BP",
  pvalueCutoff = 0.05,
  topn = 5,
  seed = 123,
  id.trans = TRUE,
  fromType = fromType_guess,
  toType = "ENTREZID",
  readable = TRUE
)
install.packages("ragg")

# E) 可视化输出
outdir <- "./13-monocle/monocle3_CD8_Memory_Exhausted"
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)

set.seed(123)
mark_n <- min(30, nrow(mat))
mark_genes <- sample(rownames(mat), mark_n, replace = FALSE)

pdf(file.path(outdir, "ClusterGVis_genes_interest.pdf"), height = 10, width = 12, onefile = FALSE)

visCluster(
  object = ck,
  plot.type = "both",
  add.sampleanno = FALSE,
  markGenes.side = "left",
  markGenes = mark_genes,
  ht.col.list = list(
    col_range = c(-2,-1.5,-1,-0.5,0,0.5,1,1.5,2),
    col_color = c("#0D0887FF","#42049EFF","#6A00A8FF",
                  "#900DA4FF","white","#E16462FF",
                  "#FCA636FF","#FCCE25FF","#F0F921FF")
  ),
  genes.gp = c("italic", fontsize = 12, col = "black"),
  line.side = "left",
  annoTerm.data = enrich,
  raster_device = "agg_png",
  raster_quality = 2
)
dev.off()



dim(mat)  # 先看看列数到底多大
pt <- monocle3::pseudotime(cds)
cells_used <- colnames(cds)[is.finite(pt)]

table(colData(cds)$cell_type[cells_used])
pt <- monocle3::pseudotime(cds)

length(pt)
sum(is.finite(pt))
summary(pt)
head(pt)
reducedDims(cds) |> names()
principal_graph(cds) |> names()

##聚类热图



#Cellchat图
library(Seurat)
library(plyr)
library(CellChat)


tmp <- new.env()
obj_names <- load("Tcells_anno.Rdata", envir = tmp)
seurat_candidates <- obj_names[sapply(obj_names, function(nm) inherits(tmp[[nm]], "Seurat"))]
Tcells_filtered <- tmp[[seurat_candidates[1]]]
rm(tmp)

library(Seurat)
library(plyr)



####改完名后的是seurat_clusters对象
#stopifnot("seurat_clusters" %in% colnames(Tcells_filtered@meta.data))


data.input <- GetAssayData(Tcells_filtered, assay = "RNA", slot = "data")
identity <- Tcells_filtered@meta.data[, "cell_type", drop = FALSE]

cellchat <- createCellChat(object = data.input, meta = identity, group.by = "cell_type")

##提取表达矩阵和细胞分类信息 上

###可选CellChatDB.human, CellChatDB.mouse
CellChatDB <- CellChatDB.human
##下一步不出图的时候运行 dev.new()
showDatabaseCategory(CellChatDB)
interaction_input <- CellChatDB$interaction
complex_input <- CellChatDB$complex
cofactor_input <- CellChatDB$cofactor
geneInfo <- CellChatDB$geneInfo
write.csv(interaction_input, file = "interaction_input_CellChatDB.csv")
write.csv(complex_input, file = "complex_input_CellChatDB.csv")
write.csv(cofactor_input, file = "cofactor_input_CellChatDB.csv")
write.csv(geneInfo, file = "geneInfo_input_CellChatDB.csv")


options(stringsAsFactors = FALSE)
interaction_input <- read.csv(file = 'interaction_input_CellChatDB.csv', row.names = 1)
complex_input <- read.csv(file = 'complex_input_CellChatDB.csv', row.names = 1)
cofactor_input <- read.csv(file = 'cofactor_input_CellChatDB.csv', row.names = 1)
geneInfo <- read.csv(file = 'geneInfo_input_CellChatDB.csv', row.names = 1)
CellChatDB <- list()
CellChatDB$interaction <- interaction_input
CellChatDB$complex <- complex_input
CellChatDB$cofactor <- cofactor_input
CellChatDB$geneInfo <- geneInfo


########在CellChat中，我们还可以先择特定的信息描述细胞间的相互作用，
##可以理解为从特定的侧面来刻画细胞间相互作用，比用一个大的配体库又精细了许多。
##查看可以选择的侧面
unique(CellChatDB$interaction$annotation)
# use Secreted Signaling for cell-cell communication analysis
CellChatDB.use <- subsetDB(CellChatDB, search = "Secreted Signaling")
cellchat@DB <- CellChatDB.use # set the used database in the object

#对表达数据进行预处理

##将信号基因的表达数据进行子集化，以节省计算成本
cellchat <- subsetData(cellchat)
#future::plan("multiprocess", workers = 1)
# 识别过表达基因（不安装presto）
cellchat <- identifyOverExpressedGenes(cellchat, do.fast = FALSE)

#cellchat <- identifyOverExpressedGenes(cellchat)
# 识别配体-受体对
cellchat <- identifyOverExpressedInteractions(cellchat)
# 将配体、受体投射到PPI网络
data("PPI.human")  # 如果 PPI.human 没有自动加载
cellchat <- smoothData(cellchat, adj = PPI.human)


#cellchat <- projectData(cellchat, PPI.human)


## 1) 计算通信概率（配体-受体层面）
cellchat <- computeCommunProb(cellchat, raw.use = TRUE)

## 过滤：每群至少 min.cells 个细胞
cellchat <- filterCommunication(cellchat, min.cells = 3)

## 提取配体-受体层面的通信结果
df.net.lr <- subsetCommunication(cellchat, slot.name = "net")
write.csv(df.net.lr, "df.net_LR.csv", row.names = FALSE)

## 2) 通路层面推断 + 汇总网络
cellchat <- computeCommunProbPathway(cellchat)
cellchat <- aggregateNet(cellchat)

## 提取通路层面的通信结果
dfpathway.net <- subsetCommunication(cellchat, slot.name = "netP")
write.csv(dfpathway.net, "df.netP_allPathways.csv", row.names = FALSE)

## 3) sources/targets 子集（用群名，不用数字索引）
grp <- levels(cellchat@idents)
grp
sources.use <- grp[1:2]
targets.use <- grp[4:5]

df.net.st <- subsetCommunication(
  cellchat,
  sources.use = sources.use,
  targets.use = targets.use,
  slot.name = "net"
)

####查看一下我做的什么分群接受/发出信号的celltype群
grp <- levels(cellchat@idents)
grp

sources.use <- grp[1:6]
targets.use <- grp[2]

sources.use
targets.use

## 3) sources/targets 子集（可自行筛选某某群进行通讯分析）
 df.net.st <- subsetCommunication(
   cellchat,
##   sources.use = c("Naive B cells c_04", "Breg c_05"),
##   targets.use = c("Plasma cells (IGHA1) c_22", "Plasmablast (IGHV3)"),
   sources.use = grp[1:6],
   targets.use = grp[2],
   slot.name = "net"
 )


write.csv(df.net.st, "df.net_sourcesTargets.csv", row.names = FALSE)

## 4) 指定通路筛选（先确认是否存在，避免报错）
paths <- cellchat@netP$pathways
paths


want <- c("MIF", "CCL")
want_ok <- intersect(want, paths)

if (length(want_ok) > 0) {
  df.net.sig <- subsetCommunication(cellchat, signaling = want_ok, slot.name = "netP")
  write.csv(df.net.sig, "df.net_WNT_TGFb_netP.csv", row.names = FALSE)
} else {
  message("No significant pathways among: ", paste(want, collapse = ", "),
          ". Available pathways: ", paste(head(paths, 30), collapse = ", "),
          ifelse(length(paths) > 30, ", ...", ""))
}

## 5) 聚合网络作图（count 和 weight）
groupSize <- as.numeric(table(cellchat@idents))

par(mfrow = c(1,2), xpd = TRUE)#左右分两列p1和p2画板
p1 <- netVisual_circle(
  cellchat@net$count,
  vertex.weight = groupSize,
  weight.scale = TRUE,
  label.edge = FALSE,
  title.name = "Number of interactions"
)

p2 <- netVisual_circle(
  cellchat@net$weight,
  vertex.weight = groupSize,
  weight.scale = TRUE,
  label.edge = FALSE,
  title.name = "Interaction weights/strength"
)



#p1 <- netVisual_circle(cellchat@net$count, vertex.weight = groupSize, weight.scale = T, label.edge= F, title.name = "Number of interactions")
#p2 <- netVisual_circle(cellchat@net$weight, vertex.weight = groupSize, weight.scale = T, label.edge= F, title.name = "Interaction weights/strength")
#左图：外周各种颜色圆圈的大小表示细胞的数量，圈越大，细胞数越多。发出箭头的细胞表达配体，
#箭头指向的细胞表达受体。配体-受体对越多，线越粗。
#右图：互作的概率或者强度值（强度就是概率值相加）


##每个细胞如何跟别的细胞互作（互作的强度或概率图）
mat <- cellchat@net$weight
par(mfrow = c(3,3), xpd=TRUE)
for (i in 1:nrow(mat)) {
  mat2 <- matrix(0, nrow = nrow(mat), ncol = ncol(mat), dimnames = dimnames(mat))
  mat2[i, ] <- mat[i, ]
  netVisual_circle(mat2, vertex.weight = groupSize, weight.scale = T, edge.weight.max = max(mat), title.name = rownames(mat)[i])
}
##每个细胞如何跟别的细胞互作（number+of+interaction图）
mat <- cellchat@net$count
par(mfrow = c(3,3), xpd=TRUE)
for (i in 1:nrow(mat)) {
  mat2 <- matrix(0, nrow = nrow(mat), ncol = ncol(mat), dimnames = dimnames(mat))
  mat2[i, ] <- mat[i, ]
  netVisual_circle(mat2, vertex.weight = groupSize, weight.scale = T, edge.weight.max = max(mat), title.name = rownames(mat)[i])
}


##可视化每个信号通路
##查看通路

levels(cellchat@idents)            #查看细胞顺序
vertex.receiver = c(1:6)          #指定靶细胞的索引
cellchat@netP$pathways             #查看富集到的信号通路
pathways.show <- "MIF"            #指定需要展示的通路

#重置参数画新图
par(mfrow = c(1,1))   # 重置成单图
par(xpd = FALSE)      # 可选：恢复默认
dev.new()             # 打开新图窗（RStudio也会新开一个device）

#MIF通路中圆图
par(mfrow = c(1,1))
netVisual_aggregate(cellchat, signaling = "MIF", layout = "circle")
title(main = "MIF signaling pathway", line = 1)


###气泡图

netVisual_bubble(cellchat, sources.use = c(2), targets.use = c(1:6), remove.isolate = FALSE)
#netVisual_chord_gene(cellchat, sources.use = c(13,14), targets.use = c(1,2,3,4,5), legend.pos.x = 20,legend.pos.y = 20,lab.cex = 1, small.gap = 7,big.gap = 30, directional = 1, thresh = 0.01, transparency = 0.4)
pdf("chord_gene_All1.pdf", width = 12, height = 12)
netVisual_chord_gene(
  cellchat,
  sources.use = c(1:6),
  targets.use = c(2),
  lab.cex = 0.6,
  small.gap = 1,
  big.gap = 5,
  directional = 1,
  thresh = 0.01,
  transparency = 0.4
)

dev.off()
plotGeneExpression(cellchat, signaling = "MIF")


##层次图
vertex.receiver = seq(1:16) # a numeric vector. 
netVisual_aggregate(cellchat, signaling = "MIF",  vertex.receiver = vertex.receiver,layout="hierarchy", pt.title = 20)
#修改源代码，改为自定义细胞以celltype为名字
receiver_names <- c("Naive B cells c_04", "Plasma cells (IGHA1) c_22")
vertex.receiver <- which(levels(cellchat@idents) %in% receiver_names)

stopifnot(length(vertex.receiver) == length(receiver_names))

netVisual_aggregate(
  cellchat,
  signaling = "GALECTIN",
  vertex.receiver = vertex.receiver,
  layout = "hierarchy",
  pt.title = 20
)





#在层次图中，实体圆和空心圆分别表示源和目标。圆的大小与每个细胞组的细胞数成比例。线越粗，互作信号越强。
#左图中间的target是我们选定的靶细胞。右图是选中的靶细胞之外的另外一组放在中间看互作。

##圈图
#par(mfrow=c(13,14))
#netVisual_aggregate(cellchat, signaling ="GALECTIN", layout = "circle",pt.title = 17)

pdf("MIF_circle.pdf", width = 10, height = 10)
par(mfrow = c(1,1), xpd = TRUE)
netVisual_aggregate(cellchat, signaling = "MIF", layout = "circle", pt.title = 17)
dev.off()


##和弦图
#par(mfrow=c(13,14))
#netVisual_aggregate(cellchat, signaling ="GALECTIN", layout = "chord", vertex.size = groupSize)


groupSize <- as.numeric(table(cellchat@idents)[levels(cellchat@idents)])


pdf("MIF_chord.pdf", width = 14, height = 14)   # 图形更大
par(mfrow = c(1,1), xpd = TRUE, mar = c(1,1,3,1))  # 留出上边距放标题

netVisual_aggregate(
  cellchat,
  signaling = "MIF",
  layout = "chord",
  vertex.size = groupSize,
  vertex.label.cex = 0.5,    # 字体变小（可改 0.4~0.7）
  edge.weight.max = max(cellchat@net$weight)  # 可选：统一线宽上限
)


dev.off()

##热图
#par(mfrow=c(2,3))
#netVisual_heatmap(cellchat, signaling = "GALECTIN",color.heatmap = "Reds")

pdf("MIF_heatmap.pdf", width = 12, height = 8)
netVisual_heatmap(cellchat, signaling = "MIF", color.heatmap = "Reds")
dev.off()


#或者在画板中直接画出热图
# 1) 先把所有文件设备关掉（防止还在 pdf 设备上）
graphics.off()   # 这句最干净
library(ComplexHeatmap)
library(grid)
# 2) 先生成热图对象
ht <- netVisual_heatmap(cellchat, signaling = "MIF", color.heatmap = "Reds")
# 3) 再 draw 到当前图形设备（RStudio Plots）
ComplexHeatmap::draw(ht, padding = unit(c(12, 45, 15, 10), "mm"))




##纵轴是发出信号的细胞，横轴是接收信号的细胞，热图颜色深浅代表信号强度。
##上侧和右侧的柱子是纵轴和横轴强度的累积


#配体-受体层级的可视化（计算各个ligand-receptor+pair对信号通路的贡献）
#pathways.show <- "GALECTIN"
#netAnalysis_contribution(cellchat, signaling = pathways.show)
pdf("MIF_LR_contribution.pdf", width = 6, height = 3.5)
par(mar = c(4, 8, 2, 1))   # 下、左、上、右边距；左边加大给基因名
netAnalysis_contribution(cellchat, signaling = "MIF")
dev.off()

##也可以看到单个配体-受体对介导的细胞-细胞通信。
#我们提供了一个extractEnrichedLR功能来提取给定信号通路的所有重要相互作用(L-R对)和相关信号基因。
pairLR.MK <- extractEnrichedLR(cellchat, signaling = "GALECTIN", geneLR.return = FALSE)
