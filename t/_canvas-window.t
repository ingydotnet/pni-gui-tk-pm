use strict;
use PNI::GUI::Tk::App;
use PNI::GUI::Tk::Controller;
use PNI::GUI::Tk::Canvas::Window;
use Test::More;

my $app        = PNI::GUI::Tk::App->new;
my $controller = PNI::GUI::Tk::Controller->new( app => $app );
my $canvas     = $controller->get_canvas;
my $button     = $canvas->get_tk_canvas->Button;
my $y          = 10;
my $x          = 10;

my $window = PNI::GUI::Tk::Canvas::Window->new(
    canvas => $canvas,
    y      => $y,
    x      => $x,
    window => $button,
);
isa_ok $window, 'PNI::GUI::Tk::Canvas::Window';

done_testing;
__END__
