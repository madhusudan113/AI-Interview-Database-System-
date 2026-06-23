-------------------------------------------------
-- AI INTERVIEW DATABASE SYSTEM
-- DATABASE DESIGN
-------------------------------------------------

create table candidates(
candidate_id number primary key,
full_name varchar2(100),
email varchar2(100),
phone varchar2(20),
experience_years number,
primary_skill varchar2(100),
resume_text clob,
created_date date default sysdate
);

create table candidate_skills(
candidate_skill_id number primary key,
candidate_id number,
skill_name varchar2(100),
proficiency_level varchar2(50),
constraint fk_candidate_skill foreign key(candidate_id) reFERENCES candidates(candidate_id)
);

create table interviewers(
interviewer_id number primary key,
interviewer_name varchar2(100),
department varchar2(100),
experience_years number
);

create table interviews(
interview_id number primary key,
candidate_id number,
interviewer_id number,
interview_date date,
interview_mode varchar2(30),
status varchar2(30),
technical_score number,
communication_score number,
confidence_score number,
final_score number,
fraud_score number,
hiring_prediction varchar2(30),
ai_feedback clob,
constraint fk_candidate foreign key(candidate_id)references candidates(candidate_id),
constraint fk_interviewer foreign key(interviewer_id) references interviewers(interviewer_id)
);

create table interview_questions(
question_id number primary key,
interview_id number,
question_text varchar2(1000),
candidate_answer clob,
score number,
foreign key(interview_id) references interviews(interview_id)
);

create table fraud_logs(
fraud_id number primary key,
interview_id number,
fraud_type varchar2(200),
fraud_timestamp date default sysdate,
remarks varchar2(500)
);

create table notifications(
notification_id number primary key,
candidate_id number,
message varchar2(500),
status varchar2(30),
created_date date default sysdate
);

create table audit_logs(
audit_id number primary key,
table_name varchar2(100),
operation varchar2(50),
username varchar2(100),
action_date date default sysdate
);

create table job_required_skills(
skill_id number primary key,
job_role varchar2(100),
skill_name varchar2(100)
);

create table skill_gap_analysis(
analysis_id number primary key,
candidate_id number,
missing_skill varchar2(100),
recommendation varchar2(500)
);

create table ai_recommendations(
recommendation_id number primary key,
candidate_id number,
recommendation_text varchar2(1000),
generated_date date default sysdate
);


-- SEQUECES
--------------------
create sequence candidate_seq start with 1;
create sequence interviewer_seq start with 100;
create sequence interview_seq start with 1000;
create sequence fraud_seq start with 1;
create sequence notification_seq start with 1;
create sequence audit_seq start with 1;
create sequence skill_gap_seq start with 1;
create sequence recommendation_seq start with 1;


-- SAMPLE DATA
------------------
insert into candidates values(candidate_seq.nextval,'madhu sudan','madhu@gmail.com','9999999999',2,'data engineering','experience in sql pyspark python databricks azure',sysdate);


insert into candidate_skills values(1,1,'sql','advanced');
insert into candidate_skills values(2,1,'pyspark','advanced');
insert into candidate_skills values(3,1,'databricks','intermediate');


insert into interviewers values(interviewer_seq.nextval,'ravi kumar','data engineering',10);


insert into interviews(interview_id,candidate_id,interviewer_id,interview_date,interview_mode,status,technical_score,communication_score,confidence_score)
values(interview_seq.nextval,1,100,sysdate,'online','completed',92,85,80);


insert into job_required_skills values(1,'data engineer','sql');
insert into job_required_skills values(2,'data engineer','python');
insert into job_required_skills values(3,'data engineer','databricks');
COMMIT;



-- PROCEDURE
-- =================
-- fraud detection engine
-- =======================
create or replace trigger fraud_detection
after insert or update on interviews
for each row
begin
if :new.technical_score>90 and :new.confidence_score<30
then
insert into fraud_logs values(fraud_seq.nextval,:new.interview_id,'possible cheating',sysdate,'high technical low confidence');
end if;
end;
/

