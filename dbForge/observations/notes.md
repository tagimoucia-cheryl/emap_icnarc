## Notes on Observations

### Notes on observations

#### Temperature
Provided in both Fahrenheit and Celsius in star schema. 

### Correlations between variables

#### RR and vent status

Each _event_ of taking a RR observation (answer in: 'visit_observation.value_as_real') and a ventilator status (answer in: 'visit_observation.value_as_text') is not recorded with the same visit_observation_id (as shown in [appendix](https://github.com/tagimoucia-cheryl/emap_icnarc/blob/main/dbForge/observations/appendix.sql))

To correlate these observations, they have the same 'visit_observation.observation.datetime'
