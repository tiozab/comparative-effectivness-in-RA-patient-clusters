
libname my "I:\Theresa\ETH DATEN\SCQM\Clustering\my";

proc sql; 
create table medtransvis (drop= visit_patient_id var1) as
select *
from my.medtrans left join my.visit
on visit_patient_id = patid; 
quit; 

proc sql; 
create table my.medtransvispat (drop= patient_id var1) as
select *
from medtransvis left join my.pat
on patient_id = patid; 
quit; 


data orderall;  
format delta_smoke delta_smokelevel delta_number_of_years_smoking 
delta_physical_activity delta_bicycling_walking delta_power_sports  
delta_weight delta_height delta_birth delta_ra_disease
delta_morning_stiffness delta_pcsus_score delta_mcsus_score delta_haq_score 
delta_euroqol_score delta_n_painfull_joints delta_n_swollen_joints
delta_bsr delta_crp delta_pain_level_today_radai delta_mda delta_activity_of_rheumatic_dis 
6. ; 
format delta_birth delta_ra_disease 6.2;
set my.medtransvispat; 

if patient_gender = "MALE" then gender=1; else gender=0;

/*for PSA PATIENTS*/
if visit_mda_score ge 5 then mda=1;                                                       /*yes, should not exist in RA*/
else if visit_mda_items ge 3 and (visit_mda_items-visit_mda_score) lt 2 then mda=1;       /*yes, adapted 2 instead of 3, this row is wrong in PsA*/
else if visit_mda_items ge 3 and (visit_mda_items-visit_mda_score) ge 2 then mda=0;       /*no, adapted 2 instead of 3, in PSA it is 3*/
else mda=.;                                                                               /*missing*/

if mda ne . then delta_mda=index_date - visit_date; 
else delta_mda=999999; 

/* I want prior covariates as defined in pptx */

if visit_date le index_date then do;

/*index date related*/
if 0 le (index_date-visit_date) le 183 then before_index_91 = 1;      /*3 months*/
if 0 le (index_date-visit_date) then before_index_ever = 1;          /*ever before*/

/*age*/
if not missing(patient_date_of_birth) then delta_birth= (index_date-patient_date_of_birth)/365;


/*RA duration*/
if not missing (patient_date_first_symptoms) then delta_ra_disease= (index_date- patient_date_first_symptoms)/365;  
else if not missing (patient_date_diagnosis) then delta_ra_disease= (index_date- patient_date_diagnosis)/365; 


/*language*/
if missing(patient_language) then language=. ;
else if patient_language = "de" then language=0;  /*german*/
else if patient_language = "fr" then language=1;  /*french*/
else language = 2 ;                               /*italian*/

/*smoking, smoking level, and current smoking years*/
if missing(visit_are_you_smoker_eq_5d) and missing(visit_smoker) then smoke =. ; 
else if visit_are_you_smoker_eq_5d="SMOKING_CURRENTLY" or visit_smoker = "I_AM_CURRENTLY_SMOKING" then smoke=1; 
else if visit_are_you_smoker_eq_5d="A_FORMER_SMOKER" or visit_smoker = "I_AM_A_FORMER_SMOKER_FOR_MORE_THAN_A_YEAR" then smoke=2; 
else if visit_are_you_smoker_eq_5d ="NEVER_BEEN_SMOKING"  or visit_smoker ="I_HAVE_NEVER_SMOKED" then smoke=0;

if smoke ne . then delta_smoke = index_date - visit_date ; 
else delta_smoke = 999999; 

if smoke=1 and visit_number_packages_of_cigare="MORE_THAN_ONE_PACKAGE_PER_DAY" then smokelevel=1;  
if smoke=1 and visit_number_packages_of_cigare="ONE_PACKAGE_OR_LESS_PER_DAY" then smokelevel=0;  

if smokelevel ne . then delta_smokelevel = index_date - visit_date ; 
else delta_smokelevel = 999999; 

if smoke=1 then number_of_years_smoking=visit_number_of_years_smoking;
else number_of_years_smoking=.;                              /*not interested in number of years smoking if the patient has stopped*/
if number_of_years_smoking gt 60 then number_of_years_smoking=.; 

