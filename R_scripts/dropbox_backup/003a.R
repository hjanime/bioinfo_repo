# CpG otoci su regije u DNA s visokim sadr�ajem 
# C+G nukleotida u kojima se �esto pojavljuju CpG
# dinukleotidi (s obzirom na ukupnu koli�inu DNA). 
# Ina�e je DNA kralje�njaka siroma�na dinukleotidom
# CpG. 

# Definicija iz rada: CpG otok je DNA sekvenca u kojoj je:
# - pomi�ni prosjek %G+C baza ve�i od 50
# - pomi�ni prosjek omjera primje�enih CpG/o�ekivanih CpG
# (Obs/Exp CpG) je ve�i od 0.6

# Obs/Exp CpG = ((number of CpG)/(number of C * number of G)) * N
# gdje je N ukupan broj nukleotida u analiziranoj sekvenci

# U radu promatraju sekvencu pomo�u "prozora" od 100 bp (N=100)
# koji se pomi�e jednu po jednu bazu pa i ja koristim 100 bp.

# �itanje podataka u character vektor duljine 1 (jedan string):
CpG <- scan("141105_CpG_small", what = "character", sep = "\n")
CpG <- CpG[-1]
CpG <- paste(CpG, sep = "", collapse = "")

# Funkcija pomi�nog zbroja move.sum:
# pomi�e se po argumentu x za 1 uzimaju�i 100 �lanova i na 
# zbraja ih.
# Koristi funkciju filter koja ustvari radi na time-series 
# podacima, ali ju koristim jer nisam na�ao neku drugu funkciju 
# koja je "kotrljaju�a", a sve petlje koje sam probao su 
# prespore na ovoliko puno podataka. 
move.sum <- function(x, n = 100){
  filter(x, rep(1, n), sides = 1)
}

# Slijede funkcije koje pomi�no zbrajaju CpG dinukleotide te 
# C i G nukleotid koji mi trebaju za izra�un pomi�nog prosjeka
# omjera primje�enih CpG/o�ekivanih CpG (Obs/Exp CpG). Koristim
# gore definiranu funkciju move.sum koja radi na brojevima.
# Zato pomo�u gsub u funkcijama zamjenjuje odgovaraju�e nukleotide
# s 1 i 0 i onda ih mogu pomi�no zbrajati.

# Izra�un pomi�nog zbroja CpG dinukleotida. 
# Prvo pomo�u vlastite funkcije only.CG sve CG dinukleotide
# zamjenjujem s 12, a onda sve 2 s 0. To radim da bi sa�uvao
# poredak nukeotida (zato stavljam dvoznamenkasti broj), a zatim
# zamjenjujem 2 s 0 da bi mogao "prebrojati" CG zbrajanjem jedinica.
# Nakon funkcije je prakti�ki svaki CpG dinukleotid zamijenjen
# sa 1, ali tako da iza slijedi 0 da bi poredak nukleotida ostao
# sa�uvan. Ostali nukleotidi su zamijenjeni s 0. 
# Zatim cijepam character vektor duljine 1 na vektor u kojem
# je svaki character odvojen. Na kraju na dobivenim brojevima
# funkcijom move.sum pomi�no zbrajam CpG dinukleotide, a kako
# funkcija vra�a objekt klase Time-Series, sve pretvaram u brojeve
only.CG <- function(x){
  y <- gsub("CG", 12, x)
  y <- gsub(2, 0, y)
  y <- gsub("[GATC]", 0, y)
  return(y)
}
CpG.num.CG <- only.CG(CpG)
CpG.num.CG <- unlist(strsplit(CpG.num.CG, split = ""))
CpG.num.CG <- as.numeric(move.sum(CpG.num.CG))

# Izra�un pomi�nog zbroja C nukleoida. Sli�no kao i kod CpG
# dinukleotida, koristim isti princip i move.sum funkciju.
only.C <- function(x){
  y <- gsub("C", 1, x)
  y <- gsub("[GAT]", 0, y)
  return(y)
}
CpG.num.C <- only.C(CpG)
CpG.num.C <- unlist(strsplit(CpG.num.C, split = ""))
CpG.num.C <- as.numeric(move.sum(CpG.num.C))
  
# Izra�un pomi�nog zbroja G nukleoida (sve isto kao iznad samo
# za G nukleotid)
only.G <- function(x){
  y <- gsub("G", 1, x)
  y <- gsub("[CAT]", 0, y)
  return(y)
}
CpG.num.G <- only.G(CpG)
CpG.num.G <- unlist(strsplit(CpG.num.G, split = ""))
CpG.num.G <- as.numeric(move.sum(CpG.num.G))


# Funkcija pomi�nog prosjeka move.average:
# pomi�e se po argumentu x za 1 uzimaju�i 100 �lanova i na 
# njima izra�unava prosjek. Koristi funkciju filter isto kao 
# move.sum (i iz istog razloga).
move.average <- function(x, n = 100){
  filter(x, rep(1/n, n), sides = 1) 
}

# Izra�un pomi�nog prosjeka C+G nukleotida uz funkciju move.average.
# Princip je skoro isti kao i kod pomi�nog zbrajanja, zamijenjujem
# sve G i C s 1, a sve A i T s O i pomo�u funkcije move.average
# ra�unam pomi�ni prosjek. 
only.C.plus.G <- function(x){
  y <- gsub("[GC]", 1, x)
  y <- gsub("[AT]", 0, y)
  return(y)
}
CpG.avg.CG <- only.C.plus.G(CpG)
CpG.avg.CG <- unlist(strsplit(CpG.avg.CG, split = ""))
CpG.avg.CG <- as.numeric(move.average(CpG.avg.CG))


# tablica u kojoj su kolone po redu: 
# - pomi�ni zbroj CpG
# - pomi�ni zbroj C
# - pomi�ni zbroj G
# - izra�un pomi�nog prosjeka Obs/Exp CpG
# - pomi�ni prosjek C+G nukleotida
CpG.df <- cbind(CpG.num.CG, CpG.num.C, CpG.num.G)
CpG.df <- data.frame(CpG.df)
CpG.df$"obs/exp" <- (CpG.df$CpG.num.CG/(CpG.df$CpG.num.C*CpG.df$CpG.num.G))*100
CpG.df <- cbind(CpG.df, CpG.avg.CG*100)
colnames(CpG.df) <- c("Number of CpG", "Number of C", 
                      "Number of G", "Obs/Exp", "%C+G")