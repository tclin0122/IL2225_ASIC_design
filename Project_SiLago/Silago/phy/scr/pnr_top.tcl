cd ../phy/db/part
read_db ${TOP_NAME}

foreach module $master_partition_module_list {
   read_ilm -cell $module -dir ${module}/ilm
}
flatten_ilm

place_design
ccopt_design
route_design

write_db ${TOP_NAME}/pnr
