create table interview_history(
interview_id number,
interview_date date,
score number
)
partition by range(interview_date)(partition p2025 values less than(to_date('01-jan-2026','dd-mon-yyyy')),
partition p2026 values less than(to_date('01-jan-2027','dd-mon-yyyy'))
);
