use strict;
use Test::More;

BEGIN {
    use_ok($_)
      or BAIL_OUT(" $_ module does not compile :-(")
      for qw(
      PNI::GUI::Tk
      PNI::GUI::Tk::App
      PNI::GUI::Tk::Comment
      PNI::GUI::Tk::Canvas
      PNI::GUI::Tk::Canvas::Group
      PNI::GUI::Tk::Canvas::Item
      PNI::GUI::Tk::Canvas::Line
      PNI::GUI::Tk::Canvas::Rectangle
      PNI::GUI::Tk::Canvas::Text
      PNI::GUI::Tk::Canvas::Window
      PNI::GUI::Tk::Controller
      PNI::GUI::Tk::Edge
      PNI::GUI::Tk::Menu
      PNI::GUI::Tk::Node
      PNI::GUI::Tk::Node_selector
      PNI::GUI::Tk::Scenario
      PNI::GUI::Tk::Slot
      PNI::GUI::Tk::Slot::In
      PNI::GUI::Tk::Slot::Out
      PNI::GUI::Tk::View
      PNI::GUI::Tk::Window
    );
}

# checking inheritance
isa_ok( "PNI::GUI::Tk::$_", "PNI::GUI::$_" ) for qw(
  Comment
  Edge
  Node
  Scenario
);
isa_ok( "PNI::GUI::Tk::$_", 'PNI::Item' ) for qw(
  App
  Canvas
  Controller
  Edge
  Menu
  Node_selector
  Window
);
isa_ok( "PNI::GUI::Tk::Canvas::$_", 'PNI::GUI::Tk::Canvas::Item' ) for qw(
  Rectangle
  Line
  Text
  Window
);
isa_ok( "PNI::GUI::Tk::$_", 'PNI::GUI::Tk::View' ) for qw(
  Node
  Canvas
  Menu
  Window
);

# checking subs
can_ok( 'PNI::GUI::Tk::App', $_ ) for qw(
  new
  add_controller
  del_controller
  run
);
can_ok( 'PNI::GUI::Tk::Canvas', $_ ) for qw(
  new
  connect_or_destroy_edge
  connecting_edge_tk_bindings
  default_tk_bindings
  double_click
  get_controller
  get_tk_canvas
  opened_node_selector
);
can_ok( 'PNI::GUI::Tk::Canvas::Group', $_ ) for qw(
  add_tk_id
  get_tk_ids
  init_canvas_group
);
can_ok( 'PNI::GUI::Tk::Canvas::Item', $_ ) for qw(
  new
  configure
  delete
  get_canvas
  get_node
  get_tk_id
  set_node
);
can_ok( 'PNI::GUI::Tk::Canvas::Line', $_ ) for qw(
  new
  get_end_y
  get_end_x
  get_start_y
  get_start_x
  set_end_y
  set_end_x
  set_start_y
  set_start_x
);
can_ok( 'PNI::GUI::Tk::Canvas::Rectangle', $_ ) for qw(
  new
);
can_ok( 'PNI::GUI::Tk::Canvas::Text', $_ ) for qw(
  new
);
can_ok( 'PNI::GUI::Tk::Canvas::Window', $_ ) for qw(
  new
);
can_ok( 'PNI::GUI::Tk::Comment', $_ ) for qw(
  new
  get_canvas_text
);
can_ok( 'PNI::GUI::Tk::Controller', $_ ) for qw(
  new
  add_node
  add_node_selector
  close_window
  connect_edge_to_input
  connect_edge_to_output
  connecting_edge
  default_tk_bindings
  del_edge
  del_node_selector
  get_app
  get_canvas
  get_node_selector
  get_tk_canvas
  get_tk_main_window
  get_scenario
  get_window
  open_pni_file
  save_pni_file
  select_edge
);
can_ok( 'PNI::GUI::Tk::Edge', $_ ) for qw(
  new
  default_tk_bindings
  get_controller
  get_end_y
  get_end_x
  get_line
  get_source
  get_start_y
  get_start_x
  set_end_y
  set_end_x
  set_start_y
  set_start_x
  set_source
  set_target
);
can_ok( 'PNI::GUI::Tk::Menu', $_ ) for qw(
  new
  get_controller
);
can_ok( 'PNI::GUI::Tk::Node', $_ ) for qw(
  new
  add_input
  add_output
  default_tk_bindings
  get_border
  get_controller
  get_input_tk_ids
  get_inputs
  get_output_tk_ids
  get_outputs
  get_text
  move
);
can_ok( 'PNI::GUI::Tk::Node_selector', $_ ) for qw(
  new
  choosen
  get_window
  get_y
  get_x
);
can_ok( 'PNI::GUI::Tk::Scenario', $_ ) for qw(
  new
  add_edge
  add_node
  del_edge
  get_controller
  get_inputs
  get_nodes
  get_outputs
);
can_ok( 'PNI::GUI::Tk::Slot', $_ ) for qw(
  hide_info
);
can_ok( 'PNI::GUI::Tk::Slot::In', $_ ) for qw(
  new
  default_tk_bindings
  del_edge
  get_border
  get_center_y
  get_center_x
  get_edge
  get_slot
  get_tk_id
  hide_info
  is_connected
  move
  set_center_y
  set_center_x
  set_edge
  show_info
);
can_ok( 'PNI::GUI::Tk::Slot::Out', $_ ) for qw(
  new
  default_tk_bindings
  add_edge
  del_edge
  get_border
  get_center_y
  get_center_x
  get_edges
  get_slot
  get_tk_id
  set_center_y
  set_center_x
  show_info
);
can_ok( 'PNI::GUI::Tk::View', $_ ) for qw(
  get_controller
  init_view
);
can_ok( 'PNI::GUI::Tk::Window', $_ ) for qw(
  new
  get_tk_main_window
);

done_testing;
