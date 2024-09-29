set TOP_NAME serial_fir
set RUN_TIME "5us"

set REPORT_DIR  ./syn/rpt;      # synthesis reports: timing, area, etc.
set OUT_DIR ./syn/db;           # output files: netlist, sdf sdc etc.
set SOURCE_DIR ./rtl;           # rtl code that should be synthesised
set SYN_DIR ./syn;              # synthesis directory, synthesis scripts constraints etc.
set TB_DIR ./tb;                # testbench directory

set hierarchy_files [split [read [open ${SOURCE_DIR}/${TOP_NAME}_hierarchy.txt r]] "\n"]
# close ${SOURCE_DIR}/${TOP_NAME}_hierarchy.txt

foreach filename [lrange ${hierarchy_files} 0 end-1] {
    # puts "${filename}"
    if {[string equal [file extension $filename] ".vhd"]} {
        vcom -2008 -work work ${SOURCE_DIR}/${filename}
    } else {
        vlog -v2001 -work work ${SOURCE_DIR}/${filename}
    }
}
vcom -2008 -work work ${TB_DIR}/${TOP_NAME}_tb.vhd

vsim -voptargs=+acc work.${TOP_NAME}_tb
add wave sim:/${TOP_NAME}_tb/*
wave zoom full

run ${RUN_TIME}
