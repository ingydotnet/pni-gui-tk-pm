package PNI::GUI::Tk::Canvas::Window;
use parent 'PNI::GUI::Tk::Canvas::Item';
use strict;
use PNI::Error;

sub new {
    my $class = shift;
    my $arg   = {@_};
    my $self  = $class->SUPER::new(@_)
      or return PNI::Error::unable_to_create_item;

    $arg->{window}
      or return PNI::Error::missing_required_argument;

    $arg->{y}
      or return PNI::Error::missing_required_argument;

    $arg->{x}
      or return PNI::Error::missing_required_argument;

    $self->set(
        tk_id => $self->get_tk_canvas->createWindow(
            $arg->{x}, $arg->{y}, -window => $arg->{window}
        )
    );

    return $self;
}

1;
__END__

=head1 NAME

PNI::GUI::Tk::Canvas::Window - Tk::Canvas window item

=cut

