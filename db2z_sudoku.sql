--
-- this version runs on Db2 for z/OS
--
WITH input(sud) AS (
  --  VALUES('91.7......326.9.8...7.8.9...86.3.17.3.......6.51.2.84...9.5.3...2.3.149......2.61')
  --   values ('..2....13.1493......8.4....1..2..9..6..4..2.82..68....8....964147...6....5..1.8.2')
  --   values ('.1..38.6......1.4559..........39.1..65..........16..2....614.....7............8.9')
  SELECT ('..94......5468........7..251...5...67..348.......6.893.1...2....8.5....9......368')
    FROM SYSIBM.SYSDUMMY1
  )
, digits(z, lp) AS (  
    SELECT '1' as z, 1 as lp from sysibm.sysdummy1
    UNION ALL
    SELECT CAST(lp + 1 AS varchar(1)), lp + 1 FROM digits WHERE lp < 9
  )
  ,  x(s, ind) AS (
   SELECT sud, instr(sud, '.') FROM input
    UNION ALL
    SELECT
      substr(s, 1, ind-1) || z || substr(s, ind+1), 
      instr( substr(s, 1, ind-1) || z || substr(s, ind+1), '.' ) 
     FROM x, digits AS z
    WHERE ind>0
      AND NOT EXISTS (
            SELECT 1
              FROM digits AS lp
              WHERE z.z = substr(s, ((ind-1)/9)*9 + lp, 1)
                OR z.z = substr(s, (mod((ind-1), 9)) + (lp-1)*9 + 1, 1)
                OR z.z = substr(s, (mod(((ind-1)/3), 3)) * 3 
                        + ((ind-1)/27) * 27 + lp
                        + ((lp-1) / 3) * 6, 1)
         )
  )
SELECT s FROM x WHERE ind=0;
