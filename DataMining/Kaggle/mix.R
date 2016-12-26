pred1 <- read.csv('gbm_500.csv')
pred2 <- read.csv('ksvm.csv')
pred3 <- read.csv('RF_sub.csv')
pred4 <- read.csv('xgboost.csv')
pred_prob_1 <- pred1$Class
pred_prob_2 <- pred2$Class
pred_prob_3 <- pred3$Class
pred_prob_4 <- pred4$Class

pred_prob_average <- (pred_prob_1 + pred_prob_2 + pred_prob_3 + pred_prob_4) / 4

num_0 <- pred_prob_1*0
num_0 <- ifelse(pred_prob_1 < 0.2, 1, 0) + 
  ifelse(pred_prob_2 < 0.2, 1, 0) + 
  ifelse(pred_prob_3 < 0.2, 1, 0) + 
  ifelse(pred_prob_4 < 0.2, 1, 0) 
num_1 <- ifelse(pred_prob_1 > 0.8, 1, 0) + 
  ifelse(pred_prob_2 > 0.8, 1, 0) + 
  ifelse(pred_prob_3 > 0.8, 1, 0) + 
  ifelse(pred_prob_4 > 0.8, 1, 0) 

pred_prob_final <- pred_prob_average
for( i in c( 1 : length( pred_prob_average ) ) ) {
  if(num_1[i] >= 3) {
    pred_prob_final[i] <- 1
  } 
  else if(pred_prob_average[i] > 0.85) {
    pred_prob_final[i] <- 1
  } 
  else if(num_0[i] >= 3) {
      pred_prob_final[i] <- 0
  }
  else if(pred_prob_average[i] < 0.15) {
    pred_prob_final[i] <- 0
  }
}

real <- read.csv( 'mix_all.csv' )
real_prob <- real$Class
for( i in c( 1 : length( real_prob ) ) ) {
  if( real_prob[i] != pred_prob_final[i] && real_prob[i] == 1) {
    print( real_prob[i] )
  }
}

write.csv(pred_prob_final, 'final_probabilities.csv', row.names = T)
