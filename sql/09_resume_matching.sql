
create or replace function resume_skill_match(p_candidate_id number,p_keyword varchar2)
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
end ;
