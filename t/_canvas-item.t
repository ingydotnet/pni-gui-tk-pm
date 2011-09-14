use strict;
use PNI::GUI::Tk::App;
use PNI::GUI::Tk::Canvas;
use PNI::GUI::Tk::Canvas::Item;
use PNI::GUI::Tk::Controller;
use Test::More;

my $app        = PNI::GUI::Tk::App->new;
my $controller = PNI::GUI::Tk::Controller->new( app => $app );
my $tk_canvas  = MainWindow->new->Canvas;
my $canvas     = PNI::GUI::Tk::Canvas->new(
    controller => $controller,
    tk_canvas  => $tk_canvas,
);

my $item = PNI::GUI::Tk::Canvas::Item->new( canvas => $canvas );
isa_ok $item, 'PNI::GUI::Tk::Canvas::Item';

isa_ok $item->get_tk_canvas, 'Tk::Canvas', 'get_tk_canvas';

my $tk_id = 1;
$item->set( tk_id => $tk_id );
is $item->get_tk_id, $tk_id, 'get_tk_id';

done_testing;
__END__
