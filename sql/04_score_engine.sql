create or replace procedure calculate_score(p_interview_id number)
as
v_score number;
begin
select technical_score*0.6+communication_score*0.2+confidence_score*0.2 into v_score from interviews where interview_id=p_interview_id;

update interviews set final_score=v_score where interview_id=p_interview_id;
commit;
end;
/

exec calculate_score(1000);
