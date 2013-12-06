# load in Chick data
data(ChickWeight)
attach(ChickWeight)

# set up canvas; I like mine to go left to right, so do it byrow
layout(matrix(nrow=2, ncol=2, data=1:4, byrow=TRUE))
layout.show(4)

# plots away! create 4 plots, 1 for each group of chicks by diet
for(i in levels(Diet))
{
    plot(weight~Time, data=subset(ChickWeight, Diet==i), pch=3, 
         col=i, xlab="Time", ylab="Weight", main=paste("Diet ", i))
    
    # do an overlay plot where the dot indicates the mean weight of chicks at that measurement time
    lines(x=unique(ChickWeight$Time), aggregate(weight~Diet*Time, data=subset(ChickWeight[Diet==i,]), mean)[,3], type="o", col="red", pch=18)
    
    # throw a legend on there, because I am classy like that.
    legend("topleft", legend=c("Time mean"), col=c("red"), lty="solid", pch=18)
}

detach(ChickWeight)