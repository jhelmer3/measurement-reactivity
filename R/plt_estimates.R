
plt_estimates <- function(data, axis_limits, method_levels) {
  
  plt_title <- glue::glue("N: {data |> pluck('params', 1, 'N')}")
  
  tidy <- data |>
    unnest(tidy) |>
    mutate(method = factor(method, method_levels$method))
  
  true_values <- crossing(method = method_levels$method,
                          tidy |>
                            select(term) |>
                            unique()) |>
    inner_join(tidy |>
                 select(term, true_value) |> unique(),
               by = "term") 
  
  tidy |>
    group_split(term) |>
    map(\(data) {
      term_name <- first(data$term)
      term_true <- true_values |> 
        filter(term == term_name)
      term_limits <- axis_limits |>
        filter(term == term_name) |>
        select(min_est, max_est) |>
        reduce(c)
      
      data |>
          ggplot(aes(x = method, y = estimate, color = method, fill = method)) +
          geom_line(data = term_true,
                    aes(y = true_value, x = method, group = term),
                    color = "black") +
          geom_violin(color = NA, alpha = .6) +
          geom_jitter(height = 0, alpha = .3, shape = 16) +
          guides(y = guide_axis(NULL, cap = T),
                 x = guide_axis(cap = T),
                 color = guide_none(),
                 fill = guide_none()) +
          scale_x_discrete(NULL,
                           breaks = method_levels$method,
                           labels = method_levels$label) +
          scale_color_manual(values = method_levels |>
                               select(method, color) |>
                               deframe(),
                             aesthetics = c("color", "fill")) +
          coord_cartesian(ylim = term_limits,
                          clip = "off") +
          labs(title = term_name) +
          theme_classic(base_size = 12) +
          theme(strip.background = element_blank(),
                strip.text = element_text(face = "bold"),
                plot.title = element_text(size = 10, hjust = 0.5))
      }) |>
    wrap_plots() +
    plot_annotation(title = plt_title,
                    theme = theme(plot.title = element_text(hjust = 0.5)))
}

# tar_read(sim_data) |>
#   plt_estimates_over_conditions()

