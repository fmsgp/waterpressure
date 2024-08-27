set scheme plottig
graph set window fontface "Times New Roman"

*water consumption
use resid_clean.dta, clear

bysort pcode: gen fth=floor-minfloor+1

reghdfe wat fth , absorb(i.pcode i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode time) poolsize(5) compact /*Table S1 Column 6-Full sample*/

sum wat, det
gen ext=1 if wat>r(p99) | wat<r(p1)
drop if ext==1

**Table 1
reghdfe wat fth , absorb(i.pcode i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode time) poolsize(5) compact /*column 1*/
reghdfe wat fth if pcat==1, absorb(i.pcode i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode time) poolsize(5) compact /*column 2*/
reghdfe wat fth if pcat==2, absorb(i.pcode i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode time) poolsize(5) compact /*column 3*/
gen age=year-year_complete
reghdfe wat fth if pcat==1 & age<=5 & age>1, absorb(i.pcode i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode time) poolsize(5) compact /*column 4*/

**Table S1
gen lnwat=ln(wat+1)
reghdfe lnwat fth , absorb(i.pcode i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode time) poolsize(5) compact /*column 1*/

gen height=Elevationm+floor*2.6 if minfloor==1
replace height=Elevationm+5+floor*2.6 if minfloor==2
reghdfe wat height, absorb(i.pcode i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode time) poolsize(5) compact /*column 2*/

