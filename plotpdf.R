plotpdf <- function(){ 
	pdf(file="myplot.pdf") ##open PDF device; create myplot.pdf
	with(faithful, plot(eruptions, waiting)) #create a plot and send to a file
	title(main = "Old Faithful Geyser data") #annotate plot, still nothing on screen
	dev.off() #close PDF file device
}


