#!/bin/sh
./extractDatesTimes.pl | grep "^A" | cut -f2,6 -d, | sort | uniq -c | sort -nr 
