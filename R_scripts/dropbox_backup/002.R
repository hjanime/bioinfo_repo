# Ako u kvadarat imamo upisan krug polumjera R, tada je povr�ina 
# kruga (R^2)*pi, a povr�ina kvadrata je 4*(R^2). Ako podijelimo
# povr�inu kruga s povr�inom kvadrata dobijemo pi/4. Ako nasumi�no
# "bacamo" to�ke u taj kvadrat, odnos izme�u povr�ine kruga i 
# povr�ine kvadrata mo�emo dobiti tako da "prebrojimo" to�ke u krugu
# i izvan kruga. Po�to znamo iz geometrije da je taj odnos pi/4, 
# tada slijedi da je: 
# pi = 4*(broj to�aka u krugu/broj to�aka u kvadratu). Kako sve 
# to�ke padaju u kvadrat (bilo unutar kruga, bilo izvan kruga),
# pi = 4*(broj to�aka u krugu/ukupan broj to�aka).

# U zadatku biramo brojeve od -1 do 1 po x i y osi, zna�i na� kvadrat
# je od -1 do 1 na x osi duga�ak i od -1 do 1 na y osi visok. 
# Krug koji mu je upisan ima polumjer 1. 

# Da bi vidjeli je li to�ka unutar kruga ili izvan kruga koristimo
# Pitagorin pou�ak. Uzmemo n to�aka s nasumi�nim koordinatama x i y.
# Ako promatramo trokut kojemu su katete a i b udaljenost to�ke 
# od x i y osi, tada  nepoznata stranica c tog trokuta odre�uje
# je li to�ka unutar kruga ili izvan kruga. Ako je c <= 1 tada je
# to�ka unutar kruga, a ako je c > 1 tada je to�ka izvan kruga.  

My.pi <- function (n){
  a <- runif(n, min = -1, max = 1)
  b <- runif(n, min = -1, max = 1)
  c <- sqrt((a^2) + (b^2))
  inside <- sum(c <= 1)
  my.pi <- 4 * (inside / n)
  return (my.pi)
}
set.seed(1234)
My.pi(100000)

# plot
My.pi.plot <- function(iter){
  pi.plot <- 0
  for (i in 1:iter){
    pi.plot[i] <- My.pi(i)
  }
  plot(pi.plot[1:i], type = "l", ylim = c(0, 5), 
       col = "blue", xlab = "Number of iterations")
  abline(pi, 0, col = "red", lwd = 0.25)
}
set.seed(1234)
My.pi.plot(500)


