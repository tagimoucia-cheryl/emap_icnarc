-- values for pH, Fio2, pO2 and Sao2 (to differentiate between venous and arterial gas values further down pipeline)

WITH loc AS 
(SELECT
  SPLIT_PART(loc.location_string,'^',1) as location_split,
  loc.location_string,
  loc.location_id,
lv.hospital_visit_id,
  lv.discharge_time
FROM 
  star.location loc
  JOIN
  star.location_visit lv
  ON 
  loc.location_id = lv.location_id
  ),
  ABG AS
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
  ltd.lab_test_definition_id IN 
  ('141462256' -- po2
  ,'141462295' --FIO2
  ,'141462250' -- pH
  ,'141462286' --sO2
  ))
  SELECT
loc.*,
  ABG.*
  FROM
  loc
  LEFT JOIN ABG
  ON loc.hospital_visit_id = ABG.hospital_visit_id
  WHERE
  loc.location_split ~ '^(T03|WSCC|SINQ|MINQ|P03CV|T07CV)'
  
  
  
  
  -- update 16/9/21; all ABG in hospital 
  
  SELECT
  ls.lab_sample_id,
  ls.sample_collection_time,
  lo.lab_order_id,
  lo.hospital_visit_id,
  lr.lab_test_definition_id,
  lr.value_as_real,
  ltd.test_lab_code
FROM 
  star.lab_sample ls
  JOIN
  star.lab_order lo
  ON
  ls.lab_sample_id = lo.lab_sample_id
  JOIN
  star.lab_result lr
  ON
  lo.lab_order_id = lr.lab_order_id
  JOIN
  star.lab_test_definition ltd
  ON
  lr.lab_test_definition_id = ltd.lab_test_definition_id
WHERE
  lr.lab_test_definition_id IN 
  ('142645490' -- pH
  ,'142645535' --FIO2
  ,'142645496' -- pO2
  ,'142645526' -- sO2
  );
