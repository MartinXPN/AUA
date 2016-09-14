# Suppose relationship between 2 variables (x, y) is linear
# y = bx + a

# correlation -> positive (b>0) / negative (b<0)
# correlation != causation

load( 'College.rda' )
str(College)

rownames( College ) <- College$University
College$University <- NULL
View( College )

cor( College$Accept, College$Apps )
?cor

plot( College$Apps, College$Accept )
pairs( ~Apps + Accept + Enroll, data = College)
cor( College[,c( "Apps", "Accept", "Enroll" ) ] )
print( cor( College[,-1] ), digits = 2 )

plot( College[,-1] )
