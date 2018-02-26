library(jsonlite)
library(caret)
library(dplyr)

clean <- function(x, ...) {
        obs <- NULL
        for (i in 1:length(input$Skeletons)) {
                x <- unlist(input$Skeletons[[i]])
                obs <- rbind(obs, x)
        }
        obs <- obs[,80:ncol(obs)]
        apply(X=obs, MARGIN=2, FUN=sd)
}

file <- c("01.json", "02.json", "03.json", "04.json", "05.json", "06.json",
          "07.json", "08.json", "09.json", "10.json")


#slowCase
path <- "data/slowCase/"
nfiles <- 10
temp <- data.frame()
for (i in 1:nfiles) {
        inpath <- paste(path, file[i], sep="")
        input <- fromJSON(inpath)
        inputC <- clean(input)
        temp <- rbind.data.frame(temp, inputC)
        names(temp) <- names(inputC)
}
slowTrain <- temp
slowTrain$status <- rep("slow", 10)



#stop status
path <- "data/motionLessCase/"
nfiles <- 6
temp <- data.frame()
for (i in 1:nfiles) {
        inpath <- paste(path, file[i], sep="")
        input <- fromJSON(inpath)
        inputC <- clean(input)
        temp <- rbind.data.frame(temp, inputC)
        names(temp) <- names(inputC)
}
stopTrain <- temp
stopTrain$status <- rep("stop", 6)

#fast status
path <- "data/fastCase/"
nfiles <- 10
temp <- data.frame()
for (i in 1:nfiles) {
        inpath <- paste(path, file[i], sep="")
        input <- fromJSON(inpath)
        inputC <- clean(input)
        temp <- rbind.data.frame(temp, inputC)
        names(temp) <- names(inputC)
}
fastTrain <- temp
fastTrain$status <- rep("fast", 10)

#normal case
path <- "data/normalCase/"
nfiles <- 10
temp <- data.frame()
for (i in 1:nfiles) {
        inpath <- paste(path, file[i], sep="")
        input <- fromJSON(inpath)
        inputC <- clean(input)
        temp <- rbind.data.frame(temp, inputC)
        names(temp) <- names(inputC)
}
normalTrain <- temp
normalTrain$status <- rep("average", 10)

allTrain <- rbind(stopTrain, slowTrain, normalTrain, fastTrain)
zeroVar <- nearZeroVar(allTrain)
save(zeroVar, file="zeroVar.Rdata")
allTrain <- select(allTrain, -zeroVar)

fit1 <- train(status~., data=training, method="rf")
save(fit1, file="fit1.Rda")
