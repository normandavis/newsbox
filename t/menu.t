#!/usr/local/bin/perl

use Data::Dumper;
use Test::More 'no_plan'; #tests => 1;
use Test::Exception;
#use TestHarness;




################
# 	       #
#  SETUP       #
#	       #
################


################
# 	       #
#  TESTS       #
#	       #
################

BEGIN {
  foreach ( qw| CGI::Application CGI::Application::Plugin::DBH  HTML::TagFilter Email::Valid  CGI::Application::Plugin::TT Data::Dumper |) {
    use_ok( $_ );
  }
}


#-- 


################
# 	       #
#  CLEANUP     #
#	       #
################

