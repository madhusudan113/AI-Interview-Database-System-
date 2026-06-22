create or replace procedure send_notification(p_candidate_id number,p_message varchar2)
as
begin
insert into notifications values(notification_seq.nextval,p_candidate_id,p_message,'pending',sysdate);
commit;
end;
/

exec send_notification(1,'your interview result is generated');