if number_of_years_smoking ne . then delta_number_of_years_smoking = index_date - visit_date ; 
else delta_number_of_years_smoking = 999999; 


/*rheumatoid factor*/
if patient_ra_crit_rheumatoid_fact="YES" then RF=1;
else if patient_ra_crit_rheumatoid_fact="NO" then RF=0;


/*anti-ccp*/
if patient_anti_ccp="YES" then anti_ccp=1;
else if patient_anti_ccp="NO" then anti_ccp=0;


/*family anamnesis*/
if patient_family_anamnesis_yn="YES" then family_anamnesis=1;
else if patient_family_anamnesis_yn="NO" then family_anamnesis=0;


/*morning stiffness*/
if visit_morning_stiffness_duratio = "NO" then morning_stiffness = 0; 
if visit_morning_stiffness_duratio = "LESS_THAN_30_MINUTES" then morning_stiffness = 1; 
if visit_morning_stiffness_duratio = "30_MINUTES_TO_1_HOUR" then morning_stiffness = 2; 
if visit_morning_stiffness_duratio = "12_HOURS" then morning_stiffness = 3; 
if visit_morning_stiffness_duratio = "24_HOURS" then morning_stiffness = 4; 
if visit_morning_stiffness_duratio = "MORE_THAN_4_HOURS" then morning_stiffness = 5; 
if visit_morning_stiffness_duratio = "ALL_DAY" then morning_stiffness = 6; 

if morning_stiffness ne . then delta_morning_stiffness = index_date - visit_date ; 
else delta_morning_stiffness = 999999;

/*acitivity at visit*/
if missing(visit_time_daily_spend_walking_) and missing(visit_power_sports_so_you_sweat) then physical_activity=.;
else if visit_time_daily_spend_walking_="MORE_THAN_ONE_HOUR" or visit_power_sports_so_you_sweat="MORE_THAN_2_HOURS_A_WEEK" then physical_activity=3;
else if visit_time_daily_spend_walking_="30_TO_60_MINUTES" or visit_power_sports_so_you_sweat="1_TO_2_HOURS_A_WEEK" then physical_activity=2;
else if visit_time_daily_spend_walking_="SOMETIMES_BUT_LESS_T" or visit_power_sports_so_you_sweat="LESS_THAN_1_HOUR_A_WEEK" then physical_activity=1;
else if visit_time_daily_spend_walking_="NONE" or visit_power_sports_so_you_sweat="NO_PHYSICAL_physical_activity" then physical_activity=0;

if physical_activity ne . then delta_physical_activity = index_date - visit_date ; 
else delta_physical_activity = 999999;

/*keep it raw*/
if missing(visit_time_daily_spend_walking_) then bicycling_walking=.;
else if visit_time_daily_spend_walking_="MORE_THAN_ONE_HOUR" then bicycling_walking=3;
else if visit_time_daily_spend_walking_="30_TO_60_MINUTES" then bicycling_walking=2;
else if visit_time_daily_spend_walking_="SOMETIMES_BUT_LESS_T" then bicycling_walking=1;
else if visit_time_daily_spend_walking_="NONE" then bicycling_walking=0;

if bicycling_walking ne . then delta_bicycling_walking = index_date - visit_date ; 
else delta_bicycling_walking = 999999;

if missing(visit_power_sports_so_you_sweat) then power_sports=.;
else if visit_power_sports_so_you_sweat="MORE_THAN_2_HOURS_A_WEEK" then power_sports=3;
else if visit_power_sports_so_you_sweat="1_TO_2_HOURS_A_WEEK" then power_sports=2;
else if visit_power_sports_so_you_sweat="LESS_THAN_1_HOUR_A_WEEK" then power_sports=1;
else if visit_power_sports_so_you_sweat="NO_PHYSICAL_ACTIVITY" then power_sports=0;

if power_sports ne . then delta_power_sports = index_date - visit_date ; 
else delta_power_sports = 999999;

