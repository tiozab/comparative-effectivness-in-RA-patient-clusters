libname my "I:\Theresa\ETH DATEN\SCQM\Clustering\my";


proc format;
value drugclass 1='other' 2='TNF' 3='JAK' ;
value drug 1='abat' 2='adal' 3='bari' 4='certo' 5='etan' 6='goli' 7='infli' 8='ritux'
                                9='toc' 10='tofa' ;
run;


data group1a;
set my.before; 

if (DMARD_AZATH+
DMARD_CHLOROCHINE+
DMARD_CYA+
DMARD_LEFLUN+
DMARD_MTX+
DMARD_SZS) ge 2; 

if PREDNISON_STEROID=1;

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

run; 

ods html file='validation_group1a.xls';

proc freq data=group1a;
tables das_outcome15m * (drugclass drug);
run;

proc freq data=group1a;
tables drugfail15m_non * (drugclass drug);
run;

title "DAS crude univariat normal dasred group1a";
proc phreg data=group1a/*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drugclass1 drugclass3  /rl ties=efron; 
run; 
title "DAS crude univariat normal dasred group1a";
proc phreg data=group1a/*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drugclass1 drugclass3 gender  delta_birth /rl ties=efron; 
run; 

title "DAS crude univariat normal dasred group1a";
proc phreg data=group1a /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 /rl ties=efron; 
run; 
title "DAS crude univariat normal dasred group1a";
proc phreg data=group1a /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 gender  delta_birth /rl ties=efron; 
run; 

title "NON  crude univariat normal dasred group1a";
proc phreg data=group1a /*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drugclass1 drugclass3 /rl ties=efron; 
run; 
title "NON  crude univariat normal dasred group1a";
proc phreg data=group1a /*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drugclass1 drugclass3 gender  delta_birth/rl ties=efron; 
run; 

title "NON crude univariat normal dasred group1a";
proc phreg data=group1a /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10  /rl ties=efron; 
run; 

title "NON crude univariat normal dasred group1a";
proc phreg data=group1a /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 gender delta_birth /rl ties=efron; 
run; 

title; run; 

ods html close; 
ods listing; 




data group1b;
set my.before; 

if RF=1 or (missing(RF) and anti_ccp=1);
if family_anamnesis=0 or missing(family_anamnesis);
if (DMARD_AZATH+
DMARD_CHLOROCHINE+
DMARD_CYA+
DMARD_LEFLUN+
DMARD_MTX+
DMARD_SZS) ge 2; 

if PREDNISON_STEROID=1;

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

run; 

ods html file='validation_group1b.xls';

proc freq data=group1b;
tables das_outcome15m * (drugclass drug);
run;

proc freq data=group1b;
tables drugfail15m_non * (drugclass drug);
run;

title "DAS crude univariat normal dasred group1b";
proc phreg data=group1b/*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drugclass1 drugclass3  /rl ties=efron; 
run; 
title "DAS crude univariat normal dasred group1b";
proc phreg data=group1b/*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drugclass1 drugclass3  gender delta_birth /rl ties=efron; 
run; 

title "DAS crude univariat normal dasred group1b";
proc phreg data=group1b /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 /rl ties=efron; 
run; 
title "DAS crude univariat normal dasred group1b";
proc phreg data=group1b /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10  gender delta_birth /rl ties=efron; 
run; 

title "NON  crude univariat normal dasred group1b";
proc phreg data=group1b /*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drugclass1 drugclass3 /rl ties=efron; 
run; 
title "NON  crude univariat normal dasred group1b";
proc phreg data=group1b /*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drugclass1 drugclass3  gender delta_birth/rl ties=efron; 
run; 

title "NON crude univariat normal dasred group1b";
proc phreg data=group1b /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10  /rl ties=efron; 
run; 

title "NON crude univariat normal dasred group1b";
proc phreg data=group1b /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 gender delta_birth /rl ties=efron; 
run; 

title; run; 

ods html close; 
ods listing; 



data group2;
set my.before; 

if gender=1; 

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

run; 

ods html file='validation_group2.xls';

proc freq data=group2;
tables das_outcome15m * (drugclass drug);
run;

proc freq data=group2;
tables drugfail15m_non * (drugclass drug);
run;

title "DAS crude univariat normal dasred group2";
proc phreg data=group2/*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drugclass1 drugclass3  /rl ties=efron; 
run; 
title "DAS crude univariat normal dasred group2";
proc phreg data=group2/*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drugclass1 drugclass3   delta_birth /rl ties=efron; 
run; 

title "DAS crude univariat normal dasred group2";
proc phreg data=group2 /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 /rl ties=efron; 
run; 
title "DAS crude univariat normal dasred group2";
proc phreg data=group2 /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10   delta_birth /rl ties=efron; 
run; 

title "NON  crude univariat normal dasred group2";
proc phreg data=group2 /*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drugclass1 drugclass3 /rl ties=efron; 
run; 
title "NON  crude univariat normal dasred group2";
proc phreg data=group2 /*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drugclass1 drugclass3   delta_birth/rl ties=efron; 
run; 

title "NON crude univariat normal dasred group2";
proc phreg data=group2 /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10  /rl ties=efron; 
run; 

title "NON crude univariat normal dasred group2";
proc phreg data=group2 /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10   delta_birth /rl ties=efron; 
run; 

title; run; 

ods html close; 
ods listing; 


data group3a;
set my.before; 

if RF=0 or (missing(RF) and anti_ccp=0);
if PREDNISON_STEROID=0;

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

run; 

ods html file='validation_group3a.xls';

proc freq data=group3a;
tables das_outcome15m * (drugclass drug);
run;

proc freq data=group3a;
tables drugfail15m_non * (drugclass drug);
run;

title "DAS crude univariat normal dasred group3a";
proc phreg data=group3a/*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drugclass1 drugclass3  /rl ties=efron; 
run; 
title "DAS crude univariat normal dasred group3a";
proc phreg data=group3a/*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drugclass1 drugclass3 gender   delta_birth /rl ties=efron; 
run; 

title "DAS crude univariat normal dasred group3a";
proc phreg data=group3a /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 /rl ties=efron; 
run; 
title "DAS crude univariat normal dasred group3a";
proc phreg data=group3a /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 gender   delta_birth /rl ties=efron; 
run; 

title "NON  crude univariat normal dasred group3a";
proc phreg data=group3a /*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drugclass1 drugclass3 /rl ties=efron; 
run; 
title "NON  crude univariat normal dasred group3a";
proc phreg data=group3a /*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drugclass1 drugclass3 gender   delta_birth/rl ties=efron; 
run; 

title "NON crude univariat normal dasred group3a";
proc phreg data=group3a /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10  /rl ties=efron; 
run; 

title "NON crude univariat normal dasred group3a";
proc phreg data=group3a /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 gender   delta_birth /rl ties=efron; 
run; 

title; run; 

ods html close; 
ods listing; 


data group3b;
set my.before; 

if RF=0 or (missing(RF) and anti_ccp=0);
if PREDNISON_STEROID=0;
if gender=0; 

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

run; 

ods html file='validation_group3b.xls';

proc freq data=group3b;
tables das_outcome15m * (drugclass drug);
run;

proc freq data=group3b;
tables drugfail15m_non * (drugclass drug);
run;

title "DAS crude univariat normal dasred group3b";
proc phreg data=group3b/*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drugclass1 drugclass3  /rl ties=efron; 
run; 
title "DAS crude univariat normal dasred group3b";
proc phreg data=group3b/*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drugclass1 drugclass3     delta_birth /rl ties=efron; 
run; 

title "DAS crude univariat normal dasred group3b";
proc phreg data=group3b /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 /rl ties=efron; 
run; 
title "DAS crude univariat normal dasred group3b";
proc phreg data=group3b /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10     delta_birth /rl ties=efron; 
run; 

title "NON  crude univariat normal dasred group3b";
proc phreg data=group3b /*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drugclass1 drugclass3 /rl ties=efron; 
run; 
title "NON  crude univariat normal dasred group3b";
proc phreg data=group3b /*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drugclass1 drugclass3     delta_birth/rl ties=efron; 
run; 

title "NON crude univariat normal dasred group3b";
proc phreg data=group3b /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10  /rl ties=efron; 
run; 

title "NON crude univariat normal dasred group3b";
proc phreg data=group3b /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10     delta_birth /rl ties=efron; 
run; 

title; run; 

ods html close; 
ods listing; 

/*high disease burden / duration, tendency towards being female and seropositive*/
data group4a;
set my.before; 

