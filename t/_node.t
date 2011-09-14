use strict;
use PNI;
use PNI::GUI::Tk::App;
use PNI::GUI::Tk::Controller;
use PNI::GUI::Tk::Node;
use Test::More;

my $app        = PNI::GUI::Tk::App->new;
my $controller = PNI::GUI::Tk::Controller->new( app => $app );
my $pni_node   = PNI::node;
$pni_node->add_input('in');
$pni_node->add_output('out');
my $center_y   = 10;
my $center_x   = 10;
my $width      = 10;
my $height     = 10;

my $node = PNI::GUI::Tk::Node->new(
    center_y   => $center_y,
    center_x   => $center_x,
    controller => $controller,
    height     => $height,
    node       => $pni_node,
    width      => $width,
);
isa_ok $node , 'PNI::GUI::Tk::Node';

ok $node->get_border, 'get_border';
ok $node->get_text,   'get_text';
ok $node->get_tk_ids, 'get_tk_ids';

done_testing;
__END__

