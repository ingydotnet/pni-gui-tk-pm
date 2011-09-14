package PNI::GUI::Tk::Node::Perldata::Scalar;
use parent 'PNI::GUI::Tk::Node';
use strict;
use PNI;

sub new {
    my $self = shift->SUPER::new(@_);

    my $scalar_output = $self->get_node->get_output('out');
    my $text_input    = $self->get_text->get_node->get_input('text');

    $scalar_output->join_to($text_input);

    $text_input->set_data('ok');

    # TODO or return PNI::Error::unable_to_create_edge

    return $self;
}

1;

