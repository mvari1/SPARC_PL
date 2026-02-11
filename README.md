# SPARC_PL

# Add PL Project Details

# Requirements

- Vivado 2023.1
- Zybo Z7-20 board files installed

---

# How to Run the Project (Fresh Clone)

### Open Vivado TCL Console

Navigate to the project directory:

```
cd C:/path/to/SPARC_PL/scripts
```

### Recreate the Project

```
source recreate_project.tcl
```

This will:

- Create the Vivado project
- Set board repo paths
- Add custom IP
- Recreate the block diagram
- Assign addresses

---

### Generate Bitstream

In Vivado GUI:

```
Generate Bitstream
```

OR in TCL:

```
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
```

---

### Export Hardware (For Vitis)

After bitstream:

```
File → Export → Export Hardware (include bitstream)
```

---

# After Editing the Block Diagram

If you modify the Block Design:

### Always do this (edit this later):

```
validate_bd_design
generate_target all [get_files system.bd]
write_bd_tcl -force ../src/bd/system_bd.tcl
```

This updates the TCL so the repo reflects your changes.

---

### Then regenerate hardware:

```
Generate Bitstream
```

If PS settings changed (DDR, clocks, HP ports):

You must also:

```
Export Hardware (new XSA)
```

---

# What To Commit to Git

Commit:

```
src/bd/system_bd.tcl
scripts/
ip/
constraints/
```

---

# Notes

- Custom Digilent IP must exist under `ip/vivado-library`
- Board repo path is set in `recreate_project.tcl`
- The project part is `xc7z020clg400-1` (Zybo Z7-20)

---

