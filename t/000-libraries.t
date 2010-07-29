#!/usr/local/bin/perl

use Data::Dumper;
use Test::More 'no_plan'; #tests => 1;
use Test::Exception;

BEGIN {
  foreach ( qw~ 
                CGI::Application 
                HTML::TagFilter 
                Email::Valid  
                Data::Dumper 
                CGI::FCKeditor
                CGI::Session
                CGI::Application::Plugin::DBH  
                CGI::Application::Plugin::DBIx::Class  
                CGI::Application::Plugin::TT 
                SQL::Translator
                Parse::RecDescent
                XML::Writer
              ~
      ) {
      use_ok( $_ );
  }
}

#                CGI::Application::Plugin::AutoRunmode
#                CGI::Application::Plugin::Session
#                CGI::Application::Plugin::Authentication 
#                CGI::Application::Plugin::Authorization 

#-- 


