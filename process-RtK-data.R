# Analyze Right to Know information

# The first part of this R-script (down to the dashed line)
# is for the general purpose of getting the data into R.
# The second part of the file is simply an illustration of what can be
# done.
# Set the working directory to the directory wherein 'requests' sits
setwd('~/RightToKnow/')

# Extract the dates and times of transactions from the downloaded
# requests by processing them with ./extractDatesTimes.pl . Store the
# resultant output in a temporary file, having created a temporary,
# file name, and then read the file as a table and safe as dataframe d.
tempFN <- tempfile(pattern="RightToKnow")

system2(command='./extractDatesTimes.pl', args = '',
  stdout = tempFN, stderr = "", stdin = "", input = NULL,
  env = character(), wait = TRUE)

d <- read.table(file = tempFN, header=F, sep=',',
  col.names=c('tran.type','user.name','tran.date','tran.time',
    'tzone','request.no'),
  colClasses=c('factor','factor','character','character',NA,'integer')
  )

# Now for a trivial example of what one might do with the request data.
# Have a look at when Mark Diamond typically works on Right to Know.
require('lubridate')
d$tran.date.time <- as.POSIXlt( paste(d$tran.date, d$tran.time) )
d$weekday <- strftime(d$tran.date.time, "%a")
d$just.time <- strftime(d$tran.date.time, "%X")

b <- seq(0, 24, 0.5)
par(mfrow=c(1,1))
d$time.in.hours <- period_to_seconds(hms(d$just.time))/3600
hist(d$time.in.hours[ (d$user.name=='mark_r_diamond') & (d$tran.type=='O')],
  breaks=0:24,
  xlab='Hour of the day',
  ylab='Number of RightToKnow.org.au entries',
  main='When does Mark R. Diamond most\noften use Right to Know?'
  )

