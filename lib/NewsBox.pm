package NewsBox;
use warnings;
use strict;
use base qw|CGI::Application|;
use CGI::Application::Plugin::DBH (qw|dbh_config dbh|);
use CGI::Application::Plugin::JSON qw|:all|;
use CGI::Application::Plugin::TT;
use HTML::TagFilter;
use Email::Valid;
use Data::Dumper;
use NewsBox::Model::Validate qw|:all|;

use vars qw($VERSION);

$VERSION = '0.01';

my $debug = 0;




=head2 _validate_form

 --------------------------------------------------------------------------------

    subroutine : _validate_form
          task : 
            in : 
           out : 
  side effects : 
   assumptions : 
       created : 
        status : works as of 
    Nota Benne : 

-- 

=cut

sub _validate_form {

    my $self = shift;

    my (%sql, $error, @error_list);	
    ($sql{'newsItem'}, $error) = $self->_val_input(1, 256, $self->query->param('newsItem') );
    if ( $error-> { msg } ) { push @error_list, { "newsItem" => $error->{ msg } }; }	    
    if (@error_list) { $self->param('error_list' => \@error_list) }
    $self->param('sql'   => \%sql);

}# _validate_form


#-- 

# DB Methods


=head2 _create_item

 --------------------------------------------------------------------------------

    subroutine : _create_item
          task : create a news item entry
            in : 
           out : 
  side effects : 
   assumptions : 
       created : 
        status : works as of 
    Nota Benne : 

-- 

=cut

sub _create_item {

    my $self = shift;

    my $newsItem  = $self->query->param('newsItem');

    # make sure that the parameter is properly quoted
    my $newsItem_quoted = $self->dbh->quote($newsItem);
    my $sth = $self->dbh->prepare("INSERT INTO news(item) VALUES ($newsItem_quoted);")
	or die "Can't prepare SQL statement: $DBI::errstr\n";
    # update the news item in the store
    $sth->execute
	or die "Can't execute SQL statement: $DBI::errstr\n";

    $self->param('success_list' => [{'success' => 'New record added'}]);

}#_create_item


=head2 _read_item_table

 --------------------------------------------------------------------------------

    subroutine : _read_item_table
          task : 
            in : 
           out : 
  side effects : 
   assumptions : 
       created : 
        status : works as of 
    Nota Benne : 

-- 

=cut

sub _read_item_table {

    my ($mydbh) = @_;

    my $sql = q/SELECT id, item FROM news ORDER BY id ASC/;
    my $sth = $mydbh->prepare($sql);
    $sth->execute;

    return $sth;

}#_read_item_table


=head2 _read_item_column 

 --------------------------------------------------------------------------------

    subroutine : read_item_column
          task : 
            in : 
           out : 
  side effects : 
   assumptions : 
       created : 
        status : works as of 
    Nota Benne : 

-- 

=cut

sub _read_item_column {
   my $self = shift;

   my $stmt = qq/SELECT item FROM news where id>0 ORDER BY id ASC/;
   my $thing = $self->dbh->selectcol_arrayref($stmt, {[2]}, $self->query->param('news'));

   return $thing;

}#read_item_column


=head2 _update

 --------------------------------------------------------------------------------

    subroutine : _update
          task : update a news item entry.
            in : CGI handle, 
                 Db handle,
                 news item id, 
                 news item entry text
           out : 
  side effects : updates news item entry in permanent store identified by unique identifier
   assumptions : 
       created : 2010-06-09 13:43:33
        status : works as of 
    Nota Benne : 

-- 

=cut

sub _update {

    my $self = shift;

    # recover the form parameters
    my $newsItem        = $self->query->param('newsItem');
    my $newsItemId      = $self->query->param('newsItemId');
    # make sure that the parameter is properly quoted
    my $newsItem_quoted = $self->dbh->quote($newsItem);
    my $sth = $self->dbh->prepare("UPDATE news SET item=($newsItem_quoted) where id=$newsItemId;")
	or die "Can't prepare SQL statement: $DBI::errstr\n";
    # update the news item in the store
    $sth->execute
	or die "Can't execute SQL statement: $DBI::errstr\n";
    $self->param('success_list' => [{'success' => 'Record updated'}]);

}#_update



