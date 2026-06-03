
identify_axis_limits <- function(sim_data) {
  sim_data |>
    unnest(tidy) |>
    summarize(.by = term,
              max_est = max(estimate),
              min_est = min(estimate))
}


