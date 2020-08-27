
***********************************************
***********************************************
*Runs moderation models
*
**Years: 2009-2017
**Model: Poisson
**Dep vars: (1) total fatalities (2) holiday/weekend fatalities (3) alcohol involved fatalities
**Exposure: County x year x month VMT
**Treatment: Dichotomous Uber active/not active
**Variables included
***(1) Treatment
****(2) Treatment, unemp, population, county, month x year FEs, county linear time trend

*Moderators
**Population
***(1) Total population
***(2) Population density
***(3) Urban centrality (% living in census urban area)

**Demographic
***(1) Log median household income
***(2) Percent college educated
***(3) Percent 20-39 year olds

**Transportation
***(1) Number of available vehicles per housing unit
***(2) % of total vehicle miles traveled (VMT) that are attributed to public transit vehicles
***(3) % of total VMT that are attributed to rail specific public transit
***(4) % of working-age residents living in block groups with access to at least one transit 
***		stop within ¾ mile of their population weighted centroid
***(5) Average number of minutes that commuters must wait between bus or train stops

**Alcohol usage/access
***(1) Number of drinking establishments per area
***(2) % of adults reporting drinking any alcohol in the past 30 days of being surveyed
***(3) % percent of adults reporting binge or heavy drinking in the past 30 days of being surveyed

**Categorize moderators into below 25th %tile, 25th-75th %tile, above 75th %tile on sample distribution
***********************************************
***********************************************


*create high, mid and low categories 

foreach var of varlist tpop  popdensity puapop vehhh vmtt_rate vmtr_rate ser_all lmhh p2039 col anyall alc drinkpld {

	astile `var'_cat =`var',nq(4)
	recode `var'_cat (1=1) (2=0) (3=0) (4=2)
	
	}
	

*Moderator models
	
foreach var of varlist tpop  popdensity puapop vehhh vmtt_rate vmtr_rate ser_all lmhh p2039 col anyall alc drinkpld {

	*dependent var - total fatalities

	poisson fatal month#year  i.cfips##c.time  unemp pop  uber_active##`var'_cat, exposure(vmt) cluster(cfips) irr 
	margins `var'_cat#uber_active, predict(ir) noestimcheck post
	nlcom (risk_ratio0: _b[0bn.`var'_cat#1.uber_active] / _b[0bn.`var'_cat#0bn.uber_active]) (risk_ratio1: _b[1bn.`var'_cat#1.uber_active] / _b[1bn.`var'_cat#0bn.uber_active]) (risk_ratio2: _b[2bn.`var'_cat#1.uber_active] / _b[2bn.`var'_cat#0bn.uber_active])
	
	*dependent var - weekend/holidays

	poisson weekend_holidayb  month#year  i.cfips##c.time  unemp pop  uber_active##`var'_cat, exposure(vmt) cluster(cfips) irr 
	margins `var'_cat#uber_active, predict(ir) noestimcheck post
	nlcom (risk_ratio0: _b[0bn.`var'_cat#1.uber_active] / _b[0bn.`var'_cat#0bn.uber_active]) (risk_ratio1: _b[1bn.`var'_cat#1.uber_active] / _b[1bn.`var'_cat#0bn.uber_active]) (risk_ratio2: _b[2bn.`var'_cat#1.uber_active] / _b[2bn.`var'_cat#0bn.uber_active])

	
	*dependent var - alcohol involved

	poisson drunkdriverb  month#year  i.cfips##c.time  unemp pop  uber_active##`var'_cat, exposure(vmt) cluster(cfips) irr 
	margins `var'_cat#uber_active, predict(ir) noestimcheck post
	nlcom (risk_ratio0: _b[0bn.`var'_cat#1.uber_active] / _b[0bn.`var'_cat#0bn.uber_active]) (risk_ratio1: _b[1bn.`var'_cat#1.uber_active] / _b[1bn.`var'_cat#0bn.uber_active]) (risk_ratio2: _b[2bn.`var'_cat#1.uber_active] / _b[2bn.`var'_cat#0bn.uber_active])

}


