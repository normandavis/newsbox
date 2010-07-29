use strict;
use warnings;
use lib "/usr/lib/cgi-bin/newsbox/lib";
use Test::More 'no_plan';

BEGIN {
  # check libs
  use_ok('NewsBox::Schema');
  # get dsn - use the memory resident one to enable easy cleanup after test
  my $schema = NewsBox::Schema->connect_memory();
  can_ok( $schema, 'connect'         );
  can_ok( $schema, 'connect_memory'  );

  # do we have a valid schema and can we deploy it?
  isa_ok( $schema, 'NewsBox::Schema' );
  can_ok( $schema, 'deploy'          );

  # deploy the schema, add a row
  $schema->deploy();
  my $item = qq|A lovely new news item|;
  my $new_row = $schema->resultset('News')->create({item => $item,});
  my $rs = $schema->resultset('News')->search({ id => 1 });
  my $row = $rs->first;

  # check if we can get what we put
  ok($row->item eq $item,'Row Insert + Retrieve');

}#END
