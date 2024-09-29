set margin 16
set drra_width 248
set drra_height 256

#Create a floorplan based on the values above with suitable dimensions for width, height and margin
#create_floorplan ...
create_floorplan -site core -core_size [expr {16*$drra_height + 2*$margin}] \
    [expr {6*$drra_height + 2*$margin}] 16 16 16 16

#plan drra tiles

for {set i 0} {$i < 8} {incr i} {
 #set coordinates and place drra tiles
  set x1 [expr {double($margin * ($i + 1) + $drra_width * $i * 2)}]
    set y1 [expr {double($margin + $drra_height)}]
    set x2 [expr {double($x1 + $drra_width * 2)}]
    set y2 [expr {double($y1 + $drra_height * 2)}]

   set cell [lindex ${partition_hinst_list} $i ]
 puts $cell
 create_boundary_constraint -type fence -hinst $cell -rects [list [list $x1 $y1 $x2 $y2]]
}

for {set i 8} {$i < 16} {incr i} {
 #set coordinates and place drra tiles
  set x1 [expr {double($margin * ($i - 7) + $drra_width * ($i - 8)*2)}]
    set y1 [expr {double($margin * 2 + $drra_height * 3)}]
    set x2 [expr {double($x1 + $drra_width * 2)}]
    set y2 [expr {double($y1 + $drra_height * 2)}]

   set cell [lindex ${partition_hinst_list} $i ]
 puts $cell
 create_boundary_constraint -type fence -hinst $cell -rects [list [list $x1 $y1 $x2 $y2]]
}

set_db add_rings_target default ; set_db add_rings_extend_over_row 0 ; set_db add_rings_ignore_rows 0 ; set_db add_rings_avoid_short 0 ; set_db add_rings_skip_shared_inner_ring none ; set_db add_rings_stacked_via_top_layer M9 ; set_db add_rings_stacked_via_bottom_layer M1 ; set_db add_rings_via_using_exact_crossover_size 1 ; set_db add_rings_orthogonal_only true ; set_db add_rings_skip_via_on_pin {  standardcell } ; set_db add_rings_skip_via_on_wire_shape {  noshape }
add_rings -nets {VDD VSS} -type core_rings -follow core -layer {top M1 bottom M1 left M2 right M2} -width {top 3.2 bottom 3.2 left 3.2 right 3.2} -spacing {top 3.2 bottom 3.2 left 3.2 right 3.2} -offset {top 3.2 bottom 3.2 left 3.2 right 3.2} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area false ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape none ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer M9 ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
add_stripes -nets {VDD VSS} -layer M2 -direction vertical -width 1.6 -spacing 1.6 -set_to_set_distance 112 -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit M9 -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit M9 -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none
set_db route_special_via_connect_to_shape { padring ring stripe blockring blockpin noshape blockwire corewire followpin iowire noshape }
route_special -connect {block_pin pad_pin pad_ring core_pin floating_stripe} -layer_change_range { M1(1) M9(9) } -block_pin_target {nearest_target} -pad_pin_port_connect {all_port one_geom} -pad_pin_target {nearest_target} -core_pin_target {first_after_row_end} -floating_stripe_target {block_ring pad_ring ring stripe ring_pin block_pin followpin} -allow_jogging 1 -crossover_via_layer_range { M1(1) M9(9) } -nets { VDD VSS } -allow_layer_change 1 -block_pin use_lef -target_via_layer_range { M1(1) M9(9) }
