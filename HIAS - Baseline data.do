*----- HIAS PRM 
*----- Pilot RCT
*----- Baseline data
*----- 04.03.2024

*Ilana
*global raw "/Users/ilanaseff/Library/CloudStorage/Box-Box/SRI PRM grants/HIAS/Data/Baseline/De-identified/"
*import excel using "$raw/HIAS LB por municipio_final_with asssignment_deid.xlsx", clear sheet("Full sample- Stata") firstrow

*Raymond
global raw "/Users/ray/Library/CloudStorage/Box-Box/2024/WASHU/Practicum/HIAS study/De-identified"
import excel using "$raw/HIAS LB por municipio_final_with asssignment_deid copy.xlsx", clear sheet("Full sample- Stata") firstrow


*-- Respondent ID
	ren resp_ID ID
	*-- Bring in respondent age and gender
		preserve
			import excel "$raw/Baseline- Participant ages.xlsx", clear sheet("Ages") firstrow
			tempfile ages
			save `ages', replace
		restore
		
		merge 1:1 ID using `ages'
			ta _m
			// Non merges are those who were excluded from study for not meeting SRI criteria
			keep if _m==3
			drop _m
			
*-- Destring variables
	destring score* SRI Edadhh_mem_1 Edadhh_mem_2 Edadhh_mem_3 Edadhh_mem_4, replace
	
*-- Intervention 
	gen intervention=treatment=="Treatment"
	
*-- Nationality
	encode nationality, gen(nationality1)
	drop nationality
	ren nationality1 nationality
	gen colombian=nationality==1 | nationality==2

*-- City
	encode city, gen(city1)
	drop city
	ren city1 city

*-- Dependency ratio, excluding those with no adult members
	*-- Assume that missing number of children or elderly is zero
		for var num_children num_elderly num_adults: replace X=0 if X==.
		replace num_dependents=num_children+num_elderly if num_dependents==.
		*-- Some issue with the strings
			gen dep_hold=num_dependents/num_adults
			gen dependency_ratio=dep_ratio
			replace dependency_ratio="" if dep_ratio=="Infinity" | dep_ratio=="NaN"
			destring dependency_ratio, replace
			replace dependency_ratio=dep_hold if dependency_ratio==.
			drop dep_hold

*-- Domain 6 wasn't calculated correctly
*--	Should be 5 if no safety concerns reported; 3 if safety concerns but don't interfere; 1 if safety concerns to do interfere
	gen score6 = 5 if domain6a_10==1
		replace score6=3 if domain6a_10==0 & domain6b=="No"
		replace score6=1 if domain6a_10==0 & domain6b=="Sí"

*-- Resilience scale
	*-- Item 1
		gen resil_1=1 if Voyaleerle4afirmaciones=="No me describe en absoluto"
		replace resil_1=2 if Voyaleerle4afirmaciones=="No me describe"
		replace resil_1=3 if Voyaleerle4afirmaciones=="Neutro"
		replace resil_1=4 if Voyaleerle4afirmaciones=="Me describe"
		replace resil_1=5 if Voyaleerle4afirmaciones=="Me describe muy bien"	
		
		tab Voyaleerle4afirmaciones resil_1
		
	*-- Item 2
		gen resil_2=1 if Independientementedeloque=="No me describe en absoluto"
		replace resil_2=2 if Independientementedeloque=="No me describe"
		replace resil_2=3 if Independientementedeloque=="Neutro"
		replace resil_2=4 if Independientementedeloque=="Me describe"
		replace resil_2=5 if Independientementedeloque=="Me describe muy bien"
		
		tab Independientementedeloque resil_2 
		
	*-- Item 3
		gen resil_3=1 if LaterceraCreoquepuedoc=="No me describe en absoluto"
		replace resil_3=2 if LaterceraCreoquepuedoc=="No me describe"
		replace resil_3=3 if LaterceraCreoquepuedoc=="Neutro"
		replace resil_3=4 if LaterceraCreoquepuedoc=="Me describe"
		replace resil_3=5 if LaterceraCreoquepuedoc=="Me describe muy bien"
		
		tab LaterceraCreoquepuedoc resil_3
		
	*-- Item 4
		gen resil_4=1 if Buscoactivamenteformasde=="No me describe en absoluto"
		replace resil_4=2 if Buscoactivamenteformasde=="No me describe"
		replace resil_4=3 if Buscoactivamenteformasde=="Neutro"
		replace resil_4=4 if Buscoactivamenteformasde=="Me describe"
		replace resil_4=5 if Buscoactivamenteformasde=="Me describe muy bien"
		
		tab Buscoactivamenteformasde resil_4
		
	egen resilience=rowtotal(resil*)
	
