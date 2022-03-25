/*
*******************************************************************************************************
Author:		 AM@mjhs.org
Date:		 06/28/2016
Description: SQL Patient Readmission Report  			
********************************************************************************************************
*/ 
Use 
Genesis
Go


Create table  #tbl_Parm_Date (
Startdateccyymm char(6),
Enddateccyymm   char(6)
)

insert into  #tbl_Parm_Date  values('201601','201606')


Create table  #tbl_Parm_Date_Patientlist (
Startdateccyymm char(6),
Enddateccyymm   char(6)
)
insert into  #tbl_Parm_Date_Patientlist values('201601','201606')


Create table #tbl_105_Readmits(
AdmitCCYYMM				      Char(6),
AdmitNum				      Int,
ContractCode                  Varchar(6),
BenefitPlanCode               Varchar(20),
Description                   Varchar(100),
DateofAdmission               Varchar (10),
DateofDischarge			      Varchar (10),
MemberId                      Varchar(11),
MemberName	                  Varchar(50),
RenderProviderParFlag         Varchar(1),
RenderProviderXRefId          Varchar(10),
RenderProviderName            Varchar(100),
AdmitPaidFlag                 Varchar(1),
SourceDischargeStatus         Varchar(3),
SourceAdmitTypeCode           Int,
ReAdmitInd                    Varchar(1),
CCSLevelKey                   Varchar(20),
CCSCategory                   Int,
TriggerRedadmitNum            Int,
TriggerDateOfAdmission        Varchar (10),
TriggerDateOfDischarge        Varchar (10), 
TriggerRenderProviderXRefID   Int,
TriggerRenderProvderName      Varchar(100),
TriggerSourceDischargeStatus  Varchar(3),
TriggerCCSLevelKey            Varchar(20),
TriggerCCSCategory            Int,
ReAdmitTypeInd                Varchar(1),
ReAdmitDays                   Int,
DiagTypeInd                   Varchar(1),
DateOfBirth                   Varchar(10)
)


Create table #tbl_125_last_Trigger(
AdmitNum                   Int,
TriggerReAdmitAdmitNum     Int)


Create table  #tbl_215_ReadmitbyDischargeStatus(
Measure                   Varchar(100),
SourceDischargeStatus     Varchar(50),
DischargeStatusDescr      Varchar(100),
AdmitCCYYMM               Char(6),
Quantity                  Int
)



Create table #tbl_262(
SourceDischargeStatus  Varchar(10),
AdmitCCYYMM            Char(6),
CountOfMemberId        Int,
UniquePat              Varchar(50)
)


Create table #tbl_263(
SourceDischargeStatus   Varchar(3),
AdmitCCYYMM             Char(6),
CountOfMemberId         Int,
UniquePat               Varchar(50)
)


Create table #tbl_280_Discharge_by_metric_table (
SourceDischargeStatus    Varchar(3),
SumOfQuantity            Int          
)



Create table #tbl_D_dischargestatus (
SourceDischargeStatus           Varchar(3),
DischargeStatusDescription       Varchar (100)         
)

insert into #tbl_D_dischargestatus values ('01', 'DISCHARGED TO HOME OR SELF CARE (ROUTINE DISCHARGE)'); 
insert into #tbl_D_dischargestatus values ('02', 'DISCHARGED/TRANSFERRED TO ANOTHER SHORT-TERM GENERAL HOSPITAL'); 
insert into #tbl_D_dischargestatus values ('03', 'DISCHARGED/TRANSFERRED TO SKILLED NURSING FACILITY'); 
insert into #tbl_D_dischargestatus values ('04', 'DISCHARGED/TRANSFERRED TO AN INTERMEDIATE CARE FACILITY'); 
insert into #tbl_D_dischargestatus values ('05', 'DISCHARGED/TRANSFERRED TO A DESIGNATED CANCER CTR/CHLDN HOSP (4/1/08)'); 
insert into #tbl_D_dischargestatus values ('06', 'DISCHARGED/TRANSFERRED TO HOME UNDER CARE OF ORGANIZED HOME HEALTH ORGAN'); 
insert into #tbl_D_dischargestatus values ('07', 'LEFT AGAINST MEDICAL ADVICE OR DISCONTINUED CARE'); 
insert into #tbl_D_dischargestatus values ('20', 'EXPIRED (OR DID NOT RECOVER-CHRISTIAN SCIENCE PATIENT)'); 
insert into #tbl_D_dischargestatus values ('50', 'DISCHARGED/TRANSFERRED TO HOSPICE - HOME'); 
insert into #tbl_D_dischargestatus values ('51', 'DISCHARGED/TRANSFERRED TO HOSPICE - MEDICAL FACILITY'); 
insert into #tbl_D_dischargestatus values ('62', 'DISCHARGED TO ANOTHER IRF (REHABILITATION FACILITY)'); 
insert into #tbl_D_dischargestatus values ('63', 'DISCHARGED TO A LONG-TERM CARE HOSPITAL'); 
insert into #tbl_D_dischargestatus values ('65', 'DISCHARGED/TRANSFERRED TO A PSYCHIATRIC HOSPITAL OR PSYCHIATRIC DISTINCT'); 
insert into #tbl_D_dischargestatus values ('70', 'DISCHARGED/TRANSFERRED TO ANOTHER FACILITY NOT DEFINED ELSEWHERE(4/1/08)')


create table #tbl_d_dischargestatusmeasure(
SourceDischargeStatus              Varchar(3),
Discharge_Status_Description       Varchar(100),
Measure                            Varchar(100),
Rank_                              Int,
Primary key (SourceDischargeStatus ,Measure)
)

