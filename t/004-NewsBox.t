#use Data::Dumper;
use Test::More 'no_plan'; #tests => 1;
use Test::Exception;
use lib "/usr/lib/cgi-bin/newsbox/lib";

BEGIN{

    foreach ( qw~
		NewsBox
                NewsBox::Model::Validate
              ~
	) {
	use_ok( $_ );
    }#foreach

      foreach ( qw~
                   _validate_form
                  ~
	  ) {
	  can_ok( 'NewsBox', $_ );
      }#foreach

    my $newsbox = NewsBox->new;
    isa_ok( $newsbox, 'NewsBox'       );
    foreach ( qw~
                 new
                 valInput
                 valEmail
                 valSelected
                 _validate_form
                ~
	) {
	can_ok( $newsbox, $_ );
    }#foreach

# need test for NewsBox::_validate_form here!
    my $webapp = NewsBox->new();



}#END

#-- 

