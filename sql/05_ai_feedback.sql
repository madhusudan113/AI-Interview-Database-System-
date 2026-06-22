create or replace procedure generate_ai_feedback(p_interview_id number)
as
v_feedback clob;
v_score number;
begin
select final_score into v_score from interviews where interview_id=p_interview_id;

if v_score>=85 then
v_feedback :='excellent candidate. strong technical skills.';
elsif v_score>=70 then
v_feedback :='good candidate. minor improvements required.';
else
v_feedback :='needs improvement and training.';
end if;

update interviews set ai_feedback=v_feedback where interview_id=p_interview_id;
commit;
end;
