# HIAS_Study
Understanding linkages between self-reliance and mental health among forcibly displaced women in Colombia

⸻

Problem Statement / Background

Despite global efforts to promote self-reliance among displaced populations, the mental health implications of household-level self-reliance are not well understood, particularly for women in Latin America. This study investigates how economic self-reliance relates to depressive symptoms and resilience among forcibly displaced women in Colombia.

⸻

Methods Used
	•	Design: Cross-sectional analysis using baseline data from a pilot RCT of the HIAS Entrepreneurship School with a Gender Lens.
	•	Participants: 348 forcibly displaced Colombian and Venezuelan women.
	•	Measures:
	•	Self-Reliance Index (SRI)
	•	Patient Health Questionnaire-9 (PHQ-9) for depression
	•	Brief Resilient Coping Scale (BRCS) for resilience
	•	Analysis: Multivariate linear regression with robust standard errors using Stata 16.

⸻

Key Findings
	•	Self-reliance was significantly associated with lower depressive symptoms, especially in domains related to food security, financial resources, and debt.
	•	Resilience was not significantly associated with overall self-reliance.
	•	Feeling controlled by others was a strong predictor of increased depressive symptoms, while community support was associated with higher resilience.

_____

How to Run the Code (Stata)
	1.	Software Required
	•	Stata 16 or higher (recommended due to robust standard error handling and compatibility with newer syntax)
 
	2.	Data Preparation
	•	Ensure that the baseline dataset used in the study (e.g., baseline_data.dta) is placed in the same working directory as the .do file.
	•	If data is deidentified and available, place it in the /data folder or update the use path in the .do file accordingly.
 
	3.	Running the Script
	•	Open Stata.
	•	Set your working directory where the .do file is saved using: cd "path_to_your_project_directory"
 
 	Run the script:do "HIAS - Baseline data.do"
  
  	4.	Expected Output
	•	The code will produce descriptive statistics, regression models for PHQ-9 and BRCS scores, and robustness checks using robust standard errors.
	•	Key results are printed to the Stata Results window and may be saved to .log or .csv files depending on final lines in the script.
 
	5.	Dependencies
	•	Ensure any user-written commands (e.g., esttab, outreg2, coefplot) are installed using:ssc install [command_name]
 
 
