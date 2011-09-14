package PNI::GUI::Tk::Canvas::Group;
use strict;
use PNI::Error;
use PNI::GUI::Tk::Canvas::Text;

sub init_canvas_group {
    my $self = shift;

    # TODO dovrei togliere i tk_id e usare add_item del_item get_items
    # anche il get_tk_ids si puo fare sol con gli item
    $self->add( items => [] );

    $self->add( tk_ids => [] );
}

sub add_canvas_item {
    my $self        = shift;
    my $canvas_item = shift
      or return PNI::Error::missing_required_argument;

    $self->add_tk_id( $canvas_item->get_tk_id );

    push @{$self->get('items')},$canvas_item;

    return $canvas_item
}

sub add_line {}

sub add_rectangle {}

sub add_text {
    my $self = shift;
    my $text = PNI::GUI::Tk::Canvas::Text->new(@_)
      or return PNI::Error::unable_to_create_item;

    return $self->add_canvas_item($text)
}

# TODO questa sub e' da deprecare ,una volta che ho implementato tutti gli add_line, add_rectangle,ecc
sub add_tk_id {
    my $self  = shift;
    my $tk_id = shift
      or return PNI::Error::missing_required_argument;

    push @{ $self->get('tk_ids') }, $tk_id;
}

sub del_canvas_item{
    my $self        = shift;
    my $canvas_item = shift
      or return PNI::Error::missing_required_argument;

  $canvas_item->delete;

  delete $self->get('items')->{$canvas_item};

}

# TODO questa sub e' da deprecare ,una volta che ho implementato tutti gli add_line, add_rectangle,ecc
sub get_tk_ids { @{ shift->get('tk_ids') } }

1
__END__

=head1 NAME

PNI::GUI::Tk::Canvas::Group

=cut

