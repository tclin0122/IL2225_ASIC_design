# Record on labs

## Task 1 - RTL simulation
Go to the correct folder in tb and run 

```
vsim -do simulation.tcl
```

## Task 2 - Top down
Start dc shell and run the synthesis

```
source scr/dc_flat.tcl
```

## Task 3 - Bottom up
```
source scr/dc_bottomup.tcl
```

## Task 4 - Physical design
1. Put required script file into the folder (/phy/scr)
    -  Put mmmc.tcl into the folder
    -  Put global_variables.tcl
    -  Put read_design.tcl into the folder
    -  Add floorplan.tcl into the folder
    -  Add power_plan.tcl into the folder