-- audit logging system
-- ============================
create or replace trigger audit_interview
after insert or update or delete on interviews
begin
insert into audit_logs values(audit_seq.nextval,'interviews',ora_sysevent,user,sysdate);
end;
/

-- PACKAGE_INTERVIEW_ENGINE
-- ===========================
-- package specification
-------------------------
create or replace package pkg_interview_engine
as
procedure calculate_score(p_interview_id number);
procedure generate_ai_feedback(p_interview_id number);
procedure predict_candidate(p_interview_id number);
function get_candidate_rank(p_candidate_id number)
return number;
procedure generate_candidate_recommendation(p_candidate_id number);
end pkg_interview_engine;
/

-- package body
----------------------

create or replace package body pkg_interview_engine
as

-- final score

procedure calculate_score(p_interview_id number)
as
v_score number;
begin
select technical_score*0.6 + communication_score*0.2 +confidence_score*0.2 into v_score from interviews where interview_id=p_interview_id;
update interviews set final_score=v_score where interview_id=p_interview_id;
end calculate_score;

-- ai feedback

procedure generate_ai_feedback(p_interview_id number)
as
v_score number;
v_feedback clob;
begin
select final_score into v_score from interviews where interview_id=p_interview_id;
if v_score >=85 then
v_feedback := 'excellent candidate. strong technical skills.';
elsif v_score >=70 then
v_feedback := 'good candidate. minor improvements required.';
else
v_feedback := 'needs improvement and training.';
end if;

update interviews set ai_feedback=v_feedback where interview_id=p_interview_id;
end generate_ai_feedback;

-- hiring prediction

procedure predict_candidate(p_interview_id number)
as
v_score number;
begin
select final_score into v_score from interviews where interview_id=p_interview_id;
if v_score >=85 then
update interviews set hiring_prediction='selected' where interview_id=p_interview_id;
elsif v_score >=70 then
update interviews set hiring_prediction='shortlist' where interview_id=p_interview_id;
else
update interviews set hiring_prediction='reject' where interview_id=p_interview_id;
end if;
end predict_candidate;

-- ranking

function get_candidate_rank(p_candidate_id number)
return number
as
v_rank number;
begin
select ranking into v_rank from(select candidate_id,rank() over(order by final_score desc) ranking from interviews) where candidate_id=p_candidate_id;
return v_rank;
end get_candidate_rank;

-- recommendation engine

procedure generate_candidate_recommendation(p_candidate_id number)
as
v_score number;
begin
select avg(final_score) into v_score from interviews where candidate_id=p_candidate_id;
if v_score >=85 then
insert into ai_recommendations values(recommendation_seq.nextval,p_candidate_id,'recommended for senior technical roles',sysdate);
elsif v_score >=70 then
insert into ai_recommendations values(recommendation_seq.nextval,p_candidate_id,'recommended after skill improvement',sysdate);
else
insert into ai_recommendations values(recommendation_seq.nextval,p_candidate_id,'need technical training',sysdate);
end if;
end generate_candidate_recommendation;

end pkg_interview_engine;
/
execute
-------------------
-- calculate score
exec pkg_interview_engine.calculate_score(1000);
-- generate ai feedback
exec pkg_interview_engine.generate_ai_feedback(1000);
-- predict hiring
exec pkg_interview_engine.predict_candidate(1000);
-- generate recommendation
exec pkg_interview_engine.generate_candidate_recommendation(1);
-- ranking
select pkg_interview_engine.get_candidate_rank(1) from dual;




-- PACKAGE SKILL ENGINE
-- ========================
-- package specification
-----------------------
create or replace package pkg_skill_engine
as
procedure analyze_skill_gap(p_candidate_id number,p_job_role varchar2);
function resume_skill_match(p_candidate_id number,p_keyword varchar)
return varchar2;
end pkg_skill_engine;
/

-- package body
-----------------

