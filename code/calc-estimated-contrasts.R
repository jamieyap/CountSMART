# Note that 
#   - this.pair
#   - input.rand.time, input.tot.time
# need to be specified prior to running the code below

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
# Using estimated values of beta, calculate estimated value of contrasts of
# of interest for each DTR 
###############################################################################

# Create C matrix
list.C <- CreateC(input.tot.time = input.tot.time, input.rand.time = input.rand.time)

# Now, continue calculations
ncore <- detectCores()
cl <- makeCluster(ncore - 1)
clusterSetRNGStream(cl, 73556469)
clusterExport(cl, c("path.code",
                    "path.output_data",
                    "list.df.est.beta",
                    "list.C",
                    "D.eos.means",
                    "D.AUC"))
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

list.df.est.diff.eos.means <- parLapply(cl = cl, 
                                        X = list.df.est.beta, 
                                        fun = EstimateDiffs, 
                                        D = D.eos.means,
                                        list.C=list.C)

list.df.est.diff.AUC <- parLapply(cl = cl, 
                                  X = list.df.est.beta, 
                                  fun = EstimateDiffs, 
                                  D = D.AUC,
                                  list.C=list.C)

stopCluster(cl)


###############################################################################
# Determine which pairwise comparison to pick out
###############################################################################
string.this.pair <- case_when(
  this.pair==1 ~ "plusplus.plusminus",
  this.pair==2 ~ "plusplus.minusplus",
  this.pair==3 ~ "plusplus.minusminus",
  this.pair==4 ~ "plusminus.minusplus",
  this.pair==5 ~ "plusminus.minusminus",
  this.pair==6 ~ "minusplus.minusminus",
  TRUE ~ NA_character_
)

assert_that(!is.na(string.this.pair), msg = "invalid option entered")

###############################################################################
# Grab, reshape, and aggregate list of contrast estimates
###############################################################################
list.est.diff.eos.means <- lapply(list.df.est.diff.eos.means, function(x, which.pair = string.this.pair){return(x[which.pair])})
list.est.diff.eos.means <- lapply(list.est.diff.eos.means, ReshapeList)
est.diff.eos.means <- bind_rows(list.est.diff.eos.means)

list.est.diff.AUC <- lapply(list.df.est.diff.AUC, function(x, which.pair = string.this.pair){return(x[which.pair])})
list.est.diff.AUC <- lapply(list.est.diff.AUC, ReshapeList)
est.diff.AUC <- bind_rows(list.est.diff.AUC)

###############################################################################
# Grab, reshape, and aggregate list of standard errors
###############################################################################
list.est.stderr.diff.eos.means <- lapply(list.df.est.beta, EstimateStdErrDiffs, D=D.eos.means, list.C=list.C)
list.est.stderr.diff.eos.means <- lapply(list.est.stderr.diff.eos.means, function(x, which.pair = string.this.pair){return(x[which.pair])})
list.est.stderr.diff.eos.means <- lapply(list.est.stderr.diff.eos.means, ReshapeList)
est.stderr.diff.eos.means <- bind_rows(list.est.stderr.diff.eos.means)

list.est.stderr.diff.AUC <- lapply(list.df.est.beta, EstimateStdErrDiffs, D=D.AUC, list.C=list.C)
list.est.stderr.diff.AUC <- lapply(list.est.stderr.diff.AUC, function(x, which.pair = string.this.pair){return(x[which.pair])})
list.est.stderr.diff.AUC <- lapply(list.est.stderr.diff.AUC, ReshapeList)
est.stderr.diff.AUC <- bind_rows(list.est.stderr.diff.AUC)

###########################################################################
# Perform additional calculations on the 'truth'
# for subsequent sanity checks
###########################################################################
source(file.path(path.code, "calc-truth-beta.R"))
source(file.path(path.code, "calc-truth-contrasts.R"))

###############################################################################
# Determine which pairwise comparison to pick out from the outputs of
# calc-truth-contrasts.R
###############################################################################
diff.eos.means <- case_when(
  this.pair==1 ~ diff.eos.means.plusplus.plusminus,
  this.pair==2 ~ diff.eos.means.plusplus.minusplus,
  this.pair==3 ~ diff.eos.means.plusplus.minusminus,
  this.pair==4 ~ diff.eos.means.plusminus.minusplus,
  this.pair==5 ~ diff.eos.means.plusminus.minusminus,
  this.pair==6 ~ diff.eos.means.minusplus.minusminus,
  TRUE ~ NA_real_
)

assert_that(!is.na(diff.eos.means), msg = "invalid option entered")

diff.AUC <- case_when(
  this.pair==1 ~ diff.AUC.plusplus.plusminus,
  this.pair==2 ~ diff.AUC.plusplus.minusplus,
  this.pair==3 ~ diff.AUC.plusplus.minusminus,
  this.pair==4 ~ diff.AUC.plusminus.minusplus,
  this.pair==5 ~ diff.AUC.plusminus.minusminus,
  this.pair==6 ~ diff.AUC.minusplus.minusminus,
  TRUE ~ NA_real_
)

assert_that(!is.na(diff.AUC), msg = "invalid option entered")



