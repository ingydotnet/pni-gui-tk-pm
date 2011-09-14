use strict;
use PNI::GUI::Tk::App;
use PNI::GUI::Tk::Controller;
use PNI::GUI::Tk::Node_selector;
use Test::More;

my $app        = PNI::GUI::Tk::App->new;
my $controller = PNI::GUI::Tk::Controller->new( app => $app );
my $y          = 10;
my $x          = 10;

my $node_selector = PNI::GUI::Tk::Node_selector->new(
    controller => $controller,
    y          => $y,
    x          => $x,
);
isa_ok $node_selector , 'PNI::GUI::Tk::Node_selector';

is $node_selector->get_controller, $controller;
is $node_selector->get_y,          $y;
is $node_selector->get_x,          $x;

done_testing;
__END__

