
library(targets)
library(tarchetypes)
library(crew)
library(crew.cluster)

tar_option_set(
  packages = c("tidyverse", "brms", "patchwork"),
  controller = crew_controller_local(workers = 4),
  format = "qs"
)

tar_source()

dir.create("outputs", showWarnings = FALSE, recursive = TRUE)

n_reps <- 200

list(
  tar_target(params_tidy_key, init_params_tidy_key()),
  tar_target(param_set, init_params(n_reps)),
  tar_target(params, define_params(param_set)),
  tar_rep(gen_data, params |>
            generate_data(),
          reps = n_reps / 4,
          batches = 4),
  tar_target(compiled_brms_models, compile_brms_model(gen_data)),
  tar_target(sim_data, gen_data |>
               fit_models(compiled_brms_models) |>
               tidy_models(),
             pattern = map(gen_data)),
  tar_target(axis_limits, identify_axis_limits(sim_data)),
  tar_group_by(sim_data_grouped,
               sim_data |> 
                 dplyr::mutate(.by = condition_id,
                               rep = row_number()), 
               condition_id),
  tar_target(estimate_plt_files,
             ggsave_and_return_path(
               paste0("outputs/estimate_plt_", targets::tar_name(), ".png"),
               plt_estimates_over_conditions(sim_data_grouped, axis_limits),
               width = 11, height = 6),
             pattern = map(sim_data_grouped),
             iteration = "list",
             format = "file"),
  tar_quarto(name = sim_v_jess,
             path = "reports/sim_v-jess.qmd",
             quiet = F)
)



