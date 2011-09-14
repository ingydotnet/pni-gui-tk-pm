use strict;
use PNI::GUI::Tk::App;
use PNI::GUI::Tk::Canvas;
use PNI::GUI::Tk::Controller;
use Test::More;

my $app = PNI::GUI::Tk::App->new;
my $controller = PNI::GUI::Tk::Controller->new( app => $app );
my $tk_canvas = MainWindow->new->Canvas;

my $canvas   = PNI::GUI::Tk::Canvas->new( 
    controller => $controller ,
    tk_canvas => $tk_canvas,
);
isa_ok $canvas, 'PNI::GUI::Tk::Canvas';

done_testing;
__END__
