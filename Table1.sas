

proc means mean median std p25 p75 min max sum nmiss data=my.before; 
var 

activity_of_rheumatic_dis
bmi
bsr
crp
das283crp_score
das28bsr_score
euroqol_score
haq_score
height
n_painfull_joints
n_swollen_joints
number_of_years_smoking
pain_level_today_radai
pcsus_score
mcsus_score
weight
delta_birth
delta_DMARD_AZATH
delta_DMARD_CHLOROCHINE
delta_DMARD_CYA
delta_DMARD_LEFLUN
delta_DMARD_MTX
delta_DMARD_SZS
delta_prednison_steroid
delta_ra_disease

anti_ccp_titer

RF_titer

; run; 


proc freq data=my.before;
tables  

family_anamnesis
gender
morning_stiffness
bicycling_walking
power_sports
DMARD_AZATH
DMARD_CHLOROCHINE
DMARD_CYA
DMARD_LEFLUN
DMARD_MTX
DMARD_SZS
PREDNISON_STEROID
PREDNISON_STEROID_MR
RF
anti_ccp
smoke
smokelevel

/ missing;
run;


title;
run;


proc format;
value drugclass 1='other' 2='TNF' 3='JAK' ;
value drug 1='abat' 2='adal' 3='bari' 4='certo' 5='etan' 6='goli' 7='infli' 8='ritux'
                                9='toc' 10='tofa' ;
run;

data all_before (drop=index_drug var); 
set my.before; 

if index_drug ="BIOLOGIC_ABATACEPT" then drugclass=1;
else if index_drug ="BIOLOGIC_ADALIMUMAB" then drugclass=2;
else if index_drug ="BIOLOGIC_BARICITINIB" then drugclass=3;
else if index_drug ="BIOLOGIC_CERTOLIZUMAB" then drugclass=2;
else if index_drug ="BIOLOGIC_ETANERCEPT" then drugclass=2;
else if index_drug ="BIOLOGIC_GOLIMUMAB" then drugclass=2;
else if index_drug ="BIOLOGIC_INFLIXIMAB" then drugclass=2;
else if index_drug ="BIOLOGIC_RITUXIMAB" then drugclass=1;
else if index_drug ="BIOLOGIC_TOCILIZUMAB" then drugclass=1;
else if index_drug ="BIOLOGIC_TOFACITINIB" then drugclass=3;

drugclass1=0; if drugclass=1 then drugclass1=1; 
drugclass2=0; if drugclass=2 then drugclass2=1; 
drugclass3=0; if drugclass=3 then drugclass3=1; 

if index_drug ="BIOLOGIC_ABATACEPT" then drug=1;
else if index_drug ="BIOLOGIC_ADALIMUMAB" then drug=2;
else if index_drug ="BIOLOGIC_BARICITINIB" then drug=3;
else if index_drug ="BIOLOGIC_CERTOLIZUMAB" then drug=4;
else if index_drug ="BIOLOGIC_ETANERCEPT" then drug=5;
else if index_drug ="BIOLOGIC_GOLIMUMAB" then drug=6;
else if index_drug ="BIOLOGIC_INFLIXIMAB" then drug=7;
else if index_drug ="BIOLOGIC_RITUXIMAB" then drug=8;
else if index_drug ="BIOLOGIC_TOCILIZUMAB" then drug=9;
else if index_drug ="BIOLOGIC_TOFACITINIB" then drug=10;

drug1=0; if drug=1 then drug1=1; 
drug2=0; if drug=2 then drug2=1; 
drug3=0; if drug=3 then drug3=1; 
drug4=0; if drug=4 then drug4=1; 
drug5=0; if drug=5 then drug5=1; 
drug6=0; if drug=6 then drug6=1; 
drug7=0; if drug=7 then drug7=1; 
drug8=0; if drug=8 then drug8=1; 
drug9=0; if drug=9 then drug9=1; 
drug10=0; if drug=10 then drug10=1; 

format drugclass drugclass. drug drug. ;


if (DMARD_AZATH + DMARD_CHLOROCHINE + DMARD_CYA + DMARD_LEFLUN + DMARD_MTX + DMARD_SZS) ge 1 then csDMARD=1; 

run; 

proc freq data=all_before;
tables csDMARD / missing; 
run; 

proc means mean median std p25 p75 min max sum data=all_before; 
class drugclass drug;
var follow_up_das follow_up_drugfail ;
run;

proc freq data=all_before;
tables das_outcome15m * (drugclass drug);
run;
proc freq data=all_before;
tables drugfail15m * (drugclass drug);
run;
proc freq data=all_before;
tables drugfail15m_non * (drugclass drug);
run;


title "DAS crude univariat normal dasred ";
proc phreg data=all_before /*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drugclass1 drugclass3 gender delta_birth /rl ties=efron; 
run; 

title "DAS crude univariat normal dasred ";
proc phreg data=all_before /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 gender delta_birth /rl ties=efron; 
run; 


title "NON  crude univariat normal dasred ";
proc phreg data=all_before /*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drugclass1 drugclass3 gender delta_birth/rl ties=efron; 
run; 

title "NON crude univariat normal dasred ";
proc phreg data=all_before /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 gender delta_birth /rl ties=efron; 
run; 
