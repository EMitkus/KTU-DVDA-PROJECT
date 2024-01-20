#install.packages("tidyverse")
library(tidyverse)

data <- read_csv("../../project/1-data/1-sample_data.csv")
additional_data <- read_csv("../../project/1-data/2-additional_data.csv")
additional_features <- read_csv("../../project/1-data/3-additional_features.csv")

combined_data <- rbind(data, additional_data)
joined_data <- inner_join(combined_data, additional_features, by = "id")

write_csv(joined_data, "../../project/1-data/train_data.csv")