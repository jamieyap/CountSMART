library(dplyr)
library(purrr)
library(assertthat)
library(rootSolve)
library(mvtnorm)
library(geeM)
library(parallel)
library(ggplot2)
library(gridExtra)
library(beepr)

path.code <- Sys.getenv("path.code")
path.output_data <- Sys.getenv("path.output_data")

source(file.path(path.code,"input-utils.R"))
source(file.path(path.code,"datagen-utils.R"))
source(file.path(path.code,"analysis-utils.R"))
source(file.path(path.code, "geemMod.r"))
environment(geemMod) <- asNamespace("geeM")

# Note that 
#   - input.M
#   - input.N
#   - input.rand.time, input.tot.time, 
#   - input.cutoff
#   - input.corr.str
#   - min.rho, max.rho
#   - this.folder
#   - this.scenario
# need to be specified prior to running the code below

###############################################################################
# User-specified design parameters
###############################################################################

# Means and proportion of zeros
input.means <- read.csv(file.path(path.output_data, this.folder, this.scenario, "input_means.csv"))  # input file: change to appropriate file
input.prop.zeros  <- read.csv(file.path(path.output_data, this.folder, this.scenario, "input_prop_zeros.csv"))  # input file: change to appropriate file

# Check that input data is in the correct format
CheckInputData(input.df = input.means, rand.time = input.rand.time, tot.time = input.tot.time)
CheckInputData(input.df = input.prop.zeros, rand.time = input.rand.time, tot.time = input.tot.time)

###############################################################################
# Specify L and D matrices for contrasts of interest 
# Below, these are specified for end-of-study means and AUC
###############################################################################
# Difference in end-of-study means
L.eos.means <- t(eCol(input.tot.time,input.tot.time))
D.eos.means <- cbind(L.eos.means,-L.eos.means)

# Difference in AUCs
# This specification assumes that measurement occasions will be 1-month apart
for(i in 1:input.tot.time){
  if(input.tot.time==2){
    L.AUC <- (1/2)*t(eCol(1,input.tot.time)) + (1/2)*t(eCol(input.tot.time,input.tot.time))
  }else if(input.tot.time>2 & i==1){
    L.AUC <- (1/2)*t(eCol(1,input.tot.time))
  }else if(input.tot.time>2 & i==input.tot.time){
    L.AUC <- L.AUC+(1/2)*t(eCol(input.tot.time,input.tot.time))
  }else{
    L.AUC <- L.AUC+t(eCol(i,input.tot.time))
  }
}
D.AUC <- cbind(L.AUC,-L.AUC)

###############################################################################
# Other inputs required in simulation (not specified by user)
###############################################################################
input.n4 <- NA_real_
list.input.rho <- as.list(seq(min.rho, max.rho, 0.05))

###############################################################################
# Calculate correlation
###############################################################################
collect.correlation.tau <- list()
collect.seq.cormat <- list()

