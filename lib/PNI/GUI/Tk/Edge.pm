package PNI::GUI::Tk::Edge;
use parent qw ( PNI::GUI::Edge PNI::GUI::Tk::View );
use strict;
use PNI::Error;
use PNI::GUI::Tk::Canvas::Line;

sub new {
    my $self = shift->SUPER::new(@_)
      or return PNI::Error::unable_to_create_item;
    my $arg = {@_};

    $self->init_view(@_)
        or return PNI::Error::generic;

    my $controller = $self->get_controller;

    # source is not required but should be a PNI::GUI::Tk::Slot::Out
    my $source = $arg->{source};
    if ( defined $source ) {
        $source->isa('PNI::GUI::Tk::Slot::Out')
          or return PNI::Error::invalid_argument_type;
    }
    $self->add( source => $source );

    # target is not required but should be a PNI::GUI::Tk::Slot::In
    my $target = $arg->{target};
    if ( defined $target ) {
        $target->isa('PNI::GUI::Tk::Slot::In')
          or return PNI::Error::invalid_argument_type;
    }
    $self->add( target => $target );

    # TODO metti bene a posto sti end_y, end_x ecc, a rigor di logica dovrebbero
    #      andare in PNI::GUI::Edge
    my $end_y   = $arg->{end_y}   || $target->get_center_y;
    my $end_x   = $arg->{end_x}   || $target->get_center_x;
    my $start_y = $arg->{start_y} || $source->get_center_y;
    my $start_x = $arg->{start_x} || $source->get_center_x;

    my $line = PNI::GUI::Tk::Canvas::Line->new(
        canvas  => $controller->get_canvas,
        end_y   => $end_y,
        end_x   => $end_x,
        start_y => $start_y,
        start_x => $start_x,
    ) or return PNI::Error::unable_to_create_item;
    $line->configure( -arrow => 'none' );
    $self->add( line => $line );

    # finally, connect edge if defined source and/or target
    defined $source and $controller->connect_edge_to_output( $self, $source );
    defined $target and $controller->connect_edge_to_input( $self, $target );

    return $self;
}

sub default_tk_bindings {
    my $self       = shift;
    my $controller = $self->get_controller;
    my $line_tk_id = $self->get_line->get_tk_id;
    my $tk_canvas  = $controller->get_canvas->get_tk_canvas;

    $tk_canvas->bind( $line_tk_id,
        '<ButtonPress-1>' => [ sub { $controller->select_edge(@_); }, $self ] );

}

sub get_end_y { shift->get_line->get_end_y }

sub get_end_x { shift->get_line->get_end_x }

# return $line : PNI::GUI::Tk::Canvas::Line
sub get_line { shift->get('line') }

# return $source : PNI::GUI::Tk::Slot::Out
sub get_source { shift->get('source') }

# return $source_node : PNI::GUI::Tk::Node
sub get_source_node { shift->get_source->get_node }

sub get_start_y { shift->get_line->get_start_y }

sub get_start_x { shift->get_line->get_start_x }

# return $target : PNI::GUI::Tk::Slot::In
sub get_target { shift->get('target') }

# return $target_node : PNI::GUI::Tk::Node
sub get_target_node { shift->get_target->get_node }

sub set_end_y {
    my $self  = shift;
    my $end_y = shift
      or return PNI::Error::missing_required_argument;

    $self->get_line->set_end_y($end_y);
}

sub set_end_x {
    my $self  = shift;
    my $end_x = shift
      or return PNI::Error::missing_required_argument;

    $self->get_line->set_end_x($end_x);
}

sub set_start_y {
    my $self    = shift;
    my $start_y = shift
      or return PNI::Error::missing_required_argument;

    $self->get_line->set_start_y($start_y);
}

sub set_start_x {
    my $self    = shift;
    my $start_x = shift
      or return PNI::Error::missing_required_argument;

    $self->get_line->set_start_x($start_x);
}

sub set_source {
    my $self   = shift;
    my $source = shift
      or return PNI::Error::missing_required_argument;
    $source->isa('PNI::GUI::Tk::Slot::Out')
      or return PNI::Error::invalid_argument_type;

    my $line = $self->get_line;
    $line->set_start_y( $source->get_center_y );
    $line->set_start_x( $source->get_center_x );

# TODO rivedi bene sta parte del set_target e del set_source a livello di design
#      per ora e' una patch
    $self->get_edge->set( source => $source->get_slot );

    $self->set( source => $source );
}

sub set_target {
    my $self   = shift;
    my $target = shift
      or return PNI::Error::missing_required_argument;
    $target->isa('PNI::GUI::Tk::Slot::In')
      or return PNI::Error::invalid_argument_type;

    my $line = $self->get_line;
    $line->set_end_y( $target->get_center_y );
    $line->set_end_x( $target->get_center_x );

# TODO rivedi bene sta parte del set_target e del set_source a livello di design
#      per ora e' una patch
    $self->get_edge->set( target => $target->get_slot );

    $self->set( target => $target );
}

1;
__END__

=head1 NAME

PNI::GUI::Tk::Edge - 

=head1 METHODS

=head2 C<default_tk_bindings>

=head2 C<get_end_x>

=head2 C<get_end_y>

=head2 C<get_start_x>

=head2 C<get_start_y>

=head2 C<set_source>

=head2 C<set_target>

=cut

