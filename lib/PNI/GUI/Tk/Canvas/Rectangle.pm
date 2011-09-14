package PNI::GUI::Tk::Canvas::Rectangle;
use parent 'PNI::GUI::Tk::Canvas::Item';
use strict;
use PNI::Error;

sub new {
    my $self = shift->SUPER::new(@_)
      or return PNI::Error::unable_to_create_item;
    my $arg = {@_};

    $arg->{y1}
      or return PNI::Error::missing_required_argument;

    $arg->{y2}
      or return PNI::Error::missing_required_argument;

    $arg->{x1}
      or return PNI::Error::missing_required_argument;

    $arg->{x2}
      or return PNI::Error::missing_required_argument;

    $self->set(
        tk_id => $self->get_tk_canvas->createRectangle(
            $arg->{x1}, $arg->{y1}, $arg->{x2}, $arg->{y2}
        )
    );

    return $self;
}

1;
__END__

=head1 NAME

PNI::GUI::Tk::Canvas::Rectangle - Tk::Canvas rectangle item

=cut

