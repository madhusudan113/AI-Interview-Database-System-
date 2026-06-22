create or replace procedure generate_candidate_recommendation(p_candidate_id number)
as
v_score number;
begin
select avg(final_score) into v_score from interviews where candidate_id=p_candidate_id;

if v_score>=85 then
insert into ai_recommendations values(recommendation_seq.nextval,p_candidate_id,'recommended for senior technical roles',sysdate);
elsif v_score>=70 then
insert into ai_recommendations values(recommendation_seq.nextval,p_candidate_id,'recommended after skill improvement',sysdate);
else
insert into ai_recommendations values(recommendation_seq.nextval,p_candidate_id,'need technical training',sysdate);
end if;
commit;
end;
