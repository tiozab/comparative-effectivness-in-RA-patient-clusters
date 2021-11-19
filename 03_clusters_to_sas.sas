/*big only, with and without delta*/


proc import datafile="I:\Theresa\ETH DATEN\SCQM\Clustering\data\clusters_big_3.csv"
         out=clusters_run_1
         dbms=csv
         replace;
run;
proc import datafile="I:\Theresa\ETH DATEN\SCQM\Clustering\data\clusters_big_4.csv"
         out=clusters_run_2
         dbms=csv
         replace;
run;
proc import datafile="I:\Theresa\ETH DATEN\SCQM\Clustering\data\clusters_big_5.csv"
         out=clusters_run_3
         dbms=csv
         replace;
run;

proc import datafile="I:\Theresa\ETH DATEN\SCQM\Clustering\data\clusters_big_run3.csv"
         out=clusters_run_4
         dbms=csv
         replace;
run;
proc import datafile="I:\Theresa\ETH DATEN\SCQM\Clustering\data\clusters_big_run4.csv"
         out=clusters_run_5
         dbms=csv
         replace;
run;
proc import datafile="I:\Theresa\ETH DATEN\SCQM\Clustering\data\clusters_big_run5.csv"
         out=clusters_run_6
         dbms=csv
         replace;
run;

/*proc means min max data = my.before; var RF_titer; run; */

libname my "I:\Theresa\ETH DATEN\SCQM\Clustering\my";

option mprint; 
%macro buildcluster;
%do n=1 %to 6;

data clusters_run_&n (drop=var1); 
set clusters_run_&n; 
var=_n_; 
run; 

data my.before; 
set my.before; 
var=_n_; 
run;

data try_&n; 
merge my.before clusters_run_&n; 
by var; 

run; 

proc format;
value drugclass 1='other' 2='TNF' 3='JAK' ;
value drug 1='abat' 2='adal' 3='bari' 4='certo' 5='etan' 6='goli' 7='infli' 8='ritux'
                                9='toc' 10='tofa' ;
run;

data medstry_&n (drop=index_drug var); 
set try_&n; 

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


%end; 
%mend;
%buildcluster;

