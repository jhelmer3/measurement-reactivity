
library(autometric)
library(targets)
library(tarchetypes)
library(crew)

# packages: rstan, tidybayes, mdmb, ggdag

tar_option_set(
  packages = c("tidyverse", "brms", "patchwork"),
  controller = crew_controller_local(
    workers = 5,
    options_metrics = crew_options_metrics(
      path = "logs/worker/",
      seconds_interval = 1
    )
  ),
  storage = "worker",
  retrieval = "worker",
  format = "qs",
  memory = "transient"
)

tar_config_set(
  as_job = T
)

# tar_option_set(
#   packages = c("tidyverse", "brms", "patchwork"),
#   debug = "sim_data_341798b7487bf001 "#, # Set the target you want to debug.
#   # cue = tar_cue(mode = "never") # Force skip non-debugging outdated targets.
# )

if (tar_active()) log_start(path = "logs/main_process.txt", seconds = 1)

tar_source()

# for future runs, I wonder if it would be better to do more batches
# I know its more targets overhead, but I wonder if, since the final object itself is small,
# if the extra read and write would be better to deal with.
n_reps <- 200

list(
  tar_target(params_tidy_key, init_params_tidy_key()),
  tar_target(param_set, init_params(n_reps)),
  tar_target(params, define_params(param_set)),
  tar_rep(gen_data, generate_data(params),
          reps = n_reps / 40,
          batches = 40),
  tar_target(compiled_brms_models, compile_brms_model(gen_data, params),
             pattern = map(params)),
  tar_target(gen_data_mapped, gen_data,
             pattern = map(gen_data),
             iteration = "list"),
  tar_target(sim_data, gen_data |>
               fit_models(compiled_brms_models),
             # maps over `tar_batch`es
             pattern = map(gen_data)),
  tar_target(axis_limits, identify_axis_limits(sim_data)),
  tar_group_by(sim_data_grouped,
               sim_data |> 
                 dplyr::rename(tidy = models) |>
                 dplyr::mutate(.by = condition_id,
                               rep = row_number()), 
               condition_id),
  tar_target(estimate_plt_files,
             ggsave_and_return_path(
               paste0("outputs/estimate_plt_condition_", sim_data_grouped[1, "condition_id"], ".png"),
               plt_estimates_over_conditions(sim_data_grouped, axis_limits),
               width = 11, height = 6),
             pattern = map(sim_data_grouped),
             iteration = "list",
             format = "file"),
  tar_quarto(name = sim_v_jess,
             path = "reports/sim_v-jess.qmd",
             quiet = F)
)