/*unbelievable weight units = "2" */
if visit_weight_kg lt 30 then weight = . ; 
else weight=visit_weight_kg;

if weight ne . then delta_weight = index_date - visit_date ; 
else delta_weight = 999999;

/*unbelievable height units until 125 */
if visit_height_cm lt 125 then height = . ; 
else  height=visit_height_cm;

if height ne . then delta_height = index_date - visit_date ; 
else delta_height = 999999;

/*pcsus score*/
if not missing(visit_sf12_pcsus_score) and not missing(visit_sf36_pcsus_score)
then pcsus_score = (visit_sf12_pcsus_score+visit_sf36_pcsus_score)/2;
else if not missing(visit_sf36_pcsus_score) then pcsus_score = visit_sf36_pcsus_score;
else if not missing(visit_sf12_pcsus_score) then pcsus_score = visit_sf12_pcsus_score;

if pcsus_score ne . then delta_pcsus_score = index_date - visit_date ; 
else delta_pcsus_score = 999999;

/*mcsus score*/
if not missing(visit_sf12_mcsus_score) and not missing(visit_sf36_mcsus_score)
then mcsus_score = (visit_sf12_mcsus_score+visit_sf36_mcsus_score)/2;
else if not missing(visit_sf36_mcsus_score) then mcsus_score = visit_sf36_mcsus_score;
else if not missing(visit_sf12_mcsus_score) then mcsus_score = visit_sf12_mcsus_score;

if mcsus_score ne . then delta_mcsus_score = index_date - visit_date ; 
else delta_mcsus_score = 999999;

/*other variables without management*/
if visit_haq_score ne . then delta_haq_score = index_date - visit_date ; 
else delta_haq_score = 999999;

if visit_euroqol_score ne . then delta_euroqol_score = index_date - visit_date ; 
else delta_euroqol_score = 999999;

if visit_n_painfull_joints ne . then delta_n_painfull_joints = index_date - visit_date ; 
else delta_n_painfull_joints = 999999;

if visit_n_swollen_joints ne . then delta_n_swollen_joints = index_date - visit_date ; 
else delta_n_swollen_joints = 999999;

if visit_bsr ne . then delta_bsr = index_date - visit_date ; 
else delta_bsr = 999999;

if visit_crp ne . then delta_crp = index_date - visit_date ; 
else delta_crp = 999999;

if visit_pain_level_today_radai ne . then delta_pain_level_today_radai= index_date - visit_date ; 
else delta_pain_level_today_radai= 999999;

if visit_activity_of_rheumatic_dis ne . then delta_activity_of_rheumatic_dis= index_date - visit_date ; 
else delta_activity_of_rheumatic_dis= 999999;

end;  

rename visit_haq_score=haq_score visit_euroqol_score= euroqol_score visit_n_painfull_joints=n_painfull_joints 
visit_n_swollen_joints = n_swollen_joints visit_bsr = bsr visit_crp=crp visit_pain_level_today_radai=pain_level_today_radai
visit_activity_of_rheumatic_dis=activity_of_rheumatic_dis 
patient_rheumatoid_factor_titer = RF_titer
patient_anti_ccp_titer =  anti_ccp_titer

; 

run; 


/*
proc print data=orderall; where missing(patient_date_of_birth); run; 
no one misses birthdate*/


/*fill in three months lookback window variables*/

proc sql;
create table threehelp as
select patid,
       visit_date, index_date, 
       before_index_91, delta_morning_stiffness ,
delta_pcsus_score , delta_mcsus_score , delta_haq_score ,
delta_euroqol_score , delta_n_painfull_joints , 
delta_n_swollen_joints , delta_activity_of_rheumatic_dis , 
delta_bsr, delta_crp , delta_pain_level_today_radai , delta_mda,
       morning_stiffness                 ,
       mda                        ,
       haq_score                 ,
       euroqol_score              ,
       mcsus_score          ,
       pcsus_score         ,
       crp            ,
       bsr          ,
	   n_painfull_joints ,
	   n_swollen_joints ,
	   pain_level_today_radai ,
	   activity_of_rheumatic_dis ,
	   visit_das283crp_score,
	   visit_das28bsr_score
