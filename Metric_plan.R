
Metric plan - monthly metrics

# outpatient metrics
#No changes just present as is
E.M.8, #consultant led first outpatients
E.M.9, # consultant led follow up outpatients
E.M.32, # total outpatient attendances
E.M.40, # NEW - total outpatient procedures ERF scope
E.M.41, # NEW - total firsts without procedure ERF scope
E.M.38 # total follow ups without procedure ERF scope
E.M.34 # number of pathways moved or discharged to PIFU

#Calculated elements
pifu util rate = EM34/EM32

Ratio of red to green outpatients
EM38 as a ratio of (EM40+EM41+EM38)

# elective metrics
# No changes present as is
E.M.10 # Elective Spells (sum of a and b)
E.M.10a # Elective Spells - total day cases
E.M.10b # Elective Spells - total ordinary spells
E.M.10c # Elective Spells - day cases U18s
E.M.10d # Elective Spells - ordinary spells U18s
E.M.18 # RTT completed admitted pathways
E.M.19 # RTT completed non-admitted pathways
E.M.20 # Clock starts
E.B.3a # Total PTL
E.B.18 # 52+ww
E.B.24 # 52+ww U18
E.B.20 # 65ww

#calculated elements

EB24 as a percentage of EB18

# NEL metrics
# No change present as is
E.M.11 # Total NEL
E.M.11a # Total NEL 0 LOS 
E.M.11b # Total NEL >=1 LOS
E.M.25 # avg no. patients with LOS >=21

# Require calculation to present as set in planning guidance
E.M.29 |> numerator/denominator # % occupied by NCTR 

# UEC metrics
# No change present as is
E.M.15 # total attendances at type 5 SDEC services
E.M.26c # Avg number of G&A beds open 
  
# Require calculation to present as set in planning guidance
E.M.13a |> numerator/denominator # % of attendances less than 4 hours in type 1 A&E
E.M.13b |> numerator/denominator # % of attendances less than 4 hours in other A&E
E.M.13 |> numerator/denominator # % of attendances less than 4 hours in all type A&E

E.B.23c needs converting to time in minutes # Average cat 2 response time

E.M.30 |> (EM30a+EM30b)/(EM30g+EM30i+EM30h+EM30j) # % of occupied G&A overnight beds
E.M.30a |> EM30a/(EM30g+EM30h) # % of occupied adult G&A overnight beds
E.M.30b |> EM30b/(EM30i+EM30j)# % of occupied paeds G&A overnight beds

E.M.26b |> numerator/denominator # Average percentage of occupied AC beds

# Diagnostic metrics
E.B.26a # counts of tests for Magnetic resonance imaging
E.B.26b # counts of tests for Computed tomography
E.B.26c # counts of tests for Non-obstetric ultrasound
E.B.26d # counts of tests for Colonoscopy
E.B.26e # counts of tests for Flexi sigmoidoscopy
E.B.26f # counts of tests for Gastroscopy
E.B.26g # counts of tests for Cardiology – echocardiography
E.B.26h # counts of tests for DEXA
E.B.26k # counts of tests for Audiology

# Require calculation to present as set in planning guidance
E.B.28a |> numerator/denominator # % 6 week waits Magnetic resonance imaging
E.B.28b |> numerator/denominator # % 6 week waits Computed tomography
E.B.28c |> numerator/denominator # % 6 week waits Non-obstetric ultrasound
E.B.28d |> numerator/denominator # % 6 week waits Colonoscopy
E.B.28e |> numerator/denominator # % 6 week waits Flexi sigmoidoscopy
E.B.28f |> numerator/denominator # % 6 week waits Gastroscopy
E.B.28g |> numerator/denominator # % 6 week waits Cardiology – echocardiography
E.B.28h |> numerator/denominator # % 6 week waits DEXA
E.B.28k |> numerator/denominator # % 6 week waits Audiology


# Cancer metrics
# Require calculation to present as set in planning guidance
E.B.27 |> numerator/denominator # % 28 day waits
E.B.35 |> numerator/denominator # % First treatment standard
E.B.34 |> numerator/denominator # % lower GI suspected cancer referrals with a FIT result

# no change present as is
E.B.33 # number of people referred to symptom specific pathway

# Primary care
# no change present as is
E.D.19 # appointments in general practice

# is already available as a percentage so no transformation needed 
E.D.21 # percent GP appts seen in 2 weeks

#Community
# ####### not available in historic data or previous year plan #######
E.T.6 # TBC not available currently

# no change present as is
#### note this metric has been changed in this year's plans

E.T.3 #Hospital discharge pathway activity
E.T.3a #Hospital discharge pathway activity - pathway 0
E.T.3b #Hospital discharge pathway activity - pathway 1
E.T.3c #Hospital discharge pathway activity - pathway 2
E.T.3d #Hospital discharge pathway activity - pathway 3

# is already available as a percentage so no transformation needed 
E.T.5 # % virtual ward occupancy

#Mental Health
# no change present as is
E.A.5 # Active inappropriate adult acute out of area placements
E.H.9 # Number of 0-17 year olds receiving MH support and who receiving at least 1 contact
E.H.31 # Number of adults and OA receiving at least 2 contacts from community or transformed MH services
E.H.15 # Number of women who received 1+ contact with specialist community PMH and MMHS services in the previous 12 months
E.H.13 # % People with SMI receiving full annual physical health check

# is already available as a percentage so no transformation needed 
E.A.4a # Reliable recovery rates for those completing a course of treatment & meeting caseness
E.A.4b # Reliable recovery rates for those completing a course of treatment
E.H.13 # % People with SMI receiving full annual physical health check

# is available as a rate so no transformation needed
E.A.S.1 # Estimated diagnosis rate for people with dementia


