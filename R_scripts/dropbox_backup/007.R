source("http://bioconductor.org/biocLite.R")
biocLite()
biocLite("ALL")

# Paket sadrzi podatke o T- i B-stanicama akutne limfaticne 
# leukemije (ALL) iz Ritz laboratorija na Dana Farber Cancer 
# Institute

library(ALL)

# A)
data(ALL)
# Ucitava data set iz paketa ALL
# Kada ucitamo neki package koji u sebi ima data.set taj data.set
# se ne u�itava automatski u memoriju zajedno s ostatkom paketa
# nego ga moramo pozvati s data kad ga trebamo. 
# To je napravljeno tako da se velika koli�ina podataka ne bi direktno
# u�itavala i nepotrebno zauzimala memoriju. 

exprs(ALL) 
# exprs pristupa podacima spremljenim u ExpressionSet
# ExpressionSet je tip pospremanja podataka dobivenih 
# "high-throughput" istrazivanjima.
# Podaci su spremljeni u matricu i to tako da redovi 
# predstavljaju setove proba, a stupci predstavljaju
# uzorke. 
# U ovom slucaju radi se o microarray podacima o ekspresiji 
# gena za akutnu limafaticnu leukemiju iz data seta ALL. 
# Imena redova imenuju "features" (tocku na microarrayu). 
# Imena stupaca predstavljaju imena uzoraka dobivenih iz pacijenata
# koji boluju od ALL. 

pData(ALL)
# pData naredba pristupa i daje podatke o uzorcima u ExpressionSetu
# ALL. U ovom slucaju imena redova su imena uzoraka, a
# u stupcima su smjesteni podaci o tom uzorku (pacijentu), npr., 
# dob, spol, datum dijagnoze itd. 


# B)
library(dplyr)

age.sex.F <- pheno.data.ALL %>%
  select(sex, age) %>%
  filter(sex == "F")

age.sex.M <- pheno.data.ALL %>%
  select(sex, age) %>%
  filter(sex == "M") 

#podaci za plot
hist.F <- hist(age.sex.F$age, plot = F)                     
hist.M <- hist(age.sex.M$age, plot = F)  

# plot - oba histograma na istom plotu s preklapanjem,
# �ene su prikazane rozo, mu�karci plavo, a na mjestu preklapanja
# je ljubi�asta (semitransparentne boje)

plot(hist.F, col = rgb(1, 0, 1, 0.25), xlim = c(0, 80), 
     ylim = c(0, 25), xlab = "Age",    
     main = "Distribution of age of female and male ALL patients")
plot(hist.M, col = rgb(0, 0, 1, 0.25), xlim = c(0, 80), 
     ylim = c(0, 25), add = T) 
legend('topright', c('M','F'), bty = 'n', border = NA,
       fill = c(rgb(0, 0, 1, 0.25), rgb(1, 0, 0, 0.25)))


# C) 
pheno.data.ALL <- pData(ALL)

# Poslo�imo tablicu tako da imamo pacijente samo s BCL/ABL 
# leukemijom i gledamo samo relapse i transplant stupce: 
bcr.abl <- pheno.data.ALL %>%
  select(mol.biol, relapse, transplant) %>%
  filter(mol.biol == "BCR/ABL", transplant != "NA") %>% 
  arrange(desc(transplant)) %>% 
  select(-1)

# u posebne tablice odvajam pacijente koji su primili transplant
# od onih koji nisu, grupiram pod relapseu i zbrajam koliko ima
# onih koji jesu u relapseu, a koliko onih koji nisu: 

transplant.TRUE <- bcr.abl %>%
  filter(transplant == "TRUE") %>%
  group_by(relapse) %>%
  summarise(n())

transplant.FALSE <- bcr.abl %>%
  filter(transplant == "FALSE") %>%
  group_by(relapse) %>%
  summarise(n())

