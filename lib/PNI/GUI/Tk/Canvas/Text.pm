package PNI::GUI::Tk::Canvas::Text;
use parent 'PNI::GUI::Tk::Canvas::Item';
use strict;
use PNI::Error;

sub new {
    my $self = shift->SUPER::new(@_)
      or return PNI::Error::unable_to_create_item;
    my $arg = {@_};

    $arg->{text}
      or return PNI::Error::missing_required_argument;

    $arg->{y}
      or return PNI::Error::missing_required_argument;

    $arg->{x}
      or return PNI::Error::missing_required_argument;

    # TODO AGGGGIUUUSTAAAAAAAAAAAAAAAAAAAAAAAAMIIIIIII !!!!!!!
    my $node =
      $self->get_canvas->get_controller->get_scenario->get_scenario->add_node(
        type => 'Tk::Canvas::Text' );

    $node->get_input('text')->set_data( $arg->{text} );
    $node->get_input('y')->set_data( $arg->{y} );
    $node->get_input('x')->set_data( $arg->{x} );

    $self->set_node($node);

    return $self;
}

sub get_text { shift->get_node->get_input('text')->get_data }

# TODO per ora faccio questo override poi quando tutti i canvas item avranno il loro nodo posso toglierlo
sub get_tk_id { shift->get_node->get_output('tk_id')->get_data }

sub set_text {
    my $self = shift;
    my $text = shift
      or return PNI::Error::missing_required_argument;

    $self->configure( -text => $text );
}

1;
__END__

=head1 NAME

PNI::GUI::Tk::Canvas::Text - Tk::Canvas text item

=head1 METHODS

=cut

