/* comment any using shift and forward slash */
/* IMPORTING THE DATA THROUGH DATALINES */
DATA DSP20.SAMPLE;
	INPUT NAME$ AGE GENDER$ SALARY;
	DATALINES;
ABC 22 M 2500
GHJ 55 F 5555
DDD 45 M 5465
;
RUN;

PROC PRINT DATA=dsp20.sample;
	TITLE 'EMPLOYEE DATA';
RUN;

proc print data= dsp20.iris label;
label SepalLength = 'Sepal Length'
		SepalWidth = 'Sepal Width'
		PetalLength = 'Petal Length';
var SepalLength SepalWidth PetalLength;
run;


/* IMPORT THE DATA USING LIST INPUT METHOD */

DATA DSP20.IRIS;
INFILE '/home/u44989252/Iris.csv' DLM= ',' FIRSTOBS=2;
FORMAT CLASS $15.;
INPUT SepalLength	SepalWidth	PetalLength	PetalWidth	Class$;
RUN;

PROC CONTENTS DATA=dsp20.iris;
RUN;


/* IMPORT THE DATA SET UNING PROC INPUT */
PROC IMPORT out= DSP20.BIGMART_TRAIN 
DATAFILE= '/home/u44989252/train_kOBLwZA.csv' dbms=csv;
GETNAMES= YES;
GUESSINGROWS= 8523;
RUN;

PROC CONTENTS DATA=DSP20.bigmart_train;
RUN;

/* summary of the data */
proc means data=dsp20.bigmart_train mean median nmiss skewness q1 Q3 MAXDEC=2;
VAR Item_Weight Item_Visibility Item_MRP Item_Outlet_Sales;
CLASS Item_Fat_Content;
run;

/* OUTPUT A RESULT */
proc means data=dsp20.bigmart_train mean median nmiss skewness q1 Q3 MAXDEC=2;
VAR Item_Weight Item_Visibility Item_MRP Item_Outlet_Sales;
CLASS Item_Fat_Content;
OUTPUT OUT = DSP20.SAMPLEOUTPUT;
run;


/* USNIGN SUMMAY */
proc SUMMARY data=dsp20.bigmart_train mean median nmiss skewness q1 Q3 MAXDEC=2;
VAR Item_Weight ;
OUTPUT OUT = DSP20.SAMPLEOUTPUT;
run;

/* UNIVARIATE ANALYISIS */
PROC UNIVARIATE DATA= dsp20.BIGMART_TRAIN;
VAR Item_MRP;
RUN;

/* CHEKING FREQUENCY */
PROC FREQ DATA= DSP20.bigmart_train;
TABLE Outlet_Size;
RUN;

/* CHEKING FREQUENCY WITH NO PERCENTAGE AND CUMULLATIVE FREQUNCY*/
PROC FREQ DATA= DSP20.bigmart_train;
TABLE Outlet_Size/ NOPERCENT NOCUM;
RUN;

/* WITH TWO VARIABLE WITH CHISQ TEST*/
PROC FREQ DATA= DSP20.bigmart_train;
TABLE Outlet_Location_Type*Outlet_Type/ NOPERCENT NOCUM NOROW NOCOL chisq;
RUN;


/* MERGING TWO TABLE */
DATA DSP20.A;
	INPUT EMPID$ LASTNAME$;
	DATALINES;
 	E00632 STAUSS
 	E01483 LEE
 	E01996 NICK
 	E04064 WASCHK
;
RUN;

DATA DSP20.B;
	INPUT EMPID$ FLIGHTNUM;
	DATALINES;
 	E04064 5105
 	E00632 5250
 	E01996 5501
;
RUN;

/* SORT THE DATA */

PROC SORT DATA= dsp20.A;
BY EMPID;
RUN;
PROC SORT DATA= dsp20.B;
BY EMPID;
RUN;

DATA DSP20.MERGED_A_AND_B;
MERGE dsp20.A (IN=A) dsp20.B (IN=B);
BY EMPID;
IF A AND B;
RUN;

