use strict;
use PNI::GUI::Tk::App;
use PNI::GUI::Tk::Canvas;
use PNI::GUI::Tk::Canvas::Item;
use PNI::GUI::Tk::Canvas::Group;
use PNI::GUI::Tk::Controller;
use Test::More;

my $app        = PNI::GUI::Tk::App->new;
my $controller = PNI::GUI::Tk::Controller->new( app => $app );
my $tk_canvas  = MainWindow->new->Canvas;
my $canvas     = PNI::GUI::Tk::Canvas->new(
    controller => $controller,
    tk_canvas  => $tk_canvas,
);


package Test::PNI::GUI::Tk::Canvas::Group;
use parent qw( PNI::Item PNI::GUI::Tk::Canvas::Group );
use strict;

sub new {
    my $self = shift->SUPER::new;
    $self->init_canvas_group(@_);
    return $self;
}

package main;

my $group = Test::PNI::GUI::Tk::Canvas::Group->new( canvas => $canvas );
isa_ok $group, 'PNI::GUI::Tk::Canvas::Group';

done_testing;
__END__

