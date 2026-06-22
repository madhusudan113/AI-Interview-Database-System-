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
