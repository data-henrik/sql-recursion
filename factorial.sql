WITH temp (n, fact) AS (
  values(0, 1)
  UNION ALL
  SELECT
    n + 1,
    (n + 1) * fact
  FROM
    temp
  WHERE
    n < 9
)
SELECT
  *
FROM
  temp