# Brojeve stavljam u zajedni�ku tablicu i to tako da su u 
# stupcima transplant+ i transplant-, a u redovima relapse-
# i relapse+, tablica prikazuje koliko kojih pacijenata ima

transplant.all <- cbind(transplant.TRUE$"n()", transplant.FALSE$"n()")
colnames(transplant.all) <- c("transplant +", "transplant -")
rownames(transplant.all) <- c("relapse -", "relapse +")

# Na toj tablici radim Fisherov test, null hipoteza je da 
# relapse ne ovisi o tome je li primljen transplant 
fisher.test(transplant.all)

# p-vrijednost je 0.045 �to zna�i da sa 95.5% sigurno��u odbacujemo
# null hipotezu, tj. 95.5% je �ansa da transplant utje�e na 
# relapse


# D) 

# Iz pheno.data uzimam samo stupce koji prestavljaju mol.biol tumora
# i cod uzoraka
# Filtriram tablicu tako je u mol.biol samo BCR/ABL leukemija ili
# negativni uzorci. Imenujem redove prema codu s tim da dodajem
# "0" na po�etak:

bcr.abl.neg <- subset(pheno.data.ALL, select = "mol.biol")
bcr.abl.neg <- subset(bcr.abl.neg, subset = (mol.biol == "BCR/ABL" | mol.biol == "NEG"))

# Iz exprs.data uzimam samo one stupce �ija imena odgovaraju
# imenima redova u pheno.data za BCR/ABL i negativne uzorke:

exprs.data.ALL <- exprs(ALL)

exprs.data.bcr.abl.neg <- subset(exprs.data.ALL, 
                                 select = (colnames(exprs.data.ALL) %in% rownames(bcr.abl.neg))) 

# exprs.data.bcr.abl.neg ima 111 stupaca �to je jednako broju
# pacijenata s BCR/ABL mutacijom ili negativnim uzorkom 


# E) 

# 1. t-test - null hipoteza je da su srednje vrijednosti uzoraka
# jednake, tj. da su uzorci jednaki. p-vrijednost daje vjerojatnost
# da je hipoteza to�na. Vjerojatnost da hipoteza nije to�na, 
# tj. vjerojatnost da su uzorci razli�iti je ((1-p.vrijednost)*100)%

# subset normalnih uzoraka iz exprs.data.ALL
norm.samp <- subset(pheno.data.ALL, select = "mol.biol", 
                    subset = (mol.biol == "NEG"))
norm.samp.exprs <- subset(exprs.data.ALL, 
                          select = (colnames(exprs.data.ALL) %in% rownames(norm.samp)))

# subset patogenih uzoraka iz exprs.data.ALL
gene.samp <- subset(pheno.data.ALL, select = "mol.biol", 
                    subset = (mol.biol == "BCR/ABL"))
gene.samp.exprs <- subset(exprs.data.ALL, 
                          select = (colnames(exprs.data.ALL) %in% rownames(gene.samp))) 

# t-test
# prvo sam napravio transpose data.frame dobivenih iznad kako bi
# mogao primijeniti mapply.
# Nakon mapply u t.test.results matrici imam sve vrijedosti t-testa
# u redovima, a u stupcima su pojedini geni. Zato radim transpose
# i pretvaram u data.frame da bi na njemu mogao raditi s dpylr
# funkcijama. Zatim izbacujem sve stupce iz data.framea osim one 
# s p-vrijednostima. I na kraju u stupac "probability" stavljam 
# vrijednosti vjerojatnosti da je null hipoteza neto�na, tj. 
# vjerojatnost da je ekspresija pojedinog gena razli�ita u 
# normalnim i patogenim uzorcima

norm.samp.exprs.t <- as.data.frame(t(norm.samp.exprs))
gene.samp.exprs.t <- as.data.frame(t(gene.samp.exprs))
t.test.results <- mapply(t.test, x = gene.samp.exprs.t, 
                         y = norm.samp.exprs.t, SIMPLIFY = T)
