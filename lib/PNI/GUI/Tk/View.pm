package PNI::GUI::Tk::View;
use strict;
use PNI::Error;

sub init_view {
    my $self = shift;
    my $arg  = {@_};

    # $controller is required
    my $controller = $arg->{controller}
      or return PNI::Error::missing_required_argument;

    # $controller must be a PNI::GUI::Tk::Controller
    $controller->isa('PNI::GUI::Tk::Controller')
      or return PNI::Error::invalid_argument_type;

    $self->add( controller => $controller );
}

# return $controller : PNI::GUI::Tk::Controller
sub get_controller { shift->get('controller') }

1;
__END__

=head1 NAME

PNI::GUI::Tk::View

=cut

