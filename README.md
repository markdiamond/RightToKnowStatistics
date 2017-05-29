# RightToKnowStatistics
This collection of scripts, written in Perl and for the Bourne shell, is designed to present some interesting statistics about Freedom of Information requests that have been lodged using the [Right to Know](https://www.righttoknow.org.au) website.

Each Freedom of Information request that is lodged using [Right to Know](https://www.righttoknow.org.au) occupies a single web-page, referred to here as a *request-page*. Additionally, each registered has a separate web-page referred to as a *user-page*. The scripts are designed to put a minimum load on the [Right to Know](https://www.righttoknow.org.au) server by downloading relevant web-pages to the local computer rather than trying to obtain the statistics by independent occasions of scraping the remote site.
What follows here is a description of the scripts and how to use them.

### getRightToKnowRequests.sh

This is the Bourne shell script to download the request pages from [Right to Know](https://www.righttoknow.org.au).

Although each request page on [Right to Know](https://www.righttoknow.org.au) has a long title, it also has a unique number. The numeric-styled URI of a request page takes the form `https://www.righttoknow.org.au/request/NUMBER`. 
The script takes either one numeric argument, or two. It a single numeric argument is supplied then the number must be a strictly positive integer, as, for example, in `getRighttoKnowRequests.sh 273`. In that case, the script will use `wget` to download request pages numbered `1` through `273`. If two arguments are given, then the two arguments must be strictly positive and the second argument must not be less than the first, as, for example, in `getRighttoKnowRequests 17 184`. In that case, the script will use `wget` to download request-pages numbered `17` to `184` inclusive. Downloaded pages are stored in a directory called `request` which, if it does not already exist, will be created.

### extractDatesTimes.pl

This is the main (work-horse) script to process the request-pages stored in the `request` directory. The raw output from `extractDatesTimes.pl` provides the input to the following scripts that produce statistical summaries:

    countRequestsByUser.sh
    countAnnotationsByUser.sh
    countAnnotationsByPageAndUser.sh
The main items of interest on each request page consist of outgoing messages (O) sent by an FOI applicant (i.e., a [Right to Know](https://www.righttoknow.org.au) user) to an agency, incoming messages (I) sent by the agency in response to a user request, and annotations (A) added by a [Right to Know](https://www.righttoknow.org.au) user who might be the applicant on a particular request page but might also be some other user.

`extractDatesTimes` must be executed in the directory that is the parent of the `request` directory. `extractDatesTimes` will process all the numbered request-pages stored in the directory `request` and will print a summary line for each outgoing message and for each annotation that it finds. 

Examples of the two kinds of summary lines are

    A,jelly_beans,2015-12-04,18:59:02,+11:00,21
and

    O,peanut_butter,2016-09-01,02:38:07,+10:00,236
 
 The first summary line indicates that an annotation (`A`) was made on request-page `21` (indicated at the end of the summary line) by user `jelly_beans` on 4 December 2015 at 18:59:02 hours in the +11 hrs UTC timezone. Similarly, the second summary line indicates that an outgoing message (`O`) was sent on request page `236` by user `peanut_butter` on 1 September 2016 at 02:38:07 hours in the +10 hrs UTC timezone.
 
### countRequestsByUser.sh
`countRequestsByUser.sh` produces a sorted output of the form:
  
    220 jelly_beans
    196 honey_bee
    133 dippy_doldrum
    .
    .
    .
      2 sweet_pea
      1 runner_beans
      1 peanut_butter

showing that user `jelly_beans` has lodged `220` Freedom of Information requests through [Right to Know](https://www.righttoknow.org.au) and that that is the greatest number of requests submitted by any user. In contrast, users `runner_beans` and `peanut_butter` have each submitted one Freedom of Information request through [Right to Know](https://www.righttoknow.org.au).

### countAnnotationsByUser.sh
`countAnnotationsByUser.sh` produces an output similar to that produced by `countRequestsByUser.sh` but the lines and counts relate to writers of annotations on request-pages rather than to the applicants themselves. More specifically, the user that is referred to in each summary line from `countAnnotationsByUser.sh` is an annotator. The line

         40 mark_r_diamond
indicates that Mark R. Diamond has written `40` annotations but says nothing about where the annotations appear. Most likely, they will be spread across a number of different request-pages.

### countAnnotationsByPageAndUser.sh
`countAnnotationsByPageAndUser.sh` counts the number of annotations on each request page and sorts the output in decending order of the annotation count. Pages with the most annotations appear first in the summary. Because the summary is by request-page and because multiple users might have annotated any particular request-page, the user who is named on the summary line is the user who initiated the request (i.e., the applicant who, in effect, owns the request-page). For example, the summary line

    5 mark_r_diamond,599
indicates that there are `5` annotations (quite possibly by different annotators) on request-page number `5` and that request-page relates to an FOI request made by Mark R. Diamond.    
    
### process-RtK-data.R
`process-RtL-data.R` is a simple Gnu R script to read the output of `extractDatesTimes.pl` without needing having to dumpt the output into an intermediate file. The output of `extractDatesTimes.pl` is read into data-frame `d` which can then be used for further analysis. The initial part of the script deals with the creation of data-frame `d`; the latter part is a simple demo that uses the time data from each record to show when (i.e., what time of day) I am most likely to be using Right to Know.
