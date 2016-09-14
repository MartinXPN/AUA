load( 'College.rda' )

View( College )

# 1. numberic var ~ 2. categoric var
t.test( College$Apps ~ College$Private )      # 2.5 times difference
t.test( College$Enroll ~ College$Private )    # 4 times difference
t.test( College$Personal ~ College$Private )  # no difference

data <- read.csv( 'Titanic_imputed.csv' )
View( data )

data$pclass <- factor( data$pclass, labels = c( "rich", 'normal', 'poor' ), levels = c( 1, 2, 3 ) )
View( data )
