library(h2o)
library(tidyverse)
h2o.init(max_mem_size = "4G")

h2o.clusterStatus()

df <- h2o.importFile("../../project/1-data/train_data.csv")
df
class(df)
summary(df)

y <- "y"
x <- setdiff(names(df), c(y, "id"))
df$y <- as.factor(df$y)
summary(df)

splits <- h2o.splitFrame(df, ratios = c(0.8,0.1), seed=123)
train  <- h2o.assign(splits[[1]], "train") # 80%
valid  <- h2o.assign(splits[[2]], "valid") # 10%
test   <- h2o.assign(splits[[3]], "test")  # 10%

h2o.exportFile(test, path = "../../project/1-data/test_data.csv", force = TRUE)

aml = h2o.automl(x = x, y = y, training_frame = train, max_models = 1)
default_plan = aml@modeling_plan

aml <- h2o.automl(x = x,
                  y = y,
                  training_frame = train,
                  validation_frame = valid,
                  stopping_metric = "AUC",
                  stopping_tolerance = 0.01,
                  stopping_rounds = 10,
                  max_runtime_secs = 900)

aml@leaderboard


#Used interchangibly to load the best model (in this case the Stacked Ensamble model)
model <- aml@leader
#model <- h2o.getModel("StackedEnsemble_BestOfFamily_1_AutoML_2_20240116_231755")

h2o.performance(model, train = TRUE)
h2o.performance(model, valid = TRUE)
perf <- h2o.performance(model, newdata = test)

h2o.auc(perf)
plot(perf, type = "roc")

#h2o.performance(model, newdata = test_data)

test_without_y <- h2o.importFile("../../project/1-data/test_data_without_y.csv")
predictions <- h2o.predict(model, test_without_y)
predictions

predictions %>%
  as_tibble() %>%
  mutate(id = row_number(), y = p0) %>%
  select(id, y) %>%
  write_csv("../5-predictions/predictions1.csv")

### ID, Y

h2o.saveModel(model, "../4-model/", filename = "my_best_automlmodel")

#Used to load the model from saved environment
#model <- h2o.loadModel("../4-model/my_best_automlmodel")
h2o.varimp_plot(model)

# Grid search
hyper_params <- list(
  hidden = list(c(20, 20)),
  rate = c(0.01, 0.001),
  input_dropout_ratio = c(0, 0.1, 0.2)
)

grid <- h2o.grid(
  algorithm = "deeplearning",
  grid_id = "dl_grid_extended",
  x = x, 
  y = y,
  training_frame = train,
  validation_frame = valid,
  epochs = 2,
  stopping_metric = "AUC",
  hyper_params = hyper_params,
  search_criteria = list(strategy = "Cartesian")
)

sorted_grid <- h2o.getGrid(grid_id = "dl_grid_extended", sort_by = "auc", decreasing = TRUE)
print(sorted_grid)

best_grid <- h2o.getModel(sorted_grid@model_ids[[1]])
