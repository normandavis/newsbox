use strict;
use warnings;
use Data::Dumper;
use Test::More 'no_plan'; #tests => 1;
use Test::Exception;

BEGIN {
  foreach ( qw| 
                List::Util
                DBI
              |
      ) {
      use_ok( $_ );
  }#foreach

  use DBI;
  use List::Util qw(first); # fast & efficient list searching

  my @driver_names = DBI->available_drivers();
  foreach my $dbtype ( qw |
                            mysql
                            SQLite
                          |
      ) {
      # returns the first instance of the search string if found
      my $success = first { $_ eq $dbtype }  @driver_names; 
      is($success, $dbtype, "DBI::$dbtype is installed!");
  }#foreach

}#begin

#-- 

