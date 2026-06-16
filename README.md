# AI Interview Database System

## Overview

AI Interview Database System is a SQL & PL/SQL based recruitment analytics platform that helps organizations:

- Store candidate interview data
- Rank candidates automatically
- Detect interview fraud
- Analyze hiring trends
- Identify skill gaps
- Generate interview reports
- Automate notifications

---

## Business Problem

Recruitment teams conduct thousands of interviews.

Challenges:

- Manual candidate evaluation
- Fraud during online interviews
- Lack of analytics
- No skill-gap identification
- Slow hiring decisions

This project solves these challenges using SQL and PL/SQL.

---

## Technologies Used

- Oracle Database
- SQL
- PL/SQL
- Triggers
- Procedures
- Functions
- Views
- Scheduler Jobs
- Window Functions
- Indexes
- Partitions

---

## Database Design

### Tables

1. Candidates
2. Interviewers
3. Interviews
4. Fraud Logs
5. Job Required Skills
6. Skill Gap Analysis

---

## Features

### Candidate Ranking

Ranks candidates based on technical scores.

### Fraud Detection

Detects:

- Multiple login attempts
- Suspicious interview activity
- Unusual behavior

### Skill Gap Analysis

Compares candidate skills against job requirements.

### Hiring Analytics

Provides:

- Monthly hiring trends
- Top candidates
- Average skill scores

### Automated Notifications

Scheduler jobs send reports automatically.

---

## Project Architecture

Candidate
    |
Interview
    |
Oracle Database
    |
PL/SQL Engine
    |
Fraud Detection
    |
Analytics Layer
    |
Reports & Notifications

---

## Sample Queries

### Top Candidates

```sql
SELECT candidate_id,
technical_score,
RANK() OVER(ORDER BY technical_score DESC)
FROM interviews;
