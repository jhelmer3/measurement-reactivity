patch_estimate_plts <- function(estimate_plts) {
  estimate_plts |> 
    imap(\(plt, idx) 
         if (idx %% 2 == 0) list(patchwork::plot_spacer() + theme_void(), plt) 
         else plt) |> 
    list_flatten() |>
    cowplot::plot_grid(plotlist = _, 
                       nrow = (length(estimate_plts) / 2) |>
                         ceiling(),
                       rel_widths = seq(1, length(estimate_plts)) |> 
                         map(\(i) 
                             if (i %% 2 == 0) c(.05, 1) 
                             else 1) |> 
                         list_c())
}

#tar_read(estimate_plts) 
