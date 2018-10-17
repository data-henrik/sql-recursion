WITH 
  INPUT(sud) AS (
    VALUES('53..7....6..195....98....6.8...6...34..8.3..17...2...6.6....28....419..5....8..79')
  ),
  DIGITS(z, lp) AS (
    VALUES('1', 1)
    UNION ALL SELECT
    CAST(lp+1 AS varchar(200)), lp+1 FROM DIGITS WHERE lp<9
  ),
  X(s, ind) AS (
    SELECT sud, instr(sud, '.') FROM INPUT
    UNION ALL
    SELECT
      substr(s, 1, ind-1) || z || substr(s, ind+1),
      instr( substr(s, 1, ind-1) || z || substr(s, ind+1), '.' )
    FROM X, DIGITS AS z
    WHERE ind>0
      AND NOT EXISTS (
            SELECT 1
            FROM DIGITS AS lp
            WHERE z.z = substr(s, ((ind-1)/9)*9 + lp, 1)
                  OR z.z = substr(s, ((ind-1)%9) + (lp-1)*9 + 1, 1)
                  OR z.z = substr(s, (((ind-1)/3) % 3) * 3
                        + ((ind-1)/27) * 27 + lp
                        + ((lp-1) / 3) * 6, 1)
         )
  )
SELECT s as solution FROM X WHERE ind=0;