DOCKER=docker
PWD = $(shell pwd)
DOCKERARGS = run --rm -v $(PWD):/src -w /src
YOSYS     = $(DOCKER) $(DOCKERARGS) ghdl/synth:beta yosys
NEXTPNR   = $(DOCKER) $(DOCKERARGS) ghdl/synth:nextpnr-ecp5 nextpnr-ecp5
ECPPACK   = $(DOCKER) $(DOCKERARGS) ghdl/synth:trellis ecppack
OPENOCD   = $(DOCKER) $(DOCKERARGS) --device /dev/bus/usb ghdl/synth:prog openocd

VFILES = $(shell find . -name "*.v")

# ECP5-EVN
LPF=constraints/ecp5-hub75b.lpf
PACKAGE=CABGA381
NEXTPNR_FLAGS=--25k --freq 25
#OPENOCD_JTAG_CONFIG=openocd/ecp5-evn.cfg
OPENOCD_JTAG_CONFIG=openocd/ft232.cfg
OPENOCD_DEVICE_CONFIG=openocd/LFE5UM5G-25F.cfg

all: main.bit

main.json: $(VFILES)
	$(YOSYS) -p "synth_ecp5 -json $@" $(VFILES)

main_out.config: main.json $(LPF)
	$(NEXTPNR) --json $< --lpf $(LPF) --textcfg $@ $(NEXTPNR_FLAGS) --package $(PACKAGE)

main.bit: main_out.config
	$(ECPPACK) --svf main.svf $< $@

main.svf: main.bit

prog: main.svf
	$(OPENOCD) -f $(OPENOCD_JTAG_CONFIG) -f $(OPENOCD_DEVICE_CONFIG) -c "transport select jtag; init; svf $<; exit"


clean:
	@rm -f work-obj08.cf *.bit *.json *.svf *.config

.PHONY: clean prog
.PRECIOUS: main.json main_out.config main.bit
