#!/bin/sh
./extractDatesTimes.pl | grep "^A" | cut -d, -f2 | sort | uniq -c | sort -nr
