#this script was used real time in our backend (node.js)
needs(jsonlite)
needs(caret)
needs(randomForest)

#clean input
input2 <- unlist(input)
input2 <- fromJSON(input2)
obs <- NULL
for (i in 1:length(input2$Skeletons)) {
        x <- unlist(input2$Skeletons[[i]])
        obs <- rbind(obs, x)
}
obs <- obs[,80:ncol(obs)]
data <- apply(X=obs, MARGIN=2, FUN=sd)
load(file="zeroVar.Rdata")
data <- select(data, -zeroVar)

#predict
load(file = "fit1.rda")
predict(fit, data)
