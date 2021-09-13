# emap_icnarc

## A note on EMAP

Observational data are input into EPIC at the bedside, and thus availabilty on EMAP is based on the decision of the bedside caregiver to include this information in the patient record.

Some variables have been omitted or are a very minor proportion of the UCLH population. 

**Temperature**
At time of writing, no qualifiers for central and peripheral temperatures in EMAP.

**Brainstem death**
Identification of brainstem death patient was omitted from variables identified, as at time of writing it was deemed to be a relatively rare clinical event in the UCLH critical care patient population.

**Sedation**
Sedation as a category did not exist at time of writing, so patients were identified as 'sedated' if they had non-0 values for infusions of:
- clonidine
- Propofol
- Midazolam
- Dexmedetomidine

Patients were deemed to be paralysed if they had non-0 values for infusions of:
- Atracurium
- Rocuronium
- Vecuronium
