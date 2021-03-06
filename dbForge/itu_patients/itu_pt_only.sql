--all admissions to ITU coded locations on EMAP
--ICU locations hard coded; will need to update over time
--accurate as of beginning of 2021
WITH loc AS 
(SELECT
  SPLIT_PART(loc.location_string,'^',1) as location_split,
  loc.location_string,
  loc.location_id,
lv.hospital_visit_id,
  lv.admission_time,
  lv.discharge_time
FROM 
  star.location loc
  JOIN
  star.location_visit lv
  ON 
  loc.location_id = lv.location_id
  ),
  itu_patients AS
  (SELECT * 
  FROM loc 
  WHERE 
  location_split ~ '^(T03|WSCC|SINQ|MINQ|P03CV|T07CV)')
SELECT *
FROM itu_patients;
