-- RR and ventilator status
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
