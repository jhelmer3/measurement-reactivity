
plt_estimates <- function(data) {
  
  plt_title <- glue::glue("N: {data |> pluck('params', 1, 'N')}")
  
  data |>
    unnest(tidy) |>
    ggplot(aes(x = type, y = estimate, color = type, fill = type)) +
    geom_hline(aes(yintercept = true_value)) +
    geom_violin(color = NA, alpha = .6) +
    geom_jitter(height = 0, alpha = .4, shape = 16) +
    facet_wrap(~ term, scales = "free_y") +
    guides(y = guide_axis("Estimate", cap = T),
           color = guide_none(),
           fill = guide_none()) +
    scale_x_discrete("Model",
                     breaks = c("lm_true", "lm_pretest", "lm_between"),
                     labels = c("lm_true" = "true",
                                "lm_pretest" = "pretest",
                                "lm_between" = "between")) +
    labs(title = plt_title) +
    theme_classic(base_size = 12) +
    theme(strip.background = element_blank(),
          strip.text = element_text(face = "bold"),
          plot.title = element_text(hjust = 0.5))
}

# tar_read(sim_data) |>
#   pluck(1) |>
#   plt_estimates()