insert into  #tbl_d_dischargestatusmeasure values ('01', 'Discharged to Home or Self Care (Routine Discharge)', '0 Unique Patients', '1'); 
insert into  #tbl_d_dischargestatusmeasure values ('01', 'Discharged to Home or Self Care (Routine Discharge)', '1 Admits', '1'); 
insert into  #tbl_d_dischargestatusmeasure values ('01', 'Discharged to Home or Self Care (Routine Discharge)', '2 ReAdmits', '1'); 
insert into  #tbl_d_dischargestatusmeasure values ('01', 'Discharged to Home or Self Care (Routine Discharge)', '3 ReAdmits(Same Provider)', '1'); 
insert into  #tbl_d_dischargestatusmeasure values ('01', 'Discharged to Home or Self Care (Routine Discharge)', '4 ReAdmits(Same Condition)', '1'); 
insert into  #tbl_d_dischargestatusmeasure values ('01', 'Discharged to Home or Self Care (Routine Discharge)', '5 Average Gap', '1'); 
insert into  #tbl_d_dischargestatusmeasure values ('01', 'Discharged to Home or Self Care (Routine Discharge)', '6 Average Gap(Same Provider)', '1'); 
insert into  #tbl_d_dischargestatusmeasure values ('01', 'Discharged to Home or Self Care (Routine Discharge)', '7 Average Gap(Same Condition)', '1'); 
insert into  #tbl_d_dischargestatusmeasure values ('02', 'Discharged/Transferred to Another Short-Term General Hospital', '0 Unique Patients', '2'); 
insert into  #tbl_d_dischargestatusmeasure values ('02', 'Discharged/Transferred to Another Short-Term General Hospital', '1 Admits', '2'); 
insert into  #tbl_d_dischargestatusmeasure values ('02', 'Discharged/Transferred to Another Short-Term General Hospital', '2 ReAdmits', '2'); 
insert into  #tbl_d_dischargestatusmeasure values ('02', 'Discharged/Transferred to Another Short-Term General Hospital', '3 ReAdmits(Same Provider)', '2'); 
insert into  #tbl_d_dischargestatusmeasure values ('02', 'Discharged/Transferred to Another Short-Term General Hospital', '4 ReAdmits(Same Condition)', '2'); 
insert into  #tbl_d_dischargestatusmeasure values ('02', 'Discharged/Transferred to Another Short-Term General Hospital', '5 Average Gap', '2'); 
insert into  #tbl_d_dischargestatusmeasure values ('02', 'Discharged/Transferred to Another Short-Term General Hospital', '6 Average Gap(Same Provider)', '2'); 
insert into  #tbl_d_dischargestatusmeasure values ('02', 'Discharged/Transferred to Another Short-Term General Hospital', '7 Average Gap(Same Condition)', '2'); 
insert into  #tbl_d_dischargestatusmeasure values ('03', 'Discharged/Transferred to Skilled Nursing Facility', '0 Unique Patients', '3'); 
insert into  #tbl_d_dischargestatusmeasure values ('03', 'Discharged/Transferred to Skilled Nursing Facility', '1 Admits', '3'); 
insert into  #tbl_d_dischargestatusmeasure values ('03', 'Discharged/Transferred to Skilled Nursing Facility', '2 ReAdmits', '3'); 
insert into  #tbl_d_dischargestatusmeasure values ('03', 'Discharged/Transferred to Skilled Nursing Facility', '3 ReAdmits(Same Provider)', '3'); 
insert into  #tbl_d_dischargestatusmeasure values ('03', 'Discharged/Transferred to Skilled Nursing Facility', '4 ReAdmits(Same Condition)', '3'); 
insert into  #tbl_d_dischargestatusmeasure values ('03', 'Discharged/Transferred to Skilled Nursing Facility', '5 Average Gap', '3'); 
insert into  #tbl_d_dischargestatusmeasure values ('03', 'Discharged/Transferred to Skilled Nursing Facility', '6 Average Gap(Same Provider)', '3'); 
insert into  #tbl_d_dischargestatusmeasure values ('03', 'Discharged/Transferred to Skilled Nursing Facility', '7 Average Gap(Same Condition)', '3'); 
insert into  #tbl_d_dischargestatusmeasure values ('04', 'Discharged/Transferred to an Intermediate Care Facility', '0 Unique Patients', '4'); 
insert into  #tbl_d_dischargestatusmeasure values ('04', 'Discharged/Transferred to an Intermediate Care Facility', '1 Admits', '4'); 
insert into  #tbl_d_dischargestatusmeasure values ('04', 'Discharged/Transferred to an Intermediate Care Facility', '2 ReAdmits', '4'); 
insert into  #tbl_d_dischargestatusmeasure values ('04', 'Discharged/Transferred to an Intermediate Care Facility', '3 ReAdmits(Same Provider)', '4'); 
insert into  #tbl_d_dischargestatusmeasure values ('04', 'Discharged/Transferred to an Intermediate Care Facility', '4 ReAdmits(Same Condition)', '4'); 
insert into  #tbl_d_dischargestatusmeasure values ('04', 'Discharged/Transferred to an Intermediate Care Facility', '5 Average Gap', '4'); 
insert into  #tbl_d_dischargestatusmeasure values ('04', 'Discharged/Transferred to an Intermediate Care Facility', '6 Average Gap(Same Provider)', '4'); 
insert into  #tbl_d_dischargestatusmeasure values ('04', 'Discharged/Transferred to an Intermediate Care Facility', '7 Average Gap(Same Condition)', '4'); 
insert into  #tbl_d_dischargestatusmeasure values ('05', 'Discharged/Transferred to a Designated Cancer Center/Children Hospital', '0 Unique Patients', '5'); 
insert into  #tbl_d_dischargestatusmeasure values ('05', 'Discharged/Transferred to a Designated Cancer Center/Children Hospital', '1 Admits', '5'); 
insert into  #tbl_d_dischargestatusmeasure values ('05', 'Discharged/Transferred to a Designated Cancer Center/Children Hospital', '2 ReAdmits', '5'); 
insert into  #tbl_d_dischargestatusmeasure values ('05', 'Discharged/Transferred to a Designated Cancer Center/Children Hospital', '3 ReAdmits(Same Provider)', '5'); 
insert into  #tbl_d_dischargestatusmeasure values ('05', 'Discharged/Transferred to a Designated Cancer Center/Children Hospital', '4 ReAdmits(Same Condition)', '5'); 
insert into  #tbl_d_dischargestatusmeasure values ('05', 'Discharged/Transferred to a Designated Cancer Center/Children Hospital', '5 Average Gap', '5'); 
insert into  #tbl_d_dischargestatusmeasure values ('05', 'Discharged/Transferred to a Designated Cancer Center/Children Hospital', '6 Average Gap(Same Provider)', '5'); 
insert into  #tbl_d_dischargestatusmeasure values ('05', 'Discharged/Transferred to a Designated Cancer Center/Children Hospital', '7 Average Gap(Same Condition)', '5'); 
insert into  #tbl_d_dischargestatusmeasure values ('06', 'Discharged/Transferred to Home Under Care of Organized Home Health Organization', '0 Unique Patients', '6'); 
insert into  #tbl_d_dischargestatusmeasure values ('06', 'Discharged/Transferred to Home Under Care of Organized Home Health Organization', '1 Admits', '6'); 
insert into  #tbl_d_dischargestatusmeasure values ('06', 'Discharged/Transferred to Home Under Care of Organized Home Health Organization', '2 ReAdmits', '6'); 
insert into  #tbl_d_dischargestatusmeasure values ('06', 'Discharged/Transferred to Home Under Care of Organized Home Health Organization', '3 ReAdmits(Same Provider)', '6'); 
insert into  #tbl_d_dischargestatusmeasure values ('06', 'Discharged/Transferred to Home Under Care of Organized Home Health Organization', '4 ReAdmits(Same Condition)', '6'); 
insert into  #tbl_d_dischargestatusmeasure values ('06', 'Discharged/Transferred to Home Under Care of Organized Home Health Organization', '5 Average Gap', '6'); 
insert into  #tbl_d_dischargestatusmeasure values ('06', 'Discharged/Transferred to Home Under Care of Organized Home Health Organization', '6 Average Gap(Same Provider)', '6'); 
insert into  #tbl_d_dischargestatusmeasure values ('06', 'Discharged/Transferred to Home Under Care of Organized Home Health Organization', '7 Average Gap(Same Condition)', '6'); 
insert into  #tbl_d_dischargestatusmeasure values ('07', 'Left Against Medical Advice or Discontinued Care', '0 Unique Patients', '7'); 
insert into  #tbl_d_dischargestatusmeasure values ('07', 'Left Against Medical Advice or Discontinued Care', '1 Admits', '7'); 
insert into  #tbl_d_dischargestatusmeasure values ('07', 'Left Against Medical Advice or Discontinued Care', '2 ReAdmits', '7'); 
insert into  #tbl_d_dischargestatusmeasure values ('07', 'Left Against Medical Advice or Discontinued Care', '3 ReAdmits(Same Provider)', '7'); 
insert into  #tbl_d_dischargestatusmeasure values ('07', 'Left Against Medical Advice or Discontinued Care', '4 ReAdmits(Same Condition)', '7'); 
insert into  #tbl_d_dischargestatusmeasure values ('07', 'Left Against Medical Advice or Discontinued Care', '5 Average Gap', '7'); 
insert into  #tbl_d_dischargestatusmeasure values ('07', 'Left Against Medical Advice or Discontinued Care', '6 Average Gap(Same Provider)', '7'); 
insert into  #tbl_d_dischargestatusmeasure values ('07', 'Left Against Medical Advice or Discontinued Care', '7 Average Gap(Same Condition)', '7'); 
insert into  #tbl_d_dischargestatusmeasure values ('20', 'Expired(Or Did Not Recover-Christian Science Patient)', '0 Unique Patients', '8'); 
insert into  #tbl_d_dischargestatusmeasure values ('20', 'Expired(Or Did Not Recover-Christian Science Patient)', '1 Admits', '8'); 
insert into  #tbl_d_dischargestatusmeasure values ('20', 'Expired(Or Did Not Recover-Christian Science Patient)', '2 ReAdmits', '8'); 
insert into  #tbl_d_dischargestatusmeasure values ('20', 'Expired(Or Did Not Recover-Christian Science Patient)', '3 ReAdmits(Same Provider)', '8'); 
insert into  #tbl_d_dischargestatusmeasure values ('20', 'Expired(Or Did Not Recover-Christian Science Patient)', '4 ReAdmits(Same Condition)', '8'); 
insert into  #tbl_d_dischargestatusmeasure values ('20', 'Expired(Or Did Not Recover-Christian Science Patient)', '5 Average Gap', '8'); 
insert into  #tbl_d_dischargestatusmeasure values ('20', 'Expired(Or Did Not Recover-Christian Science Patient)', '6 Average Gap(Same Provider)', '8'); 
insert into  #tbl_d_dischargestatusmeasure values ('20', 'Expired(Or Did Not Recover-Christian Science Patient)', '7 Average Gap(Same Condition)', '8'); 
insert into  #tbl_d_dischargestatusmeasure values ('50', 'Discharged/Transferred to Hospice - Home', '0 Unique Patients', '9'); 
insert into  #tbl_d_dischargestatusmeasure values ('50', 'Discharged/Transferred to Hospice - Home', '1 Admits', '9'); 
insert into  #tbl_d_dischargestatusmeasure values ('50', 'Discharged/Transferred to Hospice - Home', '2 ReAdmits', '9'); 
insert into  #tbl_d_dischargestatusmeasure values ('50', 'Discharged/Transferred to Hospice - Home', '3 ReAdmits(Same Provider)', '9'); 
insert into  #tbl_d_dischargestatusmeasure values ('50', 'Discharged/Transferred to Hospice - Home', '4 ReAdmits(Same Condition)', '9'); 
insert into  #tbl_d_dischargestatusmeasure values ('50', 'Discharged/Transferred to Hospice - Home', '5 Average Gap', '9'); 
insert into  #tbl_d_dischargestatusmeasure values ('50', 'Discharged/Transferred to Hospice - Home', '6 Average Gap(Same Provider)', '9'); 
insert into  #tbl_d_dischargestatusmeasure values ('50', 'Discharged/Transferred to Hospice - Home', '7 Average Gap(Same Condition)', '9'); 
insert into  #tbl_d_dischargestatusmeasure values ('51', 'Discharged/Transferred to Hospice - Medical Facility', '0 Unique Patients', '10'); 
insert into  #tbl_d_dischargestatusmeasure values ('51', 'Discharged/Transferred to Hospice - Medical Facility', '1 Admits', '10'); 
insert into  #tbl_d_dischargestatusmeasure values ('51', 'Discharged/Transferred to Hospice - Medical Facility', '2 ReAdmits', '10'); 
insert into  #tbl_d_dischargestatusmeasure values ('51', 'Discharged/Transferred to Hospice - Medical Facility', '3 ReAdmits(Same Provider)', '10'); 
insert into  #tbl_d_dischargestatusmeasure values ('51', 'Discharged/Transferred to Hospice - Medical Facility', '4 ReAdmits(Same Condition)', '10'); 
insert into  #tbl_d_dischargestatusmeasure values ('51', 'Discharged/Transferred to Hospice - Medical Facility', '5 Average Gap', '10'); 
insert into  #tbl_d_dischargestatusmeasure values ('51', 'Discharged/Transferred to Hospice - Medical Facility', '6 Average Gap(Same Provider)', '10'); 
insert into  #tbl_d_dischargestatusmeasure values ('51', 'Discharged/Transferred to Hospice - Medical Facility', '7 Average Gap(Same Condition)', '10'); 
insert into  #tbl_d_dischargestatusmeasure values ('62', 'Discharged to Another IRF (Rehabilitation Facility)', '0 Unique Patients', '11'); 
insert into  #tbl_d_dischargestatusmeasure values ('62', 'Discharged to Another IRF (Rehabilitation Facility)', '1 Admits', '11'); 
insert into  #tbl_d_dischargestatusmeasure values ('62', 'Discharged to Another IRF (Rehabilitation Facility)', '2 ReAdmits', '11'); 
insert into  #tbl_d_dischargestatusmeasure values ('62', 'Discharged to Another IRF (Rehabilitation Facility)', '3 ReAdmits(Same Provider)', '11'); 
insert into  #tbl_d_dischargestatusmeasure values ('62', 'Discharged to Another IRF (Rehabilitation Facility)', '4 ReAdmits(Same Condition)', '11'); 
insert into  #tbl_d_dischargestatusmeasure values ('62', 'Discharged to Another IRF (Rehabilitation Facility)', '5 Average Gap', '11'); 
insert into  #tbl_d_dischargestatusmeasure values ('62', 'Discharged to Another IRF (Rehabilitation Facility)', '6 Average Gap(Same Provider)', '11'); 
insert into  #tbl_d_dischargestatusmeasure values ('62', 'Discharged to Another IRF (Rehabilitation Facility)', '7 Average Gap(Same Condition)', '11'); 
insert into  #tbl_d_dischargestatusmeasure values ('63', 'Discharged to A Long-Term Care Hospital', '0 Unique Patients', '12'); 
insert into  #tbl_d_dischargestatusmeasure values ('63', 'Discharged to A Long-Term Care Hospital', '1 Admits', '12'); 
insert into  #tbl_d_dischargestatusmeasure values ('63', 'Discharged to A Long-Term Care Hospital', '2 ReAdmits', '12'); 
insert into  #tbl_d_dischargestatusmeasure values ('63', 'Discharged to A Long-Term Care Hospital', '3 ReAdmits(Same Provider)', '12'); 
insert into  #tbl_d_dischargestatusmeasure values ('63', 'Discharged to A Long-Term Care Hospital', '4 ReAdmits(Same Condition)', '12'); 
insert into  #tbl_d_dischargestatusmeasure values ('63', 'Discharged to A Long-Term Care Hospital', '5 Average Gap', '12'); 
insert into  #tbl_d_dischargestatusmeasure values ('63', 'Discharged to A Long-Term Care Hospital', '6 Average Gap(Same Provider)', '12'); 
insert into  #tbl_d_dischargestatusmeasure values ('63', 'Discharged to A Long-Term Care Hospital', '7 Average Gap(Same Condition)', '12'); 
insert into  #tbl_d_dischargestatusmeasure values ('65', 'Discharged/Transferred to a Psychiatric Hospital or Psychiatric Distinct', '0 Unique Patients', '13'); 
insert into  #tbl_d_dischargestatusmeasure values ('65', 'Discharged/Transferred to a Psychiatric Hospital or Psychiatric Distinct', '1 Admits', '13'); 
insert into  #tbl_d_dischargestatusmeasure values ('65', 'Discharged/Transferred to a Psychiatric Hospital or Psychiatric Distinct', '2 ReAdmits', '13'); 
insert into  #tbl_d_dischargestatusmeasure values ('65', 'Discharged/Transferred to a Psychiatric Hospital or Psychiatric Distinct', '3 ReAdmits(Same Provider)', '13'); 
insert into  #tbl_d_dischargestatusmeasure values ('65', 'Discharged/Transferred to a Psychiatric Hospital or Psychiatric Distinct', '4 ReAdmits(Same Condition)', '13'); 
insert into  #tbl_d_dischargestatusmeasure values ('65', 'Discharged/Transferred to a Psychiatric Hospital or Psychiatric Distinct', '5 Average Gap', '13'); 
insert into  #tbl_d_dischargestatusmeasure values ('65', 'Discharged/Transferred to a Psychiatric Hospital or Psychiatric Distinct', '6 Average Gap(Same Provider)', '13'); 
insert into  #tbl_d_dischargestatusmeasure values ('65', 'Discharged/Transferred to a Psychiatric Hospital or Psychiatric Distinct', '7 Average Gap(Same Condition)', '13'); 
insert into  #tbl_d_dischargestatusmeasure values ('70', 'Discharged/Transferred to Another Facility Not Defined ElseWhere', '0 Unique Patients', '14'); 
insert into  #tbl_d_dischargestatusmeasure values ('70', 'Discharged/Transferred to Another Facility Not Defined ElseWhere', '1 Admits', '14'); 
insert into  #tbl_d_dischargestatusmeasure values ('70', 'Discharged/Transferred to Another Facility Not Defined ElseWhere', '2 ReAdmits', '14'); 
insert into  #tbl_d_dischargestatusmeasure values ('70', 'Discharged/Transferred to Another Facility Not Defined ElseWhere', '3 ReAdmits(Same Provider)', '14'); 
insert into  #tbl_d_dischargestatusmeasure values ('70', 'Discharged/Transferred to Another Facility Not Defined ElseWhere', '4 ReAdmits(Same Condition)', '14'); 
insert into  #tbl_d_dischargestatusmeasure values ('70', 'Discharged/Transferred to Another Facility Not Defined ElseWhere', '5 Average Gap', '14'); 
insert into  #tbl_d_dischargestatusmeasure values ('70', 'Discharged/Transferred to Another Facility Not Defined ElseWhere', '6 Average Gap(Same Provider)', '14'); 
insert into  #tbl_d_dischargestatusmeasure values ('70', 'Discharged/Transferred to Another Facility Not Defined ElseWhere', '7 Average Gap(Same Condition)', '14'); 
insert into  #tbl_d_dischargestatusmeasure values ('99', 'Other/Uncoded', '0 Unique Patients', '15'); 
insert into  #tbl_d_dischargestatusmeasure values ('99', 'Other/Uncoded', '1 Admits', '15'); 
insert into  #tbl_d_dischargestatusmeasure values ('99', 'Other/Uncoded', '2 ReAdmits', '15'); 
insert into  #tbl_d_dischargestatusmeasure values ('99', 'Other/Uncoded', '3 ReAdmits(Same Provider)', '15'); 
insert into  #tbl_d_dischargestatusmeasure values ('99', 'Other/Uncoded', '4 ReAdmits(Same Condition)', '15'); 
insert into  #tbl_d_dischargestatusmeasure values ('99', 'Other/Uncoded', '5 Average Gap', '15'); 
insert into  #tbl_d_dischargestatusmeasure values ('99', 'Other/Uncoded', '6 Average Gap(Same Provider)', '15'); 
insert into  #tbl_d_dischargestatusmeasure values ('99', 'Other/Uncoded', '7 Average Gap(Same Condition)', '15'); 
insert into  #tbl_d_dischargestatusmeasure values ('To', 'Total', '0 Unique Patients', '16'); 
insert into  #tbl_d_dischargestatusmeasure values ('To', 'Total', '1 Admits', '16'); 
insert into  #tbl_d_dischargestatusmeasure values ('To', 'Total', '2 ReAdmits', '16'); 
insert into  #tbl_d_dischargestatusmeasure values ('To', 'Total', '3 ReAdmits(Same Provider)', '16'); 
insert into  #tbl_d_dischargestatusmeasure values ('To', 'Total', '4 ReAdmits(Same Condition)', '16'); 
insert into  #tbl_d_dischargestatusmeasure values ('To', 'Total', '5 Average Gap', '16'); 
insert into  #tbl_d_dischargestatusmeasure values ('To', 'Total', '6 Average Gap(Same Provider)', '16'); 
insert into  #tbl_d_dischargestatusmeasure values ('To', 'Total', '7 Average Gap(Same Condition)', '16')



