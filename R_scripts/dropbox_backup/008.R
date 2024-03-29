xyz <- c("plavo", "zeleno", "crveno", "�uto", "bijelo")

  # Kao �to sam objasnio u pro�lom zadatku, grep vra�a vrijednost
  # iz character vektora koja odgovara zadnom patternu ili vra�a 
  # smje�taj te vrijednosti u vektoru (ovisno o argumentu value)
  
  # grepl u character vektoru provjerava jednu po jednu vrijednost
  # za zadani pattern i vra�a TRUE ili FALSE za svaku vrijednost 
  # vektora s obzirom na to sadr�i li zadani pattern
  # (TRUE ako sadr�i, FALSE ako ne sadr�i). Primjer:

x <- grep("v", xyz, value = TRUE)
y <- grepl("v", xyz)
x
y

  # U primjeru provjeravamo koja rije� iz vektora xyz sadr�i slovo "v". 
  # x je dobiven grep funkcijom i sadr�i sve rije�i koje u sebi
  # imaju slovo "v". 
  # y je dobiven grepl funkcijom i sadr�i logi�ke vrijednosti po redu
  # za svaku rije� iz vektora xyz s obzirom na to sadr�i li slovo "v" ili ne.
  # Npr. na prvom mjestu u xyz je vrijednost "plavo" koja sadr�i "v" 
  # pa je prva vrijednost u logi�kom vektoru y TRUE. Na drugom mjestu
  # u xyz je "zeleno" �to ne sadr�i "l" pa je zato na drugom mjestu u 
  # logi�kom vektoru y FALSE itd. za sve vrijednosti iz vektora xyz.
  

