x <- rnorm (100000, mean=1, sd=2)
i <- x > 5
y <- x[i]
l <- length(y)
l #broj brojeva ve�ih od 5

# Ra�unanje koliko brojeva od 100000 brojeva je ve�e od 5
# pomo�u funkcije pnorm s argumentom lower.tail=FALSE.

y1 <- pnorm (5, mean=1, sd=2, lower.tail=FALSE)
# y1 ozna�ava vjerojatnost da je broj dobiven normalnom
# distribucijom ve�i od 5 pri mean=1 i sd=2 

y2 <- round (y1*100000)
y2
# mno�enjem vjerojatnosti y1 sa 100000 dobijemo broj brojeva 
# ve�ih od  5 

#plot1
mean1 <- 1
sd1 <- 2
x <- seq(-4,4,length=2000)*sd1+mean1
y <- dnorm(x,mean1,sd1)
plot(x, y, type="l", bty="l")

i <- x <= mean1-sd1
polx <- c(-4, x[i], mean1-sd1)
poly <- c(0, y[i], 0)
polygon(polx,poly, col="red")

j <- x >= mean1+sd1
polx2 <- c(mean1+sd1, x[j], 7)
poly2 <- c(0, y[j], 0)
polygon(polx2,poly2, col="red")
