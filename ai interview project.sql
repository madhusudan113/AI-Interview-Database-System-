--1.PROJECT OVERVIEW
--===================================
--Project Name(AI INTERVIEW DATABASE SYSTEM)
------------------------------------------------
--GOAL:-
-----
--Build system that:-
--	Stores candidate interview data
--	Analyzes performance
--	Detects cheating/fraud
--	Ranks candidates
--	ai feedback	
--	Sends automated notifications



--2.REAL WORLD USE CASE
--=================================
--Companies like:-
--	Linkedin
--	Naukri
--	Indeed
--	Wellfound



--3.TECHNOLOGIES USED
--=====================================
--	SQL- data analysis
--	PLSQL- automation
--	ORACLE DB- database
--	TRIGGERS- fraud detection
--	PROCEDURES- scoring
--	FUNCTIONS- ranking
--	VIEWS- analytics
--	SCHEDULAR JOBS- email automation
--	INDEXING- performance
--	PARTITIONS- big data handling



--4.SYSTEM ARCHITECTURE
--==========================================
--	CANDIDATE
--		|
--	INTERVIEW TABLE
--		|
--	DATABASE TABLES
--		|
--	PLSQL ENGINE
--		|
--	ANALYTICS + FRAUD DETECTION
--		|
--	REPORTS + RANKING + NOTIFICATIONS



--5.DATABASE DESIGN(tables creation)
--=====================================
--TABLE 1 - CANDIDATES
--=====================
create table candidates(
candidate_id number primary key,
full_name varchar2(100),
email varchar2(100),
phone varchar2(20),
experience_years number,
primary_skill varchar2(50),
resume_text clob,
created_date date default sysdate);


insert into candidates values(1,'madhu sudan','madhu@gmail.com','9999999999',2,'pyspark','experienced in spark sql and etl',sysdate);



--TABLE 2 - INTERVIEWERS
--=================================
create table interviewers(
interviewer_id number primary key,
interviewer_name varchar2(100),
department varchar2(50),
experience_years number );


insert into interviewers values(101,'ravi kumar','data engineering',10);



--TABLE 3 - INTERVIEWS
--========================
create table interviews(
interview_id number primary key,
candidate_id number,
interviewer_id number,
interview_date date,
interview_mode varchar2(30),
interview_status varchar2(30),

communication_score number,
technical_score number,
confidence_score number,
ai_feedback,

foreign key(candidate_id) references candidates(candidate_id),
foreign key(interviewer_id) references interviewers(interviewer_id)
);


insert into interviews values(1001,1,101,sysdate,'online','completed',85,92,80,'excellent in pyspark and sql' );



--TABLE 4 - FRAUD DETECTION LOGS
--==================================
create table fraud_logs(
fraud_id number primary key,
interview_id number,
fraud_type varchar2(100),
fraud_timestamp date default sysdate,
remarks varchar2(500)
);



--TABLE 5 - REQUIRED SKILL TABLE
--==================================
create table job_required_skills(
skill_id number primary key,
job_role varchar2(100),
skill_name varchar2(100));


insert into job_required_skills values(1,'data engineer','sql');
insert into job_required_skills values(2,'data engineer','pyspark');
insert into job_required_skills vlaues(3,'data engineer','databricks');
insert into job_required_skills values(4,'data engineer','aws');
insert into job_required_skills values(5,'data engineer','python');



--TABLE 6 -SKILL GAP ANALYSIS
--==================================
create table skill_gap_analysis(
analysis_id number primary key,
candidate_id number,
missing_skill varchar2(100),
recommendation varchar2(500)
);


create sequence skill_gap_seq 
start with 1
increment by 1;




--6.ACTUAL WORK USING SQL QUERIES
--==================================
--A.FIND THE TOP CANDIDATE RANKING
--------------------------------
select candidate_id,technial_score,rank() over(order by technical_score desc) rnk from interviews;


--B.FIND THE SKILL-WISE AVERAGE SCORE
-------------------------------------
select c.primary_skill,avg(i.technical_score) avg_score from candidate c inner join interviews i on c.candidate_id=i.candidate_id group by c.primary_skill;


--C.FIND AND DETECT LOW PERFORMANCE
------------------------------------
select candidate_id,technical_score from interviews where technical_score<40;


--D.MONTHLY HIRING TREND
------------------------------
select to_char(interview_date,'mon-yyyy') month_name,count(*) total_interviews
from interviews group by to_char(interview_date,'mon-yyyy');


--E.SCORE ANALYSIS 
-------------------------
with score_analysis as(
select candidate_id,
technical_score,communication_score,confidence_score
from interviews)
select *from score_analysis where technical_score>80;


--F.PARTITION ANALYTICS QUERy(avg skill score)
-------------------------------
select candidate_id,primary_skill,technical_score,avg(technical_score) over(partition by primary_skill)as avg_skill_score from candidates c
inner join interviews i on c.candidate_id=i.candidate_id;


--7.PLSQL DEVELOPMENT
--============================
--AUTOMATED CANDIDATE SCORING
-----------------------------------
create or replace procedure calculate_final_score(p_interview_id number)
as
v_total_score number;
begin
select (technial_score*0.6)+(communication_score*0.2)+(confidence_score*0.2)
into v_total_score from interviews where interview_id=p_interview_id;