create or replace package body pkg_skill_engine
as
procedure analyze_skill_gap(p_candidate_id number,p_job_role varchar2)
as
v_resume clob;
begin
select lower(resume_text) into v_resume from candidates where candidate_id=p_candidate_id;
for skill in(select skill_name from job_required_skills where lower(job_role)=lower(p_job_role))
loop
if instr(v_resume,lower(skill.skill_name))=0 then
insert into skill_gap_analysis values(skill_gap_seq.nextval,p_candidate_id,skill.skill_name,'recommended training for '||skill.skill_name);
end if;
end loop;
end analyze_skill_gap;

function resume_skill_match(p_candidate_id number,p_keyword varchar2)
return varchar2
as
v_resume clob;
begin
select lower(resume_text) into v_resume from candidates where candidate_id=p_candidate_id;
if instr(v_resume,lower(p_keyword)) > 0 then
return 'match found';
else
return 'skill missing';
end if;
end resume_skill_match;

end pkg_skill_engine;
/

--execute
-----------------------
-- skill gap analysis
exec pkg_skill_engine.analyze_skill_gap(1,'data engineer');

-- resume matching
select pkg_skill_engine.resume_skill_match(1,'python') from dual;



-- package notification engine
-- =============================
--package specification

create or replace package pkg_notification_engine
as
procedure send_notification(p_candidate_id number,p_message varchar2);
end pkg_notification_engine;
/

--package body
create or replace package body pkg_notification_engine
as
procedure send_notification(p_candidate_id number,p_message varchar2)
as
begin
insert into notifications values(notification_seq.nextval,p_candidate_id,p_message,'pending',sysdate);
end send_notification;
end pkg_notification_engine;
/

--execute
-------------------
-- notification
exec pkg_notification_engine.send_notification(1,'interview result generated');

-- interview question analytics
-- ==============================
create view vw_question_analysis as
select question_text,avg(score) average_score,count(*) attemptsfrom interview_questions group by question_text;

-- data warehouse design
-- =======================
--               DIM_CANDIDATE
--                     |
--                     |
-- DIM_DATE ---- FACT_INTERVIEW ---- DIM_SKILL
--                     |
--                     |
--              DIM_INTERVIEWER
			 


create table dim_candidate as
select candidate_id,full_name,experience_years from candidates;

create table dim_interviewer as
select * from interviewers;

create table fact_interview as
select interview_id,candidate_id,interviewer_id,final_score,technical_score,communication_score from interviews;



-- hr analytics dashboard view
-- ====================================
create or replace view vw_hr_dashboard
as
select c.full_name,c.primary_skill,i.final_score,i.hiring_prediction,i.ai_feedback,case
when i.final_score>=85 then 'top talent'
when i.final_score>=70 then 'good'
else 'average'
end candidate_category
from candidates c join interviews i on c.candidate_id=i.candidate_id;

select *from vw_hr_dashboard;


-- materalized view
-- =====================
create materialized view mv_monthly_report
refresh complete on demand
as
select to_char(interview_date,'mon-yyyy') month,count(*) total_interviews,avg(final_score) average_score from interviews
group by to_char(interview_date,'mon-yyyy');


-- partition table
-- =====================
create table interview_history(
interview_id number,
interview_date date,
score number
)
partition by range(interview_date)(partition p2025 values less than(to_date('01-jan-2026','dd-mon-yyyy')),
partition p2026 values less than(to_date('01-jan-2027','dd-mon-yyyy'))
);


-- index optimization
============================
create index idx_candidate_skill on candidates(primary_skill);
create index idx_interview_score on interviews(final_score);
create index idx_interview_date on interviews(interview_date);


-- scheduler automation
=========================
begin
dbms_scheduler.create_job(
job_name=>'daily_interview_report',
job_type=>'plsql_block',
job_action=>'
begin
dbms_output.put_line(''daily interview report generated'');
end;',
start_date=>sysdate,
repeat_interval=>'freq=daily',
enabled=>true
);
end;
/
