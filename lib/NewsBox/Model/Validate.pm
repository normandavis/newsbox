package NewsBox::Model::Validate;
use warnings;
use strict;
use HTML::TagFilter;
use Email::Valid;
use Data::Dumper;

use base 'Exporter';
use 5.010;

use vars qw($VERSION);

$VERSION = '0.01';

our @EXPORT_OK = qw~
                    valInput
                    valEmail
                    valSelected
                   ~;

our %EXPORT_TAGS = ( all => \@EXPORT_OK );



my $debug = 0;


=head2 valInput

 --------------------------------------------------------------------------------

    subroutine : valInput
          task : validate form field input
            in : 
           out : 
  side effects : 
   assumptions : 
       created : 
        status : works as of 
    Nota Benne : regex barfs on some trailing newlines

-- 

=cut

sub valInput {

   my $self = shift;
   my ($mand, $len, $value) = @_;

   if (!$value && $mand) {
     return (undef, { msg => 'cannot be blank' });
   } elsif ($len && (length($value) > $len) ) {
      return (undef, { msg => 'is limited to '.$len.' characters' });
#   } elsif ($value && $value !~ /^([\w \<\>\.\,\-\(\)\?\:\;\"\!\'\/\n\/\t\r]*)$/) {
#      return (undef, { msg => 'can only use letters, numbers, spaces and -.,&:\'' });
   } else {
      my $tf = new HTML::TagFilter;
      return ($tf->filter($1));
   }
}#valInput


=head2 valEmail

 --------------------------------------------------------------------------------

    subroutine : valEmail
          task : validate email address
            in : 
           out : 
  side effects : 
   assumptions : 
       created : 
        status : works as of 
    Nota Benne : 

-- 

=cut

sub valEmail { 
   my $self = shift;
   my ($mand, $value) = @_;
   if ( !Email::Valid->address($value) && $mand ) { 
      return ( undef, { msg => 'address does not appear to be valid or is blank' }	);
   } elsif ( !Email::Valid->address($value) && $value ) {
      return ( undef, { msg => 'address does not appear to be valid or is blank' }	);
   } else {
      return $value;
   }
}#valEmail


=head2 valSelected

 --------------------------------------------------------------------------------

    subroutine : valSelected
          task : test whether a radio button has been selected or not.
            in : 
           out : 
  side effects : 
   assumptions : 
       created : 
        status : works as of 
    Nota Benne : 

-- 

=cut

sub valSelected {
   my $self = shift;
   my ($value) = @_;
   if (!$value) {
     return (undef, { msg => 'must be selected' });
   } else {
     return $value;
   }
}#valSelected




=head1 AUTHOR

Norman Davis, C<< <norman at raptex.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-news-scroller at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=News-Scroller>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc NewsItemManager


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=News-Scroller>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/News-Scroller>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/News-Scroller>

=item * Search CPAN

L<http://search.cpan.org/dist/News-Scroller/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2010 Norman Davis, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=head1 TODO

=cut

1; # End of Validate