DATA DSP20.MERGED_A_OR_B;
MERGE dsp20.A (IN=A) dsp20.B (IN=B);
BY EMPID;
IF A OR B;
RUN;

DATA DSP20.MERGED_A_ONLY;
MERGE dsp20.A (IN=A) dsp20.B (IN=B);
BY EMPID;
IF A;
RUN;

DATA DSP20.MERGED_ONLY_B;
MERGE dsp20.A (IN=A) dsp20.B (IN=B);
BY EMPID;
IF B;
RUN;

DATA DSP20.MERGED_IF_A_NOT_B;
MERGE dsp20.A (IN=A) dsp20.B (IN=B);
BY EMPID;
IF A AND NOT B;
RUN;

DATA DSP20.MERGED_IF_B_NOT_A;
MERGE dsp20.A (IN=A) dsp20.B (IN=B);
BY EMPID;
IF B AND NOT A;
RUN;

/* APPEND THE DATA OF TWO TABLE */
DATA DSP20.APPEND;
SET dsp20.merged_a_only DSP20.merged_if_b_not_a;
RUN;

/* PREATION OF DATA */

DATA DSP20.BIGMART_TRAIN_IMPUTE;
SET DSP20.bigmart_train;
IF Item_Weight = . THEN Item_Weight = 12.60; /*HARDCODE A MEDIAN*/
RUN;

DATA DSP20.BIGMART_TRAIN_IMPUTE;
SET dsp20.bigmart_train_impute;
IF Outlet_Size = '' THEN Outlet_Size = 'MEDIUM';
RUN;

PROC FREQ DATA= dsp20.bigmart_train_impute;
TABLE Outlet_Size/ NOCOL NOROW NOPERCENT;
RUN;

PROC MEANS DATA=dsp20.bigmart_train_impute NMISS;
 VAR Item_Weight;
 RUN;


DATA DSP20.bigmart_train_impute;
SET dsp20.bigmart_train_impute;
IF Item_Fat_Content ='LF' THEN Item_Fat_Content = 'Low Fat';
IF Item_Fat_Content = 'low fat' THEN Item_Fat_Content = 'Low Fat';
IF Item_Fat_Content = 'reg' THEN Item_Fat_Content = 'Regular';
run;


PROC FREQ DATA= dsp20.bigmart_train_impute;
TABLE Item_Fat_Content/ NOCOL NOROW NOPERCENT;
RUN;

/* INSERING A NEW VARIABLE */
data dsp20.bigmart_train_impute;
	set dsp20.bigmart_train_impute;
	YOB = 2019 - Outlet_Establishment_Year;
	LN_MRP = LOG(Item_MRP);
	RUN;

data dsp20.bigmart_train_impute;
	set dsp20.bigmart_train_impute;
	IF Item_Weight LT 12.60 THEN ITEM_CLASS = 'LOW WEIGHT';
	IF Item_Weight GE 12.60 THEN ITEM_CLASS = 'HIGH WEIGHT';
	RUN;


PROC FREQ DATA=dsp20.bigmart_train_impute;
	table ITEM_CLASS/ nocum norow nocol;
	run;

/* lenics */
/*  */
/* greater than > GT */
/* less than < LT */
/* greater than or equal to GE */
/* less than or equal to LE */
/* equal  */

/* bi variate analysis */

proc corr data=dsp20.bigmart_train_impute;
run;

/* bivaraite to spicify variable */

proc corr data=dsp20.bigmart_train_impute;
var   Item_Weight Item_Outlet_Sales Item_MRP;
run; 


/* plot bivariate with coor */
proc corr data=dsp20.iris plots=all;
run;

/* plot univariate with coor */
PROC UNIVARIATE DATA= dsp20.BIGMART_TRAIN plots;
VAR Item_MRP;
RUN;


Data dsp20.score;
input student$9.+1 studentID$ selection$ test1 test2 final;
datalines;
capallieti 0545 1 94 91 87
Dubose     1252 2 51 65 91
englaes    1167 1 95 97 97
Grant      1230 2 63 75 80
Krishpski  2527 2 80 76 91 
lundsford  4860 1 92 40 86
mcbane     0647 1 75 78 72
;
run;