for(i in 1:length(list.input.rho)){
  input.rho <- list.input.rho[[i]]
  
  # Combine inputs which may vary from simulation-to-simulation into a grid
  gridx <- expand.grid(nsim=1:input.M, 
                       input.N=input.N,
                       input.rho=input.rho,
                       input.n4=input.n4,
                       input.corr.str=input.corr.str,
                       input.other.corr.params=input.rho/2,
                       stringsAsFactors = FALSE)
  
  list.gridx <- list()
  for(j in 1:nrow(gridx)){
    curr_list <- list(nsim = gridx[j, "nsim"],
                      input.N = gridx[j, "input.N"],
                      input.rho = gridx[j, "input.rho"],
                      input.n4 = gridx[j, "input.n4"],
                      input.corr.str = gridx[j, "input.corr.str"],
                      input.other.corr.params = gridx[j, "input.other.corr.params"])
    
      list.gridx <- append(list.gridx, list(curr_list))
  }
  
  list.gridx <- lapply(list.gridx, function(this.list, 
                                            means=input.means,
                                            prop.zeros=input.prop.zeros){
    this.list$input.means <- input.means
    this.list$input.prop.zeros <- input.prop.zeros
    return(this.list)
  })
  
  ncore <- detectCores()
  cl <- makeCluster(ncore-1)
  clusterSetRNGStream(cl, 102399)
  clusterExport(cl, c("path.code",
                      "list.gridx",
                      "input.tot.time","input.rand.time","input.cutoff"))
  clusterEvalQ(cl,
               {
                 library(dplyr)
                 library(assertthat)
                 library(rootSolve)
                 library(mvtnorm)
                 library(geeM)
                 source(file.path(path.code, "input-utils.R"))
                 source(file.path(path.code, "datagen-utils.R"))
                 source(file.path(path.code, "analysis-utils.R"))
               })
  
  start.time <- Sys.time()
  
  list.df.potential <- parLapply(cl=cl,
                                 X=list.gridx,
                                 fun=function(this.gridx){
                                   df <- GeneratePotentialYit(sim=this.gridx$nsim, 
                                                              N=this.gridx$input.N, 
                                                              tot.time=input.tot.time, 
                                                              rand.time=input.rand.time, 
                                                              cutoff=input.cutoff, 
                                                              rho=this.gridx$input.rho, 
                                                              input.prop.zeros=this.gridx$input.prop.zeros, 
                                                              input.means=this.gridx$input.means,
                                                              input.n4=this.gridx$input.n4,
                                                              corr.str=this.gridx$input.corr.str, 
                                                              other.corr.params=this.gridx$input.other.corr.params)
                                   return(df)
                                 })
  
  list.corr <- parLapply(cl=cl,
                         X=list.df.potential,
                         fun=function(this.list){
                           this.corr <- SeqCorrelationPO(df.list = this.list)
                           return(this.corr)
                         })
  
  # Note: list.cormat is of length input.M
  list.cormat <- parLapply(cl=cl,
                           X=list.corr,
                           fun=function(this.list){
                             cormat <- this.list$cormat
                             return(cormat)
                           })
  
  # Grab for each sequence
  list.cormat.plus.r <- parLapply(cl=cl,
                                  X=list.cormat,
                                  fun=function(this.list){
                                    cormat <- this.list$cormat.plus.r
                                    return(cormat)
                                  })
  
  list.cormat.plus.nr.plus <- parLapply(cl=cl,
                                        X=list.cormat,
                                        fun=function(this.list){
                                          cormat <- this.list$cormat.plus.nr.plus
                                          return(cormat)
                                        })
  
  list.cormat.plus.nr.minus <- parLapply(cl=cl,
                                         X=list.cormat,
                                         fun=function(this.list){
                                           cormat <- this.list$cormat.plus.nr.minus
                                           return(cormat)
                                         })
  
  list.cormat.minus.r <- parLapply(cl=cl,
                                   X=list.cormat,
                                   fun=function(this.list){
                                     cormat <- this.list$cormat.minus.r
                                     return(cormat)
                                   })
  
  list.cormat.minus.nr.plus <- parLapply(cl=cl,
                                         X=list.cormat,
                                         fun=function(this.list){
                                           cormat <- this.list$cormat.minus.nr.plus
                                           return(cormat)
                                         })
  
  list.cormat.minus.nr.minus <- parLapply(cl=cl,
                                          X=list.cormat,
                                          fun=function(this.list){
                                            cormat <- this.list$cormat.minus.nr.minus
                                            return(cormat)
                                          })
  
  # Exit parallel computation for this value of rho
  stopCluster(cl)
  
  # Reduce the lists
  cormat.plus.r <- reduce(list.cormat.plus.r, function(matrix1,matrix2){return(matrix1+matrix2)})
  cormat.plus.nr.plus <- reduce(list.cormat.plus.nr.plus, function(matrix1,matrix2){return(matrix1+matrix2)})
  cormat.plus.nr.minus <- reduce(list.cormat.plus.nr.minus, function(matrix1,matrix2){return(matrix1+matrix2)})
  
  cormat.minus.r <- reduce(list.cormat.minus.r, function(matrix1,matrix2){return(matrix1+matrix2)})
  cormat.minus.nr.plus <- reduce(list.cormat.minus.nr.plus, function(matrix1,matrix2){return(matrix1+matrix2)})
  cormat.minus.nr.minus <- reduce(list.cormat.minus.nr.minus, function(matrix1,matrix2){return(matrix1+matrix2)})
  
  # Take average across all simulated datasets
  cormat.plus.r <- cormat.plus.r/input.M
  cormat.plus.nr.plus <- cormat.plus.nr.plus/input.M
  cormat.plus.nr.minus <- cormat.plus.nr.minus/input.M
  
  cormat.minus.r <- cormat.minus.r/input.M
  cormat.minus.nr.plus <- cormat.minus.nr.plus/input.M
  cormat.minus.nr.minus <- cormat.minus.nr.minus/input.M
  
  # Calculate the maximum and minimum across all sequences
  plus.r = c(cormat.plus.r[upper.tri(cormat.plus.r)],
             cormat.plus.r[lower.tri(cormat.plus.r)])
  
  plus.nr.plus = c(cormat.plus.nr.plus[upper.tri(cormat.plus.nr.plus)],
                   cormat.plus.nr.plus[lower.tri(cormat.plus.nr.plus)])
  
  plus.nr.minus = c(cormat.plus.nr.minus[upper.tri(cormat.plus.nr.minus)],
                    cormat.plus.nr.minus[lower.tri(cormat.plus.nr.minus)])
  
  minus.r = c(cormat.minus.r[upper.tri(cormat.minus.r)],
              cormat.minus.r[lower.tri(cormat.minus.r)])
  
  minus.nr.plus = c(cormat.minus.nr.plus[upper.tri(cormat.minus.nr.plus)],
                    cormat.minus.nr.plus[lower.tri(cormat.minus.nr.plus)])
  
  minus.nr.minus = c(cormat.minus.nr.minus[upper.tri(cormat.minus.nr.minus)],
                     cormat.minus.nr.minus[lower.tri(cormat.minus.nr.minus)])
  
  all.seq <- c(plus.r, plus.nr.plus, plus.nr.minus,
               minus.r, minus.nr.plus, minus.nr.minus)
  
  tau.max <- max(all.seq, na.rm=TRUE)
  tau.min <- min(all.seq, na.rm=TRUE)
  
  # Keep record of results
  end.time <- Sys.time()
  elapsed.secs <- difftime(time1 = end.time, time2 = start.time, units = "secs")
  elapsed.secs <- as.numeric(elapsed.secs)
  
  list.est.tau <- list(data.frame(datagen.params.rho = input.rho, tau.min = tau.min, tau.max = tau.max, elapsed.secs = elapsed.secs))
  collect.correlation.tau <- append(collect.correlation.tau, list.est.tau)
  
  # Keep record of results
  list.seq.cormat <- list(datagen.params.rho = input.rho,
                          tau.min = tau.min, 
                          tau.max = tau.max,
                          cormat.plus.r = cormat.plus.r,
                          cormat.plus.nr.plus = cormat.plus.nr.plus,
                          cormat.plus.nr.minus = cormat.plus.nr.minus,
                          cormat.minus.r = cormat.minus.r,
                          cormat.minus.nr.plus = cormat.minus.nr.plus,
                          cormat.minus.nr.minus = cormat.minus.nr.minus)
  
  collect.seq.cormat <- append(collect.seq.cormat, list(list.seq.cormat))
  
  # Prepare for next iteration
  remove(list.df.potential, list.gridx)
}

collect.correlation.tau <- do.call(rbind, collect.correlation.tau)
  
###############################################################################
# Display simulated correlation
###############################################################################
print(collect.correlation.tau)

# Audio notification
beep("mario")


