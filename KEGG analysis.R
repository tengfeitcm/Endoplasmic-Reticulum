library("clusterProfiler")
library("org.Hs.eg.db")
library("enrichplot")
library("ggplot2")

pvalueFilter=0.05     
adjPvalFilter=1      

colorSel="p.adjust"
if(adjPvalFilter>0.05){
	colorSel="pvalue"
}

rt=read.table("interGenes.txt", header=F, sep="\t", check.names=F)     

genes=unique(as.vector(rt[,1]))
entrezIDs=mget(genes, org.Hs.egSYMBOL2EG, ifnotfound=NA)
entrezIDs=as.character(entrezIDs)
rt=cbind(rt, entrezIDs)
colnames(rt)[1]="gene"
rt=rt[rt[,"entrezIDs"]!="NA",]     
gene=rt$entrezID

kk <- enrichKEGG(gene=gene, organism="hsa", pvalueCutoff=1, qvalueCutoff=1)
kk@result$Description=gsub(" - Homo sapiens \\(human\\)", "", kk@result$Description)
KEGG=as.data.frame(kk)
KEGG$geneID=as.character(sapply(KEGG$geneID,function(x)paste(rt$gene[match(strsplit(x,"/")[[1]],as.character(rt$entrezID))],collapse="/")))
KEGG=KEGG[(KEGG$pvalue<pvalueFilter & KEGG$p.adjust<adjPvalFilter),]
write.table(KEGG, file="KEGG.txt", sep="\t", quote=F, row.names = F)

showNum=30
if(nrow(KEGG)<showNum){
	showNum=nrow(KEGG)
}

pdf(file="barplot.pdf", width=8.5, height=7)
barplot(kk, drop=TRUE, showCategory=showNum, label_format=100, color=colorSel)
dev.off()

pdf(file="bubble.pdf", width=8.5, height=7)
dotplot(kk, showCategory=showNum, orderBy="GeneRatio", label_format=100, color=colorSel)
dev.off()


