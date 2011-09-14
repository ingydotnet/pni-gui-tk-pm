use strict;
use PNI;
use PNI::GUI::Tk::App;
use PNI::GUI::Tk::Controller;
use PNI::GUI::Tk::Node;
use PNI::GUI::Tk::Slot;
use Test::More;

my $app        = PNI::GUI::Tk::App->new;
my $controller = PNI::GUI::Tk::Controller->new( app => $app );
my $node       = PNI::node;
my $slot       = $node->add_input('in');
my $gui_node   = PNI::GUI::Tk::Node->new(
    center_y   => 1,
    center_x   => 1,
    controller => $controller,
    height     => 1,
    node       => $node,
    width      => 1,
);

my $gui_slot = PNI::GUI::Tk::Slot->new(
    controller => $controller,
    node       => $gui_node,
    slot       => $slot,
);
isa_ok $gui_slot, 'PNI::GUI::Tk::Slot';

is $gui_slot->get_node, $gui_node;

done_testing;
__END__

