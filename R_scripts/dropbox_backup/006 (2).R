my.data.Char <- read.table("gene_with_protein_product.txt", header = T, 
                           sep =  "\t", fill = TRUE, quote = "", 
                           stringsAsFactors = F)
a <- grep("^HGNC", my.data.Char$HGNC.ID, value = T) == my.data.Char$HGNC.ID
  
  # a je logi�ka varijabla u kojoj su T i F vrijednosti usporedbe HGNC.ID
  # stupca my.data.Char data.frame-a i character varijable dobivene grep 
  # funkcijom koja iz tog istog stupca uzima sve vrijednosti koje po�inju s
  # HGNC

all(a)
  
  # all(a) vra�a vrijednost TRUE ako su sve vrijednosti u a TRUE 
  # (vra�a FALSEako je barem jedna vrijednost FALSE)

