###__author__ = 'Remi Maglione' ###

#####
#Library
library("ggplot2")

#####
#IMPORT DATA (path to modify: replace file='/..../ with your path fasta file) TO DO: automate
args <- commandArgs(trailingOnly = TRUE)
vizuN <- read.csv(file=args[1], header = TRUE, sep=',')

#vizuN <- read.csv(file='/home/haclionex/Documents/amina/all_test.fa', header = TRUE , sep=" ")

###
#rename header
names(vizuN)[1] <- "X.test"

####
#Add genome position
vizuN$x <- c(1:nrow(vizuN))

####
#Add y=1
vizuN$y <- c(1)


####
#Add group name for each ATGC or N
vizuN$group <- ifelse(vizuN$X.test=="A", "ATGC",
                      ifelse(vizuN$X.test=="T", "ATGC",
                      ifelse(vizuN$X.test=="G", "ATGC",
                      ifelse(vizuN$X.test=="C", "ATGC", "N"
                       ))))
###
#PLOT
tiff(sprintf("VizuN"), width=2400, height=600, res=480)
print(
  ggplot(data=vizuN, aes(x=x, y=y,fill=group, width=2)) + 
    xlab('Genome position') + ylab('') + ylim(0, 1) +
    geom_bar(stat = "identity", position="identity") + 
    #guides(fill=FALSE) +
    scale_fill_manual(values = c("#009E73", "#D55E00")) + 
    theme(text=element_text(family = "Arial", size=8), 
          legend.position='bottom', 
          panel.background = element_blank(),
          axis.ticks.y = element_blank(), 
          axis.text.y = element_blank())
)
dev.off()

####
#Exit Message (you have no choice !)
print("N Chromosome Plot ---> OK")