from work.orderall
where before_index_91 = 1;
quit;


proc sql;
create table threehelp2 as
select 
patid ,
visit_date ,
min(delta_morning_stiffness) as min_delta_morning, 
min(delta_pcsus_score) as min_delta_pcsus, 
min(delta_mcsus_score) as min_delta_mcsus, 
min(delta_haq_score) as min_delta_haq,
min(delta_euroqol_score) as min_delta_euroqol, 
min(delta_n_painfull_joints) as min_delta_painfull_joints, 
min(delta_n_swollen_joints) as min_delta_swollen_joints, 
min(delta_bsr) as min_delta_bsr, 
min(delta_crp) as min_delta_crp , 
min(delta_pain_level_today_radai) as min_delta_pain_level, 
min(delta_activity_of_rheumatic_dis) as min_delta_activity_rheumatic_dis , 
min(delta_mda) as min_delta_mda
from work.orderall
where before_index_91 = 1
group by patid 
;
quit;

proc sort data=threehelp ; by patid visit_date; run; 
proc sort data=threehelp2 ; by patid visit_date; run; 

data threehelp3; 
merge threehelp threehelp2 ; 
run; 


data threehelp4 (drop= before_index_91 delta_morning_stiffness delta_pcsus_score delta_mcsus_score delta_haq_score 
delta_euroqol_score delta_n_painfull_joints delta_n_swollen_joints
delta_bsr delta_crp delta_pain_level_today_radai delta_mda delta_activity_of_rheumatic_dis 
morning_stiffness  mda haq_score euroqol_score mcsus_score pcsus_score crp bsr           
n_painfull_joints n_swollen_joints pain_level_today_radai activity_of_rheumatic_dis 
visit_das283crp_score visit_das28bsr_score) ; 
set threehelp3; 

if delta_morning_stiffness = min_delta_morning then a1= morning_stiffness  ; 
if delta_mda = min_delta_mda then a2= mda ; 
if delta_haq_score = min_delta_haq then a3= haq_score ; 
if delta_euroqol_score = min_delta_euroqol then a4= euroqol_score ;  
if delta_mcsus_score = min_delta_mcsus then a5=mcsus_score ;  
if delta_pcsus_score = min_delta_pcsus then a6=pcsus_score  ;  
if delta_crp = min_delta_crp  then a7=crp  ; 
if delta_bsr = min_delta_bsr then a8=bsr ;  
if delta_n_painfull_joints = min_delta_painfull_joints then a9=n_painfull_joints ;  
if delta_n_swollen_joints = min_delta_swollen_joints then  a10=n_swollen_joints ;  
if delta_pain_level_today_radai = min_delta_pain_level then a11= pain_level_today_radai ;  
if delta_activity_of_rheumatic_dis = min_delta_activity_rheumatic_dis then a12=activity_of_rheumatic_dis;  
a13=visit_das283crp_score;
a14=visit_das28bsr_score;
run; 

 
data threehelp5 ;
array firstExist[14] ;
array lastExist[14] ;
array a[14] ;
do until(last.patId);
    set threehelp4; by patId;
    do i = 1 to dim(a);
        if missing(firstExist[i]) then firstExist[i] = a[i];
        end;
    end;
do until(last.patId);
   set threehelp4; by patId;
    do i = 1 to dim(a);
        if missing(a[i]) then a[i] = coalesce(lastExist[i], firstExist[i],.);
        else lastExist[i] = a[i];
        end;
    output;
    end;