if RF=1 or (missing(RF) and anti_ccp=1); 
if delta_ra_disease ge 8; 
if das28bsr_score ge 5 or haq_score ge 1.5 or pain_level_today_radai ge 6 or activity_of_rheumatic_dis ge 6; 


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

run; 

ods html file='validation_group4a.xls';

proc freq data=group4a;
tables das_outcome15m * (drugclass drug);
run;

proc freq data=group4a;
tables drugfail15m_non * (drugclass drug);
run;

title "DAS crude univariat normal dasred group4";
proc phreg data=group4a/*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drugclass1 drugclass3  /rl ties=efron; 
run; 
title "DAS crude univariat normal dasred group4";
proc phreg data=group4a/*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drugclass1 drugclass3   delta_birth /rl ties=efron; 
run; 

title "DAS crude univariat normal dasred group4";
proc phreg data=group4a /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 /rl ties=efron; 
run; 
title "DAS crude univariat normal dasred group4";
proc phreg data=group4a /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10   delta_birth /rl ties=efron; 
run; 

title "NON  crude univariat normal dasred group4";
proc phreg data=group4a /*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drugclass1 drugclass3 /rl ties=efron; 
run; 
title "NON  crude univariat normal dasred group4";
proc phreg data=group4a /*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drugclass1 drugclass3   delta_birth/rl ties=efron; 
run; 

title "NON crude univariat normal dasred group4";
proc phreg data=group4a /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10  /rl ties=efron; 
run; 

title "NON crude univariat normal dasred group4";
proc phreg data=group4a /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 delta_birth /rl ties=efron; 
run; 

title; run; 

ods html close; 
ods listing; 



/*high disease burden / duration, tendency towards being female and seropositive*/
data group4b;
set my.before; 

