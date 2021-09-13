WITH loc AS 
(SELECT
  SPLIT_PART(loc.location_string,'^',1) as location_split,
  loc.location_string,
  loc.location_id,
lv.hospital_visit_id,
  lv.admission_time,
  lv.discharge_time,
(lv.admission_time
  + INTERVAL '1 DAY') as adm_24
FROM 
  star.location loc
  JOIN
  star.location_visit lv
  ON 
  loc.location_id = lv.location_id
  ),
  all_obs AS
(select
  -- observation details
   ob.visit_observation_id
  ,ob.hospital_visit_id
  ,ob.observation_datetime
  ,ob.unit 
  ,ob.value_as_real
  ,ob.value_as_text
  ,ob.visit_observation_type_id
  ,ot.id_in_application
from
  star.visit_observation ob
-- observation look-up
left join
  star.visit_observation_type ot
  on ob.visit_observation_type_id = ot.visit_observation_type_id
where
ot.id_in_application in 
  (
  '10' --'SpO2' -- 602063230
  ,'5' --'BP'   --  602063234
  ,'3040109304' --'Room Air or Oxygen' -- 602063268
  ,'6' --'Temp' -- 602063248
  ,'8' --'Pulse' -- 602063237
  ,'9' --'Resp'   -- 602063257
))
SELECT
loc.*,
  all_obs.*
  FROM
  loc
  LEFT JOIN all_obs
  ON loc.hospital_visit_id = all_obs.hospital_visit_id
  WHERE
  loc.location_split ~ '^(T03|WSCC|SINQ|MINQ|P03CV|T07CV)'
AND
  (all_obs.observation_datetime BETWEEN
  loc.admission_time AND
  loc.adm_24);

