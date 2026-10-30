/* Create a SQL stored procedure for the Sudoku Solver          */
/* The puzzle is passed in as string literal length 81 (9x9).   */
/* The procedure returns one result set (ordered).              */
/* Example:                                                     */
--
-- CALL SUDOKU_SOLVE_PROC('...39.67.......8..26...7..5....5.14....6.8....95.7....7..9...84..3.......86.31...');
--
/* create with: db2 -td@ -f sudoku_solver_proc.sql

CREATE OR REPLACE PROCEDURE SUDOKU_SOLVER (IN P_PUZZLE VARCHAR(81))
  LANGUAGE SQL
  READS SQL DATA
  DYNAMIC RESULT SETS 1
  DETERMINISTIC
  NO EXTERNAL ACTION
BEGIN
  DECLARE C_RESULT CURSOR WITH RETURN TO CLIENT FOR
    WITH PUZZLE_INPUT (sud) AS (
        SELECT CAST(P_PUZZLE AS VARCHAR(81)) FROM SYSIBM.SYSDUMMY1
    ),
    CTE_DIGITS (z, lp) AS (
        /* 9 rows for the digits 1 to 9, built by recursion */
        SELECT '1' AS z, 1 AS lp FROM SYSIBM.SYSDUMMY1
        UNION ALL
        SELECT CAST(lp + 1 AS VARCHAR(1)), lp + 1 FROM CTE_DIGITS WHERE lp < 9
    ),
    /* table(sudoku state, index, level) */
    CTE_X (s, ind, lvl) AS (
        /* recursive solver: fill the first empty cell with every digit that is still legal    */
        /* lvl = recursion depth, incremented by 1 and bounded by a constant (avoids SQL0347W) */
        SELECT sud, LOCATE_IN_STRING(sud, '.'), CAST(0 AS INTEGER) FROM PUZZLE_INPUT
        UNION ALL
        SELECT CAST(SUBSTRING(s FROM 1 FOR ind-1) || z || SUBSTRING(s FROM ind+1) AS VARCHAR(81)),
               LOCATE_IN_STRING(SUBSTRING(s FROM 1 FOR ind-1) || z || SUBSTRING(s FROM ind+1), '.'),
               CAST(lvl + 1 AS INTEGER)
        FROM CTE_X, CTE_DIGITS AS digits
        WHERE lvl < 81 AND ind > 0
          AND NOT EXISTS (
            SELECT 1 FROM CTE_DIGITS AS lp
            /* next lines check cell for for row, column, and 3x3 box */
            WHERE digits.z = SUBSTRING(s FROM ((ind-1)/9)*9 + lp FOR 1)
               OR digits.z = SUBSTRING(s FROM MOD((ind-1), 9) + (lp-1)*9 + 1 FOR 1)
               OR digits.z = SUBSTRING(s FROM MOD(((ind-1)/3), 3)*3 + ((ind-1)/27)*27 + lp + ((lp-1)/3)*6 FOR 1)
          )
    ),
    SOLUTION AS (
        /* the row without empty cells is the solution */
        SELECT s FROM CTE_X WHERE ind = 0
    ),
    CTE_BOTH_COMBINED AS (
        /* split puzzle and solution into 9 rows of 9 characters */
        SELECT SUBSTR(sud, (lp-1)*9 + 1, 9) AS s9, lp*10 AS l FROM CTE_DIGITS, PUZZLE_INPUT
        UNION ALL
        SELECT SUBSTR(s,   (lp-1)*9 + 1, 9) AS s9, (lp+9)*10+1 AS l FROM CTE_DIGITS, SOLUTION
    ),
    CTE_FRAME AS (
        /* add the vertical bars and the separator lines */
        SELECT CAST('|' || SUBSTR(s9,1,3) || '|' || SUBSTR(s9,4,3) || '|' || SUBSTR(s9,7,3) || '|' AS VARCHAR(13)) AS sf, l
        FROM CTE_BOTH_COMBINED
        UNION ALL
        SELECT CASE WHEN lp=1 THEN CAST('             ' AS VARCHAR(13)) ELSE CAST('-------------' AS VARCHAR(13)) END,
               CASE WHEN lp = 9 THEN 99 WHEN lp=1 THEN 97 ELSE (lp-2)*30 + 5 END
        FROM CTE_DIGITS
    )
    SELECT sf AS PUZZLE_SOLUTION FROM CTE_FRAME ORDER BY l;

  OPEN C_RESULT;
END
@