drop firstExist1-firstExist14 lastExist1-lastExist14 i  ;
rename
a1=      morning_stiffness              
a2 =      mda                      
a3 =      haq_score               
a4 =      euroqol_score             
a5 =     mcsus_score       
a6 =      pcsus_score        
a7 =      crp          
a8 =      bsr           
a9=	   n_painfull_joints 
a10=	   n_swollen_joints 
a11=	   pain_level_today_radai 
a12=	   activity_of_rheumatic_dis 
a13= das283crp_score
a14= das28bsr_score
min_delta_morning=delta_morning_stiffness
min_delta_mda=delta_mda
min_delta_haq =delta_haq_score
min_delta_euroqol= delta_euroqol_score
min_delta_mcsus=delta_mcsus_score
min_delta_pcsus=delta_pcsus_score
min_delta_crp =delta_crp
min_delta_bsr=delta_bsr
min_delta_painfull_joints=delta_n_painfull_joints
min_delta_swollen_joints=delta_n_swollen_joints
min_delta_pain_level =delta_pain_level_today_radai
min_delta_activity_rheumatic_dis=delta_activity_of_rheumatic_dis
  ;
run;

proc sort data=threehelp5 ; by patid visit_date; run; 

data threehelp5; 
set threehelp5; 

if missing (das28bsr_score) and not missing(n_painfull_joints) 
and not missing(n_swollen_joints) and not missing(bsr) then 
das28bsr_score = 0.54*sqrt(n_painfull_joints)+0.065*n_swollen_joints
+0.33*log(bsr)+0.22;
if missing (das283crp_score) and not missing(n_painfull_joints) 
and not missing(n_swollen_joints) and not missing(crp) then 
das283crp_score = (0.56*sqrt(n_painfull_joints)+0.28*sqrt(n_swollen_joints)
+0.36*log(crp+1))*1.15+1.15;
run; 

data three (drop=visit_date) ;
set  threehelp5 ;

if delta_morning_stiffness=999999 then delta_morning_stiffness=.; 
if delta_pcsus_score=999999 then delta_pcsus_score=.; 
if delta_mcsus_score=999999 then delta_mcsus_score=.; 
if delta_haq_score=999999 then delta_haq_score=.; 
if delta_euroqol_score=999999 then delta_euroqol_score=.; 
if delta_n_painfull_joints=999999 then delta_n_painfull_joints=.; 
if delta_n_swollen_joints=999999 then delta_n_swollen_joints=.; 
if delta_bsr=999999 then delta_bsr=.; 
if delta_crp=999999 then delta_crp=.; 
if delta_pain_level_today_radai=999999 then delta_pain_level_today_radai=.; 
if delta_mda=999999 then delta_mda=.; 
if delta_activity_of_rheumatic_dis = 999999 then delta_activity_of_rheumatic_dis =.;  

by patid; 
if last.patid;

run; 


/*fill in ever before lookback window variables*/

proc sql;
create table everhelp as
select patid, gender,
       visit_date, index_date, index_drug, follow_up ,rx_stsw_outcome, censor_date, censor_reason, index_reason,
	   delta_dmard_mtx, dmard_mtx, delta_dmard_szs, dmard_szs, 
	   delta_prednison_steroid, prednison_steroid,delta_prednison_steroid_mr, 
	   prednison_steroid_mr,delta_dmard_chlorochine, dmard_chlorochine, delta_dmard_leflun, /*delta_csDMARD,*/
	   dmard_leflun, delta_dmard_cya, dmard_cya, delta_dmard_azath, dmard_azath,
       before_index_ever, 
delta_smoke , delta_smokelevel,  delta_number_of_years_smoking ,
delta_physical_activity,  delta_bicycling_walking , delta_power_sports , 
delta_weight, delta_height , delta_birth ,delta_ra_disease,
       language                 ,
       smoke                        ,
       smokelevel                 ,
       number_of_years_smoking               ,
       RF          ,
		RF_titer,
	   anti_ccp , 
	 anti_ccp_titer,
       family_anamnesis        ,
       physical_activity           ,
       bicycling_walking          ,
	   power_sports ,
	   weight,
	   height 
from work.orderall
where before_index_ever = 1;
quit;


proc sql;
create table everhelp2 as
select 
patid ,
visit_date , censor_date,censor_reason,index_reason, 
min(delta_smoke) as min_delta_smoke, 
/*min(delta_smokelevel) as min_delta_smokelevel, */
/*min(delta_number_of_years_smoking) as min_delta_years_smoking,*/
min(delta_physical_activity) as min_delta_physical_activity, 
min(delta_bicycling_walking) as min_delta_bicycling_walking , 
min(delta_power_sports) as min_delta_power_sports, 
min(delta_weight) as min_delta_weight, 
min(delta_height) as min_delta_height
/*max(delta_ra_disease) as max_delta_ra_disease*/
from work.orderall
where before_index_ever = 1
group by patid 
;
quit;

