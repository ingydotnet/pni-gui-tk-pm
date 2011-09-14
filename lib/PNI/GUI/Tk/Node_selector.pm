package PNI::GUI::Tk::Node_selector;
use parent qw( PNI::Item PNI::GUI::Tk::View );
use strict;
use PNI;
use PNI::Error;
use PNI::GUI::Tk::Canvas::Window;
use Tk::MatchEntry;

sub new {
    my $self = shift->SUPER::new;
    my $arg  = {@_};

    $self->init_view(@_);

    my $y = $arg->{y};
    $self->add( y => $y );

    my $x = $arg->{x};
    $self->add( x => $x );

    my @nodes = PNI::node_list;

    my $entry = $arg->{entry};

    my $canvas = $self->get_controller->get_canvas;

    my $tk_matchentry = $canvas->get_tk_canvas->MatchEntry(
        -autoshrink   => 1,
        -autosort     => 1,
        -choices      => \@nodes,
        -command      => sub { return $self->choosen( \$entry ); },
        -entercmd     => sub { return $self->choosen( \$entry ); },
        -ignorecase   => 1,
        -maxheight    => 10,
        -textvariable => \$entry,
      );

    my $window = PNI::GUI::Tk::Canvas::Window->new(
        canvas => $canvas,
        window => $tk_matchentry,
        y      => $y,
        x      => $x
    ) or return PNI::Error::unable_to_create_item;

    $self->add( window => $window );

    return $self
}

sub choosen {
    my $self       = shift;
    my $entry_ref  = shift;
    my $entry      = ${$entry_ref};
    my $controller = $self->get_controller;

    # Trim $entry
    $entry =~ s/^\s//g;
    $entry =~ s/\s$//g;

    # If $entry is not valid, del node_selector
    if ( $entry !~ /./ ) {
        return $controller->del_node_selector;
    }

    my $y = $self->get_y;
    my $x = $self->get_x;

    for my $node_type (PNI::node_list) {

        # Adjust case
        if ( lc $node_type eq lc $entry ) {

            # Create choosen node.
            return $controller->add_node(
                center_y => $y,
                center_x => $x,
                type     => $node_type,
            );
        }
    }

    # If $entry is something like '$foo', create scalar foo.
    if ( $entry =~ m/^\$/ ) {

        return $controller->add_node(
            center_y => $y,
            center_x => $x,
            label    => $entry,
            type     => 'Perldata::Scalar',
        );

    }

    # Finally, if $entry is a common string, write a PNI::GUI::Comment.
    return $controller->add_comment(
        center_y => $y,
        center_x => $x,
        content  => $entry,
    );
}

# return $window : PNI::GUI::Tk::Window
sub get_window { shift->get('window') }

# return $y
sub get_y { shift->get('y') }

# return $x
sub get_x { shift->get('x') }

1;
__END__

=head1 NAME

PNI::GUI::Tk::Node_selector

=head1 METHODS

=head2 C<choosen>

=head2 C<get_canvas>

=head2 C<get_controller>

=head2 C<get_window>

=head2 C<get_y>

=head2 C<get_x>

=cut

