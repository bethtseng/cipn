#usage: do("dir_name") will produce a file "all_site" which merge all file in dir
do <- function(dir){
	library("plyr")
	library("dplyr")
	path <- paste(dir, list.files(dir), sep="/")
	file <- lapply(path, read.table, header=1, sep="\t", quote="")
	names(file) <- list.files(dir)
	tmp <- Reduce(function(...) merge(..., by=c("CHROM", "POS", "ID"), all=TRUE), file)
	tmp <- arrange(tmp, CHROM)
	#REF
	x <- tmp[seq(4,ncol(tmp), 2)]
	x$m <- x[1]
	for(i in 2:ncol(x)-1) {
		x$m[!is.na(x[i])] = x[i][!is.na(x[i])]
	}
	names(x$m) <- "REF"
	result <- cbind(tmp[1:3], x$m, tmp[seq(5, ncol(tmp), 2)])
	write.table(result, file="all_merge", sep="\t", row.names=FALSE)
	result
}

#transform into train_data form
train <- function(tbl){
	tbl[5:ncol(tbl)] <- factor(ifelse(is.na(tbl[5:ncol(tbl)]), 0, 1))
	tbl
}

