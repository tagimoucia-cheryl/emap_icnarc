# emap_icnarc

## Purpose of this repository

The purpose of this repository is to share and store code for extracting data to be used in the [Inform icnarc physiology calculator](https://github.com/inform-health-informatics/ICNARC-calculation).

**Raw data**
- This is extracted from EMAP schema **.star** using **dbForge** via the UCLH Data Science Desktop. 

  - Information on gaining access to this can be found [here](https://github.com/inform-health-informatics/try-emap/commit/985f3eca880d82f9087272b87e2b951055dee3dd)
  - Code used for both the _observational_ and _laboratory_ data are provided here for review
  
- Extracted queries were exported as **.csv** files and stored on the **B:\ transfer** drive on the UCLH Data Science Desktop

**Isolating physiological variables** 
- This was done using [R studio](https://cran.rstudio.com)
- Example codes for isolating and merging variables are provided here for review