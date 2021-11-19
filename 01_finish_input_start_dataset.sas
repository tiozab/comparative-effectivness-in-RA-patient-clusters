/*
proc import datafile="I:\Theresa\ETH DATEN\SCQM\Clustering\data\visit_outR_noNA.csv"
         out=visit
         dbms=csv
         replace;
run;*/

libname my "I:\Theresa\ETH DATEN\SCQM\Clustering\my";


/*take assessed medication start date from sameorbefore as index date*/
data medfurth; 
set my.sameorbefore; 
rename medication_start_date = index_date medication_drug = index_drug visit_patient_id = patid;
run; 
proc sql; select count (distinct patid) from medfurthmed ;quit; /*3528*/

  data WORK.MED    ;
       %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
       infile 'I:\Theresa\ETH DATEN\SCQM\Clustering\data\med_outR_noNA.csv' 
 MISSOVER DSD lrecl=32767 firstobs=2 ;
 			informat var1 4.;
            informat medication_id 7. ;
			informat medication_start_date yymmdd10. ;
			informat medication_drug $50.;
			informat medication_stop_date yymmdd10. ;
			informat medication_stop_reasons $50.;
			informat medication_patient_id 10. ;
			format var1 4.;
			format medication_id 7. ;
			format medication_start_date yymmdd10. ;
			format medication_drug $50.;
			format medication_stop_date yymmdd10. ;
			format medication_stop_reasons $50.;
			format medication_patient_id 10. ;
	 input  var1
			 medication_id  
			 medication_start_date  $
			 medication_drug $
			 medication_stop_date $
			 medication_stop_reasons $
			 medication_patient_id ;
      if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
       run;

data checkdose ;
set med;

if missing(medication_drug) then delete; 
if missing(medication_start_date) then delete;
if find(medication_drug, 'DMARD') then delete;
if find(medication_drug, 'PREDNISON') then delete;
if find(medication_drug, 'OTHER') then delete;

/*pat 3411 had same day med start and stop, thus he may have received one administration
or no administration at all*/
/*decide to delete these entries, may also have been an entry by mistake*/
if not missing(medication_start_date) then do;
if medication_start_date = medication_stop_date then delete;
end; 

   rename    medication_start_date =    m_start_date
          medication_stop_date  =    m_stop_date
          medication_stop_reasons  =    m_stop_reasons
medication_patient_id   =  m_patient_id
           medication_drug      =    m_drug ;


run;
proc sql; select count (distinct m_patient_id) from work.checkdose;quit;      /*6459 patients*/

proc sort data=checkdose; by m_patient_id m_start_date m_stop_date ;run;

data doseada  (drop= m_stop_date_lead m_stop_reasons_lead m_start_date_lead m_drug_lead 
m_stop_date_lag m_start_date_lag m_drug_lag m_patient_id_lag ) ;
set checkdose;
by m_patient_id m_start_date;
set checkdose (firstobs=2 keep= m_start_date m_drug m_stop_date  m_stop_reasons   rename = (
m_start_date= m_start_date_lead   m_stop_date = m_stop_date_lead m_stop_reasons = m_stop_reasons_lead
 m_drug=m_drug_lead    ))
 checkdose (obs=1 drop=_ALL_);
if last.m_patient_id then do; m_start_date_lead =.; m_drug_lead=.; m_stop_date_lead=.; m_stop_reasons_lead=.;  end;


if m_drug ne m_drug_lead or (m_start_date_lead - m_stop_date) gt 31 then do; 
if not missing(m_start_date_lead) and not missing(m_stop_date) then do;
if m_start_date_lead lt m_stop_date then   m_stop_date = m_start_date_lead-1;   /*get rid of overlap*/
if not missing(m_start_date_lead) and missing(m_stop_date) then     /*get rid of unlimited use if there is a new drug later*/
m_stop_date= m_start_date_lead-1;
end; 
end; 
else m_stop_date = m_stop_date_lead; 

