#!/usr/bin/perl

### CONFIG ####################################################################
my $bot_token = '';
my $chat_id = '';
my $api_url = "https://api.telegram.org/bot$bot_token/sendMessage";
###############################################################################

use warnings;
use strict;
use LWP;
use Getopt::Std;
#use JSON qw(decode_json);
#use Data::Dumper;
###############################################################################

my $message = "@ARGV";
our($opt_u,$opt_m);
getopts('um');

if ( defined $opt_u ) {
    print "getUpdates();\n";
    json_parser( getUpdates() );
} elsif ( defined $opt_m ) {
    print "getMe(); \n";
    json_parser( getMe() );
} else {
    # by default, send message.
    print "postMessage(); \n";
    json_parser(postMessage($message));
}

###############################################################################
# functions:
###############################################################################

sub getUpdates {
    $api_url = "https://api.telegram.org/bot$bot_token/getUpdates";
    my $ua = LWP::UserAgent->new;
    $ua->agent("Mozilla/4.0 (compatible; MSIE 7.0)");
    # $ua->proxy(['http', 'https', 'ftp'], 'http://proxy.server.df:8080/');
    my $req = HTTP::Request->new(GET => "$api_url");
    # Response:
    my $response = $ua->request($req);
    if ($response->is_success) {
        return($response->content);
    } else {
        print "Abfrage konnte nicht erfolgreich durchgeführt werden! \n";
        print "" . $response->status_line . "\n";
        print "" . $response->content . "\n";
        return(77);
    }
}

sub getMe {
    $api_url = "https://api.telegram.org/bot$bot_token/getMe";
    my $ua = LWP::UserAgent->new;
    $ua->agent("Mozilla/4.0 (compatible; MSIE 7.0)");
    # $ua->proxy(['http', 'https', 'ftp'], 'http://proxy.server.df:8080/');
    my $req = HTTP::Request->new(GET => "$api_url");
    # Response:
    my $response = $ua->request($req);
    if ($response->is_success) {
        return($response->content);
    } else {
        print "Abfrage konnte nicht erfolgreich durchgeführt werden! \n";
        print "" . $response->status_line . "\n";
        print "" . $response->content . "\n";
        return(77);
    }
}

sub postMessage {
    my ($message) = @_;
    my $message_full = "chat_id=${chat_id}". '&text=' . $message;
    my $ua = LWP::UserAgent->new;
    $ua->agent("Mozilla/4.0 (compatible; MSIE 7.0)");
    # $ua->proxy(['http', 'https', 'ftp'], 'http://proxy.server.df:8080/');
    my $req = HTTP::Request->new(POST => "$api_url");
    print "URL:  $api_url \n";
    print "POST: $message_full \n";
    $req->header('content_type' => 'application/x-www-form-urlencoded');
    $req->content("$message_full");
    # Response:
    my $response = $ua->request($req);
    if ($response->is_success) {
        return($response->content);
    } else {
        print "Abfrage konnte nicht erfolgreich durchgeführt werden! \n";
        print "" . $response->status_line . "\n";
        print "" . $response->content . "\n";
        return(77);
    }
}

sub stupid_json_parser {
    my ( $string ) = @_;
    my @jaysohn = split(//,$string);
    foreach (@jaysohn){
        chomp();
        if ( $_ =~ /\{|\[|,/g ) {
            print "$_\n";
        } elsif ( $_ =~ /\}|\]/ ) {
            print "\n$_";
        } else {
            print "$_";
        }
    }
    print "\n";
}

sub json_parser {
    my ( $string ) = @_;
    my @jaysohn = split(/,/,$string);
    foreach (@jaysohn){
        chomp();
        print "$_\n";
    }
}
