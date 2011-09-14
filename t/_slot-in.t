use strict;
use PNI;
use PNI::GUI::Tk::App;
use PNI::GUI::Tk::Controller;
use PNI::GUI::Tk::Slot::In;
use PNI::GUI::Tk::Node;
use Test::More;

my $center_y   = 10;
my $center_x   = 10;
my $app        = PNI::GUI::Tk::App->new;
my $controller = PNI::GUI::Tk::Controller->new( app => $app );
my $pni_node   = PNI::node;
my $slot       = $pni_node->add_input('in');
my $node       = PNI::GUI::Tk::Node->new(
    center_y   => 1,
    center_x   => 1,
    controller => $controller,
    height     => 1,
    node       => $pni_node,
    width      => 1,
);

my $input = PNI::GUI::Tk::Slot::In->new(
    center_y   => $center_y,
    center_x   => $center_x,
    controller => $controller,
    node       => $node,
    slot       => $slot,
);

isa_ok $input, 'PNI::GUI::Tk::Slot::In';

is $input->get_center_y,   $center_y,   'get_center_y';
is $input->get_center_x,   $center_x,   'get_center_x';
is $input->get_controller, $controller, 'get_controller';

done_testing;
__END__