create table #tbl_d_measure(
Measure   Varchar(100)
)

insert into  #tbl_d_measure values ('Measure'); 
insert into  #tbl_d_measure values ('0 Unique Patients'); 
insert into  #tbl_d_measure values ('1 Admits'); 
insert into  #tbl_d_measure values ('2 ReAdmits'); 
insert into  #tbl_d_measure values ('3 ReAdmits(Same Provider)'); 
insert into  #tbl_d_measure values ('4 ReAdmits(Same Condition)'); 
insert into  #tbl_d_measure values ('5 Average Gap'); 
insert into  #tbl_d_measure values ('6 Average Gap(Same Provider)'); 
insert into  #tbl_d_measure values ('7 Average Gap(Same Condition)')

create table #tbl_Crosswalk (
Hospital                  Varchar(100),
Hospital_name_xwalk_      Varchar(100)
)	 

insert into #tbl_Crosswalk  values ('Albany Medical Center', 'Albany Medical Center'); 
insert into #tbl_Crosswalk  values ('Albert Einstein Medical Center', 'Albert Einstein Medical Center'); 
insert into #tbl_Crosswalk  values ('Baystate Medical Center ( Psychiatric Unit)', 'Baystate Medical Center'); 
insert into #tbl_Crosswalk  values ('Bellevue Hospital', 'Bellevue Hospital'); 
insert into #tbl_Crosswalk  values ('Beth Israel Hospital / Kings Highway Division', 'Beth Israel Hospital / Kings Highway Division'); 
insert into #tbl_Crosswalk  values ('Beth Israel Medical Cent', 'Beth Israel Medical Center'); 
insert into #tbl_Crosswalk  values ('Bronx Lebanon Hospital', 'Bronx Lebanon Hospital'); 
insert into #tbl_Crosswalk  values ('Bronx VA MC', 'Bronx Veteran Medical Center'); 
insert into #tbl_Crosswalk  values ('Brookdale Hospital Psych', 'Brookdale University Hospital'); 
insert into #tbl_Crosswalk  values ('Brookdale University Hos', 'Brookdale University Hospital'); 
insert into #tbl_Crosswalk  values ('Brooklyn Hospital Center', 'Brooklyn Hospital Center'); 
insert into #tbl_Crosswalk  values ('BROOKLYN PSYCHIATRIC CENTERS', 'BROOKLYN PSYCHIATRIC CENTERS'); 
insert into #tbl_Crosswalk  values ('Clifton Springs Hospital Psych', 'Clifton Springs Hospital'); 
insert into #tbl_Crosswalk  values ('Community Hosp-bklyn Inc', 'Community Hospital Brooklyn'); 
insert into #tbl_Crosswalk  values ('Community Medical Center', 'Community Medical Center'); 
insert into #tbl_Crosswalk  values ('CONEY ISLAND HOSPITAL-PSYCH UNIT', 'Coney Island Hospital'); 
insert into #tbl_Crosswalk  values ('Coral Springs Medical Ctr', 'Coral Springs Medical Center'); 
insert into #tbl_Crosswalk  values ('Delray Medical Center', 'Delray Medical Center'); 
insert into #tbl_Crosswalk  values ('Department of Veterans Affairs', 'Department of Veterans Affairs'); 
insert into #tbl_Crosswalk  values ('Elmhurst Hospital Center', 'Elmhurst Hospital Center'); 
insert into #tbl_Crosswalk  values ('Flushing Hospital Med Ct', 'Flushing Hospital Medical Center'); 
insert into #tbl_Crosswalk  values ('Franklin Hospital Medica', 'Franklin Hospital Medical Center'); 
insert into #tbl_Crosswalk  values ('Franklin Hospital Psych', 'Franklin Hospital'); 
insert into #tbl_Crosswalk  values ('Geisinger Medical Center', 'Geisinger Medical Center'); 
insert into #tbl_Crosswalk  values ('Good Samaritan Hospital', 'Good Samaritan Hospital'); 
insert into #tbl_Crosswalk  values ('Harlem Hospital Center', 'Harlem Hospital Center'); 
insert into #tbl_Crosswalk  values ('Interfaith Medical Center', 'Interfaith Medical Center'); 
insert into #tbl_Crosswalk  values ('Jackson North Medical Center', 'Jackson North Medical Center'); 
insert into #tbl_Crosswalk  values ('Jacobi Medical Center', 'Jacobi Medical Center'); 
insert into #tbl_Crosswalk  values ('Jamaica Hospital', 'Jamaica Hospital'); 
insert into #tbl_Crosswalk  values ('John T. Mather Memorial', 'John T. Mather Memorial Hospital'); 
insert into #tbl_Crosswalk  values ('Kings County Hospital Ce', 'Kings County Hospital Center'); 
insert into #tbl_Crosswalk  values ('Kingsbrook Jewish - Rehab', 'Kingsbrook Jewish Rehabilitation Center'); 
insert into #tbl_Crosswalk  values ('Kingsbrook Jewish MC Psych', 'Kingsbrook Jewish Medical Center Psychiatry'); 
insert into #tbl_Crosswalk  values ('Kingsbrook Jewish Medica', 'Kingsbrook Jewish Medical Center '); 
insert into #tbl_Crosswalk  values ('Lenox Hill Hospital', 'Lenox Hill Hospital'); 
insert into #tbl_Crosswalk  values ('Lincoln Medical', 'Lincoln Medical Center'); 
insert into #tbl_Crosswalk  values ('Long Island College Hosp', 'Long Island College Hospital'); 
insert into #tbl_Crosswalk  values ('Long Island Jewish Medical', 'Long Island Jewish Medical Center'); 
insert into #tbl_Crosswalk  values ('Lutheran Medical Center', 'Lutheran Medical Center'); 
insert into #tbl_Crosswalk  values ('Lutheran Medical Center-rehab Unit', 'Lutheran Medical Center Rehab Unit'); 
insert into #tbl_Crosswalk  values ('Maimonides Medical Center', 'Maimonides Medical Center'); 
insert into #tbl_Crosswalk  values ('Memorial Hosp For Cancer', 'Memorial Hospital for Cancer and Allied Diseases'); 
insert into #tbl_Crosswalk  values ('Mercy Medical Center Psych', 'Mercy Medical Center'); 
insert into #tbl_Crosswalk  values ('Metropolitan Hospital Ce', 'Metropolitan Hospital Center'); 
insert into #tbl_Crosswalk  values ('Montefiore Medical Center', 'Montefiore Medical Center'); 
insert into #tbl_Crosswalk  values ('Mount Sinai Hospital', 'Mount Sinai Hospital'); 
insert into #tbl_Crosswalk  values ('Mount Sinai Hospital ofQueens', 'Mount Sinai Hospital of Queens'); 
insert into #tbl_Crosswalk  values ('Mount Sinai Hospital Psych', 'Mount Sinai Hospital'); 
insert into #tbl_Crosswalk  values ('Nassau University Medica', 'Nassau University Medical Center'); 
insert into #tbl_Crosswalk  values ('Nassau University Medical Center Psych', 'Nassau University Medical Center'); 
insert into #tbl_Crosswalk  values ('New York Hospital Queens', 'New York Hospital Queens'); 
insert into #tbl_Crosswalk  values ('New York Methodist Hospi', 'New York Methodist Hospital '); 
insert into #tbl_Crosswalk  values ('New York Methodist Hospital - Psychiatric', 'New York Methodist Hospital'); 
insert into #tbl_Crosswalk  values ('New York Presbyterian Ho', 'New York Presbyterian Hospital'); 
insert into #tbl_Crosswalk  values ('New York Presbyterian Hospital Psych', 'New York Presbyterian Hospital'); 
insert into #tbl_Crosswalk  values ('North Broward Medical Center', 'North Broward Medical Center'); 
insert into #tbl_Crosswalk  values ('North Central Bronx Hospital', 'North Central Bronx Hospital'); 
insert into #tbl_Crosswalk  values ('North Shore University Hosp At Manhasset/syosset', 'North Shore University Hospital at Manhasset/Syosset'); 
insert into #tbl_Crosswalk  values ('Northern Westchester Hospital Psych', 'Northern Westchester Hospital'); 
insert into #tbl_Crosswalk  values ('NSUH at Forest Hills', 'North Sure University at Forest Hills'); 
insert into #tbl_Crosswalk  values ('NY Downtown Hospital', 'New York Downtown Hospital'); 
insert into #tbl_Crosswalk  values ('NYU Hospital Tisch Psych', 'NYU Hospital Center'); 
insert into #tbl_Crosswalk  values ('Nyu Hospitals Center', 'NYU Hospital Center'); 
insert into #tbl_Crosswalk  values ('Phelps Memorial Hospital', 'Phelps Memorial Hospital'); 
insert into #tbl_Crosswalk  values ('Plainview Hospital', 'Plainview Hospital'); 
insert into #tbl_Crosswalk  values ('Presbyterian Hospital', 'Presbyterian Hospital'); 
insert into #tbl_Crosswalk  values ('Queens Hospital Center', 'Queens Hospital Center'); 
insert into #tbl_Crosswalk  values ('Richmond University Med Center Psych', 'Richmond University Medical Center'); 
insert into #tbl_Crosswalk  values ('Richmond University Medi', 'Richmond University Medical Center'); 
insert into #tbl_Crosswalk  values ('RYE PSYCHIATRIC HOSPITAL CARE', 'Rye Hospital Center'); 
insert into #tbl_Crosswalk  values ('Scranton Quincy Hospital ( Psych)', 'Scranton Quincy Hospital'); 
insert into #tbl_Crosswalk  values ('South Beach Psych Center', 'South Beach Psychiatric Center'); 
insert into #tbl_Crosswalk  values ('South Nassau Communities Hospital Psych', 'South Nassau Communities Hospital'); 
insert into #tbl_Crosswalk  values ('South Nassau CommunitiesHosp', 'South Nassau Communities Hospital'); 
insert into #tbl_Crosswalk  values ('Southside Hospital (Psych)', 'Southside Hospital'); 
insert into #tbl_Crosswalk  values ('St Barnabas Hosp', 'St. Barnabas Hospital'); 
insert into #tbl_Crosswalk  values ('St Clares Hospital', 'St. Clares Hospital'); 
insert into #tbl_Crosswalk  values ('St Francis Hospital', 'St. Francis Hospital'); 
insert into #tbl_Crosswalk  values ('St Johns Epis Hosp - Sou', 'Saint Johns Episcopal Hospital at South Shore'); 
insert into #tbl_Crosswalk  values ('St Johns Episcopal Hospital Psych', 'St. Johns Episcopal Hospital'); 
insert into #tbl_Crosswalk  values ('St Lukes Roosevelt Hospital', 'St. Lukes Roosevelt Hospital'); 
insert into #tbl_Crosswalk  values ('St. Francis Hospital', 'St. Francis Hospital'); 
insert into #tbl_Crosswalk  values ('St. Josephs Hospital', 'St. Josephs Hospital'); 
insert into #tbl_Crosswalk  values ('State University of New York Downstate Medical Cen', 'State University of New York Downstate Medical Center'); 
insert into #tbl_Crosswalk  values ('Staten Island University', 'Staten Island University Hospital'); 
insert into #tbl_Crosswalk  values ('Stonybrook Univ Hospital', 'Stony Brook University Hospital'); 
insert into #tbl_Crosswalk  values ('Summit Park Psych Hospital', 'Summit Park Hospital'); 
insert into #tbl_Crosswalk  values ('Suny Downstate Mc/univ H', 'Suny Downstate Medical Center University Hospital'); 
insert into #tbl_Crosswalk  values ('SUNY Downstate/University Hosp of Brooklyn', 'State University of New York Downstate Medical Center'); 
insert into #tbl_Crosswalk  values ('The Presbyterian Hospita', 'The Presbyterian Hospital'); 
insert into #tbl_Crosswalk  values ('University of Miami Hospital', 'University of Miami Hospital'); 
insert into #tbl_Crosswalk  values ('University of Rochester Strong Memorial Hosp Psych', 'University of Rochester Strong Memorial Hospital'); 
insert into #tbl_Crosswalk  values ('Wayne County Memorial', 'Wayne County Memorial Hospital'); 
insert into #tbl_Crosswalk  values ('Westchester General Hospital', 'Westchester General Hospital'); 
insert into #tbl_Crosswalk  values ('Winthrop University Hosp', 'Winthrop University Hospital'); 
insert into #tbl_Crosswalk  values ('Woodhull Hospital', 'Woodhull Hospital'); 
insert into #tbl_Crosswalk  values ('Wyckoff Heights Medical', 'Wyckoff Heights Medical Center')