*-- PHQ-9
*-- As per: https://med.stanford.edu/fastlab/research/imapp/msrs/_jcr_content/main/accordion/accordion_content3/download_256324296/file.res/PHQ9%20id%20date%2008.03.pdf
	gen phq9_1= 0 if Enlasúltimasdossemanas=="Nunca"
	replace phq9_1= 1 if Enlasúltimasdossemanas=="Varios dias"
	replace phq9_1= 2 if Enlasúltimasdossemanas=="Más de la mitad de los días"
	replace phq9_1= 3 if Enlasúltimasdossemanas=="Casi todos los dias"
	
	tab Enlasúltimasdossemanas phq9_1
	
	gen phq9_2= 0 if KC=="Nunca"
	replace phq9_2= 1 if KC=="Varios dias"
	replace phq9_2= 2 if KC=="Más de la mitad de los días"
	replace phq9_2= 3 if KC=="Casi todos los dias"

	tab KC phq9_2
	
	gen phq9_3= 0 if KD=="Nunca"
	replace phq9_3= 1 if KD=="Varios dias"
	replace phq9_3= 2 if KD=="Más de la mitad de los días"
	replace phq9_3= 3 if KD=="Casi todos los dias"

	tab KD phq9_3
	
	gen phq9_4= 0 if KE=="Nunca"
	replace phq9_4= 1 if KE=="Varios dias"
	replace phq9_4= 2 if KE=="Más de la mitad de los días"
	replace phq9_4= 3 if KE=="Casi todos los dias"

	tab KE phq9_4
	
	gen phq9_5= 0 if KF=="Nunca"
	replace phq9_5= 1 if KF=="Varios dias"
	replace phq9_5= 2 if KF=="Más de la mitad de los días"
	replace phq9_5= 3 if KF=="Casi todos los dias"

	tab KF phq9_5
	
	gen phq9_6= 0 if KG=="Nunca"
	replace phq9_6= 1 if KG=="Varios dias"
	replace phq9_6= 2 if KG=="Más de la mitad de los días"
	replace phq9_6= 3 if KG=="Casi todos los dias"

	tab KG phq9_6
	
	gen phq9_7= 0 if KH=="Nunca"
	replace phq9_7= 1 if KH=="Varios dias"
	replace phq9_7= 2 if KH=="Más de la mitad de los días"
	replace phq9_7= 3 if KH=="Casi todos los dias"

	tab KH phq9_7
	
	gen phq9_8= 0 if KI=="Nunca"
	replace phq9_8= 1 if KI=="Varios dias"
	replace phq9_8= 2 if KI=="Más de la mitad de los días"
	replace phq9_8= 3 if KI=="Casi todos los dias"

	tab KI phq9_8
	
	gen phq9_9= 0 if KJ=="Nunca"
	replace phq9_9= 1 if KJ=="Varios dias"
	replace phq9_9= 2 if KJ=="Más de la mitad de los días"
	replace phq9_9= 3 if KJ=="Casi todos los dias"
	
	tab KJ phq9_9
	
	egen phq9=rowtotal(phq*)
	
	*-- Depression thresholds, as per same website
		*	Total Score 	Severity
		*	1-4 			Minimal depression 
		*	5-9				Mild depression
		*	10-14			Moderate depression
		*	15-19			Moderately severe depression
		*	20-27			Severe depression
		
		gen depression_level=.
			replace depression_level=1 if phq9<=4
			replace depression_level=2 if phq9>=5 & phq9<=9
			replace depression_level=3 if phq9>=10 & phq9<=14
			replace depression_level=4 if phq9>=15 & phq9<=19
			replace depression_level=5 if phq9>=20 & phq9<=27
		
		la de depression 1 "Minimal" 2 "Mild" 3 "Moderate" 4 "Moderately severe" 5 "Severe"
		la values depression_level depression
		tab depression_level

