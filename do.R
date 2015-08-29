#usage: do("dir_name") will produce a file "all_site" which merge all file in dir
do <- function(dir){
	library("plyr")
	library("dplyr")
	path <- paste(dir, list.files(dir), sep="/")
	file <- lapply(path, read.table, header=1, sep="\t", quote="")
	names(file) <- list.files(dir)
	tmp <- Reduce(function(...) merge(..., by=c("CHROM", "POS", "ID"), all=TRUE), file)
	tmp <- arrange(tmp, CHROM)
	write.table(tmp, file="all_merge", sep="\t", row.names=FALSE)
	tmp
}



