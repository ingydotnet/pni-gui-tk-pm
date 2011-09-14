package PNI::GUI::Tk::Scenario;
use parent qw( PNI::GUI::Scenario PNI::GUI::Tk::View );
use strict;
use PNI::Error;
use PNI::GUI::Node;
use PNI::GUI::Tk::Comment;
use PNI::GUI::Tk::Edge;
use PNI::GUI::Tk::Node;

sub new {
    my $self = shift->SUPER::new(@_)
      or return PNI::Error::unable_to_create_item;

    $self->init_view(@_);

    return $self;
}

# return $comment : PNI::GUI::Tk::Comment
sub add_comment {
    my $self = shift;

    my $comment = PNI::GUI::Tk::Comment->new(
        controller => $self->get_controller,
        @_
    ) or return PNI::Error::unable_to_create_item;

    $self->get('comments')->{ $comment->id } = $comment;

    return $comment;

}

# return $edge : PNI::GUI::Tk::Edge
sub add_edge {
    my $self = shift;

    my $edge = PNI::GUI::Tk::Edge->new(
        controller => $self->get_controller,
        @_
    ) or return PNI::Error::unable_to_create_item;

    $self->get('edges')->{ $edge->id } = $edge;

    return $edge;
}

# return $node : PNI::GUI::Tk::Node
sub add_node {
    my $self = shift;

# TODO questo sarebe sbagliato, funziona solo perche' non si accavallano i nomi degli argomenti
#      infatti in add_edge mi dava problemi
    my $node = $self->get_scenario->add_node(@_)
      or return PNI::Error::unable_to_create_item;

# Check if a specific node view is available, or defaults to PNI::GUI::Tk::Node.
    my $node_view      = 'PNI::GUI::Tk::Node::' . $node->get_type;
    my $node_view_path = $node_view . '.pm';
    $node_view_path =~ s/::/\//g;
    eval { require $node_view_path }
      or do { $node_view = 'PNI::GUI::Tk::Node' };

    my $gui_node = $node_view->new(
        controller => $self->get_controller,
        node       => $node,
        @_,
    ) or return PNI::Error::unable_to_create_item;

    $self->get('nodes')->{ $gui_node->id } = $gui_node;

    return $gui_node;
}

sub del_node {
    my $self = shift;
    my $node = shift
      or return PNI::Error::missing_required_argument;

    delete $self->get('nodes')->{ $node->id };
}

sub del_edge {
    my $self = shift;
    my $edge = shift
      or return PNI::Error::missing_required_argument;

    delete $self->get('edges')->{ $edge->id };
}

# return @inputs : PNI::GUI::Tk::Input
sub get_inputs {
    my $self = shift;
    my @inputs;

    # TODO fai code cleaning con grep e map come fa Marcos
    for my $node ( $self->get_nodes ) {
        push @inputs, $node->get_inputs;
    }

    return @inputs;
}

# return @nodes : PNI::GUI::Tk::Node
sub get_nodes { values %{ shift->get('nodes') }; }

# return @outputs : PNI::GUI::Tk::Output
sub get_outputs {
    my $self = shift;
    my @outputs;

    # TODO fai code cleaning con grep e map come fa Marcos
    for my $node ( $self->get_nodes ) {
        push @outputs, $node->get_outputs;
    }

    return @outputs;
}

1;
__END__

=head1 NAME

PNI::GUI::Tk::Scenario

=head1 METHODS

=cut

