#!/bin/sh
# Extract the entries for outgoing messages. The lines include the name
# of the requester and the request number. Cut just those two fields.
# Sort them, remove duplicates (i.e., entries relating to more than
# one outgoing message in any request of a particular applicant),
# leaving one line for each request ... togther with a requesters
# name. Then remove the request numbers by cutting only the applicant's
# name, and count the number of lines relating to any applicant
./extractDatesTimes.pl | grep "^O" | cut -d, -f2,6  | sort | uniq | cut -d, -f1 | uniq -c | sort -nr
