
plt_estimates_over_conditions <- function(sim_data) {
  sim_data |>
    map(plt_estimates)
}

# tar_read(sim_data) |>
#   map(plt_estimates)
