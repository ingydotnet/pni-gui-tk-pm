use strict;
use PNI::GUI::Tk::App;
use PNI::GUI::Tk::Canvas;
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

my $y1   = 10;
my $y2   = 10;
my $x1   = 10;
my $x2   = 10;
my $item = PNI::GUI::Tk::Canvas::Rectangle->new(
    canvas => $canvas,
    y1     => $y1,
    y2     => $y2,
    x1     => $x1,
    x2     => $x2,
);
isa_ok $item, 'PNI::GUI::Tk::Canvas::Rectangle';

isa_ok $item->get_tk_canvas, 'Tk::Canvas', 'get_tk_canvas';

done_testing;
__END__

