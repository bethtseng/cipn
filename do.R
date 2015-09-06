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
	x$REF <- x[1]
	for(i in 2:ncol(x)-1) {
		x$REF[!is.na(x[i])] = x[i][!is.na(x[i])]
	}
	result <- cbind(tmp[1:3], x$REF, tmp[seq(5, ncol(tmp), 2)])
	#write.table(result, file="all_merge", sep="\t", row.names=FALSE)
	result
}

#transform into train_data form
train <- function(tbl){
	tbl[5:ncol(tbl)] <- factor(ifelse(is.na(tbl[5:ncol(tbl)]), FALSE, TRUE))
	tbl
}

#change all NA to ref
natoref <- function(fram){
	for(i in 5:ncol(fram)){ fram[,i][is.na(fram[,i])] = fram$REF[is.na(file[,i])] }
	fram
}

#filtering row with same value in col
#input data frame and col num(ex: c(5,7,8) )
condi <- function(fram, col){
	x <- function(fram, col1, col2){
		con <- ifelse(as.character(fram[,col1]) == as.character(fram[,col2]), TRUE, FALSE)
		fram <- fram[con, ][!is.na(con), ]
	}
	if(length(col) ==2) fram <- x(fram, col[1], col[2])
	else fram <- x(x(fram, col[1], col[2]), col[2], col[3])
	fram
}

#t(dataframe) with colname
ttable <- function(fram){
	tfram <- t(fram) #read directory to data frame
	table <- tfram[-(1:4), ]
	colnames(table) <- paste(tfram[2,], tfram[1,], sep="_")
	write.table(table, file="snv_table", sep="\t", row.names=FALSE)
	table
}

