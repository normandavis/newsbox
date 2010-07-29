package NewsBox::Schema::News;

use strict;
use warnings;

use base qw/DBIx::Class/;

=head1 NAME

NewsBox::Schema::News - News Table DDL Class


=head1 AUTHOR

Ian Dash

=cut

__PACKAGE__->load_components(qw/Core/);

__PACKAGE__->table('news');
__PACKAGE__->add_columns(
    id => {
        size              => 11,
        data_type         => 'integer',
        default_value     => undef,
        nullable          => 0,
        is_auto_increment => 1,
    },
    item => {
        data_type => 'text',
        nullable  => 0,
    }
);

__PACKAGE__->set_primary_key('id');

1;
