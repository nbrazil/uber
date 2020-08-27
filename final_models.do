
***********************************************
***********************************************
*Runs the following models
*
*Main model (Table 2)
**Years: 2009-2017
**Model: Poisson
**Dep vars: (1) total fatalities (2) holiday/weekend fatalities (3) alcohol involved fatalities
**Exposure: County x year x month VMT
**Treatment: Dichotomous Uber active/not active
**Variables included
***(1) Treatment
****(2) Treatment, unemp rate, population, county, month x year FEs, county linear time trend

*Sensitivity analyses (Web appendix tables)
**(1) Exclude New York, San Francisco, Los Angeles
**(2) Uber or Lyft treatment indicator
**(3) UberX indicator
**(4) Number of accidents as outcome
**(5) County specific quadratice time trend
**(6) Include controls from previous study
**(7) Negative binomial regression
**(8) Ordinary least squares regression - log fatalities + 1
**(9) Ordinary least squares regression - fatalities per population
***********************************************
***********************************************



*null model
poisson fatal uber_active  , exposure(vmt) cluster(cfips) irr
poisson weekend_holidayb uber_active  , exposure(vmt) cluster(cfips) irr
poisson drunkdriverb uber_active  , exposure(vmt) cluster(cfips) irr

*full model
poisson fatal uber_active month#year i.cfips##c.time  unemp pop  , exposure(vmt) cluster(cfips) irr
poisson weekend_holidayb uber_active month#year i.cfips##c.time  unemp pop  , exposure(vmt) cluster(cfips) irr
poisson drunkdriverb uber_active month#year i.cfips##c.time  unemp pop  , exposure(vmt) cluster(cfips) irr

*uber or lyft
poisson fatal uber_or_lyft month#year i.cfips##c.time  unemp pop  , exposure(vmt) cluster(cfips) irr
poisson weekend_holidayb uber_or_lyft month#year i.cfips##c.time  unemp pop  , exposure(vmt) cluster(cfips) irr
poisson drunkdriverb uber_or_lyft month#year i.cfips##c.time  unemp pop  , exposure(vmt) cluster(cfips) irr

*uber x
poisson fatal uberx_active month#year i.cfips##c.time  unemp pop  , exposure(vmt) cluster(cfips) irr
poisson weekend_holidayb uberx_active month#year i.cfips##c.time  unemp pop  , exposure(vmt) cluster(cfips) irr
poisson drunkdriverb uberx_active month#year i.cfips##c.time  unemp pop  , exposure(vmt) cluster(cfips) irr

*controls from previous study
poisson fatal uber_active month#year i.cfips##c.time   unemp  decrim gdl hh med_mar per_se  primsb txt_ban bt taxi_county_rate  , exposure(vmt) cluster(cfips) irr
poisson weekend_holidayb uber_active month#year i.cfips##c.time   unemp  decrim gdl hh med_mar per_se  primsb txt_ban bt taxi_county_rate  , exposure(vmt) cluster(cfips) irr
poisson drunkdriverb uber_active month#year i.cfips##c.time   unemp  decrim gdl hh med_mar per_se  primsb txt_ban bt taxi_county_rate  , exposure(vmt) cluster(cfips) irr

*quadratic
poisson fatal uber_active month#year i.cfips##c.time2  unemp pop  , exposure(vmt) cluster(cfips) irr
poisson weekend_holidayb uber_active month#year i.cfips##c.time2  unemp pop  , exposure(vmt) cluster(cfips) irr
poisson drunkdriverb uber_active month#year i.cfips##c.time2  unemp pop  , exposure(vmt) cluster(cfips) irr

*negative binomial
*null model
nbreg fatal uber_active  , exposure(vmt) cluster(cfips) irr
nbreg weekend_holidayb uber_active , exposure(vmt) cluster(cfips) irr
nbreg drunkdriverb uber_active , exposure(vmt) cluster(cfips) irr

