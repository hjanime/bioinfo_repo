# Funkcije Xnorm koriste se za operacije vezane uz
# normalnu distribuciju. 

# Normalna distribucija je kontinuirana distribucija 
# vjerojatnosti koja govori kolika je vjerojatnost da 
# neka primje�ena realna vrijednost padne izme�u bilo 
# koje dvije realne granice. 

# dnorm je funkcija koja uzima argument x i vra�a visinu
# distribucije vjerojatnosti za svaku to�ku unutar x. 
# Ako se koristi samo kao dnorm(x) uzima srednju vrijednost 0 
# i standardnu devijaciju 1:
x <- seq(-4,4,length=200)
y <- dnorm (x)
plot(x,y,type="l",col="red")

# Mogu�e je i definirati proizvoljnu srednju vrijednost i standardnu
# devijaciju: dnorm (x, mean=, sd=). Primjer:
x <- seq(-10,10,length=200)
y <- dnorm (x, mean=2, sd=2)
plot(x,y,type="l",col="red", xlim=c(-10,10))

# Ukoliko standardna devijacija (sd) ostaje nepromjenjena, 
# pove�avanjem srednje vrijednosti (mean) dolazi do horizontalnog 
# pomicanja krivulje udesno, a smanjenje mean pomi�e krivulju 
# horizontalno ulijevo:
x <- seq(-15,15,length=200)
y1 <- dnorm (x, mean=0, sd=2)
y2 <- dnorm (x, mean=4, sd=2)
y3 <- dnorm (x, mean=-4, sd=2)
plot (x,y1,type="l",col="red", xlim=c(-15,15))
lines (x, y2, col="blue")
lines (x, y3, col="green")

# Smanjenje standardne devijacije (s) dovodi do uske i visoke 
# krivulje, a povi�enje standardne devijacije ( s ) do �iroke 
# i niske krivulje: 
x <- seq(-15,15,length=200)
y1 <- dnorm (x, mean=0, sd=4)
y2 <- dnorm (x, mean=0, sd=6)
y3 <- dnorm (x, mean=0, sd=2)
plot (x,y1,type="l",col="red", xlim=c(-15,15), 
      ylim=range(y1,y2,y3))
lines (x, y2, col="blue")
lines (x, y3, col="green")

# pnorm je funkcija kumulativne distribucije koja za vrijednost
# x daje vjerojatnost da je nasumi�an broj dobiven normalnom 
# distribucijom manji od x. Prihva�a iste argumente kao dnorm:
x <- seq(-15,15,length=200)
y1 <- pnorm (x, mean=2, sd=4)
y2 <- pnorm (x)
plot (x,y1,type="l",col="red", xlim=c(-15,15), ylim=c(0,1))
lines(x,y2,col="green")

# Ako �elimo da funkcija daje vjerojatnost da je nasumi�an broj 
# dobiven normalnom distribucijom VE�I od x mo�emo korisiti 
# argument lower.tail=FALSE:
x <- seq(-15,15,length=200)
y1 <- pnorm (x, mean=2, sd=4, lower.tail=FALSE)
y2 <- pnorm (x, lower.tail=FALSE)
plot (x,y1,type="l",col="red", xlim=c(-15,15), ylim=c(0,1))
lines(x,y2,col="green")

# qnorm je funkcija inverzna funkciji pnorm: vrijednost argumenta
# x je vjerojatnost, a funkcija vra�a broj �ija kumulativna 
# distribucija odgovara toj vjerojatnosti x. qnorm tako�er prihva�a
# neobavezne argumente mean i sd:
x <- seq(0,1,length.out=100)
y <- qnorm(x)
y2 <- qnorm(x, mean=2, sd=3)
plot(x,y, type="l",col="red", ylim=c(-10,10))
lines (x,y2, col='yellow')

# rnorm je funkcija koja generira nasumi�ne brojeve �ija je
# distribucija normalna. Argument x u rnorm funkciji je 
# broj nasumi�nih brojeva koje �e funkcija vratiti. rnorm tako�er
# prihva�a neobavezen argumente za srednju vrijednost (mean) i 
# standardnu devijaciju (sd):

y <- rnorm(x)
y
hist(y)

y1 <- rnorm(x,mean=3)
y1
hist(y1)

y2 <- rnorm(x,mean=3,sd=3)
y2
hist(y2)




