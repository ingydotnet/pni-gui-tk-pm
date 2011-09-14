use strict;
use PNI;
use PNI::GUI::Tk::App;
use PNI::GUI::Tk::Controller;
use PNI::GUI::Tk::Window;
use PNI::Node::Tk;
use Test::More;

my $app        = PNI::GUI::Tk::App->new;
my $controller = PNI::GUI::Tk::Controller->new( app => $app );

my $window = PNI::GUI::Tk::Window->new( controller => $controller );
isa_ok $window, 'PNI::GUI::Tk::Window';

isa_ok $window->get_controller, 'PNI::GUI::Tk::Controller', 'get_controller';
is $window->get_controller, $controller, 'get_controller';
isa_ok $window->get_tk_main_window, 'Tk::MainWindow', 'get_tk_main_window';

# show the window
ok PNI::task;

# wait a moment so user can see the window
sleep 1;

done_testing;
__END__

