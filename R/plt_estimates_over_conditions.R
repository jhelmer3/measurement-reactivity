
plt_estimates_over_conditions <- function(sim_data) {
  axis_limits <- sim_data |>
    map(\(data) data |>
          unnest(tidy)) |>
    list_rbind() |> 
    summarize(.by = term,
              max_est = max(estimate),
              min_est = min(estimate))
  
  method_levels <- init_method_levels()
  
  sim_data |>
    map(\(sim_data) plt_estimates(sim_data, axis_limits, method_levels))
}
# 
# tar_read(sim_data) |>
#   plt_estimates_over_conditions()
# 
# 
# 
# 
# method_levels |>
#   ggplot(aes(x = method, y = label, label = label, color = method)) +
#   geom_text() +
#   scale_color_manual(values = method_levels |>
#                        select(method, color) |>
#                        deframe())

