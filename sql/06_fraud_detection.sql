create or replace trigger fraud_detection
after insert or update on interviews
for each row
begin
if :new.technical_score>90 and :new.confidence_score<30
then
insert into fraud_logs values(fraud_seq.nextval,:new.interview_id,'possible cheating',sysdate,'high technical low confidence');
end if;
end;
