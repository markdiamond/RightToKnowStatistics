#!/usr/bin/perl

# In the next line, put the FULL PATH of the "request" directory; 
# i.e., the directory into which all the request pages are put
$requestDir = "/home/mrd/Programs/RightToKnow/request" ;

use constant false => 0;
use constant true  => 1;

# Open all the files that are needed for output
#  They are opend in append mode because I run this perl script in a
#  shell-file loop. If I opened the files in clobber mode, then on each 
#  loop of the shell file, the csv files would be clobbered!
#  Additionally, the full path has to be specified because the shell
#  script changes directory several times ... and that would result in a new
#  csv file in each directory instead of a consolidated file in one place

# Set working directory
chdir "$requestDir";

# Get a list of the profile files in the directories
@htmlFiles = <[0-9]*>;

# Print out a record number for each line
foreach $requestFileNumber (@htmlFiles) {

  my $document = do {
    local $/ = undef;
    open my $fh, "<", $requestFileNumber or die "Could not open $file: $!";
    <$fh>;
  };

  $document =~ s/\v/ /g;
  $document =~ s/ +/ /g;
  
  # Set user to null to ensure no carry-over when there
  # is no match
  $rtkUser = "";
  $requestType = "";

  if( $document =~ m/<a href="\/user\/([^"]+)">.*?<\/a> made this (.*?) request to/ ) {
    $rtkUser = $1;
    $requestType = $2;
  }

  $dateOfOutgoing = "";
  $timeOfOutgoing = "";
  $gmtOffset = "";
  $dateTimeOfOutGoing = "";
  #while( $document =~ m/class="outgoing correspondence box".*?datetime="([0-9]{4}-[0-9]{2}-[0-9]{2})T([0-9]{2}:[0-9]{2}:[0-9]{2})([+-][0-9]{4})/g ) {
  while( $document =~ m/class="outgoing correspondence box".*?datetime="([0-9]{4}-[0-9]{2}-[0-9]{2})T([0-9]{2}:[0-9]{2}:[0-9]{2})((\+|-)[0-9]{2}:[0-9]{2})/g ) {
    $dateTimeOfOutGoing = $1;
    $dateOfOutgoing = $1;
    $timeOfOutgoing = $2;
    $gmtOffset = $3;
    print "O,"; # Outgoing message indicator
    print "$rtkUser,";
    print "$dateOfOutgoing,";
    print "$timeOfOutgoing,";
    print "$gmtOffset,";
    print "$requestFileNumber\n";
  }

  $dateTimeOfAnnotation = "";
  $dateOfAnnotation = "";
  $timeOfAnnotation = "";
  $gmtOffset = "";
  $commenter = "" ;
  while( $document =~ m/class="comment_in_request box".*?<a href="\/user\/([^"]+)">.*?<\/a> left an annotation.*?datetime="([0-9]{4}-[0-9]{2}-[0-9]{2})T([0-9]{2}:[0-9]{2}:[0-9]{2})((\+|-)[0-9]{2}:[0-9]{2})/g ) {
    $commenter = $1;
    $dateTimeOfAnnotation = $2;
    $dateOfAnnotation = $2;
    $timeOfAnnotation = $3;
    $gmtOffset = $4;
    print "A,"; # Annotation indicator
    print "$commenter,$dateOfAnnotation,$timeOfAnnotation,$gmtOffset,";
    print "$requestFileNumber\n";
  }
}
