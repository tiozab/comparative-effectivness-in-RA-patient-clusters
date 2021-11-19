

ods html file='clusters_big_3_results_nodelta.xls';

option mprint; 
/*schreib dann noch ein loop*/
%macro loopcluster (maxcluster);
%do x=0 %to &maxcluster;
data firstcluster&x; 
set medstry_1; 
if cluster=&x; 
run; 

data firstterc&x; 
set firstcluster&x; 
run;

title "firsttec cluster big &x";

proc means mean median std p25 p75 min max sum nmiss data=firstterc&x; 
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


proc means mean median std p25 p75 min max sum data=firstterc&x; 
class drugclass drug;
var follow_up_das follow_up_drugfail ;
run;

proc freq data=firstterc&x;
tables das_outcome15m * (drugclass drug);
run;
proc freq data=firstterc&x;
tables drugfail15m * (drugclass drug);
run;
proc freq data=firstterc&x;
tables drugfail15m_non * (drugclass drug);
run;

proc freq data=firstterc&x;
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

title "DAS crude univariat normal dasred -firsttec cluster big &x";
proc phreg data=firstterc&x /*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drugclass1 drugclass3 gender delta_birth /rl ties=efron; 
run; 

title "DAS crude univariat normal dasred -firsttec cluster big &x";
proc phreg data=firstterc&x /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 gender delta_birth /rl ties=efron; 
run; 

title "DISC crude univariat normal dasred -firsttec cluster big &x";
proc phreg data=firstterc&x /*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m  (0)= drugclass1 drugclass3 gender delta_birth/rl ties=efron; 
run; 

title "DISC crude univariat normal dasred -firsttec cluster big &x";
proc phreg data=firstterc&x /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 gender delta_birth/rl ties=efron; 
run; 

title "NON  crude univariat normal dasred -firsttec cluster big &x";
proc phreg data=firstterc&x /*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drugclass1 drugclass3 gender delta_birth/rl ties=efron; 
run; 

title "NON crude univariat normal dasred -firsttec cluster big &x";
proc phreg data=firstterc&x /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 gender delta_birth /rl ties=efron; 
run; 


%end; 
%mend;
%loopcluster (5);


ods html close; 
ods html; ods listing; 
