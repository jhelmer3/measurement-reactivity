
init_params <- function(n_reps) {
  return(
    list(
      rep = n_reps,
      N = c(50, 200),
      K = 3,
      r2_aux = .33,
      p_pretest = .4,
      p_treatment = .5,
      beta0 = 0,
      beta1 = .3, 
      beta2 = .2,
      beta3 = 1,
      # beta4 defined as a function of beta1 in define_params()
      beta5 = -.1,
      beta6 = 0,
      beta7 = 0,
      sigma = 1
    )
  )
}