m_stop_date_lag = lag(m_stop_date);
 m_start_date_lag = lag(m_start_date);
 m_drug_lag = lag(m_drug);
 m_patient_id_lag = lag(m_patient_id);
format m_stop_date_lag m_start_date_lag yymmdd10.; 
 
 retain count; 
if first.m_patient_id then do; m_start_date_lag =.; m_stop_date_lag=.; count = 0;  end;
count=count+1; 
if last.m_patient_id then count =count; 
/*there is cases when two drugs are started on the same day*/
if m_start_date = m_start_date_lead and m_drug = m_drug_lead then delete;
if m_start_date = m_start_date_lag and m_drug ne m_drug_lag then m_start_date = m_stop_date_lag+1;


run;

proc sort data=doseada; by m_patient_id m_start_date; run; 

data doseada2  (drop= m_stop_date_lead m_stop_reasons_lead m_start_date_lead m_drug_lead 
m_stop_date_lag m_start_date_lag m_drug_lag m_patient_id_lag ) ;
set doseada;
by m_patient_id m_start_date;
set doseada (firstobs=2 keep= m_start_date m_drug m_stop_date  m_stop_reasons   rename = (
m_start_date= m_start_date_lead   m_stop_date = m_stop_date_lead m_stop_reasons = m_stop_reasons_lead
 m_drug=m_drug_lead    ))
 doseada (obs=1 drop=_ALL_);
if last.m_patient_id then do; m_start_date_lead =.; m_drug_lead=.; m_stop_date_lead=.; m_stop_reasons_lead=.;  end;


if m_drug ne m_drug_lead or (m_start_date_lead - m_stop_date) gt 31 then do; 
if not missing(m_start_date_lead) and not missing(m_stop_date) then do;
if m_start_date_lead lt m_stop_date then   m_stop_date = m_start_date_lead-1;   /*get rid of overlap*/
if not missing(m_start_date_lead) and missing(m_stop_date) then     /*get rid of unlimited use if there is a new drug later*/
m_stop_date= m_start_date_lead-1;
end; 
end; 
else m_stop_date = m_stop_date_lead; 


m_stop_date_lag = lag(m_stop_date);
 m_start_date_lag = lag(m_start_date);
 m_drug_lag = lag(m_drug);
 m_patient_id_lag = lag(m_patient_id);
format m_stop_date_lag m_start_date_lag yymmdd10.; 
 retain count; 
if first.m_patient_id then do; m_start_date_lag =.; m_stop_date_lag=.; count = 0;  end;
count=count+1; 
if last.m_patient_id then count =count; 
/*there is cases when two drugs are started on the same day*/
if m_start_date = m_start_date_lead and m_drug = m_drug_lead then delete;
if m_start_date = m_start_date_lag and m_drug ne m_drug_lag then m_start_date = m_stop_date_lag+1;


if m_patient_id_lag = m_patient_id and m_stop_date_lead = m_stop_date_lag then delete; 

rename    m_start_date  = medication_start_date
        m_stop_date =  medication_stop_date
		m_stop_reasons = medication_stop_reasons
         m_patient_id  =   medication_patient_id
         m_drug =  medication_drug    
;

run;


/*to check
proc print data= doseada2; where (m_start_date_lead - medication_stop_date) le 31 and medication_drug = m_drug_lead ; run; 
*/
proc sql; select count (distinct medication_patient_id) from work.doseada2;quit;      /*6459 patients*/


proc sort data=doseada2;   by medication_patient_id  ; run;
proc sort data=med; by medication_patient_id  ; run;

data med2;
set med;
if  find(medication_drug, 'BIOLOGIC') then delete;
run;

data my.medication;
set doseada2 med2;
run;

