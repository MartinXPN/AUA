data( iris )
View( iris )
iris <- subset( iris, subset = ( iris$Species != 'virginica' ) ) # remove virginica from data to work only with two variables
iris$Species <- factor( iris$Species )                           # forget about virginica

library( e1071 )
model <- svm( Species ~ Sepal.Width + Sepal.Length , data = iris, kernel = 'linear' )  # use linear SVM
plot( model, data = iris, Sepal.Length ~ Sepal.Width )                                 # plot the data X-s are the support vectors

polynomial_model <- svm( Species ~ Sepal.Width + Sepal.Length , data = iris, kernel = 'polynomial' ) # use linear SVM
plot( polynomial_model, data = iris, Sepal.Length ~ Sepal.Width )                                    # plot the data X-s are the support vectors
