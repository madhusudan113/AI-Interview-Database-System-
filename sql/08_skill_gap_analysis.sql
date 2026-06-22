create or replace procedure analyze_skill_gap(p_candidate_id number,p_job_role varchar2)
as
v_resume clob;
begin
select lower(resume_text) into v_resume from candidateswhere candidate_id=p_candidate_id;

for skill in (select skill_name from job_required_skills where lower(job_role)=lower(p_job_role))
loop
if instr(v_resume,lower(skill.skill_name))=0
then
insert into skill_gap_analysis values(skill_gap_seq.nextval,p_candidate_id,skill.skill_name,'recommended training for '||skill.skill_name);
end if;
end loop;
commit;
end;