proc sort data=everhelp ; by patid visit_date; run; 
proc sort data=everhelp2 ; by patid visit_date; run; 

data everhelp3; 
merge everhelp everhelp2 ; 
run; 


data everhelp4 (drop= before_index_ever delta_smoke delta_physical_activity  delta_bicycling_walking  delta_power_sports  
delta_weight delta_height
smoke physical_activity bicycling_walking  power_sports weight  height) ; 
set everhelp3; 

if delta_smoke = min_delta_smoke then a1= smoke  ; 
if delta_physical_activity = min_delta_physical_activity then a2= physical_activity ; 
if delta_bicycling_walking  = min_delta_bicycling_walking  then a3= bicycling_walking  ; 
if delta_power_sports = min_delta_power_sports  then a4= power_sports  ;  
if delta_weight = min_delta_weight then a5=weight ;  
if delta_height = min_delta_height then a6=height  ;  

run; 

 
data everhelp5 ;
array firstExist[6] ;
array lastExist[6] ;
array a[6] ;
do until(last.patId);
    set everhelp4; by patId;
    do i = 1 to dim(a);
        if missing(firstExist[i]) then firstExist[i] = a[i];
        end;
    end;
do until(last.patId);
   set everhelp4; by patId;
    do i = 1 to dim(a);
        if missing(a[i]) then a[i] = coalesce(lastExist[i], firstExist[i],.);
        else lastExist[i] = a[i];
        end;
    output;
    end;
drop firstExist1-firstExist6 lastExist1-lastExist6 i  ;
rename
a1=     smoke              
a2 =    physical_activity                      
a3 =    bicycling_walking                
a4 =    power_sports            
a5 =    weight      
a6 =    height      
min_delta_smoke=delta_smoke
min_delta_physical_activity=delta_physical_activity
min_delta_bicycling_walking =delta_bicycling_walking
min_delta_power_sports= delta_power_sports
min_delta_weight=delta_weight
min_delta_height=delta_height
  ;
run;

proc sort data=everhelp5 ; by patid visit_date; run; 

data ever (drop=visit_date) ;
set  everhelp5 ;

if delta_smoke=999999 then delta_smoke=.; 
if delta_smokelevel=999999 then delta_smokelevel=.; 
if delta_number_of_years_smoking=999999 then delta_number_of_years_smoking=.; 
if delta_physical_activity=999999 then delta_physical_activity=.; 
if delta_bicycling_walking=999999 then delta_bicycling_walking=.; 
if delta_power_sports=999999 then delta_power_sports=.; 
if delta_weight=999999 then delta_weight=.; 
if delta_height = 999999 then delta_height =.;  

by patid; 
if last.patid;

run; 

data before; 
merge three ever; 
by patid index_date; 

bmi = weight/((height/100)*(height/100)); 
if not missing(weight) and not missing(height) then do; 
if delta_weight le delta_height then delta_bmi = delta_weight;  
else if delta_height le delta_weight then delta_bmi = delta_height;  
end; 

run; 

data before_prim (drop=censor_datet1); 
set before; 

censor_datet1=index_date + 457;
if censor_date < censor_datet1 then censor_datet1=censor_date;

follow_up_drugfail=(censor_datet1-index_date);

format censor_datet1 yymmdd10.; 

if rx_stsw_outcome=0 then drugfail15m=0;
if rx_stsw_outcome=1 and follow_up <457 then do; 
drugfail15m=1;
censor_reason=5; /*treatment stop*/
end; 
else drugfail15m=0; 

if follow_up_drugfail = 457 then censor_reason = 4; /*15 month follow-up*/


if das28bsr_score; /*3253 von 3507*/



run;


data before_sens (drop=censor_datet1); 
set before_prim ; 

