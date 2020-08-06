#Load packages
library(tidyverse)
library(lme4)

#Load county-level NYS covid cases data
county_dt <- read.csv("us-counties.txt")
NYS <- county_dt %>% filter(state == "New York") 
#Process the dataset
NYS$date = as.POSIXct(strptime(NYS$date, format = "%Y-%m-%d"))
NYS$fips[is.na(NYS$fips)] = 36061 

#mobility data
mobility <- read.csv("DL-us-mobility-daterow.csv") %>% filter(admin1 == "New York") %>%
  filter(admin_level > 1) %>% select(date, fips, m50, m50_index)
mobility$date = as.POSIXct(strptime(mobility$date, format = "%Y-%m-%d"))

#Jion two tables
joi <- left_join(NYS, mobility, by = c("date", "fips")) %>% select(-state,-county)

#Clean data
dates <- unique(joi$date)
fips <- unique(joi$fips)
joi_1 <- joi %>% dplyr::select(date, fips,cases) %>% pivot_wider(names_from = fips, values_from = cases,
                                                                 values_fill = list(cases=0),
                                                                 values_fn = list(cases = list))
joi_1$`36061`[49] = 131273
joi_1$`36061`[48] = 127352
joi_1$`36061`[34] = 57160
joi_1$`36061`[35] = 63360
joi_1$`36061`[36] = 67552
joi_1$`36061`[37] = 68776

joi_2 <- joi_1 %>% dplyr::select(-date)

#Get daily increasing data from cumulative data
joi_3 <- joi %>% group_by(fips) %>%
  arrange(date,.by_group = TRUE) #%>%
#mutate(CASES_now = cases - lag(cases, default = first(cases))) 
for (i in fips) {
  ind_i = which(joi_3$fips==i)
  ind_i_1 = ind_i[1]
  joi_3$CASES_now[ind_i_1] = joi_3$cases[ind_i_1]
}

#The number of cases 4 days, 7 days and 1 day prior
joi_3 <- joi_3 %>% mutate(CASES_lag4 = lag(CASES_now, n = 4L)) %>%
  mutate(CASES_lag7 = lag(CASES_now, n = 7L)) %>%
  mutate(CASES_lag1 = lag(CASES_now, n = 1L)) 

#Key dates
as.Date(joi_3$date)
date1 = as.Date("2020-03-15")
ind1 = which(joi_3$date<date1)
date2 = as.Date("2020-03-20")
ind2 = which(joi_3$date<date2)
date3 = as.Date("2020-04-15")
ind3 = which(joi_3$date<date3)

#Creat indicators
#ÉèÖÃindicator
joi_3 <- joi_3 %>% mutate(ind_1 = 1, ind_2 = 1, ind_3=1,ind_4=1)
joi_3$ind_1[ind1] = 0
joi_3$ind_2[ind2] = 0
joi_3$ind_3[ind3] = 0
joi_3$ind_4[ind4] = 0
joi_3[is.na(joi_3)] = 0
