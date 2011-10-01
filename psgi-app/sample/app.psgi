#!/usr/bin/env perl

use strict;
use warnings;

use Routes::Tiny;
use Text::Caml;

my $routes = Routes::Tiny->new;

$routes->add_route('/',
    defaults => {action => \&root});

$routes->add_route('/welcome/:name' ,
    defaults => {action => \&welcome});

return \&dispatch;

sub dispatch {
    my $env = shift;

    my $path = $env->{PATH_INFO};

    if (my $route = $routes->match($path)) {
        my $action = $route->{params}{action};

        $action->($env, $route->{params});
    }
}

sub render {
    my ($template, $data) = @_;
    
    my $view = Text::Caml->new;
    
    my $html = $view->render_file($template, $data);

    [200, ['Content-Type', 'text/html'], [$html]];
}

sub root {
    my ($env, $params) = @_;

    render('root.mt', {});
}

sub welcome {
    my ($env, $params) = @_;

    render('welcome.mt', $params);
}
