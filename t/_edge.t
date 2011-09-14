use strict;
use PNI;
use PNI::GUI::Tk::App;
use PNI::GUI::Tk::Controller;
use PNI::GUI::Tk::Edge;
use PNI::GUI::Tk::Node;
use Test::More;

my $input_name  = 'in';
my $output_name = 'out';

my $app = PNI::GUI::Tk::App->new;
my $controller = PNI::GUI::Tk::Controller->new( app => $app );

my $pni_node1 = PNI::node;
my $pni_node2 = PNI::node;

$pni_node1->add_output($output_name);
$pni_node2->add_input($input_name);

my $node1 = PNI::GUI::Tk::Node->new(
    center_y   => 100,
    center_x   => 100,
    controller => $controller,
    node       => $pni_node1,
);

my $node2 = PNI::GUI::Tk::Node->new(
    center_y   => 200,
    center_x   => 200,
    controller => $controller,
    node       => $pni_node2,
);

my $source = $node1->get_output($output_name);
my $target = $node2->get_input($input_name);

my $edge = PNI::GUI::Tk::Edge->new(
    controller => $controller,
    source => $source,
    target => $target,
);
isa_ok $edge, 'PNI::GUI::Tk::Edge';

done_testing;
__END__