t.test.results <- as.data.frame(t(t.test.results))
t.test.results <- subset(t.test.results, select = "p.value")
t.test.results$probability <- round(as.numeric(t.test.results$p.value), digits = 5)*100
        
# 2.
a <- as.numeric(t.test.results$"p.value")
p.adj <- p.adjust(a, "fdr")

# Odbacujemo null hipotezu ako je vjerojatnost da podaci odgovaraju 
# null hipotezi mala (p<0.05 npr). Problem je �to kada pove�avamo
# broj hipoteza u testu, pove�ava se i vjerojatnost da nai�emo na
# neki rijetki doga�aj zbog kojeg �emo onda odbaciti null hipotezu
# kada je istinita. Kada uspore�ujemo dvije skupine u puno razli�itih
# kategorija, vjerojatnost da �emo nai�i na razliku u barem jednoj 
# od tih kategorija se pove�ava �istim slu�ajem, tj. zato jer ih 
# uspore�ujemo vi�e puta. Primjer: promatramo kako lijek djeluje
# na simptome neke bolesti i gledamo koliko je u�inkovit. 
# �to vi�e simptoma promatramo, ve�a je �ansa da �e lijek ispasti
# u�inkovitiji od postoje�eg lijeka u lije�enju barem jednog od tih 
# simptoma. 
# U na�em slu�aju mi promatramo razliku u ekpresiji gena u puno
# uzoraka, a promatramo ih sve skupa. Postoji �ansa da je ekspresija
# gena u jednom od tih uzoraka slu�ajno ve�a ili manja �isto zato
# jer promatramo puno uzoraka �to �e onda utjecati na p-vrijednost
# dobivene t-testom. 
# Zato koristimo ispravak tih p-vrijednosti FDR metodom pomo�u koje
# kontroliramo o�ekivani postotak neto�no odbijenih null hipoteza
# ("la�na otkri�a"). Ako je p=0.05 tada o�ekujemo da �emo u 5% 
# slu�ajeva odbaciti null hipotezu koja je ustvari bila to�na. 
# Pomo�u FDR metode ispravaka p-vrijednosti ta razina neto�nih
# odbacivanja null hipoteza se dr�i na prihvatljivoj razini. 

# 3. 
# moramo odvojiti 50 gena s najve�om razlikom u ekpresiji gena 
# izme�u patogenih i normalnih uzoraka, tj. gene s najmanjom
# q-vrijednosti

t.test.results$"q.value" <- round(p.adj, digits = 5)
top.50.genes <- subset(t.test.results, select = "q.value")
top.50.genes$gene.names <- rownames(top.50.genes)
top.50.genes <- top.50.genes[, c(2, 1)]
top.50.genes <- arrange(top.50.genes, q.value)
top.50.genes <- head(top.50.genes, 50)

top.50.pheno <- subset(pheno.data.ALL, select = "mol.biol", 
                       subset = (mol.biol == "NEG" | mol.biol == "BCR/ABL"))
exprs.data.top.50 <- subset(exprs.data.ALL, 
                            select = (colnames(exprs.data.ALL) %in% rownames(top.50.pheno)))
top.50.rownames <- row.names(exprs.data.top.50)
exprs.data.top.50 <- as.data.frame(exprs.data.top.50, 
                                   row.names = top.50.rownames)
exprs.data.top.50$gene.names <- top.50.rownames

logical.names <- rownames(exprs.data.top.50) %in% top.50.genes$gene.names
exprs.data.top.50 <- subset(x = exprs.data.top.50,
                          subset = (logical.names))
exprs.data.top.50 <- exprs.data.top.50[-112]

# 4. 

# 5. Heatmap
matrix.top.50 <- data.matrix(exprs.data.top.50)
top.50.heatmap <- heatmap(matrix.top.50, Colv=NA, scale="column")

# heatmapa je na�in prikazivanja podataka pomo�u boja