*--Multidimensional Empowerment Index

	*-item 1: Education
	gen school_ever=Algunavezustedasistióa=="Sí" if Algunavezustedasistióa!=""
	tab Algunavezustedasistióa school_ever
	
	*item 2: Education level
	encode Cuálfueelúltimoañodee, gen(grade_hold)
		gen school_level = .
		replace school_level = 1 if grade_hold < 5
		replace school_level = 2 if grade_hold >= 5 & grade_hold < 12
		replace school_level = 3 if grade_hold == 12
		replace school_level = 4 if grade_hold > 12
		
		tab Cuálfueelúltimoañodee grade_hold
		
		label define edu_level 1 "No Primary School Completion" ///
								2 "Primary School Completion" ///
								3 "Secondary School Completion" ///
								4 "University or Graduate Level Education"
		label values school_level edu_level
		tab school_level, nolabel
		tab school_level
	
	*-item 3: Marital status (- Converting string to numeric)
	
	encode Cuálessuestadocivilact, gen(marital_status)

		replace marital_status = 1 if Cuálessuestadocivilact == "Casados, que viven en hogares diferentes"
		replace marital_status = 2 if Cuálessuestadocivilact == "Casados, viviendo juntos"
		replace marital_status = 3 if Cuálessuestadocivilact == "Divorciada"
		replace marital_status = 4 if Cuálessuestadocivilact == "Noviazgo"
		replace marital_status = 5 if Cuálessuestadocivilact == "Soltera"
		replace marital_status = 6 if Cuálessuestadocivilact == "Viuda"
		replace marital_status = 7 if Cuálessuestadocivilact == "Viven en pareja, como si estuviera Casado"

		label define marital_status_lbl 1 "Married, living in different households" 2 "Married, living together" 3 "Divorced" 4 "Dating" 5 "Single" 6 "Widowed" 7 "Living with a partner as if married"

		label values marital_status marital_status_lbl
		
		tab Cuálessuestadocivilact marital_status

		gen partnered=marital_status==1 | marital_status==2 | marital_status==7
		ta partnered marital_status, m
		
		*--item 4
		encode Quiénensuhogartienelaú, gen(item_4)
		tab Quiénensuhogartienelaú item_4
		
		*-- item 5
		encode JU, gen(item_5)
		tab JU item_5
		
		*-- Item 6
		encode JV, gen(item_6)
		tab JV item_6
		
		*-- Item 7
		encode Porfavordígamequétande, gen(item_7)
		tab Porfavordígamequétande item_7
		
		*--item 8
		encode LasegundaUnabuenaesposa, gen(item_8)
		tab LasegundaUnabuenaesposa item_8
		
		*-- Item 9
		encode LaterceraLamujereslibr, gen(item_9)
		tab LaterceraLamujereslibr item_9
		
		*-- Item 10
		encode LacuartaAlgunasvecesse, gen(item_10)
		tab LacuartaAlgunasvecesse item_10
		
		*-- Item 11
		encode Cuálerasuocupaciónensu, gen(item_11)
		tab Cuálerasuocupaciónensu item_11
		
	*--Decision subscale:
	
		*-- item 12: Decisions on household purchases are made either jointly by the respondent or together with her partner
		
		encode Quiénensuhogartienelaú, gen(decision_on_purchases)

		replace decision_on_purchases = 1 if Quiénensuhogartienelaú == "Ambos" | Quiénensuhogartienelaú == "Su pareja"
		replace decision_on_purchases = 0 if Quiénensuhogartienelaú != "Ambos" & Quiénensuhogartienelaú != "Su pareja"
		label variable decision_on_purchases "Decisions made by respondent or jointly with partner"
		label define decision_label 0 "Other" 1 "Respondent or jointly with partner"
		label values decision_on_purchases decision_label
		
		tab Quiénensuhogartienelaú decision_on_purchases
		
		*--- item 13: Decisions on healthcare are made either jointly by the respondent or together with her partner
		
		encode JV, gen(decision_on_healthcare)
		
		replace decision_on_healthcare = 1 if JV == "Ambos" | JV == "Su pareja"
		replace decision_on_healthcare = 0 if JV != "Ambos" & JV != "Su pareja"
		label variable decision_on_healthcare "Decisions made by respondent or jointly with partner"
		label define decision_label2 0 "Other" 1 "Respondent or jointly with partner"
		label values decision_on_healthcare decision_label2
		
		tab JV decision_on_healthcare
		
		*-- item 14: Decisions on visiting family or friends are made either jointly by the respondent or together with her partner
		
		encode JU, gen(decision_on_visiting_family)

		replace decision_on_visiting_family = 1 if JU == "Ambos" | JU == "Su pareja"
		replace decision_on_visiting_family = 0 if JU != "Ambos" & JU != "Su pareja"
		label variable decision_on_visiting_family "Decisions made by respondent or jointly with partner"
		label define decision_label1 0 "Other" 1 "Respondent or jointly with partner"
		label values decision_on_visiting_family decision_label1
		
		tab JU decision_on_visiting_family
		
		*-- Subscale sum:
		gen decision_count = decision_on_purchases + decision_on_healthcare + decision_on_visiting_family
		sum decision_count
		
	*-- Attitude subscale:
	
		*-- item 15: Respondent agrees that men have the final say
		
		encode Porfavordígamequétande, gen(agree_mendecide)
		
		replace agree_mendecide = 1 if Porfavordígamequétande == "De acuerdo"
		replace agree_mendecide = 0 if Porfavordígamequétande != "De acuerdo" 
		label variable agree_mendecide "When decisions have to be made in the household, men have the final say."
		label define decision_label3 0 "Other" 1 "Agrees"
		label values agree_mendecide decision_label3
		
		tab Porfavordígamequétande agree_mendecide
		
		*--- item 16: Respondent agrees a good wife obeys her husband
		
		encode LasegundaUnabuenaesposa, gen(agree_wifeobeys)
		
		replace agree_wifeobeys = 1 if LasegundaUnabuenaesposa == "De acuerdo"
		replace agree_wifeobeys = 0 if LasegundaUnabuenaesposa != "De acuerdo" 
		label variable agree_wifeobeys "A good wife always obeys her husband."
		label define decision_label4 0 "Other" 1 "Agrees"
		label values agree_wifeobeys decision_label4
		
		tab agree_wifeobeys
		tab LasegundaUnabuenaesposa agree_wifeobeys
		
		*-- item 17: Respondent disagrees that a woman is free to decide if she wants to work.
		
		encode LaterceraLamujereslibr, gen(disagree_onwork)
		
		replace disagree_onwork = 1 if LacuartaAlgunasvecesse == "En desacuerdo"
		replace disagree_onwork = 0 if LacuartaAlgunasvecesse != "En desacuerdo"
		label variable disagree_onwork "A woman is free to decide if she wants to work"
		label define decision_label6 0 "Other" 1 "Disagrees"
		label values disagree_onwork decision_label6
		
		tab LaterceraLamujereslibr disagree_onwork

		*-- item 18: Respondent agrees that hitting a woman is justified
		encode LacuartaAlgunasvecesse, gen(agree_ipvjustified)
		
		replace agree_ipvjustified = 1 if LacuartaAlgunasvecesse == "De acuerdo"
		replace agree_ipvjustified = 0 if LacuartaAlgunasvecesse != "De acuerdo" 
		label variable agree_ipvjustified "Sometimes it is justified to hit women."
		label define decision_label5 0 "Other" 1 "Agrees"
		label values agree_ipvjustified decision_label5

		tab LacuartaAlgunasvecesse agree_ipvjustified
		
		*-- Subscale sum:
		gen attitudinal_score = agree_mendecide + agree_wifeobeys + disagree_onwork + agree_ipvjustified
		sum attitudinal_score
		
	*-- Gender-based violence items:
	
		*-- item 18: Respondent feels supported by their community frequently or always
		
		encode Graciasporcontestarestas, gen(GBV_1)
		
		replace GBV_1 = Graciasporcontestarestas == "Con frecuencia" | Graciasporcontestarestas=="Siempre"
		label variable GBV_1 "I feel supported by my community."
		label define decision_label7 0 "Other" 1 "Frequently or always"
		label values GBV_1 decision_label7

		tab Graciasporcontestarestas GBV_1
		
		*--- item 19: Respondent feels useful frequently or always
		
		encode LasegundaesMesientoúti, gen(GBV_2)

		replace GBV_2 =  LasegundaesMesientoúti == "Con frecuencia" | LasegundaesMesientoúti=="Siempre"
		label variable GBV_2 "I feel useful."
		label define decision_label8 0 "Other" 1 "Frequently or always"
		label values GBV_2 decision_label8

		tab LasegundaesMesientoúti GBV_2
		

		*-- item 20: Respondent feels controlled by one or more people frequently or always
		
		encode Mesientocontraladaporuna, gen(GBV_3)

		replace GBV_3 = Mesientocontraladaporuna == "Con frecuencia" | Mesientocontraladaporuna=="Siempre"
		label variable GBV_3 "I feel controlled."
		label define decision_label9 0 "Other" 1 "Frequently or always"
		label values GBV_3 decision_label9

		tab Mesientocontraladaporuna GBV_3
		
		
