
-- exporting Na, Crea, Urea with lab and ABG codes. DEcided to also export 141462286 which is Blood Gas s02 for patients where VGBs also done and will affect po2 values
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
  yellow_labs AS
(select
  -- laboratory details
  ltd.lab_test_definition_id,
  ltd.lab_department,
  ltd.test_lab_code,
  lr.lab_result_id,
  lr.result_last_modified_time,
  lr.units,
  lr.value_as_real,
  lr.lab_order_id,
  lr.lab_test_definition_id,
  lo.lab_order_id,
  lo.request_datetime,
  lo.hospital_visit_id,
  lo.lab_sample_id,
  lv.location_visit_id,
  lv.admission_time,
  lv.discharge_time,
  lv.location_id,
  hv.mrn_id
  FROM
  star.lab_test_definition ltd
  JOIN
  star.lab_result lr
  ON
  ltd.lab_test_definition_id = lr.lab_test_definition_id
  JOIN
  star.lab_order lo
  ON
  lr.lab_order_id = lo.lab_order_id
  JOIN
  star.location_visit lv
  ON
  lo.hospital_visit_id = lv.hospital_visit_id
  JOIN
  star.hospital_visit hv
  ON
  lv.hospital_visit_id = hv.hospital_visit_id
WHERE
  ltd.lab_test_definition_id IN (79, 141462262, 85, 141464420, 88, 141464423, 141462286)
  )
SELECT
loc.*,
  yellow_labs.*
  FROM
  loc
  LEFT JOIN yellow_labs
  ON loc.hospital_visit_id = yellow_labs.hospital_visit_id
  WHERE
  loc.location_split ~ '^(T03|WSCC|SINQ|MINQ|P03CV|T07CV)'
;
