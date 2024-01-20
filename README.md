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
          git clone https://github.com/EMitkus/KTU-DVDA-PROJECT.git
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

Our analysis found that the Stacked Ensamble model achieved the best performance with an AUC of 0.83 on the training dataset.
