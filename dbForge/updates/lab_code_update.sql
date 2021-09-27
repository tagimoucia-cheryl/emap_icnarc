-- Following codes can be used to check and update 'id' for laboratory values 

-- finding ABG parameters
-- as of 16/9/2021; no lab department is specified for ABG values in star.lab_test_defintion 
-- finding pH

SELECT
  ltd.lab_department,
  ltd.test_lab_code, 
  ltd.lab_test_definition_id
  FROM
  star.lab_test_definition ltd
  WHERE 
  ltd.test_lab_code LIKE '%pH%'; -- checked 16/9/21 == 142645490, pH(T) 142647111
  
  -- finding pao2 
  SELECT
  ltd.lab_department,
  ltd.test_lab_code, 
  ltd.lab_test_definition_id
  FROM
  star.lab_test_definition ltd
  WHERE 
  ltd.test_lab_code LIKE '%O2%'; --checked 16/9/21. Values identified where no lab department specified AND starts with same 4 digits as pH
  -- po2 142645496 (po2(T) 142647120)
  -- fio2 142645535
  
