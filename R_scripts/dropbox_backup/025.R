iris
a <- iris[["Sepal.length"]]
a
b <- iris[1]
d <- iris[[1]]
d

class(a)
class(b)
class(d)

# iris[["Sepal.length"]] vra�a NULL
# iris[1] vra�a data.frame s vrijednostima iz prvog stupca data frame iris
# iris[[1]] vra�a numeri�ke vrijednosti iz prvog stupca iris 

is.list(iris)
# data.frame je vrsta liste