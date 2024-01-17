#install.packages("tidyverse")
library(tidyverse)

data <- read_csv("../../project/1-data/1-sample_data.csv")
additional_data <- read_csv("../../project/1-data/2-additional_data.csv")
additional_features <- read_csv("../../project/1-data/3-additional_features.csv")

combined_data <- rbind(data, additional_data)
joined_data <- inner_join(combined_data, additional_features, by = "id")

write_csv(joined_data, "../../project/1-data/train_data.csv")

joined_data_mini <- joined_data[1:100, ]
joined_data_midi <- joined_data[1:1000, ]
write_csv(joined_data_mini, "../../project/1-data/joined_data_mini.csv")
write_csv(joined_data_midi, "../../project/1-data/joined_data_midi.csv")