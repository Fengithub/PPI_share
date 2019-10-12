setwd(my_work_directory)

library(clusterProfiler)
library(stringr)
library("org.Hs.eg.db")
library("org.Sc.sgd.db")

write_path_go_enrich <- function(dataset, org1, org2){
  tmp <- cbind('protein_inf', dataset)
  input_file = str_c(tmp, collapse = '_')
  Pros = read.csv(input_file, sep = "\t", header = TRUE, fill = FALSE)
  cutoff <- quantile(Pros$Degree, probs = c(0, 0.25, 0.75, 1))

  for (i in 1:4){
    upper <- cutoff[i + 1]
    lower <- cutoff[i]
    sub_pros <- Pros[which (Pros$Degree >= lower & Pros$Degree <= upper), ]
    genes <- sub_pros$Entrez_Gene
    
    #  pathway enrichment
    tmp <- cbind(toString(i), 'path_enriched', dataset)
    my_path_out_file = str_c(tmp, collapse = '_')
    kk <- enrichKEGG(genes, organism = org1, keyType = 'ncbi-geneid', pAdjustMethod = 'BH', use_internal_data = FALSE) # for human
    write.table(kk, my_path_out_file, row.names = F, col.names = T, sep = "\t", quote = F)

    # GO enrichment
    for (j in c('BP', 'CC', 'MF')){
      gg <- enrichGO(genes, org2, keyType = 'ENTREZID', ont = j, pAdjustMethod = 'BH') # for human
      tmp <- cbind(toString(i), 'GO_enriched', j, dataset)
      my_go_out_file = str_c(tmp, collapse = '_')
      write.table(gg, my_go_out_file, row.names = F, col.names = T, sep = "\t", quote = F)
    }

  }
  
}

# dataset = my_dataset
# org1 = 'sce' or 'hsa'
# org2 = 'org.Sc.sgd.db' or 'org.Hs.eg.db'