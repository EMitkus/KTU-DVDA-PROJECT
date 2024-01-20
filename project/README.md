# App screenshots:
![Predictions table](https://github.com/EMitkus/KTU-DVDA-PROJECT/assets/154337829/5f8cb5b9-6135-434b-9baf-eef1ee85f381)
![Chart](https://github.com/EMitkus/KTU-DVDA-PROJECT/assets/154337829/84e6ff0d-835c-429b-8d71-39524f6c7760)
![Predictions table](https://github.com/EMitkus/KTU-DVDA-PROJECT/assets/154337829/f9826376-5637-4c47-83fe-51155c6f3a1c)
![Help](https://github.com/EMitkus/KTU-DVDA-PROJECT/assets/154337829/30ff2fba-3624-4af1-ac04-9be6d1fc16ae)

# Project Title

Bank Loan Approval Predictor

# Motivation

This project aims to assist banks in making loan approval decisions based on customer information.

# Dependencies

To run this project, you'll need the following dependencies:

-   R kernel
-   R packages:

```         

    install.packages("h2o")
    install.packages("shiny")
    install.packages("shinybusy")
    install.packages("tidyverse")
    install.packages("knitr")
    install.packages("tibble")
    install.packages("ggplot2")
    install.packages("scales")
    install.packages("DT")
    install.packages("dplyr")
    install.packages("plotly")

```

# Directory structure

The project directory is structured as follows:
```         
    ├───1-data
    ├───2-report
    ├───3-R
    ├───4-model
    ├───5-predictions
    └───app
```


## How to Execute Code

To run the code, follow these steps:

```         
        1. Clone the GitHub repository:
          git clone https://github.com/kestutisd/KTU-DVDA-PROJECT.git
        2. Download data from:
          https://drive.google.com/drive/folders/17NsP84MecXHyctM94NLwps_tsowld_y8
        3. Navigate to the directory with data preparation scripts:
          cd KTU-DVDA-PROJECT/project/3-R
        4. Execute the data preparation script to transform the data:
          RScript data_transformation.R
```
## Data Analysis

A quick analysis of the sample data can be found in KTU-DVDA-PROJECT/project/2-report/report.md

## Results

Our analysis found that the Stacked Ensamble model achieved the best performance with an AUC of 0.83 on the training dataset. The Stacked Ensemble in our case was composed of two base models (1/2):
- 1 base model was a GBM (Gradient Boosting Machine).
- 1 base model was a GLM (Generalized Linear Model).
These base models were combined using a stacking strategy, and a GLM was used as the metalearner to create the final Stacked Ensemble model.