create table #tbl_Hospital_name_xwalk_ (
Hospital                  Varchar(100),
Hospital_name_xwalk_      Varchar(100)
)	 

insert into #tbl_Hospital_name_xwalk_ values ('Beth Israel Medical Cent', 'Beth Israel Medical Center'); 
insert into #tbl_Hospital_name_xwalk_ values ('Brookdale Hospital Psych', 'Brookdale Hospital Psychiatry'); 
insert into #tbl_Hospital_name_xwalk_ values ('Brookdale University Hos', 'Brookdale University Hospital'); 
insert into #tbl_Hospital_name_xwalk_ values ('Community Hosp-bklyn Inc', 'New York Community Hospital of Brooklyn'); 
insert into #tbl_Hospital_name_xwalk_ values ('Coral Springs Medical Ctr', 'Coral Springs Medical Center'); 
insert into #tbl_Hospital_name_xwalk_ values ('Flushing Hospital Med Ct', 'Flushing Hospital Medical Center'); 
insert into #tbl_Hospital_name_xwalk_ values ('Franklin Hospital Medica', 'Franklin Hospital Medical Center'); 
insert into #tbl_Hospital_name_xwalk_ values ('Jamaica Hospital TBI/Rehab', 'Jamaica Hospital TBI/Rehabilitation'); 
insert into #tbl_Hospital_name_xwalk_ values ('John T. Mather Memorial', 'John T. Mather Memorial Hospital'); 
insert into #tbl_Hospital_name_xwalk_ values ('Kings County Hospital Ce', 'Kings County Hospital Center'); 
insert into #tbl_Hospital_name_xwalk_ values ('Kingsbrook Jewish - Rehab', 'Kingsbrook Jewish Rehabilitation Center'); 
insert into #tbl_Hospital_name_xwalk_ values ('Kingsbrook Jewish MC Psych', 'Kingsbrook Jewish Medical Center-Psychiatry'); 
insert into #tbl_Hospital_name_xwalk_ values ('Kingsbrook Jewish Medica', 'Kingsbrook Jewish Medical Center'); 
insert into #tbl_Hospital_name_xwalk_ values ('LIJH dba Zucker Hillside Hospital', 'Zucker Hillside Hospital - North Shore-LIJ Health System'); 
insert into #tbl_Hospital_name_xwalk_ values ('Lincoln Medical', 'Lincoln Medical Center'); 
insert into #tbl_Hospital_name_xwalk_ values ('Long Island College Hosp', 'Long Island College Hospital'); 
insert into #tbl_Hospital_name_xwalk_ values ('Memorial Hosp For Cancer', 'Memorial Hospital For Cancer'); 
insert into #tbl_Hospital_name_xwalk_ values ('Mercy Medical Center Psych', 'Mercy Medical Center Psychiatry'); 
insert into #tbl_Hospital_name_xwalk_ values ('Metropolitan Hospital Ce', 'Metropolitan Hospital Center'); 
insert into #tbl_Hospital_name_xwalk_ values ('Mount Sinai Hospital ofQueens', 'Mount Sinai Hospital Of Queens'); 
insert into #tbl_Hospital_name_xwalk_ values ('Mt Vernon Hospital', 'Mount Vernon Hospital'); 
insert into #tbl_Hospital_name_xwalk_ values ('Nassau University Medica', 'Nassau University Medical'); 
insert into #tbl_Hospital_name_xwalk_ values ('New York Eye And Ear Inf', 'New York Eye and Ear Infirmary'); 
insert into #tbl_Hospital_name_xwalk_ values ('New York Methodist Hospi', 'New York Methodist Hospital'); 
insert into #tbl_Hospital_name_xwalk_ values ('New York Presbyterian Ho', 'New York Presbyterian Hospital'); 
insert into #tbl_Hospital_name_xwalk_ values ('North Shore University Hosp at Manhasset/Syosset', 'North Shore University Hospital at Manhasset/Syosset'); 
insert into #tbl_Hospital_name_xwalk_ values ('NY Downtown Hospital', 'New York Downtown Hospital'); 
insert into #tbl_Hospital_name_xwalk_ values ('NY Methodist Hospital Rehab', 'New York Methodist Hospital Rehabilitation'); 
insert into #tbl_Hospital_name_xwalk_ values ('Nyu Hospital For Joint Diseases', 'NYU Hospital For Joint Diseases'); 
insert into #tbl_Hospital_name_xwalk_ values ('Nyu Hospitals Center', 'NYU Hospitals Center'); 
insert into #tbl_Hospital_name_xwalk_ values ('Raritan Bay Medical', 'Raritan Bay Medical Center'); 
insert into #tbl_Hospital_name_xwalk_ values ('Riverview Medical Ctr', 'Riverview Medical Center'); 
insert into #tbl_Hospital_name_xwalk_ values ('Sound Shore Med. Ctr Of Westchester', 'Sound Shore Medical Center Of Westchester'); 
insert into #tbl_Hospital_name_xwalk_ values ('South Nassau CommunitiesHosp', 'South Nassau Communities Hospital'); 
insert into #tbl_Hospital_name_xwalk_ values ('St Barnabas Hosp', 'St. Barnabas Hospital'); 
insert into #tbl_Hospital_name_xwalk_ values ('St Johns Epis Hosp - Sou', 'St. Johns Episcopal Hospital'); 
insert into #tbl_Hospital_name_xwalk_ values ('Stonybrook Univ Hospital', 'Stonybrook University Hospital'); 
insert into #tbl_Hospital_name_xwalk_ values ('Suny Downstate Mc/univ H', 'University Hospital of Brooklyn-SUNY Downstate Medical Center'); 
insert into #tbl_Hospital_name_xwalk_ values ('SUNY Downstate MC/University Hosp of Brooklyn Reha', 'University Hospital of Brooklyn-SUNY Downstate Medical Center Rehab'); 
insert into #tbl_Hospital_name_xwalk_ values ('SUNY Downstate/University Hosp of Brooklyn', 'SUNY Downstate/University Hospital of Brooklyn'); 
insert into #tbl_Hospital_name_xwalk_ values ('The Presbyterian Hospita', 'The Presbyterian Hospital'); 
insert into #tbl_Hospital_name_xwalk_ values ('University Hospitals Cleveland Medicl Center', 'University Hospitals Cleveland Medical Center'); 
insert into #tbl_Hospital_name_xwalk_ values ('White Plains Hospital Ct', 'White Plains Hospital Center'); 
insert into #tbl_Hospital_name_xwalk_ values ('Winthrop University Hosp', 'Winthrop University Hospital'); 
insert into #tbl_Hospital_name_xwalk_ values ('Wyckoff Heights Medical', 'Wyckoff Heights Medical Center')



