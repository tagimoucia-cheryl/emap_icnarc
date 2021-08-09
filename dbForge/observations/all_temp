-- all peripheral temperature values available for ITU patient admissions

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
  tem AS
(SELECT
  vo.visit_observation_id,
    vo.observation_datetime,
    vo.unit,
    vo.value_as_real,
    vo.hospital_visit_id,
    vo.visit_observation_type_id
  FROM
    star.visit_observation vo
WHERE
    vo.visit_observation_type_id IN
    ('200872172',--Respective epid id 3040100959
    '47471358', -- Respective epid id 6
    '200242941'-- Respective epid id 6
    )
    )
SELECT
loc.*,
    tem.*
  FROM loc 
    JOIN
    tem
 ON
    loc.hospital_visit_id =
    tem.hospital_visit_id
  WHERE 
 loc.location_split ~ '^(T03|WSCC|SINQ|MINQ|P03CV|T07CV)';
