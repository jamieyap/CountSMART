###############################################################################
# Plot bias
###############################################################################
.path.code <- Sys.getenv("path.code")

# Specify file paths
.path.output_data <- Sys.getenv("path.output_data")
.this.folder.1 <- "sim_size_test/low_zeros"
.this.folder.2 <- "sim_size_test/moderate_zeros"
.this.folder.3 <- "sim_size_test/high_zeros"

load(file = file.path(.path.output_data, .this.folder.1, "truth.RData"))
df1 <- .df.vary.params

load(file = file.path(.path.output_data, .this.folder.2, "truth.RData"))
df2 <- .df.vary.params

load(file = file.path(.path.output_data, .this.folder.3, "truth.RData"))
df3 <- .df.vary.params

###############################################################################
# Difference in estimates of end-of-study means and AUC
###############################################################################

op <- par() # save default settings
par(mfcol = c(3,2), pty="m")

plot(-1, 
     type="n",
     xlim = c(100, 500),
     ylim = c(-1,1),
     xaxt="n",
     yaxt="n",
     xlab = "N",
     ylab = "Bias")

axis(1, at = seq(100, 500, 100))
axis(2, at = seq(-1, 1, 0.10))
abline(h = 0, lty=2)

title(main = "Estimates of Difference in End-of-Study Means\n(Low Zeros)")
points(df1$N, df1$bias.diff.eos.means, pch=21, bg = "darkgoldenrod", col="black", cex=1.7)

plot(-1, 
     type="n",
     xlim = c(100, 500),
     ylim = c(-1,1),
     xaxt="n",
     yaxt="n",
     xlab = "N",
     ylab = "Bias")

axis(1, at = seq(100, 500, 100))
axis(2, at = seq(-1, 1, 0.10))
abline(h = 0, lty=2)

title(main = "Estimates of Difference in End-of-Study Means\n(Moderate Zeros)")
points(df2$N, df2$bias.diff.eos.means, pch=21, bg = "darkgoldenrod", col="black", cex=1.7)

plot(-1, 
     type="n",
     xlim = c(100, 500),
     ylim = c(-1,1),
     xaxt="n",
     yaxt="n",
     xlab = "N",
     ylab = "Bias")

axis(1, at = seq(100, 500, 100))
axis(2, at = seq(-1, 1, 0.10))
abline(h = 0, lty=2)

title(main = "Estimates of Difference in End-of-Study Means\n(High Zeros)")
points(df3$N, df3$bias.diff.eos.means, pch=21, bg = "darkgoldenrod", col="black", cex=1.7)

plot(-1, 
     type="n",
     xlim = c(100, 500),
     ylim = c(-1,1),
     xaxt="n",
     yaxt="n",
     xlab = "N",
     ylab = "Bias")

axis(1, at = seq(100, 500, 100))
axis(2, at = seq(-1, 1, 0.10))
abline(h = 0, lty=2)

title(main = "Estimates of Difference in AUC\n(Low Zeros)")
points(df1$N, df1$bias.diff.AUC, pch=21, bg = "darkgoldenrod", col="black", cex=1.7)

plot(-1, 
     type="n",
     xlim = c(100, 500),
     ylim = c(-1,1),
     xaxt="n",
     yaxt="n",
     xlab = "N",
     ylab = "Bias")

axis(1, at = seq(100, 500, 100))
axis(2, at = seq(-1, 1, 0.10))
abline(h = 0, lty=2)

title(main = "Estimates of Difference in AUC\n(Moderate Zeros)")
points(df2$N, df2$bias.diff.AUC, pch=21, bg = "darkgoldenrod", col="black", cex=1.7)

plot(-1, 
     type="n",
     xlim = c(100, 500),
     ylim = c(-1,1),
     xaxt="n",
     yaxt="n",
     xlab = "N",
     ylab = "Bias")

