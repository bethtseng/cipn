#usage: do("dir_name") will produce a file "all_site" which merge all file in dir
do <- function(dir){
	library("plyr")
	library("dplyr")
	path <- paste(dir, list.files(dir), sep="/")
	file <- lapply(path, read.table, header=1, sep="\t", quote="", stringsAsFactors =FALSE)
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
	#write.table(result, file="all_merge", sep="\t", row.names=FALSE)
	colnames(result) <- gsub(" ", "", colnames(result))
	result
}

#transform into train_data form
train <- function(tbl){
	tbl[5:ncol(tbl)] <- factor(ifelse(is.na(tbl[5:ncol(tbl)]), FALSE, TRUE))
	tbl
}

#add class to data frame
clas <- function(fram){
	class <- c("yes", "yes", "no", "yes", "no", "yes", "no", "no","no","no","no","no","no","no","no","no","no","no","no","no")
	fram <- cbind(fram, class)
	#write.table(fram, file="snv_table", sep="\t", row.names=FALSE)
	fram
}

#change all NA to ref
natoref <- function(fram){
	for(i in 5:ncol(fram)){ fram[,i][is.na(fram[,i])] = fram$REF[is.na(fram[,i])] }
	fram
}

#t(dataframe) with colname
ttable <- function(fram){
	tfram <- t(fram) #read directory to data frame
	table <- tfram[-(1:4), ]
	colnames(table) <- paste(tfram[2,], tfram[1,], sep="_")
	#write.table(table, file="snv_table", sep="\t", row.names=FALSE)
	table
}