/* Transpose  */
proc transpose data=dsp20.score
out=DSP20.score_tranposed;
id student;
run;
proc print data=score_tranposed noobs;
 title 'student test scores';
 run;

PROC IMPORT out= DSP20.sales
DATAFILE= '/home/u44989252/sales.csv' dbms=csv;
GETNAMES= YES;
GUESSINGROWS= 200;
RUN;

DATA DSP20.AU DSP20.US;
SET Dsp20.sales;
IF  Country = 'AU' THEN OUTPUT DSP20.AU;
IF  Country = 'US' THEN OUTPUT DSP20.US;
RUN;


DATA DSP20.SALES_1;
SET DSP20.SALES;
FULL_NAMES = TRIM(First_Name)||''||TRIM(Last_Name);
RUN;

/* DELIMITER */
DATA DSP20.SALES_1;
SET DSP20.SALES_1;
FNAMES = SCAN(FULL_NAMES,1,'');
LNAMES = SCAN(FULL_NAMES,2,'');
RUN;

DATA DSP20.SALES_1;
SET DSP20.SALES_1;
INITAIL = SUBSTR(FULL_NAMES,1,1);
RUN;
/*  */
/* DATA DSP20.SALES_1; */
/* SET DSP20.SALES_1; */
/* LAST_INTIAL = SUBSTR(LASTNAME,1,1) */
/* HOME_PHONE = HOMEPHONE; */
/* SUBSRT(HOMEPHONE,1,1) = '+'; */
/* RUN; */

/* DROP A CLOUMN */
DATA DSP20.SALES_1 (DROP= FNAMES LNAMES);
SET DSP20.SALES_1;
RUN;

DATA DSP20.SALES_1;
SET DSP20.SALES_1;
DESTINATION = TRANWRD(Designation,'Rep','Representative');
Run;


/* data dsp.20.SALES_1; */
/* Set DSP20.SALES_1; */
/* CHECK = INDEX(DESTINATION,'Representative'); */
/* RUN; */


/* NUMERINC FUNCTION */
DATA DSP20.BIGMART_TRAIN;
SET dsp20.bigmart_train;
ROUND_ITEMWEIGHT = ROUND(Item_Weight);
CEIL_ITEMWEIGHT = CEIL(Item_Weight);
FLOR_ITEMWEIGHT = FLOOR(Item_Weight);
RUN;

/* staistical transformation */
data dsp20.descript;
var1 =12;
var2= .;
var3 = 7;
var4 = 5;
sumvars = sum(var1,var2,var3,var4);
average = mean(var1,var2,var3,var4);
miss = cmiss(var1,var2,var3,var4);
run;

/* date transformation */
/* data dsp20.sales_1; */
/* set dsp20.sales_1; */
/*  */
/* intck = intck('date',Hire_date,Birth_Date); */
/* run; */

/* data conversation */
data converstion;
cvar='32000';
cvar1='30.000';
cvar2 ='03may2008';
cvar3='03050800';
nvar1 = input(cvar,5.);
nvar2 = input(cvar1,commax6.);
nvar3 = input(cvar2,date9.);
nvar4 = input(cvar3,ddmmyy6.);
run;

proc contents data=converstion;
run;




data convet_numbers;
Nvar =614;
Nvar1=5000;
Nvar2=355;
Cvar1= put(nvar,3.);
cvar2=put(nvar1,dollar6.);
cvar3=put(nvar2,date9.);
cvar4= log(Nvar)
run;

proc contents data=convet_numbers;
run;

proc sql;
select * from dsp20.sales;
quit;
run;

proc sql;
select  Item_Type, Item_MRP, Item_Fat_Content,Item_MRP*.06 as new from DSP20.BIGMART_TRAIN
where  Item_Fat_Content = 'Low Fat'
order by  Item_Type desc;
quit;


proc sql;
select  Item_Type, Item_MRP, Item_Fat_Content,log(Item_MRP) as newmrp from DSP20.BIGMART_TRAIN
where  Item_Fat_Content = 'Low Fat'
order by  newmrp desc;
quit;