proc sort data=my.medication noduprecs; by medication_patient_id medication_drug   ; run;
proc sort data=my.medication; by var1; run;
proc sql; select count (distinct medication_patient_id) from my.medication ;quit;      /*9449 patients*/
/*proc sort data=my.medication; by medication_start_date; where find (medication_drug, 'BIOLOG'); run; */
/*latest 1 Oct 2019*/
/*first biological from 1998*/
/*proc sort data=my.medication; by medication_stop_date; run; 
/*latest 4 Jan 2019*/

   data MY.VISIT    ;
      %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
      infile 'I:\Theresa\ETH DATEN\SCQM\Clustering\data\visit_outR_noNA.csv' 
	 MISSOVER DSD lrecl=32767 firstobs=2 ;
           informat VAR1 4. ;
         informat visit_patient_id 10. ;
         informat visit_date yymmdd10. ;
         informat visit_weight_kg 5. ;
         informat visit_height_cm 8. ;
         informat visit_schooling $39. ;
         informat visit_smoker $43. ;
         informat visit_drink_alcoholic_beverages $5. ;
         informat visit_time_daily_spend_walking_ $20. ;
         informat visit_power_sports_so_you_sweat $26. ;
         informat visit_das28bsr_score 5. ;
         informat visit_sf36_pcsus_score 6. ;
         informat visit_sf12_pcsus_score 6. ;
         informat visit_das283crp_score 5. ;
         informat visit_radai_score 6. ;
         informat visit_mda_score 2. ;
         informat visit_radai_5_score 6. ;
         informat visit_sf12_mcsus_score 6. ;
         informat visit_haq_score 6. ;
         informat visit_euroqol_score 6. ;
         informat visit_sf36_mcsus_score 6. ;
         informat visit_mda_items 2. ;
         informat visit_n_painfull_joints 2. ;
         informat visit_n_swollen_joints 2. ;
         informat visit_bsr 5. ;
         informat visit_crp 5. ;
		informat visit_reference_area_crp_up_to 5.;
         informat visit_pain_level_today_radai 3. ;
         informat visit_activity_of_rheumatic_dis 3. ;
         informat visit_morning_stiffness_duratio $22. ;
		informat visit_are_you_smoker_eq_5d $43. ;
		informat visit_number_packages_of_cigare $43. ;
		informat visit_number_of_years_smoking 2.;
 			informat visit_patient_id 10. ;
         format VAR1 4. ;
         format visit_patient_id 10. ;
         format visit_date yymmdd10. ;
         format visit_weight_kg 5.2 ;
         format visit_height_cm 8.2 ;
         format visit_schooling $39. ;
         format visit_smoker $43. ;
         format visit_drink_alcoholic_beverages $5. ;
         format visit_time_daily_spend_walking_ $20. ;
         format visit_power_sports_so_you_sweat $26. ;
         format visit_das28bsr_score 5.2 ;
         format visit_sf36_pcsus_score 6.2 ;
         format visit_sf12_pcsus_score 6.2 ;
         format visit_das283crp_score 5.2 ;
         format visit_radai_score 6.3 ;
         format visit_mda_score 2. ;
         format visit_radai_5_score 6.3 ;
         format visit_sf12_mcsus_score 6.2 ;
         format visit_haq_score 6.3 ;
         format visit_euroqol_score 6.2 ;
         format visit_sf36_mcsus_score 6.2 ;
         format visit_mda_items 2. ;
         format visit_n_painfull_joints 2. ;
         format visit_n_swollen_joints 2. ;
         format visit_bsr 5.2 ;
         format visit_crp 5.2 ;
		 format visit_reference_area_crp_up_to 5.2;
         format visit_pain_level_today_radai 3. ;
         format visit_activity_of_rheumatic_dis 3. ;
         format visit_morning_stiffness_duratio $22. ;
		 format visit_are_you_smoker_eq_5d $43. ;
		 format visit_number_packages_of_cigare $43. ;
		 format visit_number_of_years_smoking 2.;
      input
                  VAR1 
                  visit_patient_id
                  visit_date  
                  visit_weight_kg  
                  visit_height_cm  
                  visit_schooling  $
                  visit_smoker  $
                  visit_drink_alcoholic_beverages  $
                  visit_time_daily_spend_walking_  $
                  visit_power_sports_so_you_sweat  $
                  visit_das28bsr_score
                  visit_sf36_pcsus_score  
                  visit_sf12_pcsus_score  
                  visit_das283crp_score  
                  visit_radai_score  
                  visit_mda_score
                  visit_radai_5_score  
                  visit_sf12_mcsus_score  
                  visit_haq_score  
                  visit_euroqol_score  
                  visit_sf36_mcsus_score  
                  visit_mda_items
                  visit_n_painfull_joints
                  visit_n_swollen_joints
                  visit_bsr
                  visit_crp  
				  visit_reference_area_crp_up_to
                  visit_pain_level_today_radai  
                  visit_activity_of_rheumatic_dis  
                 visit_morning_stiffness_duratio  $
				 visit_are_you_smoker_eq_5d $
				visit_number_packages_of_cigare $
				visit_number_of_years_smoking 
     ;
      if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
      run;

	  /*proc sort data=my.visit; by visit_date ; run; */
	  /*9 march 1995 until 25 Nov 2019
	  first in 1995 */