axis(1, at = seq(100, 500, 100))
axis(2, at = seq(-1, 1, 0.10))
abline(h = 0, lty=2)

title(main = "Estimates of Difference in AUC\n(High Zeros)")
points(df3$N, df3$bias.diff.AUC, pch=21, bg = "darkgoldenrod", col="black", cex=1.7)

par(op)


###############################################################################
# Difference in estimates of end-of-study means and AUC
###############################################################################

op <- par() # save default settings
par(mfcol = c(3,2), pty="m")

plot(-1, 
     type="n",
     xlim = c(100, 500),
     ylim = c(-1,1),
     xaxt="n",
     yaxt="n",
     xlab = "N",
     ylab = "Bias")

axis(1, at = seq(100, 500, 100))
axis(2, at = seq(-1, 1, 0.10))
abline(h = 0, lty=2)

title(main = "Estimates of Standard Error of\nDifference in End-of-Study Means (Low Zeros)")
points(df1$N, df1$bias.stderr.est.diff.eos.means, pch=21, bg = "darkgoldenrod", col="black", cex=1.7)

plot(-1, 
     type="n",
     xlim = c(100, 500),
     ylim = c(-1,1),
     xaxt="n",
     yaxt="n",
     xlab = "N",
     ylab = "Bias")

axis(1, at = seq(100, 500, 100))
axis(2, at = seq(-1, 1, 0.10))
abline(h = 0, lty=2)

title(main = "Estimates of Standard Error of\nDifference in End-of-Study Means (Moderate Zeros)")
points(df2$N, df2$bias.stderr.est.diff.eos.means, pch=21, bg = "darkgoldenrod", col="black", cex=1.7)

plot(-1, 
     type="n",
     xlim = c(100, 500),
     ylim = c(-1,1),
     xaxt="n",
     yaxt="n",
     xlab = "N",
     ylab = "Bias")

axis(1, at = seq(100, 500, 100))
axis(2, at = seq(-1, 1, 0.10))
abline(h = 0, lty=2)

title(main = "Estimates of Standard Error of\nDifference in End-of-Study Means (High Zeros)")
points(df3$N, df3$bias.stderr.est.diff.eos.means, pch=21, bg = "darkgoldenrod", col="black", cex=1.7)

plot(-1, 
     type="n",
     xlim = c(100, 500),
     ylim = c(-1,1),
     xaxt="n",
     yaxt="n",
     xlab = "N",
     ylab = "Bias")

axis(1, at = seq(100, 500, 100))
axis(2, at = seq(-1, 1, 0.10))
abline(h = 0, lty=2)

title(main = "Estimates of Standard Error of\nDifference in AUC (Low Zeros)")
points(df1$N, df1$bias.stderr.est.diff.AUC, pch=21, bg = "darkgoldenrod", col="black", cex=1.7)

plot(-1, 
     type="n",
     xlim = c(100, 500),
     ylim = c(-1,1),
     xaxt="n",
     yaxt="n",
     xlab = "N",
     ylab = "Bias")

axis(1, at = seq(100, 500, 100))
axis(2, at = seq(-1, 1, 0.10))
abline(h = 0, lty=2)

title(main = "Estimates of Standard Error of\nDifference in AUC (Moderate Zeros)")
points(df2$N, df2$bias.stderr.est.diff.AUC, pch=21, bg = "darkgoldenrod", col="black", cex=1.7)

plot(-1, 
     type="n",
     xlim = c(100, 500),
     ylim = c(-1,1),
     xaxt="n",
     yaxt="n",
     xlab = "N",
     ylab = "Bias")

axis(1, at = seq(100, 500, 100))
axis(2, at = seq(-1, 1, 0.10))
abline(h = 0, lty=2)

title(main = "Estimates of Standard Error of\nDifference in AUC (High Zeros)")
points(df3$N, df3$bias.stderr.est.diff.AUC, pch=21, bg = "darkgoldenrod", col="black", cex=1.7)


par(op)


