
WITH
  INPUT (sud) AS (
    VALUES
      (
        '...39.67.......8..26...7..5....5.14....6.8....95.7....7..9...84..3.......86.31...'
      )
  ),
  DIGITS(z, lp) AS (
    VALUES
      ('1', 1)
    UNION ALL
    SELECT
      CAST(lp + 1 AS varchar(200)),
      lp + 1
    FROM
      DIGITS
    WHERE
      lp < 9
  ),
  X (s, ind, len_s) AS (
    SELECT
      sud      ,
      instr(sud, '.'),
      length(sud)
    FROM
      INPUT
    UNION ALL
    SELECT
      substr(s, 1, ind -1) || z.z || RIGHT(s,81-ind),
      instr(
        substr(s, 1, ind -1) || z.z || RIGHT(s,81-ind),
        '.'
      ),
      ind+1
    FROM
      X,
      DIGITS AS z
    WHERE
      ind BETWEEN 1 AND 81 AND
      NOT EXISTS (
        SELECT
          1
        FROM
          DIGITS AS lp
        WHERE
          z.z = substr(s, ((ind -1) / 9) * 9 + lp.lp, 1) OR
          z.z = substr(s, ((ind -1) % 9) + (lp.lp -1) * 9 + 1, 1) OR
          z.z = substr(
            s,
            (((ind -1) / 3) % 3) * 3 + ((ind -1) / 27) * 27 + lp.lp + ((lp.lp -1) / 3) * 6,
            1
          )
      )
  )
SELECT
  s AS solution,
  ind AS INDEX,
  len_s
FROM
  X
WHERE
  ind=0;
