use strict;
use warnings;
use lib "/usr/lib/cgi-bin/newsbox/lib";
use NewsBox::Schema;
use Test::DBIx::Class::Schema;

BEGIN {
  # check libs

  # get dsn - use the memory resident one to enable easy cleanup after test
  my $schema = NewsBox::Schema->connect_memory();

  # create a new schema test object
  my $schematest = Test::DBIx::Class::Schema->new(
						  {
						   # required
						   dsn       => $schema,
						   namespace => 'NewsBox::Schema',
						   moniker   => 'News',
						   # optional
						   username  => '',
						   password  => '',
						  }
						 );
  # tell it what to test
  $schematest->methods(
		       {
			'columns'    => [
					 qw~
					     id
					     item
					   ~
					],
			'resultsets' => [
					 # we may need to add resultset methods here!
					],
			'relations'  => [],
			'custom'     => [],
		       }
		      );

  # run the tests
  $schematest->run_tests();
}#END
