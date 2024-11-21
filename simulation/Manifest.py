
action = "simulation"
sim_tool = "modelsim"
sim_top = "priority_encoder" + "_tb"
gui_mode = True
vsim_args = " -do vsim_gui.do -voptargs=+acc " if gui_mode else " -c -do vsim_tcl.do "

vlog_opt = " -define default_nettype=none"

sim_post_cmd = "vsim" + vsim_args + sim_top

modules = {
    "local": [
        "../testbench/"
    ],
}