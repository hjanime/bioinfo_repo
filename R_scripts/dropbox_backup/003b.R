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
# koji se pomi�e jednu po jednu bazu. 

CpG <- scan("141107_CpG", what = "character", sep = "\n")
a <- grep(">", CpG)
CpG <- CpG[-a]
CpG <- paste(CpG, sep = "", collapse = "")


# Izra�un pomi�nog zbroja CpG dinukleotida. Zbrajam CpG dinukleodite
# u bazama 1:100, pa zatim 2:101, pa 3:102 itd. 

# Prvo pomo�u vlastite funkcije only.CG sve CG dinukleotide
# zamjenjujem s 12, a onda sve 2 s 0. To radim da bi sa�uvao
# poredak nukeotida (zato stavljam dvoznamenkasti broj), a zatim
# zamjenjujem 2 s 0 da bi mogao "prebrojati" CG zbrajanjem jedinica.
# Nakon funkcije je prakti�ki svaki CpG dinukleotid zamijenjen
# sa 1, ali tako da iza slijedi 0 da bi poredak nukleotida ostao
# sa�uvan. Ostali nukleotidi su zamijenjeni s 0. 

# Zatim cijepam character vektor duljine 1 na vektor u kojem
# je svaki character odvojen. Na kraju na dobivenim brojevima
# funkcijom move.sum pomi�no zbrajam CpG dinukleotide. 

# Funkcija pomi�nog zbroja move.sum:
# pomi�e se po argumentu x za 1 uzimaju�i 100 �lanova i 
# zbraja ih. Koristi funkciju filter koja ustvari radi na 
# time-series  podacima, ali ju koristim jer nisam na�ao neku 
# drugu funkciju koja je "kotrljaju�a", a sve petlje koje sam
# probao su prespore na ovako puno podataka.
# Funkcija vra�a objekt klase Time-Series pa sve pretvaram u 
# brojeve.

# Cijelo vrijeme koristim istu varijablu (ma�tovitog naziva xyz)
# kako mi se ne bi nakupljale velike varijable i zauzimale memoriju.
# Ionako sve odmah stavljam u data.frame. 

only.CG <- function(x){
  y <- gsub("CG", 12, x)
  y <- gsub(2, 0, y)
  y <- gsub("[GATC]", 0, y)
  return(y)
}

move.sum <- function(x, n = 100){
  filter(x, rep(1, n), sides = 1)
}

xyz <- only.CG(CpG)
xyz <- unlist(strsplit(xyz, split = ""))
xyz <- as.numeric(move.sum(xyz))
CpG.df <- data.frame(xyz)
colnames(CpG.df) <- "Number of CpG"

# Zbrajanje C i G nukleotida radim malo druk�ije, 
# pretvaranje nukleotida u brojeve radim pomo�u faktora. 
# Mislim da je ovo br�i na�in nego da radim analogno ovom iznad
# (gsub).

# Prije svega vektor duljine 1 sa svim bazama pretvaram
# u vektor duljine jednakoj duljini sekvence u kojoj je svaka
# baza zasebni �lan vektora.

CpG <- unlist(strsplit(CpG, split = ""))

xyz <- factor(CpG) # levels(CG.mov.avg) = A C G T
levels(xyz) <- c(0, 1, 0, 0) 
xyz <- as.character(xyz)
xyz <- as.numeric(move.sum(xyz))
CpG.df <- cbind(CpG.df, xyz)
colnames(CpG.df) <- c("Number of CpG", "Number of C")

xyz <- factor(CpG) # levels(CG.mov.avg) = A C G T
levels(xyz) <- c(0, 0, 1, 0) 
xyz <- as.character(xyz)
xyz <- as.numeric(move.sum(xyz))
CpG.df <- cbind(CpG.df, xyz)
colnames(CpG.df) <- c("Number of CpG", "Number of C", "Number of G")

# U kolonu Obs/Exp stavljam rezultate izra�una pomi�nog prosjeka
# primje�enih CpG/o�ekivanih CpG (Obs/Exp CpG):
CpG.df$"Obs/Exp" <- (CpG.df$"Number of CpG"/
                       (CpG.df$"Number of C"
                        *CpG.df$"Number of G"))*100

# Izra�un pomi�nog prosjeka C+G. Radi sli�no kao i izra�un 
# pomi�nog zbrajanja samo �to funkcija ra�una pomi�ni prosjek;
# uzima prvih �lanove od 1:100 i ra�una njihov prosjek, zatim
# 2:101, pa 3:102 itd. Isto kao i move.sum koristi funkciju 
# factor (i iz istog razloga). Levels faktora su pomno�eni sa
# 100 kako bi dobio postotak. 

move.average <- function(x, n = 100){
  filter(x, rep(1/n, n), sides = 1) 
}

xyz <- factor(CpG) # levels(CG.mov.avg) = A C G T
levels(xyz) <- c(0, 100, 100, 0) 
xyz <- as.character(xyz)
xyz <- as.numeric(move.average(xyz))
CpG.df <- cbind(CpG.df, xyz)
colnames(CpG.df) <- c("Number of CpG", "Number of C", 
                      "Number of G", "Obs/Exp", "%C+G")
