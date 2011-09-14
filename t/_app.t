use strict;
use PNI::File;
use PNI::GUI::Tk::App;
use Test::More;

my $app = PNI::GUI::Tk::App->new;
isa_ok $app, 'PNI::GUI::Tk::App';

ok $app->add_controller( file => PNI::File->new );
ok my $controller = $app->add_controller, 'add_controller';
ok $app->del_controller( $controller );

done_testing;
__END__
