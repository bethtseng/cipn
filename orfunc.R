orfunc <- function(fram){
	for(i in 1: ncol(fram)){
		carct <- as.vector(fram[,i][!duplicated(fram[,i])])
		if(length(carct) > 2){
			add <- addfunc(as.vector(fram[,i]), carct, colnames(fram)[i])
			nam <- colnames(fram)[1:i]
			fram <- cbind(fram[,1:i], add, fram[,(i+1):ncol(fram)])
			colnames(fram)[1:i] <- nam
		}
	}
	fram[!duplicated(fram),]
}

addfunc <- function(vect, carct, name){
	fram <- data.frame(remove = c(1:length(vect)))
	for(i in 1:length(carct)){
		for(j in 2:length(carct)){
			if(i < j){
				pattern <- paste(carct[i], "|", carct[j], sep="")
				add <- lapply(vect, function(x){ if(x==carct[i]||x==carct[j]){ x <- pattern} else{x=x} })
				fram <- cbind(fram, as.vector(unlist(add)))
				name <- gsub('<.*$', "", name)
				colnames(fram) <- c(colnames(fram)[1:length(colnames(fram))-1], paste(name, "<", pattern, ">", sep=""))
			}
		}
	}
	fram[,2:ncol(fram)]
}