proc sort data=my.visit; by visit_patient_id visit_date;
	
	data lastvisit (keep=patid lastvisit); 
	set my.visit; 

	by visit_patient_id; 
	if last.visit_patient_id; 
	rename visit_patient_id = patid visit_date= lastvisit; 
	run; 

proc sql; 
create table visit1 (keep=visit_patient_id lastvisit) as
select *
from my.visit left join lastvisit
on visit_patient_id = patid; 
quit; 

proc sort data=visit1 nodupkeys; by visit_patient_id; run; 
proc sql; select count (distinct visit_patient_id) from visit1 ;quit;      /*9852 patients*/

    data patient    ;
      %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
     infile 'I:\Theresa\ETH DATEN\SCQM\Clustering\data\pat_outR_noNA.csv' MISSOVER DSD lrecl=32767 firstobs=2 ;
         informat VAR1 4. ;
         informat patient_id 32. ;
         informat patient_gender $8. ;
         informat patient_date_of_birth yymmdd10. ;
         informat patient_language $4. ;
         informat patient_diagnose $25. ;
         informat patient_date_first_symptoms yymmdd10. ;
         informat patient_date_diagnosis yymmdd10. ;
         informat patient_family_anamnesis_yn $5. ;
         informat patient_ra_crit_rheumatoid_fact $5. ;
         informat patient_rheumatoid_factor_titer 32. ;   
         informat patient_rheumatoid_factor_uln 32. ;
         informat patient_anti_ccp $5. ;
         informat patient_anti_ccp_titer 32. ;   
		 informat patient_anti_ccp_uln 32. ;  
         informat patient_date_discontinuation yymmdd10. ;
         format VAR1 4. ;
         format patient_id yymmdd10. ;
         format patient_gender $8. ;
         format patient_date_of_birth yymmdd10. ;
         format patient_language $4. ;
         format patient_diagnose $25. ;
         format patient_date_first_symptoms yymmdd10. ;
         format patient_date_diagnosis yymmdd10. ;
         format patient_family_anamnesis_yn $5. ;
         format patient_ra_crit_rheumatoid_fact $5. ;
         format patient_rheumatoid_factor_titer 32. ;   
         format patient_rheumatoid_factor_uln 32. ;
         format patient_anti_ccp $5. ;
         format patient_anti_ccp_titer 32. ;   
		 format patient_anti_ccp_uln 32. ;  
         format patient_date_discontinuation yymmdd10. ;
     input
                 VAR1  
                 patient_id
                 patient_gender  $
                 patient_date_of_birth  
                 patient_language  $
                 patient_diagnose  $
                 patient_date_first_symptoms  
                 patient_date_diagnosis  
                 patient_family_anamnesis_yn  $
                 patient_ra_crit_rheumatoid_fact  $
                 patient_rheumatoid_factor_titer  
                 patient_rheumatoid_factor_uln 
                 patient_anti_ccp $
                 patient_anti_ccp_titer   
		         patient_anti_ccp_uln 
                 patient_date_discontinuation  
      ;
     if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
     run;

