# char-gender
Repository for "[Causal Effect of Character Gender on Readers' Preferences](https://osf.io/preprints/socarxiv/ef9mj_v1)"

## Repository Structure

### Code
- **code/data_cleaning.ipynb** - Data preprocessing and cleaning pipeline
  - Filters survey responses for participants who passed reading comprehension checks
  - Removes incomplete surveys and pilot data
  - Excludes participants who identified as non-binary (for this specific analysis)
  - Creates treatment variables (which story had a woman/man protagonist)
  - Removes sensitive information (Prolific IDs)
  - Outputs the cleaned public dataset

- **code/analysis.ipynb** - Statistical analysis and visualization
  - Estimates conditional average treatment effects (CATE) of protagonist gender on reader preferences
  - Performs bootstrap calculations for confidence intervals
  - Creates visualizations (probability plots, effect plots)
  - Analyzes demographic distributions (political views, income levels)

### Data
- **data/public_data.csv** - Cleaned dataset with 2,983 survey responses containing:
  - Reader preferences (which story they chose to continue reading)
  - Treatment assignments (protagonist gender for each story)
  - Demographic information (age, gender, income, political views, location)
  - Reading comprehension check responses
  - Open-ended explanations for story choices

### Figures
- **figures/pihats.png** - Probability plots showing reader preferences by protagonist gender
  - Visualizes the probability of choosing each story by treatment condition
  - Displays results across different demographic subgroups

- **figures/cate.png** - Conditional average treatment effect (CATE) estimates
  - Shows the estimated causal effect of protagonist gender on reader preferences
  - Includes confidence intervals from bootstrap analysis
  - Breaks down effects by reader demographics

