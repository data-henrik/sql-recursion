-- both queries are against the SAMPLE database
-- and should return the same result
SELECT LEVEL, CAST(SPACE((LEVEL - 1) * 4) || '/' || DEPTNAME
       AS VARCHAR(40)) AS DEPTNAME
FROM DEPARTMENT
     START WITH DEPTNO = 'A00'
     CONNECT BY NOCYCLE PRIOR DEPTNO = ADMRDEPT;


WITH tdep(level, deptname, deptno) as (
    SELECT 1, CAST( DEPTNAME AS VARCHAR(40)) AS DEPTNAME, deptno
    FROM department 
    WHERE DEPTNO = 'A00'
    UNION ALL
    SELECT t.LEVEL+1, CAST(SPACE(t.LEVEL  * 4) || '/' || d.DEPTNAME
       AS VARCHAR(40)) AS DEPTNAME, d.deptno
    FROM DEPARTMENT d, tdep t
    WHERE d.admrdept=t.deptno and d.deptno<>'A00')
SELECT level, deptname
FROM tdep;



