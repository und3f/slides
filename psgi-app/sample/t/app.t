#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 2;
use Plack::Test;
use HTTP::Request::Common;

use FindBin '$Bin';
my $app = require "$Bin/../app.psgi";
test_psgi $app, sub {
    my $cb = shift;

    my $res = $cb->(GET '/');
    like $res->content, qr/Hello, Plack!/;

    $res = $cb->(GET '/welcome/Sergey');
    like $res->content, qr/Hello, Sergey./;
}
