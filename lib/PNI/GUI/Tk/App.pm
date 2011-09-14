package PNI::GUI::Tk::App;
use parent 'PNI::Item';
use strict;
use PNI;
use PNI::GUI::Tk;
use PNI::GUI::Tk::Controller;
use Tk;

my $i_am_running;

sub new {
    my $self  = shift->SUPER::new;
    my $arg   = {@_};

    $self->add( controller => {} );

    return $self
}

# return $controller : PNI::GUI::Tk::Controller
sub add_controller {
    my $self = shift;

    my $controller = PNI::GUI::Tk::Controller->new( app => $self, @_ )
      or return PNI::Error::unable_to_create_item;

    return $self->get('controller')->{ $controller->id } = $controller
}

sub del_controller {
    my $self       = shift;
    my $controller = shift
      or return PNI::Error::missing_required_argument;

    delete $self->get('controller')->{ $controller->id };
    undef $controller;

    # Exit if it is the only controller left.
    if ( keys %{ $self->get('controller') } ) {
        return 1;
    }
    else {
        Tk::exit;
    }
}

sub run {

    # only one App should be running
    return if $i_am_running;
    $i_am_running = 1;

    # Create the first controller 
    shift->add_controller(@_);

    PNI::loop;
}

1
__END__

=head1 NAME

PNI::GUI::Tk::App

=head1 SYNOPSIS 

    my $app = PNI::GUI::Tk::App->new;

    $app->run; 

=head1 METHODS

=head2 C<add_controller>

    # create a new controller
    my $controller = $app->add_controller;

    # open a controller and load a .pni file
    my $controller2 = $app->add_controller( file => $pni_file );

=head2 C<del_controller>

    $app->del_controller( $controller );

Remove the specified controller. If there is only one controller, the application exits.

=head2 C<run>

    $app->run;


    my $file = PNI::File->new( path => 'path/to/my/file.pni' );
    $app->run( file => $file );

=cut