dbms_output.put_line('final  score:- '||v_total_score);
end;

exec calculate_final_score(1001);



--8.FRAUD DETECTION SYSTEM
======================================
--CREATE FRAUD DETECTION TRIGGERS
---------------------------------------
--(if confidence score too low but technical score too high then possible cheating)

create or replace trigger fraud_detection_trigger
after insert or update on interviews
for each row
begin
if :new.technical_score>90 and :new.confidence_score<30 then
	insert into fraud_logs(fraud_id,interview_id,fraud_type,remarks)values(fraud_seq.nextval,:new.interview_id,'possible online assitence','high technical score with low confidence');
end if;
end;

create sequence fraud_seq 
start with 1 
increment by 1;



--9.RESUME KEYWORD ANALYSIS
--=============================
--AI RESUME SCANNING(find candidates having 'pyspark')
----------------------------------------------------
select candidate_id,full_name from candidates where lower(resume_text) like '%pyspark%';

--FIND MISSING SKILLS
--------------------------------
select c.full_name,s.missing_skill from candidate c join skill_gap_analysis on c.candidate_id=s.candidate_id where s.missing_skill='databricks';



--10.AUTOMATED RANKING SYSTEM
--============================================
create or replace function get_candidate_rank(p_candidate_id number)
return number
as
v_rank number;
begin
select ranking into v_rank from (
select candidate_id,rank() over(order by technial_score desc)ranking from interviews)where candidate_id=p_candidate_id;
return v_rank;
end;

select get_candidate_rank(1) from dual;



--11.AUTOMATED EMAIL NOTIFICATIONS(by using dbms_scheduler)
--=========================================================
begin
dbms_scheduler.create_job(
job_name=>'interview_report_job',
job_type=>'plsql_block',
job_action=>'begin 
				dbms_output.put_line('sending interviews reports');
			end;',
start_date=>systimestamp,
repeat_interval=>'freq=daily',
enabled=>TRUE
);
end;



--12.GENERATED AI FEEDBACK
--===============================
created or replace procedure generate_ai_feedback(p_interview_id number)
as
v_tech number;
v_comm number;
v_conf number;
v_feedback clob;
begin
select technial_score,communication_score,confidence_score into v_tech,v_comm,v_conf from interviews where interview_id=p_interview_id;
--technical analysis
if v_tech>=90 then
	v_feedback:='excellent technical knowledge. ';
elsif v_tech>=70 then
	v_feedback:='good technical knowledge. ';
elsif v_tech >=50 then
	v_feedback:='average technincal knowledge. ';
else
	v_feedback:='needs technical improvement. ';
end if;

--confident  analysis
if v_conf >=90 then
	v_feedback:=v_feedback||'highly confident. ';
elsif v_conf>=70 then
	v_feedback:=v_feedback||'confident.';
else 
	v_feedback:=v_feedback||'needs confidence building.';
end if;

--communication analysis
if v_comm>=90 then
	v_feedback:=v_feedback||'excellent communication.';
elsif v_comm>=70 then
	v_feedback:=v_feedback||'good communication.';
else
	v_feedback:=v_feedback||'needs communication improvement.';
end if;

update interviews set ai_feedback=v_feedback where interview_id=p_interview_id;
commit;
end;


--13.ANALYSE SKILLS GAP
--=========================
create or replace procedure analyze_skill_gap(p_candidate_id number,p_job_role varchar2)
as
v_resume clob;
begin
select lower(resume_text) into v_resume from candidates where candidate_id=p_candidaate_id;
for i in (select skill_name from job_required_skills where upper(job_role)=upper(p_job_role)
loop
if instr(v_resume,lower(i.skill_name)=0 then
insert into skill_gap_analysis(analysis_id,candidate_id,missing_skill,recommendation) values(skill_gap_seq.nextval,p_canidate_id,i.skill_name,'recommended training for '||i.skill_name);
end if;
end loop;
commit;
end;

exec analyze_skill_gap(1,'data engineer');



--14.CREATE HR DASHBDOARD VIEWS
--=================================
create or replace view vw_interview_dashboard as
select c.full_name,c.primary_skill,
i.technial_score,i.communication_score,i.confidence_score,
(i.technial_score + i.communication_score + i.confidence_score) total_score
from candidate c inner join interviews i on c.candidate_id=i.candidate_id ;



--15.INDEXING OR PERFORMANCE AND OPTIMIZATION
--===========================================
--A.CREATE INDEXES(used to increase the peformance )
-------------------------
create index idx_candidate_skill on candidate(primary_skill);
create index idx_interview_date on interviews(interview_date);


--B.CREATE PARTITIONS (used for large data optimization)
------------------------------------------------------------
create table interview_archive(
interview_id number,interview_date date,technical_score number)
partiton by range(interview_date) (
partition p_2025 values less than (to_date('01-jan-2026','dd-mon-yyyy')),
partition p_2026 values less than (to_date('01-jan-2027','dd-mon-yyyy'))
);



--13.PROJECT FLOW
--========================
--	resume uploaded
--			|
--	candidate registered
--			|
--	interview scheduled
--			|
--	scores stored
--			|
--	plsql scoring engine
--			|
--	fraud detection trigger
--			|
--	analytics queries
--			|
--	ranking generated
--			|
--	dashboard reporting
--			|
--	email notications
