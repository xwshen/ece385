/*---------------------------------------------------------------------------
  --      lab9_alt.sv Zuofu Cheng                                        --
  --      lab9 top-level with lab7 compatible names                        --
  --      Useful if you don't want to rename everything from lab7          --
  --                                                                       --
  --      For use with ECE 385 Experiment 9                                --
  --      UIUC ECE Department                                              --
  ---------------------------------------------------------------------------*/
// Top-level module that integrates the Nios II system with the rest of the hardware

module lab9_alt(  	  input			CLOCK_50, 
				  input  [3:0]  KEY,
				  output [7:0]  LEDG,
				  output [17:0] LEDR,
				  output [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
				  
				  output [12:0] DRAM_ADDR,
				  output [1:0]  DRAM_BA,
				  output        DRAM_CAS_N,
				  output		    DRAM_CKE,
				  output		    DRAM_CS_N,
				  inout  [31:0] DRAM_DQ,
				  output  [3:0] DRAM_DQM,
				  output		    DRAM_RAS_N,
				  output		    DRAM_WE_N,
				  output		    DRAM_CLK
				  );
				  
				  logic  [1:0] to_sw_sig;		// handshake
				  logic  [1:0] to_hw_sig;
				  logic  [7:0] to_sw_port;		// data
				  logic  [7:0] to_hw_port;
				  
				  logic  [127:0] msg_en;
				  logic  [127:0] aes_key;
				  logic  [127:0] msg_de;
				  logic 		 io_ready;
				  logic			 aes_ready;
				  
				  // For debugging purpose
				  assign LEDR[7:0] = {to_hw_port[7:0]};
				  assign LEDG[3:0] = {to_sw_sig, to_hw_sig};
				  
				  lab7_soc NiosII (.clk_clk(CLOCK_50), 
											 .reset_reset_n(KEY[0]), 
											 .to_sw_sig_export(to_sw_sig), 
											 .to_hw_sig_export(to_hw_sig),
											 .to_sw_port_export(to_sw_port),
											 .to_hw_port_export(to_hw_port),
											 .sdram_wire_addr(DRAM_ADDR),    //  sdram_wire.addr
											 .sdram_wire_ba(DRAM_BA),      	//  .ba
											 .sdram_wire_cas_n(DRAM_CAS_N),    //  .cas_n
											 .sdram_wire_cke(DRAM_CKE),     	//  .cke
											 .sdram_wire_cs_n(DRAM_CS_N),      //  .cs_n
											 .sdram_wire_dq(DRAM_DQ),      	//  .dq
											 .sdram_wire_dqm(DRAM_DQM),     	//  .dqm
											 .sdram_wire_ras_n(DRAM_RAS_N),    //  .ras_n
											 .sdram_wire_we_n(DRAM_WE_N),      //  .we_n
											 .sdram_clk_clk(DRAM_CLK)			//  clock out to SDRAM from other PLL port
											 );
											 
				  io_module io_module0 (.clk(CLOCK_50),
										.reset_n(KEY[1]),
										.to_sw_sig(to_sw_sig),
										.to_sw_port(to_sw_port),
										.to_hw_sig(to_hw_sig),
										.to_hw_port(to_hw_port),
										.msg_en(msg_en),
										.key(aes_key),
										.msg_de(msg_de),
										.io_ready(io_ready),
										.aes_ready(aes_ready)
					);

					
					aes_controller aes_controller0 (.clk(CLOCK_50),
													.reset_n(KEY[1]),
													.msg_en(msg_en),
													.key(aes_key),
													.msg_de(msg_de),
													.io_ready(io_ready),
													.aes_ready(aes_ready),
													.cont(KEY[3])
					);
					
									
					// Displays the first 4 and the last 4 digits of the received message
					HexDriver        Hex0 (.In0(msg_de[3:0]),
											     .Out0(HEX0) );
					HexDriver        Hex1 (.In0(msg_de[7:4]),
											     .Out0(HEX1) );
					HexDriver        Hex2 (.In0(msg_de[11:8]),
											     .Out0(HEX2) );
					HexDriver        Hex3 (.In0(msg_de[15:12]),
											     .Out0(HEX3) );
					HexDriver        Hex4 (.In0(msg_de[115:112]),
											     .Out0(HEX4) );
					HexDriver        Hex5 (.In0(msg_de[119:116]),
											     .Out0(HEX5) );
					HexDriver        Hex6 (.In0(msg_de[123:120]),
											     .Out0(HEX6) );
					HexDriver        Hex7 (.In0(msg_de[127:124]),
											     .Out0(HEX7) );							  
endmodule
