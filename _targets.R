
library(targets)
library(tarchetypes)
library(crew)
library(crew.cluster)

tar_option_set(
  packages = c("tidyverse", "patchwork"),
  controller = crew_controller_local(workers = 4),
  format = "qs"
)

tar_source()

dir.create("outputs", showWarnings = FALSE, recursive = TRUE)

n_reps <- 20

list(
  tar_target(params_tidy_key, init_params_tidy_key()),
  tar_target(param_set, init_params(n_reps)),
  tar_target(params, define_params(param_set)),
  tar_rep(sim_data, params |>
            generate_data() |>
            fit_models() |>
            tidy_models(),
          reps = n_reps / 4,
          batches = 4),
  tar_target(axis_limits, identify_axis_limits(sim_data)),
  tar_group_by(sim_data_grouped,
               sim_data |> 
                 dplyr::mutate(.by = condition_id,
                               rep = row_number()), 
               condition_id),
  tar_target(estimate_plts, 
             plt_estimates_over_conditions(sim_data_grouped, axis_limits),
             pattern = map(sim_data_grouped),
             iteration = "list"),
  tar_target(estimate_plt_files,
             paste0("outputs/estimate_plt_", 
                    targets::tar_name(), ".png") |>
               ggsave_and_return_path(estimate_plts, width = 10, height = 6),
             pattern = map(estimate_plts),
             iteration = "list",
             format = "file"),
  tar_quarto(name = sim_v_jess,
             path = "reports/sim_v-jess.qmd",
             quiet = F)
)