=head2 _delete_item

 --------------------------------------------------------------------------------

    subroutine : _delete_item
          task : 
            in : 
           out : 
  side effects : 
   assumptions : 
       created : 
        status : works as of 
    Nota Benne : 

-- 

=cut


sub _delete_item {

    my $self = shift;

    # recover the form parameters
    my $newsItemId      = $self->query->param('newsItemId');
    my $sth = $self->dbh->prepare("DELETE from news where id=$newsItemId;")
	or die "Can't prepare SQL statement: $DBI::errstr\n";
    # update the news item in the store
    $sth->execute
	or die "Can't execute SQL statement: $DBI::errstr\n";
    $self->param('success_list' => [{'success' => 'Record deleted'}]);

}#_delete_item


#-- 


=head2 rm_show_home_page

 --------------------------------------------------------------------------------

    subroutine : rm_show_home_page
          task : display the web page that fronts the web app
            in : 
           out : 
  side effects : 
   assumptions : 
       created : 
        status : works as of 2010-07-04 14:08:10
    Nota Benne : 

-- 

=cut

sub rm_show_home_page {

    my $self = shift;

    # get the items from the database 
    my $sth = _read_item_table($self->dbh); 
    my $newsitems = [];
    # and load them into the TT var
    while (my $row = $sth->fetchrow_hashref) {
	push (@$newsitems,$row);
    }

    my %params = (
	email     => 'email@rupertthehacker.com',
	pagetitle => 'My NewsBox Test',
	newsitems => $newsitems,
	dump      => $debug ? "<pre> " . Dumper($self) . "</pre>" : "",
	);

    return $self->tt_process('static/templates/index.tt2', \%params);
#    return $self->tt_process('static/newsbox.tt2', \%params);

}#rm_show_home_page


=head2 rm_show_newsbox_page

 --------------------------------------------------------------------------------

    subroutine : rm_show_newsbox_page
          task : display the web page that fronts the web app
            in : 
           out : 
  side effects : 
   assumptions : 
       created : 
        status : works as of 2010-07-04 14:08:10
    Nota Benne : 

-- 

=cut

sub rm_show_newsbox_page {

    my $self = shift;

    # get the items from the database 
    my $sth = _read_item_table($self->dbh); 
    my $newsitems = [];
    # and load them into the TT var
    while (my $row = $sth->fetchrow_hashref) {
	push (@$newsitems,$row);
    }

    my %params = (
	email     => 'email@rupertthehacker.com',
	pagetitle => 'My NewsBox Test',
	newsitems => $newsitems,
	dump      => $debug ? "<pre> " . Dumper($self) . "</pre>" : "",
	);

    return $self->tt_process('static/templates/newsbox.tt2', \%params);

}#rm_show_newsbox_page


=head2 rm_show_create_page

 --------------------------------------------------------------------------------

    subroutine : rm_show_create_page
          task : display the web page that fronts the web app
            in : 
           out : 
  side effects : 
   assumptions : 
       created : 
        status : works as of 2010-07-04 14:08:10
    Nota Benne : 

-- 

=cut

sub rm_show_create_page {

    my $self = shift;

    my %params = (
	dump      => $debug ? "<pre> " . Dumper($self) . "</pre>" : "",
	);

    return $self->tt_process('static/templates/create.tt2', \%params);

}#rm_show_create_page


=head2 rm_show_update_page

 --------------------------------------------------------------------------------

    subroutine : rm_show_update_page
          task : display the web page that fronts the web app
            in : 
           out : 
  side effects : 
   assumptions : 
       created : 
        status : works as of 2010-07-04 14:08:10
    Nota Benne : 

-- 

=cut

sub rm_show_update_page {

    my $self = shift;

    # get the items from the database 
    my $sth = _read_item_table($self->dbh); 
    my $newsitems = [];
    # and load them into the TT var
    while (my $row = $sth->fetchrow_hashref) {
	push (@$newsitems,$row);
    }

    my %params = (
	email     => 'email@rupertthehacker.com',
	pagetitle => 'My Update News Item Test',
	newsitems => $newsitems,
	dump      => $debug ? "<pre> " . Dumper($self) . "</pre>" : "",
	);

    return $self->tt_process('static/templates/update.tt2', \%params);

}#rm_show_update_page


