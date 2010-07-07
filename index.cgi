#!/usr/bin/perl
use lib "/usr/lib/cgi-bin/newsbox/lib";
use NewsBox;
my $webapp = NewsBox->new();
$webapp->run();
