use strict;
use PNI::GUI::Tk::App;
use PNI::GUI::Tk::Canvas;
use PNI::GUI::Tk::Canvas::Item;
use PNI::GUI::Tk::Canvas::Rectangle;
use PNI::GUI::Tk::Controller;
use Test::More;

my $app        = PNI::GUI::Tk::App->new;
my $controller = PNI::GUI::Tk::Controller->new( app => $app );
my $tk_canvas  = MainWindow->new->Canvas;
my $canvas     = PNI::GUI::Tk::Canvas->new(
    controller => $controller,
    tk_canvas  => $tk_canvas,
);

my $text = 'text';
my $y    = 10;
my $x    = 10;
my $item = PNI::GUI::Tk::Canvas::Text->new(
    canvas => $canvas,
    text   => $text,
    y      => $y,
    x      => $x,
);
isa_ok $item, 'PNI::GUI::Tk::Canvas::Text';

isa_ok $item->get_tk_canvas, 'Tk::Canvas', 'get_tk_canvas';

done_testing;
__END__