-- 100 Extract Readmits

Insert into #tbl_105_Readmits(
	AdmitCCYYMM,
	AdmitNum,
	ContractCode,
	BenefitPlanCode,
    Description,
	DateOfAdmission,
	DateOfDischarge,
	MemberId,
	RenderProviderParFlag,
	RenderProviderXRefId,
	AdmitPaidFlag,
	SourceDischargeStatus,
	SourceAdmitTypeCode,
    ReAdmitInd,
	CCSLevelKey,
	DateOfBirth	
)

Select
	t1.AdmitCCYYMM,
	t1.AdmitNum,
	t1.ContractCode,
	t1.BenefitPlanCode,
	t3.Description,
	t1.DateOfAdmission,
	t1.DateOfDischarge,
	t1.MemberId,
	t1.RenderProviderParFlag,
	t1.RenderProviderXRefId,
	t1.AdmitPaidFlag,
	t1.SourceDischargeStatus,
	t1.SourceAdmitTypeCode,
	t1.ReAdmitFlag,
	t1.CCSLevelKeyAdmit,
	t2.DateOfBirth
from factAdmissions t1 
inner join factMember t2 on
t1.MemberId = t2.MemberId 
inner join luContractBenefitPlan t3 on
t1.ContractCode = t3.ContractCode and
t1.BenefitPlanCode = t3.BenefitPlanCode
inner join #tbl_Parm_Date t4 on
t1.admitccyymm between t4.startdateccyymm and t4.enddateccyymm 
where t1.AcuteSNFIndAdmit = 'A'
and t1.BusinessUnitCode ='ep'


