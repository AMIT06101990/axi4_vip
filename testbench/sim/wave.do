onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/pif/clk
add wave -noupdate /top_tb/pif/reset
add wave -noupdate -expand -group WRITE_ADDRESS_PHASE /top_tb/pif/AWID
add wave -noupdate -expand -group WRITE_ADDRESS_PHASE /top_tb/pif/AWADDR
add wave -noupdate -expand -group WRITE_ADDRESS_PHASE /top_tb/pif/AWLEN
add wave -noupdate -expand -group WRITE_ADDRESS_PHASE /top_tb/pif/AWSIZE
add wave -noupdate -expand -group WRITE_ADDRESS_PHASE /top_tb/pif/AWBURST
add wave -noupdate -expand -group WRITE_ADDRESS_PHASE /top_tb/pif/AWLOCK
add wave -noupdate -expand -group WRITE_ADDRESS_PHASE /top_tb/pif/AWCACHE
add wave -noupdate -expand -group WRITE_ADDRESS_PHASE /top_tb/pif/AWPROT
add wave -noupdate -expand -group WRITE_ADDRESS_PHASE /top_tb/pif/AWVALID
add wave -noupdate -expand -group WRITE_ADDRESS_PHASE /top_tb/pif/AWREADY
add wave -noupdate -expand -group WRITE_DATA_PHASE /top_tb/pif/WID
add wave -noupdate -expand -group WRITE_DATA_PHASE /top_tb/pif/WDATA
add wave -noupdate -expand -group WRITE_DATA_PHASE /top_tb/pif/WSTRB
add wave -noupdate -expand -group WRITE_DATA_PHASE /top_tb/pif/WLAST
add wave -noupdate -expand -group WRITE_DATA_PHASE /top_tb/pif/WVALID
add wave -noupdate -expand -group WRITE_DATA_PHASE /top_tb/pif/WREADY
add wave -noupdate -expand -group WRITE_RESP_PHASE /top_tb/pif/BID
add wave -noupdate -expand -group WRITE_RESP_PHASE /top_tb/pif/BRESP
add wave -noupdate -expand -group WRITE_RESP_PHASE /top_tb/pif/BVALID
add wave -noupdate -expand -group WRITE_RESP_PHASE /top_tb/pif/BREADY
add wave -noupdate -expand -group READ_ADDRESS_PHASE /top_tb/pif/ARID
add wave -noupdate -expand -group READ_ADDRESS_PHASE /top_tb/pif/ARADDR
add wave -noupdate -expand -group READ_ADDRESS_PHASE /top_tb/pif/ARLEN
add wave -noupdate -expand -group READ_ADDRESS_PHASE /top_tb/pif/ARSIZE
add wave -noupdate -expand -group READ_ADDRESS_PHASE /top_tb/pif/ARBURST
add wave -noupdate -expand -group READ_ADDRESS_PHASE /top_tb/pif/ARLOCK
add wave -noupdate -expand -group READ_ADDRESS_PHASE /top_tb/pif/ARCACHE
add wave -noupdate -expand -group READ_ADDRESS_PHASE /top_tb/pif/ARPROT
add wave -noupdate -expand -group READ_ADDRESS_PHASE /top_tb/pif/ARVALID
add wave -noupdate -expand -group READ_ADDRESS_PHASE /top_tb/pif/ARREADY
add wave -noupdate -expand -group READ_DATA_PHASE /top_tb/pif/RID
add wave -noupdate -expand -group READ_DATA_PHASE /top_tb/pif/RDATA
add wave -noupdate -expand -group READ_DATA_PHASE /top_tb/pif/RRESP
add wave -noupdate -expand -group READ_DATA_PHASE /top_tb/pif/RLAST
add wave -noupdate -expand -group READ_DATA_PHASE /top_tb/pif/RVALID
add wave -noupdate -expand -group READ_DATA_PHASE /top_tb/pif/RREADY
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {58 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {154 ns}

quit -force
