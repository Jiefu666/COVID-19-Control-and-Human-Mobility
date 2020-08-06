# COVID-19-Control-and-Human-Mobility
Use public mobilty data from New York State to elucidate the role of human mobilty and ascertain the impact of control measures.


## Data Source
* COVID-19 data in the United States: [nytimes](https://github.com/nytimes/covid-19-data)
* Data for Mobility Changes in Response to COVID-19: [Descartes Labs](https://github.com/descarteslabs/DL-COVID-19)
* [NYS COVID19 Response Timeline](https://abcnews.go.com/US/News/timeline-100-days-york-gov-andrew-cuomos-covid/story?id=71292880): Testing Available date and some other import policy change dates.

## Method
We got the inspiration from this [paper](science.sciencemag.org/cgi/content/full/science.abb4218/DC1). We focused on the COVID-19 cases and mobilty data for each county in New York State.
* We fit a mixed effects Poisson GLM of daily case counts to days since the first case report in each county (fixed effect) and a random effect for each province on the slope and intercept to estimate the epidemic doubling time across each county;
* To evaluate hypotheses regarding the effect of mobility and testing on COVID-19 dynamics, we fit three different Generalized Linear Models (GLM). Model 1 was a Poisson GLM to estimate daily case counts, Model 2 was a negative binomial GLM to estimate daily case counts, and Model 3 was a log-linear regression to estimate daily cumulative cases. The three models were compared using differences in BIC and AIC. 
* BIC and AIC scores are calculated on a GLM of the form Y(t) = Y(t-4) + m50 + I_1(t) + I_2(t) +I_3(t), where Y(t) is either the number of new cases observed on day t (Model 1 & 2) or cumulative number of cases observed through day t (Model 3), Y(t-4) represents the number of cases (or the cumulative number under Model 3) four days prior (median doubling time in New York State), IT_1(t), IT_2(t) and IT_3(t) are three indicator functions, and m50 is the mobilty index. We tried different models with different indicators to evaluate which are the key indicators.
