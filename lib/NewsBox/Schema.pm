package NewsBox::Schema;

use strict;
use warnings;

use Cwd;
use File::Spec;

use base qw/DBIx::Class::Schema/;

=head1 NAME

NewsBox::Schema - DBIx::Class SQLite DB Layer


=head1 SYNOPSIS

  use NewsBox::Schema;

  my $schema = NewsBox::Schema->connect();
  # or for a memory resident version of the database
  # my $schema = NewsBox::Schema->connect_memory();

  $schema->deploy();

  my $rs = $schema->result('News')->search({
    id => 5
  });

  ......

=head1 AUTHOR

Ian Dash

=cut

our $dbfile;

__PACKAGE__->load_classes();

sub connect {
   my $self = shift;

   my $rootdir = (File::Spec->splitpath(__FILE__))[1];
   $rootdir .= '../../static';
   $rootdir = Cwd::abs_path($rootdir);

   $dbfile  = "$rootdir/db.sqlt";
  
   my $class = (ref $self) ? (ref ($self)) : $self;
   $self->SUPER::connect(
       "dbi:SQLite:dbname=$dbfile"
   );

}#connect


=head2 connect_memory

 --------------------------------------------------------------------------------

    subroutine : connect_memory
          task : connect to a memory resident version of the database
            in : self
           out : dsn to memory resident Db
  side effects : creates database dsn
   assumptions : database is dynamic and only persists when memory is active.
       created : 2010-07-23 15:58:16
        status : works as of 2010-07-23 15:58:26
    Nota Benne : if you switch off the machine you lose the database :-)

-- 

=cut

sub connect_memory {
  my $self = shift;
  
  my $class = (ref $self) ? (ref ($self)) : $self;
  $self->SUPER::connect(
      "dbi:SQLite:dbname=:memory:"
      );

}#connect_memory

1;
