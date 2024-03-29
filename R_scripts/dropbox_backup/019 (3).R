disc <- c(5, 3, 0, 2, 0, 3, 2, 3, 6, 1, 2, 1, 2, 1, 3, 3, 3, 5, 2, 4,
4, 0, 2, 3, 7, 12, 3, 10, 9, 2, 3, 7, 7, 2, 3, 3, 6, 2, 4, 3, 5, 2, 
2, 4, 0, 4, 2, 5, 2, 3, 3, 6, 5, 8, 3, 6, 6, 0, 5, 2, 2, 2, 6, 3, 4, 
4, 2, 2, 4, 7, 5, 3, 3, 0, 2, 2, 2, 1, 3, 4, 2, 2, 1, 1, 1, 2, 1, 4, 
4, 3, 2, 1, 4, 1, 1, 1, 0, 0, 2, 0);
tbl <- table(disc)
nm <- names(tbl)

# funkcija "table" prebroji koliko se pojedini element (kategorija)
# pojavljuje u vektoru i napravi tablicu u kojoj je svakom
# jedinstvenom elementu pridru�en broj ponavljanja u vektoru. 

# tbl varijabla sadr�i tablicu koja pokazuje koliko je puta u 
# godinama od 1850. do 1959. zabilje�en odre�en broj zna�ajnih 
# otkri�a. Npr. u tom je razdoblju u 12 pojedina�nih godina
# zabilje�eno 1 otkri�e, u 26 pojedin�anih godina 2 otkri�a itd.  

# nm varijabla sadr�i "imena" podataka u tablici, u na�em slu�aju
# imena su brojevi otkri�a (0 otki�a, 1 otkri�e, 2 otkri�a itd.).
# nm je vektor koji sadr�i character data type pa se podaci u njemu
# ne mogu manipulirati broj�anim operatorima (+ - * /). Za dijeljenje
# svakog �lana nm vektora sa dva podatke u njemu treba prije pretvoriti
# u numeri�ki tip podataka funkcijom as.numeric(nm):

nm_num <- as.numeric(nm)
nm_num <- nm_num/2
nm_num

# ra�unanje prosje�nog broja bitnih otki�a u periodu 1860-1959:
tbl_numeric <- as.numeric(tbl)
tbl_numeric
mean(tbl_numeric)
