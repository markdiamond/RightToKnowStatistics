# RightToKnowStatistics
This collection of scripts, written for the Bourne Shell and for Perl, is designed to present some interesting statistics about Freedom of Information requests that have been lodged using the [Right to Know](https://www.righttoknow.org.au) website.

Each Freedom of Information request that is lodged using [Right to Know](https://www.righttoknow.org.au) occupies a single web-page, referred to here as a *request-page*. The scripts are designed to put a minimum load on the [Right to Know](https://www.righttoknow.org.au) server by downloading relevant web-pages to the local computer rather than trying to obtain the statistics by independent occasions of scraping the remote site.

@getRightToKnowRequests.sh
This is the Bourne shell script to download the request pages from [Right to Know](https://www.righttoknow.org.au). Although each request page on 
The script takes one compulsory argument and one optional argument in the form:
