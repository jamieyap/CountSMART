path.code <- Sys.getenv("path.code")
path.output_data <- Sys.getenv("path.output_data")
this.folder <- "exchangeable"
source(file.path(path.code, "datagen-utils.R"))

###############################################################################
# Calculate value of dispersion parameter for base case
###############################################################################

dat.mu <- read.csv(file.path(path.output_data, this.folder, "base_case/input_means.csv"))
dat.tau <- read.csv(file.path(path.output_data, this.folder, "base_case/input_prop_zeros.csv"))

dat.disp <- dat.mu
dat.disp[,2:7] <- NA

for(this.row in 1:6){
  for(this.column in 2:7){
    use.mu <- dat.mu[this.row, this.column]
    use.prop.zeros <- dat.tau[this.row, this.column]
    val <- SolveForSigmaSquared(input.mu = use.mu, input.prop.zeros = use.prop.zeros)
    dat.disp[this.row, this.column] <- val
  }
}

write.csv(dat.disp, file.path(path.output_data, this.folder, "base_case/dispersion_parameter.csv"))

###############################################################################
# Calculate value of dispersion parameter for cases within sim_vary_effect
###############################################################################

list.dat <- list()

for(idx.scenario in 1:10){
  dat.mu <- read.csv(file.path(path.output_data, this.folder, "sim_vary_effect", paste("sim_results", idx.scenario, sep="_"), "input_means.csv"))
  dat.tau <- read.csv(file.path(path.output_data, this.folder, "sim_vary_effect", paste("sim_results", idx.scenario, sep="_"), "input_prop_zeros.csv"))
  
  dat.disp <- dat.mu
  dat.disp[,2:7] <- NA
  
  for(this.row in 1:6){
    for(this.column in 2:7){
      use.mu <- dat.mu[this.row, this.column]
      use.prop.zeros <- dat.tau[this.row, this.column]
      val <- SolveForSigmaSquared(input.mu = use.mu, input.prop.zeros = use.prop.zeros)
      dat.disp[this.row, this.column] <- val
    }
  }
  
  list.dat <- append(list.dat, list(dat.disp))
  write.csv(dat.disp, file.path(path.output_data, this.folder, "sim_vary_effect", paste("sim_results", idx.scenario, sep="_"), "dispersion_parameter.csv"))
}

list.pct <- list()

for(i in 2:10){
  dat.pct <- (list.dat[[i]][,2:7] - list.dat[[1]][,2:7])/list.dat[[1]][,2:7]
  list.pct <- append(list.pct, list(dat.pct))
}

print(list.pct)


