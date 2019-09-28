setwd(my_work_directory)
library(GOSemSim)
library("org.Hs.eg.db")
library("org.Sc.sgd.db")
library(foreach)
library(doParallel)

hsGO1 <- godata('org.Hs.eg.db', ont = "MF")
hsGO2 <- godata('org.Hs.eg.db', ont = "CC")
hsGO3 <- godata('org.Hs.eg.db', ont = "BP")
scGO1 <- godata('org.Sc.sgd.db', ont = "MF")
scGO2 <- godata('org.Sc.sgd.db', ont = "CC")
scGO3 <- godata('org.Sc.sgd.db', ont = "BP")

PPIs = read.csv(my_PPI_input_file,sep = "\t",header = TRUE,fill = FALSE)
#  my_PPI_input_file include the entrez id of each protein in a pair

PPIs$MF_geneSim <- 'NA'
PPIs$CC_geneSim <- 'NA'
PPIs$BP_geneSim <- 'NA'

foreach (i = 1: nrow(PPIs)) %dopar% {
  gene1 <- PPIs$Entrez_A[i]
  gene2 <- PPIs$Entrez_B[i]
  a <- geneSim(gene1, gene2, semData = scGO1, measure = "Resnik", combine = "BMA")
  if (!is.na(a)){
    PPIs$MF_geneSim[i] <- a$geneSim
  }
  b <- geneSim(gene1, gene2, semData = scGO2, measure = "Resnik", combine = "BMA")
  if (!is.na(b)){
    PPIs$CC_geneSim[i] <- b$geneSim
  }
  c <- geneSim(gene1, gene2, semData = scGO3, measure = "Resnik", combine = "BMA")
  if (!is.na(c)){
    PPIs$BP_geneSim[i] <- c$geneSim
  }
}

write.table(PPIs, my_PPI_out_file, row.names = F, col.names = T, sep = "\t", quote = F)