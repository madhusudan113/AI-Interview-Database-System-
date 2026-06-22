begin
dbms_scheduler.create_job(
job_name=>'daily_interview_report',
job_type=>'plsql_block',
job_action=>'
begin
dbms_output.put_line(''daily interview report generated'');
end;',
start_date=>sysdate,
repeat_interval=>'freq=daily',
enabled=>true
);
end;