**-- Table 1:

	bysort intervention: summarize dependency_ratio

	bysort intervention: tabulate nationality

	bysort intervention: tabulate marital_status

	ssc install estout, replace

	*-- Summarize variables for control group
estpost summarize resp_age hhsize dependency_ratio resil_1 resil_2 resil_3 resil_4 school_ever school_level partnered item_4 item_5 item_6 item_7 item_8 item_9 item_10 item_11 depression_level decision_count attitudinal_score GBV_1 GBV_2 GBV_3 if treatment == "Control"
eststo control

	*-- Summarize variables for intervention group
estpost summarize resp_age hhsize dependency_ratio resil_1 resil_2 resil_3 resil_4 school_ever school_level partnered item_4 item_5 item_6 item_7 item_8 item_9 item_10 item_11 depression_level decision_count attitudinal_score GBV_1 GBV_2 GBV_3 if treatment == "Treatment"
eststo intervention

	*-- Summarize Variables for entire study population
estpost summarize resp_age hhsize dependency_ratio resil_1 resil_2 resil_3 resil_4 school_ever school_level partnered item_4 item_5 item_6 item_7 item_8 item_9 item_10 item_11 depression_level decision_count attitudinal_score GBV_1 GBV_2 GBV_3

	*-- Display table
esttab control intervention, cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2)) n(fmt(0))") label noobs nonumber collabels(none) mtitle("Control" "Treatment")

	*-- Summarize Variables for entire study population