reghdfe wat fth , absorb(i.pcode i.time) cluster(pcode time) poolsize(5) compact /*column 3*/
reghdfe wat fth , absorb(i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode time) poolsize(5) compact /*column 4*/
reghdfe wat fth , absorb(i.pcode#i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode time) poolsize(5) compact /*column 5*/

**Figure 1 (a) & (b)
reghdfe wat ib2.fth if pcat==1, absorb(i.pcode i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode time) poolsize(2) compact
eststo event_pcat1

coefplot event_pcat1,  drop(_cons 1.fth 27.fth 28.fth 29.fth 30.fth) scheme(plottig) ciopts(recast(rcap)) vertical ytitle("Monthly water consumption") xsize(3.45) ysize(2.5) ylabel(-6(2)2,format(%5.2f)) yline(0) omitted coeflabels(2.fth="base"	3.fth=" "	4.fth=" "	5.fth=" "	6.fth="+5"	7.fth=" "	8.fth=" "	9.fth=" "	10.fth=" "	11.fth="+10"	12.fth=" "	13.fth=" "	14.fth=" "	15.fth=" "	16.fth="+15"	17.fth=" "	18.fth=" "	19.fth=" "	20.fth=" "	21.fth="+20"	22.fth=" "	23.fth=" "	24.fth=" "	25.fth=" "	26.fth="+25"	27.fth=" "	28.fth=" "	29.fth=" " 30.fth=" ") legend(off) base
graph save event_pcat1.gph, replace
graph export event_pcat1.png, replace

reghdfe wat ib2.fth if pcat==2, absorb(i.pcode i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode time) poolsize(5) compact
eststo eventfloor_pcat2
coefplot ib2.fth,  drop(_cons 1.floor 27.floor 28.floor 29.floor 30.floor) scheme(plottig) ciopts(recast(rcap)) vertical ytitle("Monthly water consumption") xsize(3.45) ysize(2.5) ylabel(-6(2)2,format(%5.2f)) yline(0) omitted coeflabels(2.floor="base"	3.floor=" "	4.floor=" "	5.floor=" "	6.floor="+5"	7.floor=" "	8.floor=" "	9.floor=" "	10.floor=" "	11.floor="+10"	12.floor=" "	13.floor=" "	14.floor=" "	15.floor=" "	16.floor="+15"	17.floor=" "	18.floor=" "	19.floor=" "	20.floor=" "	21.floor="+20"	22.floor=" "	23.floor=" "	24.floor=" "	25.floor=" "	26.floor="+25"	27.floor=" "	28.floor=" "	29.floor=" " 30.floor="30") legend(off) base
graph save event_pcat2.gph, replace
graph export event_pcat2.png, replace

**Figure S1
cap drop fcat
gen fcat=1 if maxfloor<=10
replace fcat=2 if maxfloor<=20 & fcat==.
replace fcat=3 if maxfloor<=30 & fcat==.

foreach i in 1 2 3{
	foreach j in 1 2{
reghdfe wat ib2.fth if pcat==1 & fcat==`i', absorb(i.pcode i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode time) poolsize(5) compact
eststo event_pcat`j'_fcat`i'
	}
}

foreach j in 1 2{
coefplot  event_pcat`j'_fcat1,  drop(_cons 1.fth 10.fth) scheme(plottig) ciopts(recast(rcap)) vertical ytitle("Monthly water consumption") xsize(3.45) ysize(2.5) ylabel(-6(2)2,format(%5.2f)) yline(0) omitted coeflabels(2.fth="base"	3.fth=" "	4.fth=" "	5.fth=" "	6.fth="+5"	7.fth=" "	8.fth=" "	9.fth=" "	10.fth=" "	11.fth="+10"	12.fth=" "	13.fth=" "	14.fth=" "	15.fth=" "	16.fth="+15"	17.fth=" "	18.fth=" "	19.fth=" "	20.fth=" "	21.fth="+20"	22.fth=" "	23.fth=" "	24.fth=" "	25.fth=" "	26.fth="+25"	27.fth=" "	28.fth=" "	29.fth=" " 30.fth=" ") legend(off) base 
graph save  event_pcat`j'_fcat1.gph, replace
graph export  event_pcat`j'_fcat1.png, replace

coefplot  event_pcat`j'_fcat2,  drop(_cons 1.fth 20.fth) scheme(plottig) ciopts(recast(rcap)) vertical ytitle("Monthly water consumption") xsize(3.45) ysize(2.5) ylabel(-6(2)2,format(%5.2f)) yline(0) omitted coeflabels(2.fth="base"	3.fth=" "	4.fth=" "	5.fth=" "	6.fth="+5"	7.fth=" "	8.fth=" "	9.fth=" "	10.fth=" "	11.fth="+10"	12.fth=" "	13.fth=" "	14.fth=" "	15.fth=" "	16.fth="+15"	17.fth=" "	18.fth=" "	19.fth=" "	20.fth=" "	21.fth="+20"	22.fth=" "	23.fth=" "	24.fth=" "	25.fth=" "	26.fth="+25"	27.fth=" "	28.fth=" "	29.fth=" " 30.fth=" ") legend(off) base 
graph save  event_pcat`j'_fcat2.gph, replace
graph export  event_pcat`j'_fcat2.png, replace

coefplot  event_pcat`j'_fcat3,  drop(_cons 1.fth 30.fth) scheme(plottig) ciopts(recast(rcap)) vertical ytitle("Monthly water consumption") xsize(3.45) ysize(2.5) ylabel(-6(2)2,format(%5.2f)) yline(0) omitted coeflabels(2.fth="base"	3.fth=" "	4.fth=" "	5.fth=" "	6.fth="+5"	7.fth=" "	8.fth=" "	9.fth=" "	10.fth=" "	11.fth="+10"	12.fth=" "	13.fth=" "	14.fth=" "	15.fth=" "	16.fth="+15"	17.fth=" "	18.fth=" "	19.fth=" "	20.fth=" "	21.fth="+20"	22.fth=" "	23.fth=" "	24.fth=" "	25.fth=" "	26.fth="+25"	27.fth=" "	28.fth=" "	29.fth=" " 30.fth=" ") legend(off) base 
graph save  event_pcat`j'_fcat3.gph, replace
graph export  event_pcat`j'_fcat3.png, replace
}
**Figure 2 (a)
cap drop N
bysort pcode floor time: gen N=_N
cap drop mbsize
bysort pcode floor: egen mbsize=mean(N)
cap drop mbsq
bysort pcat: egen mbsq=xtile(mbsize), n(4)

reghdfe wat i.mbsq if pcat==1, absorb(i.fth i.pcode i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode time) poolsize(5) compact
eststo het_hdb_mbs
coefplot  het_hdb_mbs,  drop(_cons) scheme(plottig) ciopts(recast(rcap)) vertical ytitle("Monthly water consumption") xsize(3.45) ysize(2.5) ylabel(-1(0.5)0.5,format(%5.2f)) yline(0) omitted coeflabels(1.mbsq="<5" 2.mbsq="5-7"  3.mbsq="8-10" 4.mbsq=">10") legend(off) base xtitle("Number of units on the floor")
graph save  hdb_mbs.gph, replace
graph export  hdb_mbs.png, replace

**Figure 2(b)
bysort pcode: egen bdheight=max(height)
gen reverse_fth=maxfloor-floor
reghdfe wat ib0.reverse_fth if pcat==1 & bdheight>45, absorb(i.pcode i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode) poolsize(5) compact
coefplot,  keep(0.reverse_fth 1.reverse_fth 2.reverse_fth 3.reverse_fth 4.reverse_fth 5.reverse_fth 6.reverse_fth) scheme(plottig) ciopts(recast(rcap)) vertical ytitle("Monthly water consumption") xsize(3.45) ysize(2.5) ylabel(-6(2)2,format(%5.2f)) yline(0) omitted coeflabels(0.reverse_fth="Top" 1.reverse_fth="Top-1" 2.reverse_fth="Top-2" 3.reverse_fth="Top-3" 4.reverse_fth="Top-4" 5.reverse_fth="Top-5" 6.reverse_fth="Top-6") legend(off) base xline(2.5)
graph save pump_high_HDB.gph
graph export pump_high_HDB.png

**Figure S2
reghdfe wat ib0.reverse_fth if pcat==1 & bdheight<35, absorb(i.pcode i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode) poolsize(5) compact
coefplot,  keep(0.reverse_fth 1.reverse_fth 2.reverse_fth 3.reverse_fth 4.reverse_fth 5.reverse_fth 6.reverse_fth) scheme(plottig) ciopts(recast(rcap)) vertical ytitle("Monthly water consumption") xsize(3.45) ysize(2.5) ylabel(-2(2)6,format(%5.2f)) yline(0) omitted coeflabels(0.reverse_fth="Top" 1.reverse_fth="Top-1" 2.reverse_fth="Top-2" 3.reverse_fth="Top-3" 4.reverse_fth="Top-4" 5.reverse_fth="Top-5" 6.reverse_fth="Top-6") legend(off) base xline(2.5)
graph save pump_low_HDB.gph
graph export pump_low_HDB.png

**Figure 3

***Income/ptype: Figure 3(a)
reghdfe wat c.fth#i.ptype if pcat==1, absorb(i.pcode i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode time) poolsize(5) compact 
eststo het_ptype
coefplot het_ptype,  drop(_cons) scheme(plottig) ciopts(recast(rcap)) vertical ytitle("Monthly water consumption") xsize(3.45) ysize(2.5) ylabel(-0.4(0.2)0.2,format(%5.2f)) yline(0) omitted legend(off) base coeflabels(1.ptype#c.fth="HDB 1-/2-room" 2.ptype#c.fth="HDB 3-room" 3.ptype#c.fth="HDB 4-room" 4.ptype#c.fth="HDB 5-room+")
graph save het_ptype.gph, replace
graph export het_ptype.png, replace

***Green building: Figure 3(b)
reghdfe wat c.fth#i.green if pcat==1 & year_complete>2005, absorb(i.pcode i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode time) poolsize(5) compact
eststo green1
coefplot green1, drop(_cons) scheme(plottig) ciopts(recast(rcap)) vertical ytitle("Monthly water consumption") xsize(3.45) ysize(2.5) ylabel(-0.4(0.2)0.2,format(%5.2f)) yline(0) omitted legend(off) base coeflabels(0.status_alt#c.fth="Non-green" 2.status_alt#c.fth="Green" )
graph save green1.gph, replace
graph export green1.png, replace

reghdfe wat c.fth#i.green if pcat==2 & year_complete>2005, absorb(i.pcode i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode time) poolsize(5) compact
eststo green2
coefplot green2, drop(_cons) scheme(plottig) ciopts(recast(rcap)) vertical ytitle("Monthly water consumption") xsize(3.45) ysize(2.5) ylabel(-0.4(0.2)0.2,format(%5.2f)) yline(0) omitted legend(off) base coeflabels(0.status_alt#c.fth="Non-green" 2.status_alt#c.fth="Green" )
graph save green2.gph, replace
graph export green2.png, replace

***Building age: Figure 3(c)
cap drop age
gen age=year-year_complete
cap drop agec
gen agec=1 if age<=10 & age!=.
replace agec=2 if age<=20 & age!=. & agec==.
replace agec=3 if age<=30 & age!=. & agec==.
replace agec=4 if age<=40 & age!=. & agec==.

reghdfe wat c.fth#i.agec if pcat==1, absorb(i.pcode i.time i.ptype i.groundfloor i.topfloor i.supply i.pump) cluster(pcode time) poolsize(5) compact
eststo agec1
coefplot agec1, drop(_cons) scheme(plottig) ciopts(recast(rcap)) vertical ytitle("Monthly water consumption") xsize(3.45) ysize(2.5) ylabel(-0.4(0.2)0.2,format(%5.2f)) yline(0) omitted legend(off) base coeflabels(1.agec#c.fth="<10" 2.agec#c.fth="10-20" 3.agec#c.fth="20-30" 4.agec#c.fth=">30")
graph save  het_hdb_age.gph, replace
graph export  het_hdb_age.png, replace

reghdfe wat c.fth#i.agec if pcat==2, absorb(i.pcode i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode time) poolsize(5) compact
eststo agec2
coefplot agec2, drop(_cons) scheme(plottig) ciopts(recast(rcap)) vertical ytitle("Monthly water consumption") xsize(3.45) ysize(2.5) ylabel(-0.4(0.2)0.2,format(%5.2f)) yline(0) omitted legend(off) base coeflabels(1.agec#c.fth="<10" 2.agec#c.fth="10-20" 3.agec#c.fth="20-30" 4.agec#c.fth=">30")
graph save het_private_age.gph, replace
graph export  het_private_age.png, replace

***Time since move in: Figure 3(d)
gen with5= year-movein_year
replace with5=5 if with5>5

reghdfe wat c.fth#i.with5 if pcat==1, absorb(i.pcode i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode time) poolsize(5) compact
eststo adjust1

coefplot adjust1, drop(_cons) scheme(plottig) ciopts(recast(rcap)) vertical ytitle("Monthly water consumption") xsize(3.45) ysize(2.5) ylabel(-0.2(0.1)0.1,format(%5.2f)) yline(0) omitted legend(off) base coeflabels(0.with5#c.fth="Y1" 1.with5#c.fth="Y2" 2.with5#c.fth="Y3" 3.with5#c.fth="Y4" 4.with5#c.fth="Y5")
graph save  adjust1.gph, replace
graph export  adjust1.png, replace

reghdfe wat c.fth#i.with5 if pcat==2, absorb(i.pcode i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode time) poolsize(5) compact
eststo adjust2
coefplot adjust2, drop(_cons 0.with5#c.fth) scheme(plottig) ciopts(recast(rcap)) vertical ytitle("Monthly water consumption") xsize(3.45) ysize(2.5) ylabel(-0.2(0.1)0.1,format(%5.2f)) yline(0) omitted legend(off) base coeflabels(1.with5#c.fth="Y1" 2.with5#c.fth="Y2" 3.with5#c.fth="Y3" 4.with5#c.fth="Y4" 5.with5#c.fth="Y5")
graph save  adjust2.gph, replace
graph export  adjust2.png, replace

**Figure 5
***Efficiency improvements: Figure 5(a)
reghdfe wat i.fth_cat#1.post_HIP if pcat==1 & year_complete<2005, absorb(i.pcode i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode time) poolsize(5) compact
eststo hip_pcat
coefplot  hip_pcat, drop(_cons) scheme(plottig) ciopts(recast(rcap)) vertical ytitle("Monthly water consumption") xsize(3.45) ysize(2.5) ylabel(-2(1)1,format(%5.2f)) yline(0) omitted legend(off) base coeflabels(1.fth_cat#1.post_HIP="Q1" 2.fth_cat#1.post_HIP="Q2" 3.fth_cat#1.post_HIP="Q3" 4.fth_cat#1.post_HIP="Q4")
graph save hip_floor.gph, replace
graph export hip_floor.png, replace

***Water pricing: Figure 5(b)
gen pchg=(time>=685)
reghdfe wat ib2.pcat#1.pchg, absorb(i.pcode i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode time) poolsize(5) compact
eststo pchg

reghdfe wat i.pcat##i.fth_cat#1.pchg, absorb(i.pcode i.time i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode time) poolsize(5) compact
eststo pchg_fcat
coefplot  pchg_fcat, keep(1.pcat#*) scheme(plottig) ciopts(recast(rcap)) vertical ytitle("Monthly water consumption") xsize(3.45) ysize(2.5) ylabel(-4(2)2,format(%5.2f)) yline(0) omitted legend(off) base coeflabels(1.pcat#1.fth_cat#1.pchg="Q1" 1.pcat#2.fth_cat#1.pchg="Q2" 1.pcat#3.fth_cat#1.pchg="Q3" 1.pcat#4.fth_cat#1.pchg="Q4")
graph save pchg_floor.gph, replace
graph export pchg_floor.png, replace

***Nudging: Figure 5(c)
gen nudge=(time>679)

reghdfe wat i.fth_cat#1.nudge if year==2016, absorb(i.pcode i.ptype i.topfloor i.groundfloor i.supply i.pump) cluster(pcode time) poolsize(5) compact
eststo nudge_floor
coefplot  nudge_floor, drop(_cons) scheme(plottig) ciopts(recast(rcap)) vertical ytitle("Monthly water consumption") xsize(3.45) ysize(2.5) ylabel(-4(2)2,format(%5.2f)) yline(0) omitted legend(off) base coeflabels(1.fth_cat#1.nudge="Q1" 2.fth_cat#1.nudge="Q2" 3.fth_cat#1.nudge="Q3" 4.fth_cat#1.nudge="Q4")
graph save nudge_floor.gph, replace
graph export nudge_floor.png, replace

*Building level electricity and water: Figure 4
use resid_clean.dta, clear

gen nfloor=maxfloor-minfloor
drop if nfloor<5
drop if floor==minfloor 
drop if floor==maxfloor

bysort pcode ptype time: egen mwat=mean(wat)
bysort pcode ptype time: egen melec=mean(elec_hh)
bysort pcode ptype time: gen cn=_n

cap drop N
bysort pcode floor time: gen N=_N

keep if cn==1

cap drop region
gen region=floor(pcode/10000)

cap drop lnmwat
gen lnmwat=ln(mwat+1)
cap drop lnmelec
gen lnmelec=ln(melec+1)

keep if lnmwat!=. & lnmelec!=. & year_complete>1980 & maxfloor>3 & maxfloor<31

reghdfe lnmwat c.nfloor c.nfloor#1.pcat, absorb(time region ptype year_complete) cluster(pcode time)
eststo wat_temp
reghdfe lnmelec c.nfloor c.nfloor#1.pcat, absorb(time region ptype year_complete) cluster(pcode time)
eststo elec_temp

coefplot wat_temp elec_temp, keep(1.pcat#c.nfloor) scheme(plottig) ciopts(recast(rcap)) vertical ytitle("Log of monthly consumption") xsize(3.45) ysize(2.5) ylabel(-0.01(0.005)0.01,format(%5.2f)) yline(0) omitted legend(pos(6) row(1)) base coeflabels(1.pcat#c.nfloor="Difference in consumption change between HDB and private")
graph electricity.gph, replace
graph  electricity.png, replace


*water pressure measurement: Figure 1 (c) & (d)
use pressure_record.dta, clear

drop if D==""
drop if A=="Address"
drop E
destring D, replace
rename D psi
split C
rename C1 type
drop if B==""
destring B, replace
rename B floor

drop if floor==1 
summ psi, det
drop if psi>=4.8 | psi<=1

bysort type floor: gen cn=_n
bysort type floor: gen N=_N

cap drop mpsi
bysort type floor: egen mpsi=mean(psi)
tw (fpfitci mpsi floor if cn==1 & type=="HDB" & N!=1) (scatter mpsi floor if cn==1 & type=="HDB" & N!=1),  xtitle("Floor") ytitle("Water pressure (bars)") legend(pos(6) row(1) lab(1 "Confidence Interval") lab(2 "Fitted values") lab(3 "Mean water pressure")) ylab(1(1)5) xlab(0(5)20)
graph save HDB_pressure.gph, replace
graph export HDB_pressure.png, replace

tw (lfitci mpsi floor if cn==1 & type=="Condo") (scatter mpsi floor if cn==1 & type=="Condo"),  xtitle("Floor") ytitle("Water pressure (bars)") legend(pos(6) row(1) lab(1 "Confidence Interval") lab(2 "Fitted values") lab(3 "Mean water pressure")) ylab(1(1)5) xlab(0(5)20)
graph save private_pressure.gph, replace
graph export private_pressure.png, replace

*water pressure satisfaction: Figure S4
use pool_sample_final.dta, clear

bysort ca: gen cn=_n
keep if cn==1
split unitno, p("-")
gen floor=substr(unitno, 2, 2)

split unit, p("-")
replace floor=unit1 if floor==""

destring floor, replace
drop if floor==.

bysort floor: egen msf=mean(e9h)
bysort floor: gen fcn=_n
bysort floor: gen fcN=_N

tw (lfitci msf floor if fcN>2) (scatter msf floor if fcN>2),  xtitle("Floor") ytitle("Satisfaction with water pressure") legend(pos(6) row(1) lab(1 "Confidence Interval") lab(2 "Fitted values") lab(3 "Mean satisfaction level")) ylab(3(1)5) xlab(0(5)20)
graph save satisfaction.gph, replace
graph export satisfaction.png, replace

