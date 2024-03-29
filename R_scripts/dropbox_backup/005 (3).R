# U prvom zadatku ra�unamo mass probability function
# diskretne uniformne distribucije. Diskretna distribucija zna�i
# da brojevi pri bacanju kocke mogu zauzeti to�no unaprijed odre�ene 
# vrijednosti i zato su na grafu predstavljeni to�kom. Pri bacanju 
# kocke ishod ne mo�e zauzeti vrijednost npr. 2.5 ili 3.8 nego samo
# cijeli broj izme�u 1 i 6. Uniformna distribucija zna�i da postoji 
# jednaka vjerojatnost da ishod bacanja kocke bude bilo koji cijeli 
# broj izme�u 1 i 6. 

# Dunif se koristi za izra�un probability density function
# kod kontinuirane uniformne distribucije. Kod kontinuirane 
# uniformne distribucije svi intervali jednake duljine izme�u
# minimalne i maximalne vrijednosti su jednako vjerojatni. Zato na 
# grafu to vidimo kao crtu, tj. interval. 

# Kada bi u prvom zadatku koristili dunif ne bi ra�unali 
# probability mass function bacanja kocke kao sada (koliko je 
# vjerojatno da ishod bacanja kocke bude npr. 2) nego probability 
# density function (koliko je vjerojatno da kocka zauzme bilo koju
# vrijednost izme�u 0 i 6). Bez obzira koristimo li kao argument u
# funkciji 2 ili 4.5 dobiveni ishod je  0.1666667

x <- dunif (2, max=6)
y <- dunif (4.5, max=6)
if (x==y) print("ishod je isti bez obzira na argument") else print("ne�to sam zeznuo")