/* CREATEING A TABLE USING SQL */
proc sql;
CREATE TABLE DSP20.TRAIL AS
select  Item_Type, Item_MRP, Item_Fat_Content,log(Item_MRP) as newmrp from DSP20.BIGMART_TRAIN
where  Item_Fat_Content = 'Low Fat'
order by  newmrp desc;
quit;


PROC SQL;
CREATE TABLE EXERCISE AS
SELECT  Item_Weight,Item_MRP, (Item_Weight/Item_MRP) AS DIVINDING, (1/Item_Weight) AS INVERSEWEIGHT, (1/Item_MRP) AS INVERSEMRP
/* SELECT  Item_Weight, (1/Item_Weight) AS INVERSEWEIGHT */
/* SELECT  Item_MRP, (1/Item_MRP) AS INVERSEWEIGHT */
from DSP20.BIGMART_TRAIN;
QUIT;

PROC SQL;
SELECT COUNT(*)
FROM DSP20.BIGMART_TRAIN;
QUIT;


PROC SQL;
SELECT Outlet_Location_Type, COUNT(Outlet_Type) AS OutletType
FROM DSP20.BIGMART_TRAIN
GROUP BY  Outlet_Location_Type;
QUIT;


PROC MEANS DATA= DSP20.BIGMART_TRAIN NMISS;
RUN;

PROC SQL;
SELECT Item_Fat_Content, AVG(Item_Weight) AS AVERGEWEIGHT
FROM  DSP20.BIGMART_TRAIN_IMPUTE
GROUP BY Item_Fat_Content;
QUIT;

/* mering */
PROC IMPORT out= DSP20.dosing 
DATAFILE= '/home/u44989252/Dosing.xlsx' dbms=xlsx;
GETNAMES= YES;
GUESSINGROWS= 20;
RUN;

PROC IMPORT out= DSP20.Vitals
DATAFILE= '/home/u44989252/Vitals.xlsx' dbms=xlsx;
GETNAMES= YES;
GUESSINGROWS= 20;
RUN;

proc sql;
	create table new as
	select a.patient,a.med,b.pulse,b.temp
	from DSP20.dosing  as a,DSP20.Vitals as b
	where a.patient = b.patient;
quit;

proc sql;
	create table leftjoin as
	select a.patient,a.med,b.pulse,b.temp
	from DSP20.dosing as a left join DSP20.Vitals as b on a.patient = b.patient;
quit;

proc sql;
	create table rj as
	select a.patient,a.med,b.pulse,b.temp
	from DSP20.dosing as a RIGHT join DSP20.Vitals as b on a.patient = b.patient;
quit;



proc sql;
	create table FULL as
	select a.patient,a.med,b.pulse,b.temp
	from DSP20.dosing as a FULL JOIN DSP20.Vitals as b on a.patient = b.patient;
quit;

PROC FREQ DATA= dsp20.bigmart_train_impute;
RUN;

PROC REG DATA=dsp20.bigmart_train_impute;
MODEL ITEM_OUTLET_SALES = ITEM_WEIGHT ITEM_VISIBILITY ITEM_MRP YOB;
OUTPUT OUT=DSP20.BIGPREDIT PREDICTED=PY RESIDUAL=RY;
RUN;


proc princomp data=dsp20.bigmart_train_impute n=2 plots=none
	out=work.printcom_score;
var ITEM_WEIGHT ITEM_VISIBILITY ITEM_MRP YOB;
run;

proc reg data= work.printcom_score;
model ITEM_OUTLET_SALES =  Prin1 Prin2;
output out= example predicted= py residual= ry;
run;


proc glm data= dsp20.bigmart_train_impute;
class  Item_Fat_Content Item_Type Outlet_Size Outlet_Location_Type Outlet_Type;
model ITEM_OUTLET_SALES = ITEM_WEIGHT ITEM_VISIBILITY ITEM_MRP YOB  Item_Fat_Content Item_Type Outlet_Size Outlet_Location_Type Outlet_Type;
output out = predicted p = preds r = residual;
run;