select
	t1.AdmitNum,
	Min(t2.ReAdmitDays)MinofReAdmitDays
into #tbl_120_find_lasttrigger
from #tbl_105_Readmits t1 
inner join factReAdmissions t2 on 
t1.AdmitNum = t2.AdmitNum 
	Group by
	t1.AdmitNum


--121 find last Trigger 
Insert #tbl_125_last_Trigger(
AdmitNum,	
TriggerReAdmitAdmitNum 
)

select
	t1.AdmitNum,
	Max(t2.TriggerReAdmitAdmitNum)TriggerReAdmitAdmitNum

from #tbl_120_find_lasttrigger t1
inner join 
factReAdmissions t2 on	
t1.AdmitNum = t2.AdmitNum and
t1.MinofReAdmitDays = t2.ReAdmitDays
	Group by 
	t1.AdmitNum


--106 fill missing discharge status

update t1 set t1.SourceDischargeStatus = '99'
from #tbl_105_Readmits t1 	
where t1.SourceDischargeStatus is null

--130 Append trigger data

update t3 set t3.TriggerRedadmitNum = t2.TriggerReAdmitAdmitNum,
              t3.ReAdmitTypeInd     = t2.ReAdmitTypeInd,
              t3.ReAdmitDays        = t2.ReAdmitDays,
              t3.TriggerCCSLevelKey = t2.CCSLevelKeyAdmitTrigger
       
 
              
from #tbl_125_last_Trigger t1 
inner join factReAdmissions t2 on
t1.AdmitNum = t2.AdmitNum and
t1.TriggerReAdmitAdmitNum = t2.TriggerReAdmitAdmitNum
inner join #tbl_105_Readmits t3 on
t2.AdmitNum = t3.AdmitNum

--140 Append trigger data

update t1 set t1.TriggerRenderProviderXRefID = t1.RenderProviderXRefId,
              t1.TriggerSourceDischargeStatus = t1.SourceDischargeStatus,
              t1.TriggerDateOfAdmission =  t1.DateofAdmission,
              t1.TriggerDateOfDischarge = t1.DateofDischarge
from #tbl_105_Readmits t1 	

--150 Append trigger data
update t2 set t2.TriggerRenderProviderXRefID  =  t1.RenderProviderXRefId,
              t2.TriggerSourceDischargeStatus =  t1.SourceDischargeStatus,
              t2.TriggerDateOfAdmission       =  t1.DateOfAdmission,
              t2.TriggerDateOfDischarge       =  t1.DateOfDischarge               
from factAdmissions t1
inner join #tbl_105_Readmits t2 on
t1.AdmitNum = t2.TriggerRedadmitNum 	

--159 fill ccs category
update t1 set t1.CCSCategory = '99'
from #tbl_105_Readmits t1 	


--160 fill ccs category
update t1 set t1.CCSCategory = t2.CCSLevel1
from #tbl_105_Readmits t1
inner join luCCS t2 on
t1.CCSLevelKey = t2.CCSLevelKey 	

--179 fill css category
update t1 set t1.TriggerCCSCategory = '99'
from #tbl_105_Readmits t1

--180 fill css category
update t1 set t1.TriggerCCSCategory = t2.CCSLevel1
from #tbl_105_Readmits t1
inner join luCCS t2 on 
t1.TriggerCCSLevelKey = t2.CCSLevelKey

--190 
update t1 set t1.DiagTypeInd = 'N'
from #tbl_105_Readmits t1

-- 200
update t1 set t1.DiagTypeInd = 'Y'
from #tbl_105_Readmits t1
where t1.TriggerCCSCategory = t1.CCSCategory

select * from #tbl_215_ReadmitbyDischargeStatus t1
where t1.SourceDischargeStatus = 'Total'


--210 by discharge status
insert #tbl_215_ReadmitbyDischargeStatus (
Measure,
SourceDischargeStatus,
AdmitCCYYMM,
Quantity
)

select
'1 Admits' Measure,
 t1.TriggerSourceDischargeStatus SourceDischargeStatus,
 AdmitCCYYMM,
 Count(t1.AdmitNum)Quantity
from #tbl_105_Readmits t1
Group by
	TriggerSourceDischargeStatus,
	AdmitCCYYMM
Order by 2,3


--220a by discharge status  
insert #tbl_215_ReadmitbyDischargeStatus (
Measure,
SourceDischargeStatus,
AdmitCCYYMM,
Quantity
)
   
 select
	'2 ReAdmits' Measure,
	t1.TriggerSourceDischargeStatus SourceDischargeStatus,
	AdmitCCYYMM,
 Count(t1.AdmitNum)Quantity
from #tbl_105_Readmits t1
where t1.ReAdmitInd = 'Y'
Group by
	TriggerSourceDischargeStatus,
	AdmitCCYYMM
 
 --220b by discharge status
 
insert #tbl_215_ReadmitbyDischargeStatus (
Measure,
SourceDischargeStatus,
AdmitCCYYMM,
Quantity
)
 
 select
	'5 Average Gap' Measure,
	t1.TriggerSourceDischargeStatus SourceDischargeStatus,
	AdmitCCYYMM,
 sum(t1.ReAdmitDays)Quantity
from #tbl_105_Readmits t1
where t1.ReAdmitInd = 'Y'
Group by
	TriggerSourceDischargeStatus,
	AdmitCCYYMM
 
 
 
 --230a by discharge status
 
insert #tbl_215_ReadmitbyDischargeStatus (
Measure,
SourceDischargeStatus,
AdmitCCYYMM,
Quantity
)
 
 select
	'4 ReAdmits(Same Condition)' Measure,
	t1.TriggerSourceDischargeStatus SourceDischargeStatus,
	AdmitCCYYMM,
	Count(t1.AdmitNum)Quantity
from #tbl_105_Readmits t1
where t1.ReAdmitInd = 'Y'
and t1.DiagTypeInd ='Y'
Group by
	TriggerSourceDischargeStatus,
	AdmitCCYYMM
 
 
  --230b by discharge status
 