*plots for Figure 2
*Alcohol involved fatalities

*Transportation related variables

estimates clear

poisson drunkdriverb  month#year  i.cfips##c.time  unemp pop uber_active##vehhh_cat, exposure(vmt) cluster(cfips) irr
margins vehhh_cat#uber_active if vehhh_cat >0,  predict(ir) noestimcheck post
nlcom (risk_ratio1: _b[1bn.vehhh_cat#1.uber_active] / _b[1bn.vehhh_cat#0bn.uber_active]) (risk_ratio2: _b[2bn.vehhh_cat#1.uber_active] / _b[2bn.vehhh_cat#0bn.uber_active]), post
estimates store results_1

poisson drunkdriverb  month#year  i.cfips##c.time  unemp pop uber_active##vmtt_rate_cat, exposure(vmt) cluster(cfips) irr
margins vmtt_rate_cat#uber_active if vmtt_rate_cat >0,  predict(ir) noestimcheck post
nlcom (risk_ratio3: _b[1bn.vmtt_rate_cat#1.uber_active] / _b[1bn.vmtt_rate_cat#0bn.uber_active]) (risk_ratio4: _b[2bn.vmtt_rate_cat#1.uber_active] / _b[2bn.vmtt_rate_cat#0bn.uber_active]), post
estimates store results_2

poisson drunkdriverb  month#year  i.cfips##c.time  unemp pop uber_active##vmtr_rate_cat, exposure(vmt) cluster(cfips) irr
margins vmtr_rate_cat#uber_active if vmtr_rate_cat >0,  predict(ir) noestimcheck post
nlcom (risk_ratio5: _b[1bn.vmtr_rate_cat#1.uber_active] / _b[1bn.vmtr_rate_cat#0bn.uber_active]) (risk_ratio6: _b[2bn.vmtr_rate_cat#1.uber_active] / _b[2bn.vmtr_rate_cat#0bn.uber_active]), post
estimates store results_3

poisson drunkdriverb  month#year  i.cfips##c.time  unemp pop uber_active##ser_all_cat, exposure(vmt) cluster(cfips) irr
margins ser_all_cat#uber_active if ser_all_cat >0, predict(ir) noestimcheck post
nlcom (risk_ratio7: _b[1bn.ser_all_cat#1.uber_active] / _b[1bn.ser_all_cat#0bn.uber_active]) (risk_ratio8: _b[2bn.ser_all_cat#1.uber_active] / _b[2bn.ser_all_cat#0bn.uber_active]), post
estimates store results_4

coefplot (results_1, aseq(Veh. Own)  \ results_2, aseq(PT VMT) \ results_3, aseq(Rail VMT) \ results_4, aseq(PT Service Freq.)), xline(1, lcolor(blue)) coeflabels(risk_ratio1 = "Q1" risk_ratio2 = "Q4" risk_ratio3 = "Q1" risk_ratio4 = "Q4" risk_ratio5 = "Q1" risk_ratio6 = "Q4" risk_ratio7 = "Q1" risk_ratio8 = "Q4")  grid(none) graphregion(fcolor(white) ifcolor(white)) xtitle("Incidence rate ratio") title("") mcolor(black) ciopts(lcolor(red))
graph export coeftrans.png, replace


*Demographic variables

poisson drunkdriverb  month#year  i.cfips##c.time  unemp pop uber_active##lmhh_cat, exposure(vmt) cluster(cfips) irr
margins lmhh_cat#uber_active if lmhh_cat >0,  predict(ir) noestimcheck post
nlcom (risk_ratio1: _b[1bn.lmhh_cat#1.uber_active] / _b[1bn.lmhh_cat#0bn.uber_active]) (risk_ratio2: _b[2bn.lmhh_cat#1.uber_active] / _b[2bn.lmhh_cat#0bn.uber_active]), post
estimates store results_7

poisson drunkdriverb  month#year  i.cfips##c.time  unemp pop uber_active##p2039_cat, exposure(vmt) cluster(cfips) irr
margins p2039_cat#uber_active if p2039_cat >0,  predict(ir) noestimcheck post
nlcom (risk_ratio3: _b[1bn.p2039_cat#1.uber_active] / _b[1bn.p2039_cat#0bn.uber_active]) (risk_ratio4: _b[2bn.p2039_cat#1.uber_active] / _b[2bn.p2039_cat#0bn.uber_active]), post
estimates store results_8

poisson drunkdriverb  month#year  i.cfips##c.time  unemp pop uber_active##col_cat, exposure(vmt) cluster(cfips) irr
margins col_cat#uber_active if col_cat >0,  predict(ir) noestimcheck post
nlcom (risk_ratio5: _b[1bn.col_cat#1.uber_active] / _b[1bn.col_cat#0bn.uber_active]) (risk_ratio6: _b[2bn.col_cat#1.uber_active] / _b[2bn.col_cat#0bn.uber_active]), post
estimates store results_9

coefplot (results_7, aseq(Log HH Inc.)  \ results_8, aseq(% 20-39 year old)  \ results_9, aseq(% college degree)), xline(1, lcolor(blue)) coeflabels(risk_ratio1 = "Q1" risk_ratio2 = "Q4" risk_ratio3 = "Q1" risk_ratio4 = "Q4" risk_ratio5 = "Q1" risk_ratio6 = "Q4") grid(none)  graphregion(fcolor(white) ifcolor(white)) xtitle("Incidence rate ratio") title("") mcolor(black) ciopts(lcolor(red))
graph export coefdems.png, replace


*Alcohol usage variables

poisson drunkdriverb  month#year i.cfips##c.time  unemp pop uber_active##anyall_cat, exposure(vmt) cluster(cfips) irr
margins anyall_cat#uber_active if anyall_cat >0,  predict(ir) noestimcheck post
nlcom (risk_ratio1: _b[1bn.anyall_cat#1.uber_active] / _b[1bn.anyall_cat#0bn.uber_active]) (risk_ratio2: _b[2bn.anyall_cat#1.uber_active] / _b[2bn.anyall_cat#0bn.uber_active]), post
estimates store results_10

poisson drunkdriverb  month#year  i.cfips##c.time  unemp pop uber_active##alc_cat, exposure(vmt) cluster(cfips) irr
margins alc_cat#uber_active if alc_cat >0,  predict(ir) noestimcheck post
nlcom (risk_ratio3: _b[1bn.alc_cat#1.uber_active] / _b[1bn.alc_cat#0bn.uber_active]) (risk_ratio4: _b[2bn.alc_cat#1.uber_active] / _b[2bn.alc_cat#0bn.uber_active]), post
estimates store results_11

poisson drunkdriverb  month#year  i.cfips##c.time  unemp pop uber_active##drinkpld_cat, exposure(vmt) cluster(cfips) irr
margins drinkpld_cat#uber_active if drinkpld_cat >0,  predict(ir) noestimcheck post
nlcom (risk_ratio5: _b[1bn.drinkpld_cat#1.uber_active] / _b[1bn.drinkpld_cat#0bn.uber_active]) (risk_ratio6: _b[2bn.drinkpld_cat#1.uber_active] / _b[2bn.drinkpld_cat#0bn.uber_active]), post
estimates store results_12

coefplot (results_10, aseq(% Any drink)  \ results_11, aseq(% Binge drink) \ results_12, aseq(Drink place density)), xline(1, lcolor(blue)) coeflabels(risk_ratio1 = "Q1" risk_ratio2 = "Q4" risk_ratio3 = "Q1" risk_ratio4 = "Q4" risk_ratio5 = "Q1" risk_ratio6 = "Q4") grid(none)  graphregion(fcolor(white) ifcolor(white)) xtitle("Incidence rate ratio") title("") mcolor(black) ciopts(lcolor(red))
graph export coefdrink.png, replace