censor_datet1=index_date + 457;
if censor_date < censor_datet1 then censor_datet1=censor_date;

follow_up_drugfail=(censor_datet1-index_date);

format censor_datet1 yymmdd10.; 

if rx_stsw_outcome=0 then drugfail15m_non=0;
if rx_stsw_outcome=1 and follow_up <457 and index_reason = 1 then do; 
drugfail15m_non=1;
censor_reason_non=5; /*treatment stop due to non-response*/
end; 
else if rx_stsw_outcome=1 and follow_up <457 and index_reason = . then do; 
drugfail15m_non=0; 
censor_reason_non=6; /*other treatment stop*/
end; 
else drugfail15m_non=0; 

if follow_up_drugfail = 457 then censor_reason_non = 4; /*15 month follow-up*/

if missing(censor_reason_non) then censor_reason_non = censor_reason; 

run; 

proc freq data=before_sens ; tables drugfail15m_non drugfail15m; run; 


data das28 (keep=patid das28bsr_score index_date needed_); 
set before_sens; 
needed_ = 0.8*das28bsr_score; 
run; 

data ids (keep=patid); 
set before_sens; 
run; 

proc sql; 
create table outcomedashelp as
select patid,
	visit_date, index_date, index_drug, censor_date, censor_reason, index_reason,
	visit_das28bsr_score
from my.medtransvispat
where patid in (select patid from ids); 
quit; 


proc sql; select count (distinct patid) from work.outcomedashelp; quit; 

data outcomedashelp2 (drop=das28bsr_score);
merge outcomedashelp das28; 
by patid index_date; 

if 0 le (index_date - visit_date) le 183 and missing(visit_das28bsr_score) then 
visit_das28bsr_score = das28bsr_score; 


visit_date_lag = lag(visit_date); 
visit_das28bsr_score_lag = lag(visit_das28bsr_score); 

run; 

proc sort data=outcomedashelp2 ; by patid visit_date; run; 


data outcomedashelp3 (drop= diff visit_date_lag visit_das28bsr_score_lag) ; 
set outcomedashelp2; 
by patid;
if first.patid then call missing(visit_date_lag,visit_das28bsr_score_lag); 

diff = visit_date-visit_date_lag;

if 0 le diff le 183 and missing(visit_das28bsr_score) then
visit_das28bsr_score = visit_das28bsr_score_lag;

run; 

proc sort data=outcomedashelp3 ; by patid visit_date; run; 

data outcomedashelp4 (drop= diff visit_date_lead visit_das28bsr_score_lead) ; 
set outcomedashelp3; 
by patid;
set outcomedashelp3 (firstobs=2 keep= visit_date visit_das28bsr_score    rename = (
visit_date= visit_date_lead   visit_das28bsr_score = visit_das28bsr_score_lead  ))
 outcomedashelp3 (obs=1 drop=_ALL_);

if last.patid then call missing(visit_date_lead,visit_das28bsr_score_lead); 

diff = visit_date_lead-visit_date;

if 0 le diff le 91 and missing(visit_das28bsr_score) then
visit_das28bsr_score = visit_das28bsr_score_lead;

run; 

proc sort data=outcomedashelp4 ; by patid visit_date; run; 


proc sql; select count (distinct patid) from work.outcomedashelp4; quit;


proc sort data=work.outcomedashelp4; by patid visit_date; 



data outcomedasfurth (drop= needed_ ); 
set work.outcomedashelp4; 
by patid; 
retain needed;
if first.patid then needed=needed_;
else needed=coalesce(needed_,needed);

if 0 le visit_das28bsr_score le needed then outcome=1; 
else outcome=0;
/*
if missing(visit_das28bsr_score) then missing_das_date=visit_date; 

format missing_das_date yymmdd10.; 
*/
run; 
proc sql; select count (distinct patid) from work.outcomedasfurth; quit; 

data keepout; 
set outcomedasfurth; 

if visit_date gt index_date;  
run; 

data keepout2; 
set keepout; 
if outcome ne 1 then delete; 
outcome_date = visit_date; 
format outcome_date ddmmyy10.;
run; 