*full model
nbreg fatal uber_active month#year i.cfips##c.time  unemp pop  , exposure(vmt) cluster(cfips) irr
nbreg weekend_holidayb uber_active month#year i.cfips##c.time  unemp pop  , exposure(vmt) cluster(cfips) irr
nbreg drunkdriverb uber_active month#year i.cfips##c.time  unemp pop  , exposure(vmt) cluster(cfips) irr

*OLS - log fatal + 1
reg fatal2 uber_active month#year i.cfips##c.time  unemp pop  , cluster(cfips) 
reg weekend_holidayb2 uber_active month#year i.cfips##c.time  unemp pop  ,  cluster(cfips) 
reg drunkdriverb2 uber_active month#year i.cfips##c.time  unemp pop  , cluster(cfips) 

*OLS - fatal per pop
reg fatal3 uber_active month#year i.cfips##c.time  unemp pop  , cluster(cfips) 
reg weekend_holidayb3 uber_active month#year i.cfips##c.time  unemp pop  ,  cluster(cfips) 
reg drunkdriverb3 uber_active month#year i.cfips##c.time  unemp pop  , cluster(cfips) 

*accidents
poisson crashes uber_active month#year i.cfips##c.time  unemp pop  , exposure(vmt) cluster(cfips) irr
poisson weekend_holidaya uber_active  month#year i.cfips##c.time  unemp pop  , exposure(vmt) cluster(cfips) irr
poisson drunkdrivera uber_active month#year i.cfips##c.time  unemp pop  , exposure(vmt) cluster(cfips) irr

*excludes LA, SF and NY

poisson fatal uber_active month#year i.cfips##c.time  unemp pop if largecity != 1 , exposure(vmt) cluster(cfips) irr
poisson weekend_holidayb uber_active month#year i.cfips##c.time  unemp pop if largecity != 1  , exposure(vmt) cluster(cfips) irr
poisson drunkdriverb uber_active month#year i.cfips##c.time  unemp pop  if largecity != 1 , exposure(vmt) cluster(cfips) irr


*Tobit models

*log fatal + 1
tobit fatal2 uber_active month#year i.cfips##c.time  unemp pop  , vce(cluster cfips) ll
tobit weekend_holidayb2 uber_active month#year i.cfips##c.time  unemp pop  ,  vce(cluster cfips) ll
tobit drunkdriverb2 uber_active month#year i.cfips##c.time  unemp pop  , vce(cluster cfips) ll

*fatal per pop
tobit fatal3 uber_active month#year i.cfips##c.time  unemp pop  , vce(cluster cfips) ll
tobit weekend_holidayb3 uber_active month#year i.cfips##c.time  unemp pop  ,  vce(cluster cfips) ll
tobit drunkdriverb3 uber_active month#year i.cfips##c.time  unemp pop  , vce(cluster cfips) ll


*Autoregressive (1) and (2)

gen date =  ym(year, month) 
format date %tm

tsset GEOID date

poisson fatal L.fatal uber_active month#year i.cfips##c.time  unemp pop  , exposure(vmt) cluster(cfips ) irr
poisson fatal L.fatal L2.fatal uber_active month#year i.cfips##c.time  unemp pop  , exposure(vmt) cluster(cfips ) irr

poisson weekend_holidayb L.weekend_holidayb uber_active month#year i.cfips##c.time  unemp pop  , exposure(vmt) cluster(cfips) irr
poisson weekend_holidayb L.weekend_holidayb L2.weekend_holidayb uber_active month#year i.cfips##c.time  unemp pop  , exposure(vmt) cluster(cfips) irr

poisson drunkdriverb L.drunkdriverb uber_active month#year i.cfips##c.time  unemp pop  , exposure(vmt) cluster(cfips) irr
poisson drunkdriverb L.drunkdriverb L2.drunkdriverb uber_active month#year i.cfips##c.time  unemp pop  , exposure(vmt) cluster(cfips) irr


