# infix operatori su funkcije koje se pozivaju tako da ime funkcije dolazi 
# izme�u dva argumenta (za razliku od ve�ine funkcija koje su "prefix" operatori
# i kod kojih ime funkcije dolazi ispred argumenata). 

# %in% provjerava postoji li lijevi argument u desnom i vra�a
# logi�ku vrijednost (T ako postoji, F ako ne postoji). Primjer:

x <- 1:10
2 %in% x # vra�a TRUE jer 2 postoji u x
11 %in% x # vra�a FALSE jer 11 ne postoji u x
"b" %in% x # vra�a FALSE je "b" ne postoji u x

