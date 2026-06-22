
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
constraint fk_candidate_skill foreign key(candidate_id) references candidates(candidate_id)
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