estpost summarize resp_age hhsize dependency_ratio phq9 depression_level depression_level resilience attitudinal_score decision_count SRI score1a score1b score2 score3 score4 score5 score6 score7 score8 score9 score10 score11 score12

	* - Categorical outcomes

tab school_ever
tab colombian
tab partnered
tab GBV_1 
tab GBV_2
tab GBV_3
tab city 

*-- What predicts self-reliance?


	*correlation of predictors:

		*- Generate a new binary variable 'attended_primary'
	gen attended_primary = .
	replace attended_primary = school_level
	replace attended_primary = 1 if school_level >= 2
	replace attended_primary = 0 if school_level < 2
	label variable attended_primary "Attended Primary"
		label define school_label 0 "Did not complete primary" 1 "Completed primary"
		label values attended_primary school_label
		
		tab attended_primary

		
	local vars resp_age attended_primary colombian hhsize dependency_ratio partnered score1a score1b score2 score3 score4 score5 score6 score7 score8 score9 score10 score11 score12 SRI phq9 resilience attitudinal_score decision_count GBV_1 GBV_2 GBV_3
	
pwcorr `vars', sig
	
*-- Regression Analysis

	*-- Self-reliance:
		
		regress SRI resp_age
		
		regress SRI partnered
		
		regress SRI attended_primary
		
		regress SRI colombian
		
		regress SRI hhsize
		
		regress SRI dependency_ratio
		
		regress SRI phq9
		
		regress SRI resilience
		
		regress SRI attitudinal_score
		
		regress SRI decision_count
		
		regress SRI GBV_3
		
		regress SRI GBV_1
		
		regress SRI i.city
		
		regress SRI resp_age partnered attended_primary colombian hhsize dependency_ratio phq9 resilience attitudinal_score decision_count GBV_3 GBV_1 i.city

	*-- PHQ-9
		
		regress phq9 resp_age
		
		regress phq9 partnered
		
		regress phq9 attended_primary
		
		regress phq9 colombian
		
		regress phq9 hhsize
		
		regress phq9 dependency_ratio
		
		regress phq9 SRI
		
		regress phq9 attitudinal_score
		
		regress phq9 decision_count
		
		regress phq9 GBV_3
		
		regress phq9 GBV_1
		
		regress phq9 i.city
		
		regress phq9 resilience
		
		regress phq9 resp_age partnered attended_primary colombian hhsize dependency_ratio SRI resilience attitudinal_score decision_count GBV_3 GBV_1 i.city
		
		
	*-- Atleast Moderate Depression
	
		gen atleast_moderate_depression = depression_level		
		gen partnered_mod_depression =atleast_moderate_depression==3 | atleast_moderate_depression==4 | atleast_moderate_depression==5
		tab partnered_mod_depression atleast_moderate_depression
			
		label define label10 0 "Other" 1 "atleast_moderate_depression"
		label values partnered_mod_depression label10
			
		tab partnered_mod_depression atleast_moderate_depression
		
		logistic partnered_mod_depression resp_age
		
		logistic partnered_mod_depression partnered
		
		logistic partnered_mod_depression attended_primary
		
		logistic partnered_mod_depression colombian
		
		logistic partnered_mod_depression hhsize
		
		logistic partnered_mod_depression dependency_ratio
		
		logistic partnered_mod_depression attitudinal_score
		
		logistic partnered_mod_depression decision_count
		
		logistic partnered_mod_depression GBV_3
		
		logistic partnered_mod_depression GBV_1
		
		logistic partnered_mod_depression SRI
		
		logistic partnered_mod_depression i.city
		
		logistic partnered_mod_depression resilience
	
		logistic partnered_mod_depression resp_age partnered attended_primary colombian hhsize dependency_ratio attitudinal_score decision_count GBV_3 GBV_1 SRI resilience i.city
		
	*-- Resilience
	
		regress resilience resp_age
		
		regress resilience partnered
		
		regress resilience attended_primary
		
		regress resilience colombian
		
		regress resilience hhsize
		
		regress resilience dependency_ratio
		
		regress resilience phq9
		
		regress resilience attitudinal_score
		
		regress resilience decision_count
		
		regress resilience GBV_3
		
		regress resilience GBV_1
		
		regress resilience i.city
		
		regress resilience SRI
		
		regress resilience resp_age partnered attended_primary colombian hhsize dependency_ratio phq9 attitudinal_score decision_count GBV_3 GBV_1 i.city SRI
		
		
		

****--- Predictinng individual domains for Self-reliance score



*-- PHQ-9
		
		regress phq9 resp_age
		
		regress phq9 partnered
		
		regress phq9 attended_primary
		
		regress phq9 colombian
		
		regress phq9 hhsize
		
		regress phq9 dependency_ratio
		
		regress phq9 score1a
		
		*regress phq9 score1b 
		
		regress phq9 score2 
		
		*regress phq9 score3 
		
		*regress phq9 score4  
		
		regress phq9 score5 
		
		regress phq9 score6 
		
		regress phq9 score7 
		
		regress phq9 score8 
		
		regress phq9 score9 
		
		regress phq9 score10 
		
		regress phq9 score11 
		
		regress phq9 score12
		
		regress phq9 attitudinal_score
		
		regress phq9 decision_count
		
		regress phq9 GBV_3
		
		regress phq9 GBV_1
		
		regress phq9 i.city
		
		regress phq9 resilience
		
		regress phq9 resp_age partnered attended_primary colombian hhsize dependency_ratio resilience attitudinal_score decision_count GBV_3 GBV_1 score1a /*score1b*/ score2 /*score3 score4*/ score5 score6 score7 score8 score9 score10 score11 score12 i.city
		
		
	*-- Atleast Moderate Depression
			
		tab partnered_mod_depression atleast_moderate_depression
		
		logistic partnered_mod_depression resp_age
		
		logistic partnered_mod_depression partnered
		
		logistic partnered_mod_depression attended_primary
		
		logistic partnered_mod_depression colombian
		
		logistic partnered_mod_depression hhsize
		
		logistic partnered_mod_depression dependency_ratio
		
		logistic partnered_mod_depression attitudinal_score
		
		logistic partnered_mod_depression decision_count
		
		logistic partnered_mod_depression GBV_3
		
		logistic partnered_mod_depression GBV_1
		
		logistic partnered_mod_depression score1a 
		
		*logistic partnered_mod_depression score1b 
		
		logistic partnered_mod_depression score2 
		
		*logistic partnered_mod_depression score3 
		
		*logistic partnered_mod_depression score4
		
		logistic partnered_mod_depression score5 
		
		logistic partnered_mod_depression score6 
		
		logistic partnered_mod_depression score7 
		
		logistic partnered_mod_depression score8 
		
		logistic partnered_mod_depression score9 
		
		logistic partnered_mod_depression score10 
		
		logistic partnered_mod_depression score11 
		
		logistic partnered_mod_depression score12
		
		logistic partnered_mod_depression i.city
		
		logistic partnered_mod_depression resilience
	
		logistic partnered_mod_depression resp_age partnered attended_primary colombian hhsize dependency_ratio attitudinal_score decision_count GBV_3 GBV_1 score1a /*score1b*/ score2 /*score3 score4*/ score5 score6 score7 score8 score9 score10 score11 score12 resilience i.city
		
		
	*-- Resilience
	
		regress resilience resp_age
		
		regress resilience partnered
		
		regress resilience attended_primary
		
		regress resilience colombian
		
		regress resilience hhsize
		
		regress resilience dependency_ratio
		
		regress resilience phq9
		
		regress resilience attitudinal_score
		
		regress resilience decision_count
		
		regress resilience GBV_3
		
		regress resilience GBV_1
		
		regress resilience i.city
		
		regress resilience score1a 
		
		*regress resilience score1b 
		
		regress resilience score2 
		
		*regress resilience score3 
		
		*regress resilience score4 
		
		regress resilience score5 
		
		regress resilience score6 
		
		regress resilience score7 
		
		regress resilience score8 
		
		regress resilience score9 
		
		regress resilience score10 
		
		regress resilience score11 
		
		regress resilience score12
		
		regress resilience resp_age partnered attended_primary colombian hhsize dependency_ratio phq9 attitudinal_score decision_count GBV_3 GBV_1 score1a /*score1b*/ score2 /*score3 score4*/ score5 score6 score7 score8 score9 score10 score11 score12  i.city
