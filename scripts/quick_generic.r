args<-commandArgs(TRUE)
path <- args[1]
path = paste(path,"chr",sep="/")
sample_name <- args[2]
ws <- args[3]
combo_sn = paste("_",sample_name,sep="")
combo_sn2 = paste(sample_name, "Chr", sep= " ")
for (k in c(1:25,"M")) {
    png(paste(path,"_poly.png", sep=as.character(k)),width = 800, height = 480, units = "px", pointsize = 12)
    Test <- read.table(paste(path,"_poly.txt",sep=as.character(k)))
    for (i in 2) { plot(Test[,1],Test[,i],type="l",col='green', xlab= "", ylab = "",xaxt = 'n',yaxt='n', ylim=c(0,1000))
    par(new=T)}
    abline(h = 400, lty = 3, col = 'green')
    par(new=TRUE)
    Test <- read.table(paste(path,combo_sn,sep=as.character(k)))
    for (i in 2) { plot(Test[,1],Test[,i],type="l",col='cornflowerblue', xlab = "", ylab = "",xaxt = 's', ylim = c(0,1))
                                par(new=T)}
    abline(h = 0.9, lty = 3, col = 'grey72')
    par(new=TRUE)
    abline(h = 0.1, lty = 3, col = 'grey72')
    #abline(v = 1:13, lty = 3, col = 'purple')
    axis(side = 1, at = c(0,10000000,20000000,30000000,40000000,50000000,60000000,70000000,800000000), labels =           c("0Mbp",'10Mbp','20Mbp','30Mbp','40Mbp','50Mbp','60Mbp','70Mbp','80Mbp'))
    #title(main=paste(combo_sn2,", window_length = ",ws, "SNP, Homozygosity Score (Wik + TLF)",sep=as.character(k)),ylab="Homozygosity score")
    title(main=sprintf("%s%s, window_length = %s SNP's, Homozygosity Score (Wik +TLF)", combo_sn2, k, ws),ylab="Homozygosity score")
    #sprintf("<set name=\"%s\" value=\"%i\" ></set>\n", "nina", 5)
    #legend(0,5000, c("105FEGG","125FBGB","66FEGG","71FAGA","72FAGA"), cex=0.8,
    #       col=c("red","green","blue","cyan","darkmagenta") , pch=19 )
    dev.off()
}
