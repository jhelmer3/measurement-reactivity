
# Load packages required to define the pipeline:
library(targets)
library(tarchetypes)

# Set target options:
tar_option_set(
  packages = c("tibble", "tidyverse", "patchwork", "mirai") 
)

tar_source()

list(
  tar_target(params_tidy_key, init_params_tidy_key()),
  tar_target(param_set, init_params(n_reps = 200)),
  tar_target(params, define_params(param_set)),
  tar_target(sim_data, simulate_over_conditions(params)),
  tar_target(estimate_plts, plt_estimates_over_conditions(sim_data),
             format = "qs"),
  tar_target(estimate_plts_patch, patch_estimate_plts(estimate_plts),
             format = "qs"),
  tar_quarto(name = sim_v_jess,
             path = "reports/sim_v-jess.qmd",
             quiet = F)
)



