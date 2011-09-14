use strict;
use PNI::GUI::Tk::App;
use PNI::GUI::Tk::Controller;
use PNI::GUI::Tk::Menu;
use Test::More;

my $app        = PNI::GUI::Tk::App->new;
my $controller = PNI::GUI::Tk::Controller->new( app => $app );
my $menu = PNI::GUI::Tk::Menu->new( controller => $controller );

isa_ok $menu, 'PNI::GUI::Tk::Menu'; 

done_testing;
__END__
