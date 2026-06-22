create or replace trigger audit_interview
after insert or update or delete on interviews
begin
insert into audit_logs values(audit_seq.nextval,'interviews',ora_sysevent,user,sysdate);
end;
