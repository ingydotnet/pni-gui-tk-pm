use strict;
use Test::More;
use PNI::GUI::Tk::App;
use PNI::GUI::Tk::Controller;

my $app = PNI::GUI::Tk::App->new;
my $controller = PNI::GUI::Tk::Controller->new( app => $app );
isa_ok $controller, 'PNI::GUI::Tk::Controller';

isa_ok $controller->get_canvas,    'PNI::GUI::Tk::Canvas';
isa_ok $controller->get_tk_canvas, 'Tk::Canvas';

# inject a fake init and task for tests
package PNI::Node;

sub init {
    my $node = shift;
    $node->add_input('in');
    $node->add_output('out');
}
sub task { 1 }

package main;

my $node1   = $controller->add_node( center_y => 100, center_x => 100, );
isa_ok $node1,'PNI::GUI::Tk::Node';

my $node2   = $controller->add_node( center_y => 140, center_x => 100, );
isa_ok $node2,'PNI::GUI::Tk::Node';

my $content = 'This is a comment';
my $comment = $controller->add_comment(
    center_y => 160,
    center_x => 100,
    content  => $content
);
isa_ok $comment,'PNI::GUI::Tk::Comment';

SKIP: {
    local $TODO =
'review connecting_edge sub and test connect_edge_to_output and connect_edge_to_input';
    my $source = $node1->get_output('out');
    my $target = $node2->get_input('in');
    my $edge; # = $controller->add_edge( source => $source, target => $target );
    isa_ok $edge,  'PNI::GUI::TK::Edge';
    isa_ok $node1, 'PNI::GUI::TK::Node';
    isa_ok $node2, 'PNI::GUI::TK::Node';
}

# show the window
ok PNI::task;

sleep 1;

done_testing;
__END__

