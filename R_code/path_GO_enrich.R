setwd(my_work_directory)

library(clusterProfiler)
library(stringr)
library("org.Hs.eg.db")
library("org.Sc.sgd.db")

dataset = my_dataset
tmp <- cbind('protein_inf', dataset)
input_file = str_c(tmp, collapse = '_')
Pros = read.csv(input_file, sep = "\t", header = TRUE, fill = FALSE)
cutoff <- c(0, 3, 10, 100, 10000)
for (i in 1:4){
  upper <- cutoff[i + 1]
  lower <- cutoff[i]
  
  sub_pros <- Pros[which (Pros$'Degree' > lower & Pros$Degree <= upper), ]
  genes <- sub_pros$Entrez_Gene
  
  #  pathway enrichment
  tmp <- cbind(toString(i), 'path_enriched', dataset)
  my_path_out_file = str_c(tmp, collapse = '_')
  # kk <- enrichKEGG(genes, organism = 'sce', keyType = 'ncbi-geneid', pAdjustMethod = 'BH', use_internal_data = FALSE) # for Saccharomyces cerevisiae
  kk <- enrichKEGG(genes, organism = 'hsa', keyType = 'ncbi-geneid', pAdjustMethod = 'BH', use_internal_data = FALSE) # for human
  write.table(kk, my_path_out_file, row.names = F, col.names = T, sep = "\t", quote = F)

  # GO enrichment
  for (j in c('BP', 'CC', 'MF')){
    # gg <- enrichGO(genes, "org.Sc.sgd.db", keyType = 'ENTREZID', ont = j, pAdjustMethod = 'BH') # for Saccharomyces cerevisiae
    gg <- enrichGO(genes, "org.Hs.eg.db", keyType = 'ENTREZID', ont = j, pAdjustMethod = 'BH') # for human
    tmp <- cbind(toString(i), 'GO_enriched', j, dataset)
    my_go_out_file = str_c(tmp, collapse = '_')
    write.table(gg, my_go_out_file, row.names = F, col.names = T, sep = "\t", quote = F)
  }
}