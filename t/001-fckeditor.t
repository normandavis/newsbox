#!/usr/local/bin/perl

use Data::Dumper;
use Test::More 'no_plan'; #tests => 1;
use Test::Exception;

BEGIN {
      use_ok( CGI::FCKeditor);

      my $editor = CGI::FCKeditor->new;
      isa_ok($editor, CGI::FCKeditor);
      can_ok($editor, new);
      can_ok($editor, set_base);
      can_ok($editor, set_name);
      can_ok($editor, set_set);
      can_ok($editor, set_value);
}

BEGIN {

#Basic

    my $fck = CGI::FCKeditor->new();
    $fck->set_name('fck');              #HTML <input name>(default 'fck')
    $fck->set_base('/fckeditor/');      #FCKeditor Directory
    $fck->set_set('Basic');             #FCKeditor Style(default 'Default')
    $fck->set_value('READ ME');         #input field default value(default '')
    my $form_input_source = $fck->fck;  #output html source
    
    isa_ok($fck, CGI::FCKeditor);

    my $output = qq|<div><textarea name="fck" rows="4" cols="40" style="width: 100%; height: 500px">READ ME</textarea></div>|;
    is ($form_input_source, $output, "output is as expected.");
}

#  use CGI::FCKeditor;
#
#  #Simple
#  my $fck = CGI::FCKeditor->new();
#  $fck->set_base('/FCKeditor/');  #FCKeditor Directory
#  my $form_input_source = $fck->fck;    #output html source
#  
#  #Basic
#  my $fck = CGI::FCKeditor->new();
#  $fck->set_name('fck');        #HTML <input name>(default 'fck')
#  $fck->set_base('/FCKeditor/');        #FCKeditor Directory
#  $fck->set_set('Basic');       #FCKeditor Style(default 'Default')
#  $fck->set_value('READ ME');   #input field default value(default '')
#  my $form_input_source = $fck->fck;    #output html source
#  
#  #Short
#  my $fck = CGI::FCKeditor->new('fck','/FCKeditor/','Basic','READ ME');
#  my $form_input_source = $fck->fck;
#


#-- 


################
# 	       #
#  CLEANUP     #
#	       #
################

