create materialized view mv_monthly_report
refresh complete on demand
as
select to_char(interview_date,'mon-yyyy') month,count(*) total_interviews,avg(final_score) average_score from interviews
group by to_char(interview_date,'mon-yyyy');
