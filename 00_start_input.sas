/*
proc import datafile="I:\Theresa\ETH DATEN\SCQM\Clustering\data\visit_outR_noNA.csv"
         out=visit
         dbms=csv
         replace;
run;*/

libname my "I:\Theresa\ETH DATEN\SCQM\Clustering\my";

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


   data WORK.VISIT    ;
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


    data WORK.PAT    ;
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
proc sql; select count (distinct patient_id) from work.pat;quit;  /*9956*/
proc sql; select count (distinct visit_patient_id) from work.visit;quit;  /*9852 RA patients*/

/*get new users of RA targeted therapies*/
/*defined as a first RA targeted therapy on the first visit or lateron*/
/*RA targeted therapy is allowed to start a maximum of 91 days after a visit to carry values forward if needed*/
/*otherwise the treatment start date is considered a visit*/

proc sort data=visit ; by  visit_patient_id visit_date;run;


data my.visit_help (keep=firstvisit visit_patient_id);
set visit;
if missing(visit_date) then delete; 
by visit_patient_id;
if first.visit_patient_id;
rename  visit_date = firstvisit; 
run;     

proc sql; select count (distinct visit_patient_id) from my.visit_help;quit;  /*9852 RA patients, all there*/


proc sql; 
create table medvis (drop= visit_patient_id) as
select visit_patient_id,
		medication_patient_id,
		medication_start_date,
		medication_drug,
		firstvisit
from my.visit_help left join med
on visit_patient_id = medication_patient_id;
quit; 

proc sort data=medvis ; by  medication_patient_id medication_start_date;run;   

proc sql; select count (distinct medication_patient_id) from work.medvis;quit;  /*9438 RA patients, all there*/

data medication;
set medvis;
if missing(medication_drug) then delete; 
if missing(medication_start_date) then delete; 
if find(medication_drug, 'PREDNISON') or find(medication_drug, 'DMARD') or find(medication_drug, 'OTHER')then delete;
run; 

proc sql; select count (distinct medication_patient_id) from work.medication;quit;  /* 6449 RA patients */

data medication; 
set medication; 
if find(medication_drug, 'BIOLOGIC') and medication_start_date ge firstvisit then newuser=1;    
else newuser=0; 

run; 

proc sort data=medication ; by  medication_patient_id medication_start_date;run;

data medication; 
set medication; 
by medication_patient_id;
if first.medication_patient_id;
run; 

proc sql; select count (distinct medication_patient_id) from work.medication;     quit;     /* 6449 RA patients */


data first_users (drop= newuser firstvisit); 
set medication; 
if newuser=0 then delete; 
run; 

proc sql; select count (distinct medication_patient_id) from first_users;     quit;     /*4257 patients targeted therapy new users*/


proc sql; 
create table medvis2 (drop= medication_patient_id) as
select visit_patient_id,
		medication_patient_id,
		medication_start_date,
		 medication_drug,
		visit_date
from visit left join first_users
on visit_patient_id = medication_patient_id
where not missing(medication_start_date);
quit; 

proc sql; select count (distinct  visit_patient_id) from work.medvis2 ;     quit;     /*4257 patients targeted therapy new users*/

data medvis3; 
set medvis2; 
diff=medication_start_date-visit_date;
if 0 le diff; 

run; 

data  medvis3; 
set  medvis3; 

by visit_patient_id ;
if last.visit_patient_id;
run; 

proc univariate data= medvis3;   var diff; run; 
/*0-50% 0 days, 75% 42 days, 90% 196 days*/

data sameorbefore; 
set medvis2; 
diff=medication_start_date-visit_date;
if 0 le diff lt 183; 

run; 

proc sort data=sameorbefore ; by  visit_patient_id visit_date;run;

data my.sameorbefore (drop=visit_date diff); 
set sameorbefore; 

by visit_patient_id ;
if last.visit_patient_id;
run; 

proc sql; select count (distinct visit_patient_id) from my.sameorbefore;     quit;     
/*3528 patients with targeted therapy have a visit within 91 days prior*/
/*proc univariate data=sameorbefore; var diff; run; */
/*50% 0 days, 75% 14 days, 90% 41 days*/

/*
data same; 
set my.sameorbefore; 
if diff=0; 
run; 

proc sql; select count (distinct visit_patient_id) from work.same;     quit;    
/*2258 patients have a first time targeted therapy on a visit date*/