if RF=1 or (missing(RF) and anti_ccp=1); 
if gender=0;
if delta_ra_disease ge 8; 
if das28bsr_score ge 5 or haq_score ge 1.5 or pain_level_today_radai ge 6 or activity_of_rheumatic_dis ge 6; 


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

run; 

ods html file='validation_group4b.xls';

proc freq data=group4b;
tables das_outcome15m * (drugclass drug);
run;

proc freq data=group4b;
tables drugfail15m_non * (drugclass drug);
run;

title "DAS crude univariat normal dasred group4";
proc phreg data=group4b/*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drugclass1 drugclass3  /rl ties=efron; 
run; 
title "DAS crude univariat normal dasred group4";
proc phreg data=group4b/*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drugclass1 drugclass3   delta_birth /rl ties=efron; 
run; 

title "DAS crude univariat normal dasred group4";
proc phreg data=group4b /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 /rl ties=efron; 
run; 
title "DAS crude univariat normal dasred group4";
proc phreg data=group4b /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10   delta_birth /rl ties=efron; 
run; 

title "NON  crude univariat normal dasred group4";
proc phreg data=group4b /*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drugclass1 drugclass3 /rl ties=efron; 
run; 
title "NON  crude univariat normal dasred group4";
proc phreg data=group4b /*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drugclass1 drugclass3   delta_birth/rl ties=efron; 
run; 

title "NON crude univariat normal dasred group4";
proc phreg data=group4b /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10  /rl ties=efron; 
run; 

title "NON crude univariat normal dasred group4";
proc phreg data=group4b /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 delta_birth /rl ties=efron; 
run; 

title; run; 

ods html close; 
ods listing; 

/*low disease burden patients*/
data group5a;
set my.before; 

