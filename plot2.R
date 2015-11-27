ukr <- read.csv(file="ukr.txt", header=T, sep=',', encoding = "UTF-8", stringsAsFactors = F)
ukr$dt  <- as.POSIXct( ukr$DateTime, format="%Y-%m-%d %H:%M:%S",  tz = "GMT")

binning = c(); for(i in 1:4320){ binning = append(binning,ukr[1,"dt"] + i*60) }

freq <- data.frame( index=integer(), count=integer() )
for (i in 1:length(binning)-1){ slice <- subset(ukr, dt>binning[i] & dt<binning[i+1]); freq <- rbind(freq, data.frame(index=i, count=dim(slice)[[1]] )) }

plot( decompose( ts(freq[2:4320,"count"],frequency=1440) ) )
