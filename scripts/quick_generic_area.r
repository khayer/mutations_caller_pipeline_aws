args<-commandArgs(TRUE)
path <- args[1]
path = paste(path,"chr",sep="/")
sample_name <- args[2]
combo_sn = paste("_",sample_name,sep="")
combo_sn2 = paste(sample_name, "Chr", sep= " ")
lower_bound <- as.numeric(args[3])
upper_bound <- as.numeric(args[4])
chromosome_number <- args[5]
for (k in chromosome_number) {
    png(paste(path,"_poly.png", sep=as.character(k)),width = 800, height = 480, units = "px", pointsize = 12)
    Test <- read.table(paste(path,"_poly.txt",sep=as.character(k)))
    for (i in 2) { plot(Test[,1],Test[,i],type="l",col='green', xlab= "", ylab = "",xaxt = 'n',yaxt='n', ylim=c(0,1000),xlim=c(lower_bound,upper_bound))
    par(new=T)}
    abline(h = 400, lty = 3, col = 'green')
    par(new=TRUE)
    Test <- read.table(paste(path,combo_sn,sep=as.character(k)))
    for (i in 2) { plot(Test[,1],Test[,i],type="p",col='cornflowerblue', xlab = "", ylab = "",xaxt = 'n', ylim = c(0,1),xlim=c(lower_bound,upper_bound))
                                par(new=T)}
    abline(h = 0.9, lty = 3, col = 'grey72')
    par(new=TRUE)
    abline(h = 0.1, lty = 3, col = 'grey72')
    #abline(v = 1:13, lty = 3, col = 'purple')
    axis(side = 1, at = c(0,10000000,20000000,30000000,40000000,50000000,60000000,70000000,800000000), labels =           c("0Mbp",'10Mbp','20Mbp','30Mbp','40Mbp','50Mbp','60Mbp','70Mbp','80Mbp'))
    title(main=paste(combo_sn2,", window_length = 1SNP, Homozygosity Score (Wik + TLF)",sep=as.character(k)),ylab="Homozygosity score")
    #legend(0,5000, c("105FEGG","125FBGB","66FEGG","71FAGA","72FAGA"), cex=0.8,
    #       col=c("red","green","blue","cyan","darkmagenta") , pch=19 )
    dev.off()
}
