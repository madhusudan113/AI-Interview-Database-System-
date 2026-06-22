create or replace function get_candidate_rank(p_candidate_id number)
return number
as
v_rank number;
begin
select ranking into v_rank from(select candidate_id,rank() over(order by final_score desc) ranking from interviews ) where candidate_id=p_candidate_id;
return v_rank;
end;
/


select get_candidate_rank(1)from dual;
