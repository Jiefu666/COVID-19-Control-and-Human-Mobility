library(ggplot2)
library(dplyr)
library(pheatmap)
library(wesanderson)
library(RVAideMemoire)
library(lme4)
library(glmulti)
library(leaps)
library(MASS)
library(pscl)
library(dynlm)
library(glmnet)

#different moidels with different variables

#5 variables
data_1 = joi_3 %>% dplyr::select(CASES_lag4, m50, ind_1, ind_2, ind_3)
lm1 = lm(log(Y + 1)~.,data = data_1[,2:6])
poi1 = glm(Y~.,data = data_1[,2:6], family = poisson)
nb1 = glm(Y~.,data = data_1[, 2:6], family = negative.binomial(theta=1))
summary(lm1)
summary(poi1)
summary(nb1)
#In lm1, the p-values indicate ind_2, ind_3 not significant
#In nb1, the p-values indicate ind_1, ind_2 and ind_3 not significant

#CASES_lag4, m50, ind_1
data_2 = joi_3 %>% dplyr::select(CASES_lag4, m50, ind_1)
lm2 = lm(log(Y + 1)~.,data = data_2[,2:4])
poi2 = glm(Y~.,data = data_2[,2:4], family = poisson)
nb2 = glm(Y~.,data = data_2[, 2:4], family = negative.binomial(theta=1))
summary(lm2)
summary(poi2)
summary(nb2)

#CASES_lag4, m50
data_3 = joi_3 %>% dplyr::select(CASES_lag4, m50)
lm3 = lm(log(Y + 1)~.,data = data_3[,2:3])
poi3 = glm(Y~.,data = data_3[,2:3], family = poisson)
nb3 = glm(Y~.,data = data_3[, 2:3], family = negative.binomial(theta=1))
summary(lm3)
summary(poi3)
summary(nb3)

#AIC and BIC for each model
data.frame(LM_AIC = c(aic(lm1), aic(lm2), aic(lm3)),
           Pois_AIC = c(aic(poi1), aic(poi2), aic(poi3)),
           NB_AIC = c(aic(nb1), aic(nb2), aic(nb3)),
           LM_BIC = c(bic(lm1), bic(lm2), bic(lm3)),
           Pois_BIC = c(bic(poi1), bic(poi2), bic(poi3)),
           NB_BIC = c(bic(nb1), bic(nb2), bic(nb3)),
           row.names = c("CASES_lag4+m50+ind_1+ind_2+ind_3",
                         "CASES_lag4+m50+ind_1",
                         "CASES_lag4+m50"))

#Prediction (using nb2)
nyc_m50 = mobility %>% dplyr::filter(fips==36061)
nyc_data = joi_3 %>% dplyr::filter(fips == 36061)
#4.15-4.18
new_data_1 = data.frame(CASES_lag4 = c(7837, 4844, 4206, 3921),
                        m50 = c(0.019, 0.019, 0.019, 0.015),
                        ind_1 = c(1,1,1,1))
new_data_1$pred = predict(nb2, new_data_1, type = "response")

new_2 = data.frame(CASES_lag4 = 7837, m50 = 0.019, ind_1 = 1)
new_2$pred = log(predict(nb2, new_2, type = "response"))


nyc_data_4= joi_3%>%dplyr::filter(fips == 36061)
plot(x = nyc_data_4$date, y = nyc_data_4$CASES_now)