insert #tbl_215_ReadmitbyDischargeStatus (
Measure,
SourceDischargeStatus,
AdmitCCYYMM,
Quantity
)
 
 select
	'7 Average Gap(Same Condition)' Measure,
	t1.TriggerSourceDischargeStatus SourceDischargeStatus,
	AdmitCCYYMM,
 sum(t1.ReAdmitDays)Quantity
from #tbl_105_Readmits t1
where t1.ReAdmitInd = 'Y'
and t1.DiagTypeInd = 'Y'
Group by
	TriggerSourceDischargeStatus,
	AdmitCCYYMM
 
--240a by discharge status


insert #tbl_215_ReadmitbyDischargeStatus (
Measure,
SourceDischargeStatus,
AdmitCCYYMM,
Quantity
)
   
 select
	'3 ReAdmits(Same Provider)' Measure,
	t1.TriggerSourceDischargeStatus SourceDischargeStatus,
	AdmitCCYYMM,
 Count(t1.AdmitNum)Quantity
from #tbl_105_Readmits t1
where t1.ReAdmitInd = 'Y'
and t1.ReAdmitTypeInd = 'S'
Group by
	TriggerSourceDischargeStatus,
	AdmitCCYYMM
	

--240b by discharge status

insert #tbl_215_ReadmitbyDischargeStatus (
Measure,
SourceDischargeStatus,
AdmitCCYYMM,
Quantity
)
 
 select
	'6 Average Gap(Same Provider)' Measure,
	t1.TriggerSourceDischargeStatus SourceDischargeStatus,
	AdmitCCYYMM,
sum(t1.ReAdmitDays)Quantity
from #tbl_105_Readmits t1
where t1.ReAdmitInd = 'Y'
and t1.ReAdmitTypeInd = 'S'
Group by
	TriggerSourceDischargeStatus,
	AdmitCCYYMM
 
 
-- 250 by discharge status
select 
	t1.TriggerSourceDischargeStatus SourceDischargeStatus, 
    t1.AdmitCCYYMM,
    t1.MemberId
into #tbl_250_by_discharge_status
from #tbl_105_Readmits t1
   Group by
	t1.TriggerSourceDischargeStatus,
    t1.AdmitCCYYMM,
    t1.MemberId


-- 251 by discharge status_test
select 
	t1.TriggerSourceDischargeStatus SourceDischargeStatus, 
    t1.MemberId,
    '999999'  AdmitCCYYMM
into #tbl_251_by_discharge_status
from #tbl_105_Readmits t1
   Group by
	t1.TriggerSourceDischargeStatus,
    t1.MemberId


--252 by discharge status_test
select 
	'999999'SourceDischargeStatus,
    t1.MemberId,
    AdmitCCYYMM
into #tbl_252_by_discharge_status
from #tbl_105_Readmits t1
   Group by
	t1.MemberId,
	AdmitCCYYMM



--253 by discharge status_test
select 
	'999999'SourceDischargeStatus,
    t1.MemberId,
    '999999'  AdmitCCYYMM
into #tbl_253_by_discharge_status
from #tbl_105_Readmits t1
   Group by
	t1.MemberId



-- 260 discharge status
insert into #tbl_215_ReadmitbyDischargeStatus(
SourceDischargeStatus,
AdmitCCYYMM,
Quantity,
Measure 
) 
 select
	t1.SourceDischargeStatus,
	t1.AdmitCCYYMM,
	Count (t1.Memberid)Memberid,
    '0 Unique Patients' Measure
from #tbl_250_by_discharge_status t1
group by
	t1.SourceDischargeStatus,
	t1.AdmitCCYYMM
Order by 1,2



--270 fill default descr

update t1 set t1.DischargeStatusDescr = 'Other/Uncoded'
from #tbl_215_ReadmitbyDischargeStatus t1

--280  fill descr

update t1 set t1.DischargeStatusDescr = t2.Discharge_Status_Description
from #tbl_215_ReadmitbyDischargeStatus t1
inner join #tbl_d_dischargestatusmeasure t2 on
t1.Measure = t2.Measure and
t1.SourceDischargeStatus = t2.SourceDischargeStatus


--280 Rank discharge

insert into #tbl_280_Discharge_by_metric_table(
SourceDischargeStatus,
SumOfQuantity
)
select
	t1.SourceDischargeStatus,
	Sum(t1.Quantity)Quantity

from #tbl_215_ReadmitbyDischargeStatus t1 
where t1.Measure = '1 Admits'
and t1.SourceDischargeStatus Not in('99','To')
group by 
	t1.SourceDischargeStatus


--285 Append total

insert into #tbl_215_ReadmitbyDischargeStatus(
SourceDischargeStatus,
DischargeStatusDescr,
Measure,
AdmitCCYYMM,
Quantity
) 

select
	'To' SourceDischargeStatus,
	'Total' DischargeStatusDescr,
	 t1.Measure,
	 t1.AdmitCCYYMM,
	 sum(t1.Quantity)Quantity
from #tbl_215_ReadmitbyDischargeStatus t1
Group by
   	 t1.Measure,
	 t1.AdmitCCYYMM
order by 3	 
	 
		
		

--289 Overwrite sourcedischarestatus

Update t1 set t1.SourceDischargeStatus = '99'
from #tbl_215_ReadmitbyDischargeStatus t1
where t1.DischargeStatusDescr = 'Other/Uncoded'
		
		

--510 fill member name
Update t1 set t1.MemberName = t2.MemberLastName +' ' + t2.MemberFirstName 
from #tbl_105_Readmits t1
inner join factMember t2 on
t1.MemberId = t2.MemberId


--520 fill render provider name 1

Update t1 set t1.RenderProviderName = case when t3. Hospital is null then t2.ProviderFullName else t3.Hospital_name_xwalk_ end 

from #tbl_105_Readmits t1
inner join luProvider t2 on 
t1.RenderProviderXRefId = t2.ProviderId 
left outer join #tbl_Crosswalk t3 on
t2.ProviderFullName = t3.Hospital

--530 fill trigger render provider name 1
Update t1 set t1.TriggerRenderProvderName = case when t3. Hospital is null then t2.ProviderFullName else t3.Hospital_name_xwalk_ end 

from #tbl_105_Readmits t1
inner join luProvider t2 on 
t1.RenderProviderXRefId = t2.ProviderId 
left outer join #tbl_Crosswalk t3 on
t2.ProviderFullName = t3.Hospital



-- 261 discharge status_Test
insert into #tbl_215_ReadmitbyDischargeStatus(
SourceDischargeStatus,
AdmitCCYYMM,
Quantity,
Measure 
) 
 select
	t1.SourceDischargeStatus,
	t1.AdmitCCYYMM,
	Count (t1.Memberid)Memberid,
    '0 Unique Patients' Measure
from #tbl_251_by_discharge_status t1
group by
	t1.SourceDischargeStatus,
	t1.AdmitCCYYMM
order by 1,2

-- 262 discharge status_Test

Insert into #tbl_262(
SourceDischargeStatus,
AdmitCCYYMM,
CountOfMemberId,
UniquePat
)
select
 t1.SourceDischargeStatus,
 t1.AdmitCCYYMM,
 Count(t1.MemberId)CountofMembers,
 '0 Unique Patients' UniquePat
from #tbl_252_by_discharge_status t1
 Group by
 t1.SourceDischargeStatus,
 t1.AdmitCCYYMM
 order by 2
 


-- 263 discharge status_Test
insert into #tbl_215_ReadmitbyDischargeStatus(
SourceDischargeStatus,
AdmitCCYYMM,
Quantity,
Measure 
) 
 select
	'To' SourceDischargeStatus,
	t1.AdmitCCYYMM,
	Count (t1.Memberid)Memberid,
    '0 Unique Patients' Measure
from #tbl_253_by_discharge_status t1
group by
	t1.AdmitCCYYMM


update t1 set t1.ReAdmitDays = '0'
from #tbl_105_Readmits t1
where t1.ReAdmitDays is null

 --262 Update Total By Month
 Update t1  set t1.Quantity = t2.CountOfMemberId
 From #tbl_215_ReadmitbyDischargeStatus t1
 inner join #tbl_262 t2 on 
 t1.AdmitCCYYMM = t2.AdmitCCYYMM
 where t1.SourceDischargeStatus = 'to'
 and t1.Measure = '0 Unique Patients'

select

	t3.SumOfQuantity,
	t1.SourceDischargeStatus,
	t1.Discharge_Status_Description,
	t1.Measure,
	t2.AdmitCCYYMM,
	Sum(t2.Quantity)Quantity
Into #290DischargeStatusReport	
from #tbl_d_dischargestatusmeasure t1
left outer join #tbl_215_ReadmitbyDischargeStatus t2 on 
t1.Measure = t2.Measure and
t1.SourceDischargeStatus = t2.SourceDischargeStatus
left outer join #tbl_280_Discharge_by_metric_table t3 on
t1.SourceDischargeStatus = t3.SourceDischargeStatus
	Group by
	t3.SumOfQuantity,
	t1.SourceDischargeStatus,
	t1.Discharge_Status_Description,
	t1.Measure,
	t2.AdmitCCYYMM
 

 
