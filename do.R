do <- function(dir){
	library("plyr")
	library("dplyr")
	path <- list.files(dir)
	file <- lapply(path, read.table, header=1, sep="\t", quote="")
	tmp <- Reduce(function(x, y) merge(x, y, all=TRUE), file)
	mer <- arrange(select(tmp, CHROM:POS), CHROM)
	write.table(mer, file="../all_site", sep="\t", row.names=FALSE)
	return mer
}



