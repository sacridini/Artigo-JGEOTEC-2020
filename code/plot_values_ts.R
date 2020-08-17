x <- read.csv("~/Documents/jgeotec2020/tables/output_samples_greenness.csv")
x <- x[x$class == "for",]
x$CID <- NULL
x$system.index <- NULL
x$.geo <- NULL
x$X.1 <- NULL
x$X <- NULL
x$class <- NULL
# x$row_sd <- apply(x, 1, sd); View(x)
x <- as.numeric(as.vector(x[96,]))
summary(x); sd(x)
plot(x)