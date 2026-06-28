# employee-eda-r
Statistical EDA pipeline in R — salary, performance &amp; HR data analysis
Employee HR Data — Statistical EDA in R
A complete Exploratory Data Analysis (EDA) pipeline built in R, analyzing synthetic employee HR data across 200 records and 5 departments. This project demonstrates end-to-end data analysis skills — from data generation and cleaning through to visualization and hypothesis testing.
---
Tools & Libraries
Tool	Purpose
R	Core programming language
ggplot2	Data visualization
dplyr	Data manipulation & summarisation
tidyr	Data reshaping (wide ↔ long)
corrplot	Correlation matrix heatmap
scales	Number formatting (commas, currency)
---
Project Structure
```
employee-eda-r/
├── analysis.R          # Main R script (full pipeline)
├── README.md           # Project documentation
└── plots/
    ├── 01\\\_correlation\\\_matrix.png
    ├── 02\\\_salary\\\_distribution.png
    ├── 03\\\_salary\\\_by\\\_department.png
    ├── 04\\\_salary\\\_vs\\\_experience.png
    ├── 05\\\_performance\\\_by\\\_gender.png
    ├── 06\\\_employee\\\_count.png
    └── 07\\\_satisfaction\\\_vs\\\_performance.png
```
---
Dataset
The dataset is synthetically generated using R's random number functions, simulating a realistic HR employee dataset with the following features:
Variable	Type	Description
`employee\\\_id`	Integer	Unique identifier
`department`	Categorical	Engineering, Marketing, Sales, HR, Finance
`age`	Numeric	Employee age (22–65)
`salary`	Numeric	Annual salary in ZAR (30,000–120,000)
`experience\\\_yrs`	Numeric	Years of experience (1–20)
`performance`	Numeric	Performance score (40–100)
`satisfaction`	Numeric	Job satisfaction rating (1–10)
`gender`	Categorical	Male / Female
> `set.seed(42)` is used to ensure fully reproducible results on every run.
---
Analysis Overview
1. Descriptive Statistics
Summary table of mean, median, standard deviation, min, and max for all numeric variables.
2. Correlation Analysis
Pearson correlation matrix across all numeric variables, visualized as a color-coded heatmap.
3. Visualizations
Salary Distribution — Histogram with density curve and mean marker
Salary by Department — Boxplot with jittered data points
Salary vs Experience — Scatter plot with linear regression line and 95% CI
Performance by Gender — Density plot with mean indicators
Employee Count by Department — Horizontal bar chart
Satisfaction vs Performance — Scatter plot with overall trend line
4. Hypothesis Testing
Test	Variables	Purpose
Independent t-test	Salary × Gender	Test for significant salary differences between genders
Pearson Correlation Test	Experience × Salary	Test significance of experience–salary relationship
One-Way ANOVA	Performance × Department	Test for performance differences across departments
---
How to Run
Make sure R is installed — Download R
Optionally install RStudio — Download RStudio
Clone this repository:
```bash
   git clone  https://github.com/Mbali242/employee-eda-r.git
   ```
Open `analysis.R` in RStudio
Run the script — required packages install automatically if missing
Plots are saved to the `/plots` folder and displayed in the RStudio Plots pane
---
Key Insights
Salary distributions approximate a normal curve with some right skew
Experience has a weak-to-moderate positive correlation with salary
Performance scores are broadly consistent across genders and departments
Job satisfaction shows a slight positive trend with performance
---
Author
Mbali Fezeka Dlamini
Computer Science Student  
 
linkedin |  GitHub
---