proc sql; select count (distinct medication_patient_id) from work.med;quit; /*9449*/
proc sql; select count (distinct medication_patient_id) from my.medication;quit; /*9449*/
proc sql; select count (distinct patient_id) from patient;quit;  /*9956*/
proc sql; select count (distinct visit_patient_id) from my.visit;quit;  /*9852 RA patients*/

/*get treatment stop date as potential outcome*/
proc sql; 
create table medfurthmed (drop=medication_patient_id medication_id var1) as
select *
from work.medfurth left join my.medication
on medication_patient_id = patid; 
quit; 

proc sort data=medfurthmed ; by patid medication_start_date medication_stop_date; run; 
proc sql; select count (distinct patid) from medfurthmed ;quit; /*3528*/
/*proc print data=medfurthmed ; where medication_start_date=.; run; 
only dmard and prednison, only 12 rows*/

/*proc print data=medfurthmed ; where find(medication_drug, 'OTHER'); run; 
47 rows*/

/*add first visit*/
proc sql; 
create table medfurthmedfirst (drop=visit_patient_id) as
select *
from medfurthmed left join my.visit_help
on patid = visit_patient_id; 
quit; 
/*
data see; 
set medfurthmedfirst ; 
if index_date = medication_start_date; 
run; 

proc print data=see; where firstvisit gt medication_start_date; run; 
*/

data medfurthmedfirst (drop= firstvisit); 
set medfurthmedfirst; 
if medication_start_date=. then medication_start_date=firstvisit;
run; 


/*proc print data=medfurthmedfirst ; where medication_start_date=.; run; 
0 rows*/

/*add last visit*/
proc sql; 
create table medfurthmedfirstlast (drop=visit_patient_id) as
select *
from medfurthmedfirst left join visit1
on patid = visit_patient_id; 
quit; 

/*proc print data=medfurthmedfirstlast ; where medication_stop_date=.; run; 
0 rows*/


data my.pat (drop= patient_cod_year) ; 
set patient; 

death = mdy(7,1,patient_cod_year);

format death yymmdd10.; 
run; 


proc sql; 
create table mfmflpat (drop=patient_id) as
select patid,
		index_date,
		index_drug,
		medication_start_date,
		medication_drug,
		medication_stop_date,
		medication_stop_reasons,
		lastvisit as c1 format yymmdd10.,
		patient_id,
		patient_date_discontinuation as c2 format yymmdd10.,
		death as c3 format yymmdd10.
from medfurthmedfirstlast left join my.pat
on patid = patient_id; 
quit; 

proc sql; select count (distinct patid) from mfmflpat;quit; /*3528*/




data mfmflpat_stop (drop = index_reason_help medication_stop_reasons) ;
set mfmflpat;

if index_date = medication_start_date and find(medication_drug,'BIOLOGIC')
then index_reason_help = medication_stop_reasons ; 

if index_reason_help in ("WITHDRAWAL_REASON_NOT_EFFECTIVE",
"WITHDRAWAL_REASON_NOT_EFFECTIVE,WITHDRAWAL_REASON_ADVERSE_EVENT",
"WITHDRAWAL_REASON_NOT_EFFECTIVE,WITHDRAWAL_REASON_ADVERSE_EVENT,WITHDRAWAL_REASON_OTHER",
"WITHDRAWAL_REASON_NOT_EFFECTIVE,WITHDRAWAL_REASON_OTHER")
then index_reason = 1; 


run; 


data mfmflpat_stop2 (drop=Exist);
do until(last.patid);
    set mfmflpat_stop; by patid;
           if missing(Exist) then Exist = index_reason ;
    end;
do until(last.patid);
   set mfmflpat_stop; by patid;
        if missing(index_reason ) then index_reason  = coalesce(Exist,.);
        else Exist =index_reason ;
    output;
    end;
run;


data mfmflpat2; 
set mfmflpat_stop2; 
rownum = _n_; 
run; 

