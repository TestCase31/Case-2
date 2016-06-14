/*
За исключением второй версии запроса,
пример выполнен на Oracle
*/
/*
Создать таблицу sales
*/
CREATE TABLE sales AS 
    SELECT 1 salesid, 10 productid, sysdate datetime, 50 customerid FROM dual
    UNION ALL
    SELECT 2, 11, sysdate, 50 FROM dual
    UNION ALL
    SELECT 3, 11, sysdate-1, 50 FROM dual
    UNION ALL
    SELECT 4, 10, sysdate-1, 50 FROM dual
    UNION ALL
    SELECT 5, 10, sysdate-2, 50 FROM dual
    UNION ALL
    SELECT 6, 12, sysdate-2, 50 FROM dual
    UNION ALL
    SELECT 7, 16, sysdate, 51 FROM dual
    UNION ALL
    SELECT 8, 15, sysdate, 51 FROM dual
    UNION ALL
    SELECT 9, 16, sysdate-1, 51 FROM dual
    UNION ALL
    SELECT 10, 11, sysdate-1, 51 FROM dual
    UNION ALL
    SELECT 11, 10, sysdate-1, 51 FROM dual
    UNION ALL
    SELECT 12, 16, sysdate-2, 51 FROM dual
    UNION ALL
    SELECT 13, 11, sysdate, 52 FROM dual
    UNION ALL
    SELECT 14, 16, sysdate, 52 FROM dual
    UNION ALL
    SELECT 15, 10, sysdate, 52 FROM dual
    UNION ALL
    SELECT 16, 16, sysdate-1, 52 FROM dual
    UNION ALL
    SELECT 17, 15, sysdate-1, 52 FROM dual
/

Table created.

/*
Содержание таблицы
*/
SELECT * FROM sales;

   SALESID  PRODUCTID DATETIME CUSTOMERID
---------- ---------- -------- ----------
         1         10 11.06.16         50
         2         11 11.06.16         50
         3         11 10.06.16         50
         4         10 10.06.16         50
         5         10 09.06.16         50
         6         12 09.06.16         50
         7         16 11.06.16         51
         8         15 11.06.16         51
         9         16 10.06.16         51
        10         11 10.06.16         51
        11         10 10.06.16         51
        12         16 09.06.16         51
        13         11 11.06.16         52
        14         16 11.06.16         52
        15         10 11.06.16         52
        16         16 10.06.16         52
        17         15 10.06.16         52

17 rows selected.


/*
Запрос выполнен на Oracle
*/
WITH wq2 AS (
  SELECT MAX (productid) KEEP (DENSE_RANK FIRST ORDER BY salesid) eachfirstproduct
    FROM sales
GROUP BY customerid, datetime
)
  SELECT eachfirstproduct productid, COUNT (eachfirstproduct) productcount
    FROM wq2
GROUP BY eachfirstproduct
ORDER BY productcount DESC, productid;

 PRODUCTID PRODUCTCOUNT
---------- ------------
        16            4
        10            2
        11            2

3 rows selected.

/*
Запрос по стандарту ISO SQL:2013
Совместимость с MSSQL 2008 
*/
SELECT productid, COUNT(productid) firstcount
  FROM (SELECT sales.productid,
               ROW_NUMBER () OVER (PARTITION BY customerid, datetime ORDER BY salesid) firstproduct
          FROM sales)
 WHERE firstproduct = 1
GROUP BY productid
ORDER BY firstcount DESC, productid;

 PRODUCTID FIRSTCOUNT
---------- ----------
        16          4
        10          2
        11          2
        
DROP TABLE sales
/

Table dropped.