Select *
into #finalPivotOutput
from
(
Select
	t1.SourceDischargeStatus,
	t1.Discharge_Status_Description,
	t1.Measure,
	t1.AdmitCCYYMM,
	t1.Quantity
From #290DischargeStatusReport t1

)t2

pivot
(
  Sum(Quantity)
  for  AdmitCCYYMM in ([201601],[201602],[201603],[201604],[201605],[201606],[999999])
) piv;





--310 diagnosis summary(mbrs)
	select
		t2.CCSCategory,
		Sum(t2.SumofReAdmitDays)ReAdmitDays,
		Sum(t2.CountofAdmitNum)CountofAdmitNum1,
		Sum(case when t2.ReAdmitInd = 'Y' then t2.CountofAdmitNum else 0 end) Y,
		Sum(case when t2.ReAdmitInd = 'N' then t2.CountofAdmitNum else 0 end) N

	Into #310diagnosis_summary	
	from

	(  
	select 
		t1.CCSCategory,
		t1.ReAdmitInd,
		Count(t1.AdmitNum)CountofAdmitNum,
		Sum(t1.ReAdmitDays)SumofReAdmitDays

	from #tbl_105_Readmits t1 
	group by
		t1.CCSCategory,
		t1.ReAdmitInd
	)t2
	group by
		t2.CCSCategory

--320 diagnosis Summary(diags)	

select
  t1.DiagTypeInd,
  t1.CCSCategory,
  t1.ReAdmitInd,
  Count(t1.AdmitNum)AdmitNum,
  Sum(t1.ReAdmitDays)ReAdmitDays,
  Count(t1.AdmitNum)AdmitNum_1
into #tbl_320_diagnosis_Summary	
from #tbl_105_Readmits t1
where t1.DiagTypeInd ='Y'
and t1.ReAdmitInd = 'Y' 
Group by
  t1.DiagTypeInd,
  t1.CCSCategory,
  t1.ReAdmitInd
  
 
--330 diagnosis Summary(diags)	
select
	t1.ReAdmitTypeInd,
	t1.CCSCategory,
	t1.ReAdmitInd,
	Count(t1.AdmitNum)AdmitNum,
	Sum(t1.ReAdmitDays)ReAdmitDays,
	Count(t1.AdmitNum)AdmitNum1
Into #tbl_330_diagnosis_Summary
from #tbl_105_Readmits t1
where t1.ReAdmitTypeInd = 'S'
Group by
	t1.ReAdmitTypeInd,
	t1.CCSCategory,
	t1.ReAdmitInd


--D_CCS
select distinct 
	t1.CCSLevel1,
	t1.CCSLevel1Descr
Into #tbl_DCCS
from dbo.luCCS t1
	
	
--340 diagnosis summary
select
 t3.CCSLevel1Descr,
 t1.CountofAdmitNum1,
 t1.Y,
 t1.ReAdmitDays SumofReadmitDays,
 t2.AdmitNum DiagCt,
 t2.ReAdmitDays DiagGap,
 t4.AdmitNum ProvCt,
 t4.ReAdmitDays ProvGap
into #tbl_340_diagnosis_summary
from #310diagnosis_summary t1
left outer join #tbl_320_diagnosis_Summary t2	on
t1.CCSCategory = t2.CCSCategory 
left outer join #tbl_DCCS t3 on
t1.CCSCategory = t3.CCSLevel1
left outer join #tbl_330_diagnosis_Summary t4 on
t1.CCSCategory = t4.CCSCategory
order by 2 desc


--410 Provider Summary
select
		t2.Hospital,
		Sum(t2.ReAdmitDays)ReAdmitDays,
		Sum(t2.Admitnum)CountofAdmitNum1,
		Sum(case when t2.ReAdmitInd = 'N' then t2.Admitnum else 0 end) N,
		Sum(case when t2.ReAdmitInd = 'Y' then t2.Admitnum else 0 end) Y
		
into #tbl_410_Provider_Summary
from 

(


select
	t2.ProviderFullName Hospital,
	t1.ReAdmitInd,
	Count(t1.AdmitNum)Admitnum,
	Sum(t1.ReAdmitDays)ReAdmitDays,
	Count(t1.AdmitNum)Admitnum1
	from #tbl_105_Readmits t1
inner join Genesis.dbo.luProvider t2 on
t1.TriggerRenderProviderXRefID = t2.ProviderId
group by
	t2.ProviderFullName,
	t1.ReAdmitInd
)t2
group by
t2.Hospital
order by 1

--420 Provider Summary
select
 t1.DiagTypeInd,
 t2.ProviderFullName Hospital,
 t1.ReAdmitInd,
 Count(t1.AdmitNum)AdmitNum,
 Sum(t1.ReAdmitDays)ReAdmitDays,
 Count(t1.AdmitNum)AdmitNum1
 into #420_Provider_Summary 
 from #tbl_105_Readmits t1
inner join Genesis.dbo.luProvider t2 on 
t1.TriggerRenderProviderXRefID = t2.ProviderId 
where t1.DiagTypeInd = 'Y'
and t1.ReAdmitInd = 'Y'
group by
 t1.DiagTypeInd,
 t2.ProviderFullName, 
 t1.ReAdmitInd
 
 
 --430 Provider Summary(Prov)
select
	t2.ProviderFullName Hospital,
	t1.ReAdmitTypeInd,
	t1.ReAdmitInd,
	Count(t1.AdmitNum)AdmitNum,
	Sum(t1.ReAdmitDays)ReAdmitDays
into #tbl_430_Provider_Summary
from #tbl_105_Readmits t1
inner join Genesis.dbo.luProvider t2 on
t1.TriggerRenderProviderXRefID = t2.ProviderId 
where t1.ReAdmitTypeInd = 'S'	
group by
	t2.ProviderFullName, 
	t1.ReAdmitTypeInd,
	t1.ReAdmitInd

--440 Provider Summary Report

select
	case when t4. Hospital is null then t1.Hospital else t4.Hospital_name_xwalk_ end Hospital,
	t1.CountofAdmitNum1,
	t1.Y,
	t1.ReAdmitDays    ReAdmitdays410,
	t2.AdmitNum       Admit430,
	t2.ReAdmitDays    ReAdmit430,
	t3.AdmitNum       AdmitNum420,
	t3.ReAdmitDays    ReAdmitDays420
Into #tbl_440_Provider_Summary_Report
from #tbl_410_Provider_Summary t1
left outer join #tbl_430_Provider_Summary t2 on
t1.Hospital = t2.Hospital 
left outer join #420_Provider_Summary t3 on
t1.Hospital = t3.Hospital
left outer join #tbl_Hospital_name_xwalk_ t4 on
t1.Hospital = t4.Hospital
order by 2 desc 


select 
	t4.Startdateccyymm,
	t4.Enddateccyymm,
	t2.ReAdmitTypeInd,
	Case when t2.DiagTypeInd = 'Y' then 'S' else 'D' end Diag,
	t2.TriggerSourceDischargeStatus,
	t2.AdmitCCYYMM,
	t2.MemberId,
	STUFF(t2.MemberName, CHARINDEX(' ', t2.MemberName, 0), 0, ',')MemberName,
	t2.BenefitPlanCode,
	t2.Description,
	STUFF(t2.RenderProviderName, CHARINDEX(' ', t2.RenderProviderName, 0), 0, ',')RenderProviderName,
	t2.DateofAdmission,
	t2.DateofDischarge,
	t3.CCSLevel1Descr,
	STUFF(t2.TriggerRenderProvderName, CHARINDEX(' ', t2.TriggerRenderProvderName, 0), 0, ',')TriggerRenderProviderName,
	t2.TriggerDateOfAdmission,
	t2.TriggerDateOfDischarge,
	t1.CCSLevel1Descr TriggerDiag,
	t2.DateOfBirth
Into #tbl_560Patientlist
from #tbl_DCCS t1
inner join #tbl_105_Readmits t2 on
t1.CCSLevel1 = t2.TriggerCCSCategory
inner join #tbl_DCCS t3 on 
t2.CCSCategory = t3.CCSLevel1
inner join #tbl_Parm_Date_Patientlist t4 on
t2.AdmitCCYYMM between t4.Startdateccyymm and t4.Enddateccyymm
where t2.ReAdmitTypeInd is not null

--Final Report Outputs:

--1)

select 
	t1.SourceDischargeStatus,
	t1.Discharge_Status_Description,
	t1.Measure,
	'' [<>],
    t1.[201601],
    t1.[201602],
    t1.[201603],
    t1.[201604],
    t1.[201605],
    t1.[201606],
    t1.[999999]

from #finalPivotOutput t1
order by 1,2,3

--2)

select * from #tbl_340_diagnosis_summary

--3)

select * from #tbl_440_Provider_Summary_Report

--4)

select * from #tbl_560Patientlist 


