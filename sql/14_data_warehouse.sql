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
