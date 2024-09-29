# create partitions 
foreach part_hinst ${partition_hinst_list} {
    puts $part_hinst
    create_partition -hinst ${part_hinst} -core_spacing 0.0 0.0 0.0 0.0 -rail_width 0.0 -min_pitch_left 2 -min_pitch_right 2 -min_pitch_top 2 -min_pitch_bottom 2 -reserved_layer {1 2 3 4} -pin_layer_top {2 4} -pin_layer_left {3} -pin_layer_bottom {2 4} -pin_layer_right {3} -place_halo 10.0 0.0 0.0 0.0 -route_halo 10.0 -route_halo_top_layer 7 -route_halo_bottom_layer 1 }
##
align_partition_clones -update_user_grid -pg_horizontal_grid -pg_vertical_grid -snap_all_corners
assign_partition_pins
assign_io_pins
set_db budget_virtual_opt_engine none
set_db budget_constant_model true
set_db budget_include_latency true
create_timing_budget -partitions ${partition_module_list}
commit_partitions
write_partitions -dir ${PART_DIR} -def
