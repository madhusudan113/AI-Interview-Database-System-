create or replace view vw_hr_dashboard
as
select c.full_name,c.primary_skill,i.final_score,i.hiring_prediction,i.ai_feedback,case
when i.final_score>=85 then 'top talent'
when i.final_score>=70 then 'good'
else 'average'
end candidate_category
from candidates c join interviews i on c.candidate_id=i.candidate_id;

select *from vw_hr_dashboard;
