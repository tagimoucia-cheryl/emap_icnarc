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
  visit_observation_id,
  observation_datetime,
  value_as_text,
  hospital_visit_id,
  visit_observation_type_id
  FROM
  star.visit_observation
  WHERE
  visit_observation_type_id IN
 ('57957994',
'198476189')
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

-- checking if single unique visit observation id matches notation of ventilation status and documents RR
-- does not .'. need to use observation_datetime to match RR and vent status

SELECT
  vot.id_in_application,
  vo.value_as_real,
  vo.value_as_text,
  vo.visit_observation_id,
  vo.observation_datetime,
  hv.hospital_visit_id,
  hv.mrn_id
  FROM
  star.visit_observation_type vot
  JOIN
  star.visit_observation vo
  ON
  vot.visit_observation_type =
  vo.visit_observation_type_id
  JOIN
  star.hospital_visit hv
  ON
  vo.hospital_visit_id =
  hv.hospital_visit_id
WHERE
vot.id_in_application IN
('9',
'315170')
AND
hv.hospital_visit_id IN
  ('446');
