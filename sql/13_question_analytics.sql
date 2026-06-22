create view vw_question_analysis as
select question_text,avg(score) average_score,count(*) attemptsfrom interview_questions group by question_text;

