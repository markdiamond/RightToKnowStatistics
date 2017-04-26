#!/bin/sh
# Usage : getRtKrequests [lowestNumberRequest=1] highestNumberRequest
#
# Downloads request pages from the website for Right to Know
# (https://www.righttoknow.org.au ) using wget.
# I tell Right to Know who I am --- by setting the user-agent
# argument for the wget requests --- so that an administrator can
# admonish me if I put too much load on the RtK server.
# Users typically see a long name on each Right to Know request page
# but in addition to the long name, there is also a corresponding number.
# I download pages by using request numbers.
#
# Check that the range of requests is valid. If there is only one
# argument, then it is the upper bound and must be >= 1.
# If there is more than one argument, then we require that
# 1 <= lowestNumberRequest <= highestNumberRequest <= 4000
# The 4000 limit is simply because there are currently about 3100 
# requests.

# The sensible thing to do is actually to discover the last
# request page using a (clever) binary search. One might, for example,
# start with a possible just-beyond-the-last-page number (e.g., 16)
# and then test for the existence of that page using 
# the wget command in --quiet --spider mode. If one discovers that the
# putative upper-bound page exists, then it obviously is not just-beyond
# the real last-page and one would then double the test-page value
# of the upper-bound and also shift up the lower-bound.
# But, as I said, the search needs to be more clever than that because
# about 10% of possible page numbers will return 404 errors because
# they have been deleted by an administrator or are otherwise
# unassigned.  Without some cleverness, one might set too low an 
# upper-bound. It might be sensible to set the upper bound at a place
# where a 404 error is returned for 4 successive web-pages ... or
# something like that.
# 
#  ... but the approach here is simple and crude

maxHighestNumberRequest=4000
# Assign arguments to lowest and highest request numbers
if test $# -eq 1
then requestLo=1
  requestHi=$1
else if test $# -eq 2
  then requestLo=$1
    requestHi=$2
  else echo Usage: getRtKrequests lowestNumberRequest highestNumberRequest
    exit 1
  fi
fi
# Check that the lowest request number is 1 or more
if test $requestLo -lt 1
then echo "getRtKrequests: Lowest number request must be 1 or greater."
  exit 1
fi
# Check that the highest request does not exceed our stated maximum
if test $requestHi -gt $maxHighestNumberRequest
then echo -n "getRtKrequests: Highest number request cannot exceed "
  echo $maxHighestNumberRequest
  exit 1
fi
# Check that the lowest number request doesn't exceed the highest
if test $requestLo -gt $requestHi
then echo -n "getRtKrequests: Lowest number request cannot exceed highest number request."
 exit 1
fi
#
YOURNAME=YourName
TMPFILE=`mktemp` || exit 1
requestLo=$1
requestHi=$2
seq $requestLo $requestHi > $TMPFILE
echo Getting requests in the range $requestLo to $requestHi
echo Using $TMPFILE as a temporary file
wget --user-agent="$YOURNAME-bot" \
  --base="https://www.righttoknow.org.au/request/" \
  --input-file=$TMPFILE 
#
# If a directory called "request" does not exist, create one
[ -d request ] || mkdir request

# Move files but pipe errors to the sink hole
mv [0-9] [0-9][0-9] [0-9][0-9][0-9] [0-9][0-9][0-9][0-9] request/ 2> /dev/null