data mfmflpat3 (keep=c1-c3); 
set mfmflpat_stop2; 

if missing(c1) then c1='22dec2020'd; /*no missing*/
if missing(c2) then c2='22dec2020'd;
if missing(c3) then c3='22dec2020'd;

run; 
/*
proc print data=mfmflpat3; where c1 = '22dec2020'd; run; 
0 rows*/


data mfmflpat4  (keep=min_date);
   set mfmflpat3;
    array c{*} _numeric_;

min_date = min(of c{*});       /* min value for this observation */
 
format min_date yymmdd10.;

run;

data mfmflpat4 ; 
set mfmflpat4;
rownum = _n_; 
run; 


data mfmflpat5 (drop=c1-c3 rownum );
merge mfmflpat4 mfmflpat2;
by rownum;

min_date = min_date + 31;  /*add uncertainty period to censor dates*/

run; 

proc sql; select count (distinct patid) from work.mfmflpat5; quit; /*3528*/

data medused (drop= medication_start_date medication_stop_date censor min_date);
format censor_date yymmdd10.;
set mfmflpat5;

/*time under treatment until index_date*/
time_med=index_date-medication_start_date; 
/*only keep medications that were started at least at intex date (or later)*/
if time_med ge 0; 

if index_date = medication_start_date and find(medication_drug,'BIOLOGIC') then do; 

	if medication_stop_date=. then do; 
	censor = 1 ; 
	censor_date = min_date ; /*end due to censoring*/
	censor_reason = 3; 
	end; 
	else if medication_stop_date ne . then do; 
		if medication_stop_date le min_date then do; 
		censor=0; 
		censor_date = medication_stop_date +31; /*end due to medication stop*/
		censor_reason = 4; 
		end;
		else if medication_stop_date gt censor_date then do; 
		censor=1; 
		censor_date = min_date ; /*end due to censoring*/
		censor_reason = 3; 
		end;
	end;

follow_up = censor_date - index_date; 

end; 

if censor=0 then rx_stsw_outcome = 1; 
if censor=1 then rx_stsw_outcome = 0; 

run; 

proc sql; select count (distinct patid) from work.medused; quit; /*3528*/

/*
proc print data = medused ; where drugsurvival ne . and  drugsurvival lt 0; run; 
0 rows*/

data fillcensor_date (drop=Exist);
do until(last.patid);
    set medused; by patid;
           if missing(Exist) then Exist = censor_date ;
    end;
do until(last.patid);
   set medused; by patid;
        if missing(censor_date ) then censor_date  = coalesce(Exist,.);
        else Exist =censor_date ;
    output;
    end;
run;

data fillcensor_date; 
set fillcensor_date; 

if censor_date ge index_date; 

run; 

proc sql; select count (distinct patid) from fillcensor_date; quit; /*3506*/

data fillfollow_up (drop=Exist);
do until(last.patid);
    set fillcensor_date; by patid;
           if missing(Exist) then Exist = follow_up;
    end;
do until(last.patid);
   set fillcensor_date; by patid;
        if missing(follow_up) then follow_up = coalesce(Exist,.);
        else Exist =follow_up;
    output;
    end;
run;


data fillrx_stsw_outcome (drop=Exist);
do until(last.patid);
    set fillfollow_up; by patid;
           if missing(Exist) then Exist =rx_stsw_outcome ;
    end;
do until(last.patid);
   set fillfollow_up; by patid;
        if missing(rx_stsw_outcome ) then rx_stsw_outcome  = coalesce(Exist,.);
        else Exist = rx_stsw_outcome ;
    output;
    end;
run;

data fillrx_censor_reason (drop=Exist);
do until(last.patid);
    set fillrx_stsw_outcome; by patid;
           if missing(Exist) then Exist =censor_reason;
    end;
do until(last.patid);
   set fillrx_stsw_outcome; by patid;
        if missing(censor_reason) then censor_reason = coalesce(Exist,.);
        else Exist = censor_reason;
    output;
    end;
