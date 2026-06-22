create or replace procedure predict_candidate(p_interview_id number)
as
v_score number;
begin
select final_score into v_score from interviews where interview_id=p_interview_id;

if v_score>=85 then
update interviews set hiring_prediction='selected';
elsif v_score>=70 then
update interviews set hiring_prediction='shortlist';
else
update interviews set hiring_prediction='reject';
end if;
commit;
end;
