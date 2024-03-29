FASTA <- function(location){
  fasta.data <- readLines (location, warn = FALSE)
  xyz <- grep("^>", fasta.data) # pozicije u fasta.data na kojima se nalaze imena gena 
  seq.a <- xyz + 1 # pozicije na kojima po�inju sekvence gena 
  seq.z <- xyz - 1 # pozicije na kojima zavr�avaju sekvence gena
  seq.z <- seq.z[-1] # prva vrijednost je 0 pa ju odstranjujemo
  seq.z <- c(seq.z, length(fasta.data)) # dodamo na kraj poziciju na kojoj zavr�ava zadnja sekvenca
  
  sequence <- list()
  for (i in 1:length(seq.a)){
    sequence[i] <- paste(fasta.data[seq.a[i]:seq.z[i]], collapse="")
  }
  
  seq.name <- grep("^>", fasta.data, value = TRUE)
  seq.name <- gsub("^>", "", seq.name)
  sequence <- as.character(sequence)
  dt <- data.frame(seq.name, sequence)
  return(dt)
}

fasta.data.frame <- FASTA("fasta.txt")

# Moram priznati da mi je ideju kako napraviti ovaj zadatak dala 
# Dora (ovaj prvi dio u funkciji, kako dobiti pozicije na kojima 
# po�inju i zavr�avaju DNA sekvence, varijable seq.a i seq.b). 
# Tako�er nisam stigao napraviti provjeru ima li file koji u�itavamo
# pravilni format, to bi provjeravao s grep("^>") da vidim po�inje li 
# ime gena s ">", a sekvencu bi provjeravao s grep([GATC]) da vidim
# ima li u sekvenci nekih drugih slova osim GATC