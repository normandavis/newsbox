#!/usr/local/bin/perl

use Data::Dumper;
use Test::More 'no_plan'; #tests => 1;
use Test::Exception;
#use TestHarness;

use lib "/usr/lib/cgi-bin/newsbox/lib";

BEGIN {

    foreach ( qw~
		NewsBox
                NewsBox::Model::Validate
              ~
	) {
	use_ok( $_ );
    }#foreach

      foreach ( qw~
                   valInput
                   valEmail
                   valSelected
                  ~
	  ) {
	  can_ok( 'NewsBox::Model::Validate', $_ );
      }#foreach

    my $newsbox = NewsBox->new;
    isa_ok( $newsbox, 'NewsBox'       );
    foreach ( qw~
                 new
                 valInput
                 valEmail
                 valSelected
                ~
	) {
	can_ok( $newsbox, $_ );
    }#foreach

     my $msg = q|cannot be blank|;
     my $mand = 1;
     my $len  = 256;
     my $text = "";
     my ($first, $second) = ($newsbox->valInput($mand, $len, $text));
     my $return_msg = $second->{'msg'};
     is ($return_msg, $msg, "catches empty input.");

     $mand = 1;
     $len = 2;
     $msg = q|is limited to | . $len . q| characters|;
     $text = "abc";
     ($first, $second) = ($newsbox->valInput($mand, $len, $text));
     $return_msg = $second->{'msg'};
     is ($return_msg, $msg, "catches over-long input.");

#     $msg = q|can only use letters, numbers, spaces and -.,&:'|;
#     $mand = 1;
#     $len = 256;
#     $text = q|@&*^%$|;
#     ($first, $second) = ($newsbox->valInput($mand, $len, $text));
#     $return_msg = $second->{'msg'};
#     is ($return_msg, $msg, q|catches forbidden characters|);

     $msg = undef;
     $mand = 1;
     $len = 256;
     $text = q|<p>
Mary had a little lamb,
<p>
           its fleece was white as snow</p>
<p>
           and everywhere that Mary went</p>
<p>
           she got lost</p>|;

     ($first, $second) = ($newsbox->valInput($mand, $len, $text));
     $return_msg = $second->{'msg'};
     is ($return_msg, $msg, q|allows html tags|);

}#END

#-- 


