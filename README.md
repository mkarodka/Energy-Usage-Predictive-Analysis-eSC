# Data Science Project

# Predictive Analysis of Energy Usage for eSC

## Overview
This project focuses on analyzing energy usage patterns for Energy Smart Communities (eSC), aiming to understand energy consumption drivers and promote energy-saving behaviors among customers. The analysis addresses concerns about global warming, prevents blackouts from excessive electrical grid demand, and aligns with environmental sustainability objectives.

## Business Objectives
- Predict energy usage based on weather data, building characteristics, and historical consumption
- Identify key factors influencing energy usage and their relative importance
- Provide actionable insights for energy management and resource planning

## Data Sources
The analysis utilizes data from AWS S3 buckets:
- House Data: `static_house_info.parquet`
- Energy Data: `2023-houseData/102063.parquet`
- Weather Data: `2023-weatherdata/G4500010.csv`
- Data Dictionary: `data_dictionary.csv`

## Methodology

### Data Processing
1. **Data Acquisition**
   - Retrieved house information, energy data, and weather data from AWS S3
   - Collected metadata information for all datasets

2. **Data Cleansing & Transformation**
   - Removed rows with missing values
   - Filtered houses in "Hot-Humid" climate zones (1,639 out of 5,710 total)
   - Merged house, energy, and weather data
   - Calculated total energy consumption for cooling purposes

3. **Data Munging**
   - Utilized parallel processing with `parLapply()` and `mclapply()`
   - Conducted exploratory data analysis (EDA)
   - Prepared data for modeling

## Modeling Approach

### Initial Approach: SVM with K-fold Cross-validation
- Explored supervised k-fold cross-validation with SVM
- Attempted different cross-fold configurations with 60% training data
- Discontinued due to computational constraints

### Final Model: Linear Regression
- Implemented linear regression with 60-40 train-test split
- Evaluated using multiple metrics:
  - R-squared
  - Mean Absolute Error (MAE)
  - Mean Squared Error (MSE)
  - Root Mean Squared Error (RMSE)

## Interactive Visualization
- Developed a Shiny app for data visualization and analysis
- Deployed at: [eSC Energy Analysis Dashboard](https://mugdha-karodkar.shinyapps.io/IST687_Final_Project/)

## Key Findings & Recommendations

### Building Improvements
1. **Ceiling Insulation**
   - Upgrade to minimum R-30 rating
   - Focus on top floor insulation

2. **Air Leakage Prevention**
   - Target lower air change rates (1-2 ACH50)
   - Seal gaps and cracks in building envelope

3. **HVAC Optimization**
   - Upgrade to higher SEER rating systems (SEER 13+)
   - Consider heat pump installation

4. **Wall Insulation**
   - Implement appropriate R-value based on construction
   - Options: "Wood Stud, R-15" or "CMU, 6-in Hollow, R-19"

### Appliance Recommendations
1. **Ceiling Fans**
   - Install efficient ceiling fans
   - Optimize usage to reduce AC dependence

2. **Dryers**
   - Recommend heat pump dryers
   - Focus on energy-efficient models

3. **Washers**
   - Recommend Energy Star-rated front load washers
   - Prioritize water and energy efficiency

## Model Validation Results

### Metrics
- Adjusted R-squared: 0.6003 (60% variance explained)
- Residual Standard Error: 0.1037
- Mean Absolute Error: 0.08003056
- Mean Squared Error: 0.0153531
- Root Mean Squared Error: 0.1239076
- P-value: < 2.2e-16 (statistically significant)

## Project Assumptions
- Dataset represents residential properties in South and North Carolina
- Analysis focused on July data for summer cooling
- Considered total energy consumption for cooling purposes
- Targeted buildings in hot-humid climate zones only

## Contact
For questions or suggestions about this project, please create an issue in this repository.



