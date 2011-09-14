use strict;
use PNI::GUI::Tk::App;
use PNI::GUI::Tk::Canvas;
use PNI::GUI::Tk::Canvas::Line;
use PNI::GUI::Tk::Controller;
use Test::More;

my $app        = PNI::GUI::Tk::App->new;
my $controller = PNI::GUI::Tk::Controller->new( app => $app );
my $tk_canvas  = MainWindow->new->Canvas;
my $canvas     = PNI::GUI::Tk::Canvas->new(
    controller => $controller,
    tk_canvas  => $tk_canvas,
);

my $start_x = 10;
my $start_y = 10;
my $end_x   = 10;
my $end_y   = 10;
my $item    = PNI::GUI::Tk::Canvas::Line->new(
    canvas  => $canvas,
    start_x => $start_x,
    start_y => $start_y,
    end_x   => $end_x,
    end_y   => $end_y,
);
isa_ok $item, 'PNI::GUI::Tk::Canvas::Line';

isa_ok $item->get_tk_canvas, 'Tk::Canvas', 'get_tk_canvas';

done_testing;
__END__


