# Specify file paths
.path.output_data <- Sys.getenv("path.output_data")
df.deltaQ <- read.csv(file.path(.path.output_data,"sim_sensitivity_group_four","truth-delta-Q.csv"))
plot.this.rho <- 0.15

###############################################################################
# Plot power for detecting difference in end-of-study means
###############################################################################

jpeg(file.path(.path.output_data, "sim_vary_effect", paste("plot_power_eos_means_",plot.this.rho,".jpeg",sep="")), width = 930, height = 900)

palette <- c("darkgoldenrod","forestgreen","firebrick3","lightcoral","mistyrose1",
             "bisque3","lightblue4","steelblue4","wheat3","grey30")

# -----------------------------------------------------------------------------
# Plot for rho = 0.80
# -----------------------------------------------------------------------------

par(mar = c(5, 4, 0.5, 0.5) + 0.1)  # Bottom, left, top, right

plot(-1, 
     type="n",
     xlim = c(100,750),
     ylim = c(0,1),
     xaxt="n",
     yaxt="n",
     xlab = "Total sample size N",
     ylab = "Power")


axis(1, at = seq(100, 600, 50))
axis(2, at = seq(0, 1, 0.10))

for(idx in c(0,1,2,3,4,5,6,7,8)){
  .this.folder.alternative <- paste("sim_vary_effect/sim_results_", idx, sep="")
  load(file = file.path(.path.output_data, .this.folder.alternative, "power.RData"))
  plotdat <- power.table[which(power.table$rho==plot.this.rho),]
  lines(plotdat$N, plotdat$power.eos.means, lty=2, col = palette[1+idx], lwd=0.5)  
  lines(plotdat$N, plotdat$power.eos.means, lty=2, col = palette[1+idx], lwd=5)  
  points(plotdat$N, plotdat$power.eos.means, pch=21, bg = palette[1+idx], col="black", cex=2)       
}

abline(h = 0.80, lty=2)

text(150,1,paste("rho=",plot.this.rho), col="red",cex=2)

for(idx in 0:9){
  if(idx<=2){
    text(680,0.05+idx/15,paste("Scenario ",1+idx,": delta_EOS=",df.deltaQ$truth.delta.eos.means[idx+1],sep=""), col = palette[1+idx], cex=1)
  }else if(idx>=3 & idx <=4){
    text(680,0.05+idx/10,paste("Scenario ",1+idx,": delta_EOS=",df.deltaQ$truth.delta.eos.means[idx+1],sep=""), col = palette[1+idx], cex=1)
  }else if(idx==5){
    text(680,0.05+idx/9,paste("Scenario ",1+idx,": delta_EOS=",df.deltaQ$truth.delta.eos.means[idx+1],sep=""), col = palette[1+idx], cex=1)
  }else if(idx==6){
    text(680,0.05+idx/9,paste("Scenario ",1+idx,": delta_EOS=",df.deltaQ$truth.delta.eos.means[idx+1],sep=""), col = palette[1+idx], cex=1)
  }else if(idx==7){
    text(680,0.05+idx/9,paste("Scenario ",1+idx,": delta_EOS=",df.deltaQ$truth.delta.eos.means[idx+1],sep=""), col = palette[1+idx], cex=1)
  }else if(idx==8){
    text(680,0.05+idx/9.5,paste("Scenario ",1+idx,": delta_EOS=",df.deltaQ$truth.delta.eos.means[idx+1],sep=""), col = palette[1+idx], cex=1)
  }else if(idx==9){
    text(680,0.05+idx/10,paste("Scenario ",1+idx,": delta_EOS=",df.deltaQ$truth.delta.eos.means[idx+1],sep=""), col = palette[1+idx], cex=1)
  }
}

dev.off()

###############################################################################
# Plot power for detecting difference in AUC
###############################################################################

jpeg(file.path(.path.output_data, "sim_vary_effect", paste("plot_power_AUC_",plot.this.rho,".jpeg",sep="")), width = 930, height = 900)

palette <- c("darkgoldenrod","forestgreen","firebrick3","lightcoral","mistyrose1",
             "bisque3","lightblue4","steelblue4","wheat3","grey30")

# -----------------------------------------------------------------------------
# Plot for rho = 0.80
# -----------------------------------------------------------------------------

par(mar = c(5, 4, 0.5, 0.5) + 0.1)  # Bottom, left, top, right

plot(-1, 
     type="n",
     xlim = c(100,750),
     ylim = c(0,1),
     xaxt="n",
     yaxt="n",
     xlab = "Total sample size N",
     ylab = "Power")


axis(1, at = seq(100, 600, 50))
axis(2, at = seq(0, 1, 0.10))

for(idx in c(0,1,2,3,4,5,6,7,8)){
  .this.folder.alternative <- paste("sim_vary_effect/sim_results_", idx, sep="")
  load(file = file.path(.path.output_data, .this.folder.alternative, "power.RData"))
  plotdat <- power.table[which(power.table$rho==plot.this.rho),]
  lines(plotdat$N, plotdat$power.AUC, lty=2, col = palette[1+idx], lwd=0.5)  
  lines(plotdat$N, plotdat$power.AUC, lty=2, col = palette[1+idx], lwd=5)  
  points(plotdat$N, plotdat$power.AUC, pch=21, bg = palette[1+idx], col="black", cex=2)       
}

abline(h = 0.80, lty=2)

text(150,1,paste("rho=",plot.this.rho), col="red",cex=2)

for(idx in 0:9){
  if(idx<=2){
    text(680,0.05+idx/15,paste("Scenario ",1+idx,": delta_AUC=",df.deltaQ$truth.delta.AUC[idx+1],sep=""), col = palette[1+idx], cex=1)
  }else if(idx==3){
    text(680,0.05+idx/10,paste("Scenario ",1+idx,": delta_AUC=",df.deltaQ$truth.delta.AUC[idx+1],sep=""), col = palette[1+idx], cex=1)
  }else if(idx==4){
    text(680,0.05+idx/9,paste("Scenario ",1+idx,": delta_AUC=",df.deltaQ$truth.delta.AUC[idx+1],sep=""), col = palette[1+idx], cex=1)
  }else if(idx==5){
    text(680,0.05+idx/8,paste("Scenario ",1+idx,": delta_AUC=",df.deltaQ$truth.delta.AUC[idx+1],sep=""), col = palette[1+idx], cex=1)
  }else if(idx==6){
    text(680,0.05+idx/8,paste("Scenario ",1+idx,": delta_AUC=",df.deltaQ$truth.delta.AUC[idx+1],sep=""), col = palette[1+idx], cex=1)
  }else if(idx==7){
    text(680,0.05+idx/8.5,paste("Scenario ",1+idx,": delta_AUC=",df.deltaQ$truth.delta.AUC[idx+1],sep=""), col = palette[1+idx], cex=1)
  }else if(idx==8){
    text(680,0.05+idx/9,paste("Scenario ",1+idx,": delta_AUC=",df.deltaQ$truth.delta.AUC[idx+1],sep=""), col = palette[1+idx], cex=1)
  }else if(idx==9){
    text(680,0.05+idx/9.7,paste("Scenario ",1+idx,": delta_AUC=",df.deltaQ$truth.delta.AUC[idx+1],sep=""), col = palette[1+idx], cex=1)
  }
}

dev.off()