proc sort data=keepout2; by patid visit_date; run; 

data keepout3 (keep= patient_id outcome_date);
set keepout2; 
by patid; 
if first.patid; 
rename patid = patient_id;
run; 
proc sql; select count (distinct patient_id) from work.keepout3; quit; /*1737*/

proc sql; 
create table seeoutc (drop=patient_id) as
select * 
from work.outcomedasfurth left join keepout3
on patid = patient_id; 
quit; 

proc sql; select count (distinct patid) from work.seeoutc ; quit; 

proc sort data=seeoutc; by patid visit_date; run; 

data seeoutc; 
set seeoutc; 

if visit_date le index_date then call missing (outcome,outcome_date);
run; 


data seeoutc2 ; 
set seeoutc; 

if not missing(outcome_date) then do; 

if /*0 le censor_date le missing_das_date and*/ 0 le censor_date le outcome_date then do; 
outcome=0; 
outcome_date = censor_date; 
end; 
/*
else if (0 le missing_das_date le censor_date or missing (censor_date)) and 0 le missing_das_date le outcome_date then do; 
outcome=0; 
outcome_date = missing_das_date; 
end; 
*/

end; 
/*
else if missing(outcome_date) and not missing(missing_das_date) then do; 

if 0 le censor_date le missing_das_date then do; 
outcome=0; 
outcome_date = censor_date; 
end; 

if 0 le missing_das_date le censor_date  then do; 
outcome=0; 
outcome_date = missing_das_date; 
end; 

end; 
*/
else do; outcome_date = censor_date; outcome = 0; end; 


run; 

data seeoutc3 (drop=visit_date censor_date visit_das28bsr_score /*missing_das_date*/) ; 
set seeoutc2; 
run; 

proc sort data=seeoutc3; by patid outcome_date; run; 

data seeoutc4 (keep = patid outcome_date);
set seeoutc3;
if outcome_date gt index_date; 
run; 

proc sort data=seeoutc4; by patid outcome_date; run; 

data seeoutc5 (keep = patid das_outcome_date);
set seeoutc4;
by patid; 
if first.patid; 
rename outcome_date = das_outcome_date; 
run; 



data seeoutcomesoon  (drop=outcome_date);
merge seeoutc5 seeoutc2;
by patid; 
run; 

proc sort data=seeoutcomesoon; by patid visit_date; run; 

data seeoutcomesoon2  ;
set seeoutcomesoon;

total = das_outcome_date - index_date ; 

run;

proc sql; select count (distinct patid) from work.seeoutcomesoon  ; quit; 

data dasoutcome (keep=patid das_outcome_date outcome total); 
set seeoutcomesoon2; 
by patid ; 

if last.patid; 
run;  

proc sql; select count (distinct patid) from work.dasoutcome; quit; 

/*
proc print data=dasoutcome; where missing(outcome); run; 
0 missings
*/

data before_das28outcome; 
merge before_sens dasoutcome; 
by patid; run; 


data my.before (drop=censor_datet1 ); 
set before_das28outcome; 

censor_datet1=index_date + 457;
if das_outcome_date < censor_datet1 then censor_datet1=das_outcome_date; 

follow_up_das=(censor_datet1-index_date);

format censor_datet1 yymmdd10.; 

if outcome=0 then das_outcome15m=0;
if outcome=1 and follow_up<457 then do; 
das_outcome15m=1;
censor_reason_das = 5; /*outcome*/
end;
else das_outcome15m=0;

if follow_up_das = 457 then censor_reason_das = 2; /*15 month follow-up*/

if missing(censor_reason_das) and censor_reason = 5 then censor_reason_das = 4; 
if missing(censor_reason_das) then censor_reason_das = censor_reason; 


run;
proc sql; select count (distinct patid) from my.before; quit; 

proc means data =  my.before n nmiss;
  var _numeric_ ;
run;


/*
%ds2csv (
   data=my.before,
   runmode=b,
   csvfile="I:\Theresa\ETH DATEN\SCQM\Clustering\data\beforev5.csv"
 );quit; 
*/
