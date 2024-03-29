library(dplyr)
My.k.means <- function(n, mydata){
  
  # initializing varijabli
  x <- list()
  y <- 0
  
  # biranje n nasumi�nih  centroida
  cent <- mydata[sample(nrow(mydata), n), ]
  
  for (i in 1:(n + 25)){
    
    # izra�unavanje udaljenosti svake to�ke iz data framea od centroida
    mydata1 <- mydata
    for (j in 1:n){
      mydata1[ , ncol(mydata)+j] <- apply(mydata1, 1, function(x) sqrt(sum((x - cent[j, ])^2)))
    }
    
    # pridru�ivanje centorida svakoj to�ki pomo�u which.min (gleda
    # koja vrijednost centroida je najbli�a to�ki, tj. koja je najmanja
    # vrijednost)
    mydata1$centroid <- apply(mydata1[, (ncol(mydata) + 1):(ncol(mydata)+n)], 1, which.min)
    
    # izra�unavanje novih centroida pomo�u funkcija iz paketa dplyr. 
    # Prvo grupiram po postoje�im centroidima, zatim izra�unavam srednju 
    # vrijednost. Dobijem data frame sa srednjim vrijednostima svih kolona 
    # pa bri�em kolone koje mi ne trebaju. 
    cent.new <- mydata1 %>%
      group_by(centroid) %>%
      summarise_each(funs(mean))
    cent.new <- cent.new[, -(ncol(mydata)+2):-(ncol(mydata)+2+n)]
    cent.new <- cent.new[-1]
 
    # provjeravanje jesu li novi centroidi jednaki postoje�ima
    # (ako jesu prekida se petlja, ako nisu funkcija kre�e ispo�etka
    # s novim vrijednostima centroida)
    x[i] <- list(all.equal(cent, cent.new))
    if (x[i] == "TRUE") break
    cent <- cent.new
  }
  
  # dodavanje kolone s dodijeljenim brojem centroida u data.frame 
  # s vrijednostima centroida i preslagivanje kolona tako da kolona
  # s dodijeljenim brojem centroida bude prva kolona
  cent$centroid <- row.names(cent)
  cent <- cent[, c(ncol(cent), 1:(ncol(cent) - 1))]
  
  # kona�ni data set s pridru�enim vrijednostima centroida
  mydata1 <- subset(mydata1, select = c(1:ncol(mydata), ncol(mydata1)))
  mydata1 <- cbind(mydata1, cent[match(mydata1$centroid, cent$centroid), 2:ncol(cent)])
  
  # plot - samo ako data ima najvi�e 2 dimenzije
  if(ncol(mydata) < 3){
    plot(mydata1[1:2], col = mydata1$centroid, pch = 20)
    points(cent[2:3], col = 4, pch = 8, cex = 2)
    
    # Voronoi regije
    for (i in 1:n){
      vor <- subset(mydata1, select = c("x", "y"), centroid == i)
      vor.hull <- lapply(vor, "[", chull(vor))
      polygon(vor.hull, lty = 2, border = i)
    }
  }
  
return(mydata1)
}

data.kmeans <- read.table(file = 'Kmeans_test.tsv', sep = '\t', header = T)
x <- My.k.means(3, data.kmeans)