=head2 rm_create_item

 --------------------------------------------------------------------------------

    subroutine : rm_create_item
          task : 
            in : 
           out : 
  side effects : 
   assumptions : 
       created : 
        status : works as of 
    Nota Benne : need to refactor _val_input to accomodate html before we can use
                 it here

-- 

=cut

sub rm_create_item {

    my $self = shift;

    $self->_validate_form();                           
    if ( $self->param('error_list')) {
	my $result = [{ 'messages' => $self->param('error_list') }];
	return $self->json_body( $result );
    }
   
    $self->_create_item();
   
    my $result = [{ 'messages' => $self->param('success_list') }];
    return $self->json_body($result);                         

}#rm_create_item


=head2 rm_read_all_items

 --------------------------------------------------------------------------------

    subroutine : rm_read_all_items
          task : 
            in : 
           out : 
  side effects : 
   assumptions : 
       created : 
        status : works as of 
    Nota Benne : 

-- 

=cut

sub rm_read_all_items {
   my $self = shift;

   my $newsitems = $self->_read_item_column;

   return $self->json_body( {"news" => $newsitems} );

}#rm_read_all_items


=head2 rm_update_item

 --------------------------------------------------------------------------------

    subroutine : rm_update_item
          task : 
            in : 
           out : 
  side effects : 
   assumptions : 
       created : 
        status : works as of 
    Nota Benne : 

-- 

=cut

sub rm_update_item {

   my $self = shift;

   $self->_validate_form();                           
   if ( $self->param('error_list')) {
       my $result = [{ 'messages' => $self->param('error_list') }];
       return $self->json_body( $result );
   }
   
   $self->_update();
   
   my $result = [{ 'messages' => $self->param('success_list') }];
   return $self->json_body( $result);                         

}#rm_update_item


=head2 rm_delete_item

 --------------------------------------------------------------------------------

    subroutine : rm_delete_item
          task : 
            in : 
           out : 
  side effects : 
   assumptions : 
       created : 
        status : works as of 
    Nota Benne : to be written!!!

-- 

=cut

sub rm_delete_item {

    my $self = shift;

# need a popup that asks for confirmation on page

    $self->_delete_item();
   
    my $result = [{ 'messages' => $self->param('success_list') }];
    return $self->json_body($result);                         

}#rm_delete_item


=head2 setup

 --------------------------------------------------------------------------------

    subroutine : setup
          task : set up the CGI application and define the run modes.
            in : CGI::App object & run-mode parameter set in form
           out : output from choosen run-mode
  side effects : many & varied :-)
   assumptions : 
       created : 
        status : works as of 2010-07-06 09:39:51
    Nota Benne : 

-- 

=cut

sub setup {
    my $self = shift;
    $self->start_mode('hp');
    $self->mode_param('rm');
    $self->run_modes(
	'hp' => 'rm_show_home_page',
	'cp' => 'rm_show_create_page',
	'up' => 'rm_show_update_page',
	'np' => 'rm_show_newsbox_page',
	'c'  => 'rm_create_item',
	'r'  => 'rm_read_all_items',
	'u'  => 'rm_update_item',
	'd'  => 'rm_delete_item',
	);

    # use the same args as DBI->connect();
#    my $data_source = "dbi:SQLite:dbname=newsbox.db";
#    my $username    = '';
#    my $auth        = '';

    my $data_source = 'dbi:mysql:latestnews:192.168.0.27';
    my $username    = 'rupert';
    my $auth        = 'rupert';
    my $attr        = {
                        PrintError => 1,
			RaiseError => 1
    };
    my $config_aref = [$data_source, $username, $auth, $attr];
    $self->dbh_config($config_aref);

}#setup

sub version {
    return $VERSION;
}#version


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

1. DONE add hidden form parameters
2. DONE merge form code 
3. DONE - 2010-06-29 17:19:55 - use Template::Toolkit
4. get NewsScroller using the database as its source
5. incorporate CKEditor
6. use sqlite as the database engine http://sqlite.org/sqlite.html
7. DONE expand text fields to take more text
8. DONE - 2010-06-29 17:20:26 - create a catalyst version.
9. DONE reverse order of listing
10. DONE - 2010-07-06 12:57:18 - delete method
11. bundle project
12. create a github version.


=cut

1; # End of NewsBox