run;



proc sort data=fillrx_censor_reason noduprecs; by patid medication_drug descending time_med index_drug follow_up rx_stsw_outcome censor_date censor_reason index_reason ; run;  

/* remove duplicate medication in the datafile*/
data medusednodup (drop=medication_drug_lag); 
set fillrx_censor_reason; 

medication_drug_lag = lag (medication_drug); 

by patid; 
if first.patid then medication_drug_lag=.; 

if medication_drug = medication_drug_lag then delete; 
run; 

proc sort data=medusednodup noduprecs; by patid index_date index_drug follow_up rx_stsw_outcome censor_date censor_reason index_reason; run; 

PROC TRANSPOSE DATA=medusednodup OUT=medtrans prefix=delta_;
   BY patid index_date index_drug follow_up rx_stsw_outcome censor_date censor_reason index_reason;
   ID medication_drug ;
   RUN;

data my.medtrans (keep=patid rownum index_date index_drug follow_up rx_stsw_outcome  censor_date censor_reason index_reason delta_DMARD_MTX delta_DMARD_SZS 
delta_PREDNISON_STEROID delta_PREDNISON_STEROID_MR delta_DMARD_CHLOROCHINE delta_DMARD_LEFLUN delta_DMARD_CYA delta_DMARD_AZATH
					DMARD_MTX DMARD_SZS PREDNISON_STEROID PREDNISON_STEROID_MR 
					DMARD_CHLOROCHINE DMARD_LEFLUN DMARD_CYA DMARD_AZATH); 
set medtrans; 

rownum = _n_;

if delta_DMARD_MTX=0 then delta_DMARD_MTX=.;
DMARD_MTX=1; if delta_DMARD_MTX=. then DMARD_MTX=0;

if delta_DMARD_SZS=0 then delta_DMARD_SZS=.;
DMARD_SZS=1; if delta_DMARD_SZS=. then DMARD_SZS=0;

if delta_PREDNISON_STEROID=0 then delta_PREDNISON_STEROID=.;
PREDNISON_STEROID=1; if delta_PREDNISON_STEROID=. then PREDNISON_STEROID=0; 

if delta_PREDNISON_STEROID_MR=0 then delta_PREDNISON_STEROID_MR=.;
PREDNISON_STEROID_MR=1; if delta_PREDNISON_STEROID_MR=. then PREDNISON_STEROID_MR=0; 

if delta_DMARD_CHLOROCHINE=0 then delta_DMARD_CHLOROCHINE=.;
DMARD_CHLOROCHINE=1; if delta_DMARD_CHLOROCHINE=. then DMARD_CHLOROCHINE=0;

if delta_DMARD_LEFLUN=0 then delta_DMARD_LEFLUN=.;
DMARD_LEFLUN=1; if delta_DMARD_LEFLUN=. then DMARD_LEFLUN=0;

if delta_DMARD_CYA=0 then delta_DMARD_CYA=.;
DMARD_CYA=1; if delta_DMARD_CYA=. then DMARD_CYA=0;

if delta_DMARD_AZATH=0 then delta_DMARD_AZATH=.;
DMARD_AZATH=1; if delta_DMARD_AZATH=. then DMARD_AZATH=0;

delta_DMARD_MTX=delta_DMARD_MTX/365;
delta_DMARD_SZS=delta_DMARD_SZS/365;
delta_PREDNISON_STEROID=delta_PREDNISON_STEROID/365;
delta_PREDNISON_STEROID_MR=delta_PREDNISON_STEROID_MR/365;
delta_DMARD_CHLOROCHINE=delta_DMARD_CHLOROCHINE/365;
delta_DMARD_LEFLUN=delta_DMARD_LEFLUN/365;
delta_DMARD_CYA=delta_DMARD_CYA/365;
delta_DMARD_AZATH=delta_DMARD_AZATH/365;

run; 

proc sql; select count (distinct patid) from my.medtrans; quit; /*3506*/
