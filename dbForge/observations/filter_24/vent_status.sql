-- extracting ventilation status for all ITU patients in FIRST 24 HOURS OF ADMISSION


WITH loc AS 
(SELECT
  SPLIT_PART(loc.location_string,'^',1) as location_split,
  loc.location_string,
  loc.location_id,
lv.hospital_visit_id,
  lv.admission_time,
  (lv.admission_time
  + INTERVAL '1 DAY') as adm_24,
  lv.discharge_time,
  hv.mrn_id
FROM 
  star.location loc
  JOIN
  star.location_visit lv
  ON 
  loc.location_id = lv.location_id
  JOIN
  star.hospital_visit hv
  ON
  lv.hospital_visit_id =
  hv.hospital_visit_id)
,
  vent AS
  (SELECT
  vo.visit_observation_id,
  vo.observation_datetime,
  vo.value_as_text,
   vo.value_as_real,
  vo.hospital_visit_id,
  vo.visit_observation_type_id,
   vot.id_in_application
  FROM
  star.visit_observation vo
   JOIN
   star.visit_observation_type vot
   ON
   vo.visit_observation_type_id =
   vot.visit_observation_type_id
  WHERE
  visit_observation_type_id IN
 ('9',
 '315170')
)
SELECT
  loc.*,
  vent.*
  FROM
  loc 
  JOIN
  vent
ON
    loc.hospital_visit_id =
  vent.hospital_visit_id
WHERE
loc.location_split ~ '^(T03|WSCC|SINQ|MINQ|P03CV|T07CV)'
AND
vent.observation_datetime <
loc.adm_24;


