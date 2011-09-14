use strict;
use PNI::GUI::Tk::App;
use PNI::GUI::Tk::Controller;
use PNI::GUI::Tk::Scenario;
use PNI::Scenario;
use Test::More;

my $app          = PNI::GUI::Tk::App->new;
my $controller   = PNI::GUI::Tk::Controller->new( app => $app );
my $pni_scenario = PNI::Scenario->new;
my $scenario     = PNI::GUI::Tk::Scenario->new(
    controller => $controller,
    scenario   => $pni_scenario,
);
isa_ok $scenario, 'PNI::GUI::Tk::Scenario';

isa_ok $scenario->get_file, 'PNI::File';
is $scenario->get_scenario, $pni_scenario;

done_testing;
__END__

