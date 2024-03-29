x <- 1:10
sample(x, size=5)

# Funkcija "sample" uzima nasumi�an uzorak veli�ine n iz vektora 
# duljine m. Ako ne preciziramo "size" uzima nasumi�an uzorak duljine
# jednake duljini vektora (permitira vektor): 

x <- 1:10
sample(x)

# Parametar "replace" dozvoljava da jedan �lan vektora bude izabran
# vi�e puta:

x <- 1:10
sample(x, replace=TRUE)

#Pomo�u tog vektora mogu�e je uzeti nasumi�an uzorak 
# vektora koji je ve�i od same veli�ine vektora:

x <- 1:10
sample(x, size=15, replace=TRUE)