if das28bsr_score le 3.2 or haq_score le 0.7 or pain_level_today_radai le 4 or activity_of_rheumatic_dis le 4; 

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

run; 

ods html file='validation_group5a.xls';

proc freq data=group5a;
tables das_outcome15m * (drugclass drug);
run;

proc freq data=group5a;
tables drugfail15m_non * (drugclass drug);
run;

title "DAS crude univariat normal dasred group5a";
proc phreg data=group5a/*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drugclass1 drugclass3  /rl ties=efron; 
run; 
title "DAS crude univariat normal dasred group5a";
proc phreg data=group5a/*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drugclass1 drugclass3 gender   delta_birth /rl ties=efron; 
run; 

title "DAS crude univariat normal dasred group5a";
proc phreg data=group5a /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 /rl ties=efron; 
run; 
title "DAS crude univariat normal dasred group5a";
proc phreg data=group5a /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 gender   delta_birth /rl ties=efron; 
run; 

title "NON  crude univariat normal dasred group5a";
proc phreg data=group5a /*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drugclass1 drugclass3 /rl ties=efron; 
run; 
title "NON  crude univariat normal dasred group5a";
proc phreg data=group5a /*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drugclass1 drugclass3 gender   delta_birth/rl ties=efron; 
run; 

title "NON crude univariat normal dasred group5a";
proc phreg data=group5a /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10  /rl ties=efron; 
run; 

title "NON crude univariat normal dasred group5a";
proc phreg data=group5a /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 gender   delta_birth /rl ties=efron; 
run; 

title; run; 

ods html close; 
ods listing; 

/*low disease burden/duration patients with tendency towards women and RF positivity*/
data group5b;
set my.before; 

if RF=1 or (missing(RF) and anti_ccp=1); 
if gender=0;
if das28bsr_score le 3.2 or haq_score le 0.7 or pain_level_today_radai le 4 or activity_of_rheumatic_dis le 4; 

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

run; 

ods html file='validation_group5b.xls';

proc freq data=group5b;
tables das_outcome15m * (drugclass drug);
run;

proc freq data=group5b;
tables drugfail15m_non * (drugclass drug);
run;

title "DAS crude univariat normal dasred group5b";
proc phreg data=group5b/*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drugclass1 drugclass3  /rl ties=efron; 
run; 
title "DAS crude univariat normal dasred group5b";
proc phreg data=group5b/*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drugclass1 drugclass3   delta_birth /rl ties=efron; 
run; 

title "DAS crude univariat normal dasred group5b";
proc phreg data=group5b /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 /rl ties=efron; 
run; 
title "DAS crude univariat normal dasred group5b";
proc phreg data=group5b /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_das *das_outcome15m  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10   delta_birth /rl ties=efron; 
run; 

title "NON  crude univariat normal dasred group5b";
proc phreg data=group5b /*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drugclass1 drugclass3 /rl ties=efron; 
run; 
title "NON  crude univariat normal dasred group5b";
proc phreg data=group5b /*covs (aggregate)*/; 
class drugclass (param=ref ref='TNF'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drugclass1 drugclass3   delta_birth/rl ties=efron; 
run; 

title "NON crude univariat normal dasred group5b";
proc phreg data=group5b /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10  /rl ties=efron; 
run; 

title "NON crude univariat normal dasred group5b";
proc phreg data=group5b /*covs (aggregate)*/; 
class drug (param=ref ref='adal'); 
/*id id;*/ 
model follow_up_drugfail *drugfail15m_non  (0)= drug1 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10 delta_birth /rl ties=efron; 
run; 

