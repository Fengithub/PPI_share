library(GOSemSim)
library("org.Hs.eg.db")
library("org.Sc.sgd.db")
library(foreach)
library(doParallel)

data_code = 'org.Hs.eg.db' # for human 
# data_code = 'org.Sc.sgd.db' # for Sacch

load_GO_database <- function(data_code){
	myGO <- list()
	myGO$MF <- godata(data_code, ont = "MF")
	myGO$CC <- godata(data_code, ont = "CC")
	myGO$BP <- godata(data_code, ont = "BP")
	return(myGO)
}

myGO <- load_GO_database(data_code)

cal_GO_simi <- function(myGO, PPIs, out_file){
	PPIs$MF_geneSim <- 'NA'
	PPIs$CC_geneSim <- 'NA'
	PPIs$BP_geneSim <- 'NA'
	numCores <- detectCores()
	foreach (i = 1: nrow(PPIs)) %dopar% {
	  gene1 <- PPIs$Entrez_A[i]
	  gene2 <- PPIs$Entrez_B[i]
	  a <- geneSim(gene1, gene2, semData = myGO$MF, measure = "Resnik", combine = "BMA")
	  if (!is.na(a)){
	    PPIs$MF_geneSim[i] <- a$geneSim
	  }
	  b <- geneSim(gene1, gene2, semData = myGO$CC, measure = "Resnik", combine = "BMA")
	  if (!is.na(b)){
	  	PPIs$CC_geneSim[i] <- b$geneSim
	  }
	  c <- geneSim(gene1, gene2, semData = myGO$BP, measure = "Resnik", combine = "BMA")
	  if (!is.na(c)){
	  	PPIs$BP_geneSim[i] <- c$geneSim
	  }
	}
	write.table(PPIs, out_file, row.names = F, col.names = T, sep = "\t", quote = F)
}

cal_GO_simi(myGO, my_PPIs, my_out_file)


 

