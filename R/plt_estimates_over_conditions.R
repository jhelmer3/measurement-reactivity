
plt_estimates_over_conditions <- function(sim_data, axis_limits) {
  method_levels <- init_method_levels()
  
  plt_estimates(sim_data, axis_limits, method_levels)
}

tar_read(sim_data)
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

