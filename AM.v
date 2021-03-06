// ce este comentat era ce aveam eu initial si ce nu functiona

module reg8Pld(di,do,clk,pld);
	input[7:0]di;
	output reg[7:0]do;
	input clk,pld;
	always@(posedge clk) begin
		if(pld)
			do<=di;
		else
			do<=do;
	end
endmodule

module reg3Pld(di,do,clk,pld);
	input[2:0]di;
	output reg[2:0]do;
	input clk,pld;
	always@(posedge clk) begin
		if(pld)
			do<=di;
		else
			do<=do;
	end
endmodule


module MUX_1_DIN_2( di0, di1, sel, do);
	parameter DATA_WIDTH =8;
	input[DATA_WIDTH-1 : 0] di0 , di1;
	input sel;
	output reg[DATA_WIDTH-1 : 0] do;
	always @(di0 or di1 or sel) begin 
		casex( sel )
		1'b0 :
			do <=di0;
		1'b1 :
			do <=di1;
	
		endcase
	end
endmodule
module MUX_1_DIN_3(di0, di1,di2, do,sel);
	parameter DATA_WIDTH =8;
	input[DATA_WIDTH-1 : 0] di0,di1;
	input [2:0] di2;
	input [1:0] sel;
	output reg[DATA_WIDTH-1 : 0] do;
	
	always @(di0 or di1 or di2 or sel) begin 
		casex( sel )
		2'b00 :
			do <=di0;
		2'b01 :
			do <=di1;
		2'b1x :
			do <={5'b11111,di2};
	
		endcase
	end
endmodule

module Buffer(oedata,di,do);
	input oedata;
	input[7 : 0] di;
	output reg[7 : 0] do;
	always @(oedata or di) begin 
		casex( oedata )
		1'b0 :
			do <=di;
		endcase
	end
endmodule
module counter(clk, res, pl, en, inc, dec, di, do, cin, con);

	input clk, res, pl, en, inc, dec;
	input [7:0] di;
	output reg [7:0] do;
	input cin;
	output con;

	reg [7:0] do_next;
	wire co_inc, co_dec;

	always @(posedge clk)
		if(res)
			do <= 8'b0;
		else
			do <= do_next;

	always @(pl or en or inc or dec or di or do or cin)
		casex({pl,en,inc,dec,cin})
			5'b1xxxx: do_next = di;
			5'b0xxx1, 5'b00xxx, 5'b01000: do_next = do;
			5'b011x0: do_next = do + 1;
			5'b01010: do_next = do - 1;
		endcase

	assign co_inc = (do === 8'hff) & en & inc & (~cin);
	assign co_dec = (do === 8'b0) & en & dec & (~cin);
	assign con = ~(co_inc | co_dec);

endmodule
/*module NUMARATOR_8_BIT(clk,res,plc,en,inc,dec,cin,di,con,do) ;
	parameter n = 8 ;
	input en;
	input clk, res, inc, dec, plc;
	input [n-1:0] di ;
	input cin;
	output reg [n-1:0] do ;
	output reg con;
	always@(posedge clk) begin
	casex({en,res, inc, dec, plc})
		5'b0xxxx: do <= do ;
		5'b11xxx: do <= {8'b00000000} ;
		5'b101xx:begin
				if(cin==1'b0)
				begin
						if (do==8'b11111111) 
						begin
							con <=1'b0;
							do<=8'b00000000;
						end	
						else
						begin
							do <= do + 1 ;	
            					end
				end
					
			  end
		5'b1001x:begin
				if(cin==1'b0)
				begin
					if (do==8'b00000000) 
					begin
						con <=1'b0;
						do<=8'b11111111;
					end	
					else
					begin
						do <= do - 1 ;	
            				end
			  	end
			end
		5'b10001: do <= di ;
	endcase
	end
endmodule*/
module done_gen(dowc, dowr, doac, cinw, mode, done);
	input [7:0] dowc, dowr, doac;
	input [1:0] mode;
	input cinw;
	output reg done; 
 
 	always @(dowc or dowr or doac or cinw or mode)
		casex({mode,cinw})
			3'b00_0: done = (dowc === 8'b1); 
			3'b00_1: done = ~(|dowc);
			3'b01_0: done = (dowc + 1 === dowr);
			3'b01_1: done = (dowc === dowr);
			3'b10_x: done = (dowc === doac);
			3'b11_x: done = 1'b0;
	endcase 
endmodule
module Decoder(I,CR,plar,plwr,sela,selw,plcr,seld,plac,ena,inca,deca,resw,plwc,enw,incw,decw,oedata);
	input [2:0] I ;
	input [2:0] CR ;
	output reg plar,plwr,sela,selw,plcr,plac,ena,inca,deca,resw,plwc,enw,incw,decw,oedata;
	output reg[1:0] seld;
	always@(I,CR) begin
		casex({I,CR})
			6'b000xxx: begin
					plar<=0;
					plwr<=0;	
					sela<=1'bx;
					selw<=1'bx;
					plcr<=1;
					seld<=2'bxx;
					plac<=0;
					ena<=0;
					inca<=0;
					deca<=0;
					resw<=0;
					plwc<=0;
					enw<=0;
					incw<=0;
					decw<=0;
					oedata<=0;
				end
			6'b001xxx: begin
					plar<=0;
					plwr<=0;	
					sela<=1'bx;
					selw<=1'bx;
					plcr<=0;
					seld<=2'b1x;
					plac<=0;
					ena<=0;
					inca<=0;
					deca<=0;
					resw<=0;
					plwc<=0;
					enw<=0;
					incw<=0;
					decw<=0;
					oedata<=1;
				end
			6'b010xxx: begin
					plar<=0;
					plwr<=0;	
					sela<=1'bx;
					selw<=1'bx;
					plcr<=0;
					seld<=2'b01;
					plac<=0;
					ena<=0;
					inca<=0;
					deca<=0;
					resw<=0;
					plwc<=0;
					enw<=0;
					incw<=0;
					decw<=0;
					oedata<=1;
				end
			6'b011xxx: begin
					plar<=0;
					plwr<=0;	
					sela<=1'bx;
					selw<=1'bx;
					plcr<=0;
					seld<=2'b00;
					plac<=0;
					ena<=0;
					inca<=0;
					deca<=0;
					resw<=0;
					plwc<=0;
					enw<=0;
					incw<=0;
					decw<=0;
					oedata<=1;
				end
			6'b100xx0: begin
					plar<=0;
					plwr<=0;	
					sela<=1;
					selw<=1;
					plcr<=0;
					seld<=2'bxx;
					plac<=1;
					ena<=0;
					inca<=0;
					deca<=0;
					resw<=0;
					plwc<=1;
					enw<=0;
					incw<=0;
					decw<=0;
					oedata<=0;
				end
			6'b100x11: begin
					plar<=0;
					plwr<=0;	
					sela<=1;
					selw<=1;
					plcr<=0;
					seld<=2'bxx;
					plac<=1;
					ena<=0;
					inca<=0;
					deca<=0;
					resw<=0;
					plwc<=1;
					enw<=0;
					incw<=0;
					decw<=0;
					oedata<=0;
				end
			6'b100x01: begin
					plar<=0;
					plwr<=0;	
					sela<=1;
					selw<=1'bx;
					plcr<=0;
					seld<=2'bxx;
					plac<=1;
					ena<=0;
					inca<=0;
					deca<=0;
					resw<=1;
					plwc<=0;
					enw<=0;
					incw<=0;
					decw<=0;
					oedata<=0;
				end
			6'b101xxx: begin
					plar<=1;
					plwr<=0;	
					sela<=0;
					selw<=1'bx;
					plcr<=0;
					seld<=2'bxx;
					plac<=1;
					ena<=0;
					inca<=0;
					deca<=0;
					resw<=0;
					plwc<=0;
					enw<=0;
					incw<=0;
					decw<=0;
					oedata<=0;
				end
			6'b110xx0: begin
					plar<=0;
					plwr<=1;	
					sela<=1'bx;
					selw<=0;
					plcr<=0;
					seld<=2'bxx;
					plac<=0;
					ena<=0;
					inca<=0;
					deca<=0;
					resw<=0;
					plwc<=1;
					enw<=0;
					incw<=0;
					decw<=0;
					oedata<=0;
				end
			6'b110x11: begin
					plar<=0;
					plwr<=1;	
					sela<=1'bx;
					selw<=0;
					plcr<=0;
					seld<=2'bxx;
					plac<=0;
					ena<=0;
					inca<=0;
					deca<=0;
					resw<=0;
					plwc<=1;
					enw<=0;
					incw<=0;
					decw<=0;
					oedata<=0;
				end
			6'b110x01: begin
					plar<=0;
					plwr<=1;	
					sela<=1'bx;
					selw<=1'bx;
					plcr<=0;
					seld<=2'bxx;
					plac<=0;
					ena<=0;
					inca<=0;
					deca<=0;
					resw<=1;
					plwc<=0;
					enw<=0;
					incw<=0;
					decw<=0;
					oedata<=0;
				end
			6'b111000: begin
					plar<=0;
					plwr<=0;	
					sela<=1'bx;
					selw<=1'bx;
					plcr<=0;
					seld<=2'bxx;
					plac<=0;
					ena<=1;
					inca<=1;
					deca<=0;
					resw<=0;
					plwc<=0;
					enw<=1;
					incw<=0;
					decw<=1;
					oedata<=0;
				end
			6'b1110x1: begin
					plar<=0;
					plwr<=0;	
					sela<=1'bx;
					selw<=1'bx;
					plcr<=0;
					seld<=2'bxx;
					plac<=0;
					ena<=1;
					inca<=1;
					deca<=0;
					resw<=0;
					plwc<=0;
					enw<=1;
					incw<=1;
					decw<=0;
					oedata<=0;
				end
			6'b111010: begin
					plar<=0;
					plwr<=0;	
					sela<=1'bx;
					selw<=1'bx;
					plcr<=0;
					seld<=2'bxx;
					plac<=0;
					ena<=1;
					inca<=1;
					deca<=0;
					resw<=0;
					plwc<=0;
					enw<=0;
					incw<=0;
					decw<=0;
					oedata<=0;
				end
			6'b111100: begin
					plar<=0;
					plwr<=0;	
					sela<=1'bx;
					selw<=1'bx;
					plcr<=0;
					seld<=2'bxx;
					plac<=0;
					ena<=1;
					inca<=0;
					deca<=1;
					resw<=0;
					plwc<=0;
					enw<=1;
					incw<=0;
					decw<=1;
					oedata<=0;
				end
			6'b1111x1: begin
					plar<=0;
					plwr<=0;	
					sela<=1'bx;
					selw<=1'bx;
					plcr<=0;
					seld<=2'bxx;
					plac<=0;
					ena<=1;
					inca<=0;
					deca<=1;
					resw<=0;
					plwc<=0;
					enw<=1;
					incw<=1;
					decw<=0;
					oedata<=0;
				end
			6'b111110: begin
					plar<=0;
					plwr<=0;	
					sela<=1'bx;
					selw<=1'bx;
					plcr<=0;
					seld<=2'bxx;
					plac<=0;
					ena<=1;
					inca<=0;
					deca<=1;
					resw<=0;
					plwc<=0;
					enw<=0;
					incw<=0;
					decw<=0;
					oedata<=0;
				end


			
		endcase
	end
endmodule
module TEST_AM40;
	reg clk;
	reg [2:0] I;
	reg [7:0] di;
	reg cinw,cina;
	wire conw,cona;
	wire [2:0] CR;
	wire [7:0] doar;
	wire [7:0] doam;
	wire [7:0] doac;
	wire [7:0] dowr;
	wire [7:0] dowm;
	wire [7:0] dowc;	
	wire [7:0] do;
	wire [7:0] ao;
	wire plar,plwr,sela,selw,plcr,plac,ena,inca,deca,resw,plwc,enw,incw,decw,oedata;
	wire[1:0] seld;
	
	reg8Pld Adress_Reg(di,doar,clk,plar);
	reg8Pld Word_Reg(di,dowr,clk,plwr);
	reg3Pld Ctrl_Reg(di[2:0],CR,clk,plcr);
	
	MUX_1_DIN_2 Adress_Mux(di,doar,sela,doam);
	MUX_1_DIN_2 Word_Mux(di,dowr,selw,dowm);

	MUX_1_DIN_3 Data_Mux(doac,dowc,CR, do, seld);

	counter Adress_Cnt(clk,1'b0,plac,ena,inca,deca,doam,doac,cina,cona);
	counter Word_Cnt(clk,resw,plwc,enw,incw,decw,dowm,dowc,cinw,conw);
	
	//NUMARATOR_8_BIT Adress_Cnt(clk,1'b0,plac,ena,inca,deca,cina,doam,cona,doac);
	//NUMARATOR_8_BIT Word_Cnt(clk,resw,plwc,enw,incw,decw,cinw,dowm,conw,dowc);

	Decoder Decodor(I,CR,plar,plwr,sela,selw,plcr,seld,plac,ena,inca,deca,resw,plwc,enw,incw,decw,oedata);
	Buffer Data_Bus(oedata,doac,ao);
	done_gen Done_Gen(dowc,dowr,doac,cinw,CR[1:0],done);
	
	
		
	
	initial begin
	#0 clk =1'b0;
	forever
		#1 clk =~clk;
	end

	initial begin
	//#2 I=3'b000;di=8'b00000110;cina=1'b0;cinw=1'b0;
	//#2 I=3'b101;di=8'b00101100;
	//#2 I=3'b110;di=8'b00000111;
	//#2 I=3'b111;
	//#200
	//#2 $finish();
		#10 I=3'b000;di=8'h0;cina=1'b1;cinw=1'b1; // WRITE CR = 000 <-----------
		#10 I=3'b001;di=8'h0;cina=1'b1;cinw=1'b1; // READ CR

		#10 I=3'b101;di=8'h22;cina=1'b1;cinw=1'b1; // LOAD ADDRESS
		#10 I=3'b011;di=8'h0;cina=1'b1;cinw=1'b1; // READ AC
		#10 I=3'b111;di=8'h0;cina=1'b0;cinw=1'b1; // ENABLE AC
		
		#50;
		#10 I=3'b100;di=8'h0;cina=1'b1;cinw=1'b1; // REINITIALIZE AC
		#10 I=3'b011;di=8'h0;cina=1'b1;cinw=1'b1; // READ AC(AR)

		#10 I=3'b110;di=8'h33;cina=1'b1;cinw=1'b1; // LOAD WORD COUNTER/REGISTER
		#10 I=3'b010;di=8'h0;cina=1'b1;cinw=1'b1; // READ WC
		#10 I=3'b111;di=8'h0;cina=1'b1;cinw=1'b0; // ENABLE WC
		#50;
		#10 I=3'b100;di=8'h0;cina=1'b1;cinw=1'b1; // REINITIALIZE WC
		#10 I=3'b010;di=8'h0;cina=1'b1;cinw=1'b1; // READ WC(WR)


		#10 I=3'b000;di=8'h1;cina=1'b1;cinw=1'b1; // WRITE CR = 001 <-----------
		#10 I=3'b001;di=8'h0;cina=1'b1;cinw=1'b1; // READ CR

		#10 I=3'b101;di=8'h44;cina=1'b1;cinw=1'b1; // LOAD ADDRESS
		#10 I=3'b011;di=8'h0;cina=1'b1;cinw=1'b1; // READ AC
		#10 I=3'b111;di=8'h0;cina=1'b0;cinw=1'b1; // ENABLE AC
		#50;
		#10 I=3'b100;di=8'h0;cina=1'b1;cinw=1'b1; // REINITIALIZE AC
		#10 I=3'b011;di=8'h0;cina=1'b1;cinw=1'b1; // READ AC(AR)

		#10 I=3'b110;di=8'h55;cina=1'b1;cinw=1'b1; // LOAD WORD COUNTER/REGISTER
		#10 I=3'b010;di=8'h0;cina=1'b1;cinw=1'b1; // READ WC
		#10 I=3'b000;di=8'h0;cina=1'b1;cinw=1'b1; // WRITE CR = 000
		#10 I=3'b100;di=8'h0;cina=1'b1;cinw=1'b1; // REINITIALIZE WC
		#10 I=3'b010;di=8'h0;cina=1'b1;cinw=1'b1; // READ WC(WR)


		#10 I=3'b000;di=8'h2;cina=1'b1;cinw=1'b1; // WRITE CR = 010 <-----------
		#10 I=3'b001;di=8'h0;cina=1'b1;cinw=1'b1; // READ CR

		#10 I=3'b101;di=8'h66;cina=1'b1;cinw=1'b1; // LOAD ADDRESS
		#10 I=3'b011;di=8'h0;cina=1'b1;cinw=1'b1; // READ AC
		#10 I=3'b111;di=8'h0;cina=1'b0;cinw=1'b1; // ENABLE AC
		#50;
		#10 I=3'b100;di=8'h0;cina=1'b1;cinw=1'b1; // REINITIALIZE AC
		#10 I=3'b011;di=8'h0;cina=1'b1;cinw=1'b1; // READ AC(AR)

		#10 I=3'b110;di=8'h77;cina=1'b1;cinw=1'b1; // LOAD WORD COUNTER/REGISTER
		#10 I=3'b010;di=8'h0;cina=1'b1;cinw=1'b1; // READ WC
		#10 I=3'b111;di=8'h0;cina=1'b1;cinw=1'b0; // ENABLE WC
		#50;
		#10 I=3'b100;di=8'h0;cina=1'b1;cinw=1'b1; // REINITIALIZE WC
		#10 I=3'b010;di=8'h0;cina=1'b1;cinw=1'b1; // READ WC(WR)


		#10 I=3'b000;di=8'h3;cina=1'b1;cinw=1'b1; // WRITE CR = 011 <-----------
		#10 I=3'b001;di=8'h0;cina=1'b1;cinw=1'b1; // READ CR

		#10 I=3'b101;di=8'h88;cina=1'b1;cinw=1'b1; // LOAD ADDRESS
		#10 I=3'b011;di=8'h0;cina=1'b1;cinw=1'b1; // READ AC
		#10 I=3'b111;di=8'h0;cina=1'b0;cinw=1'b1; // ENABLE AC
		#50;
		#10 I=3'b100;di=8'h0;cina=1'b1;cinw=1'b1; // REINITIALIZE AC
		#10 I=3'b011;di=8'h0;cina=1'b1;cinw=1'b1; // READ AC(AR)

		#10 I=3'b110;di=8'h99;cina=1'b1;cinw=1'b1; // LOAD WORD COUNTER/REGISTER
		#10 I=3'b010;di=8'h0;cina=1'b1;cinw=1'b1; // READ WC
		#10 I=3'b111;di=8'h0;cina=1'b1;cinw=1'b0; // ENABLE WC
		#50;
		#10 I=3'b100;di=8'h0;cina=1'b1;cinw=1'b1; // REINITIALIZE WC
		#10 I=3'b010;di=8'h0;cina=1'b1;cinw=1'b1; // READ WC(WR)


		#10 I=3'b000;di=8'h4;cina=1'b1;cinw=1'b1; // WRITE CR = 100 <-----------
		#10 I=3'b001;di=8'h0;cina=1'b1;cinw=1'b1; // READ CR

		#10 I=3'b101;di=8'haa;cina=1'b1;cinw=1'b1; // LOAD ADDRESS
		#10 I=3'b011;di=8'h0;cina=1'b1;cinw=1'b1; // READ AC
		#10 I=3'b111;di=8'h0;cina=1'b0;cinw=1'b1; // ENABLE AC
		#50;
		#10 I=3'b100;di=8'h0;cina=1'b1;cinw=1'b1; // REINITIALIZE AC
		#10 I=3'b011;di=8'h0;cina=1'b1;cinw=1'b1; // READ AC(AR)


		#10 I=3'b000;di=8'h5;cina=1'b1;cinw=1'b1; // WRITE CR = 101 <-----------
		#10 I=3'b001;di=8'h0;cina=1'b1;cinw=1'b1; // READ CR

		#10 I=3'b101;di=8'hbb;cina=1'b1;cinw=1'b1; // LOAD ADDRESS
		#10 I=3'b011;di=8'h0;cina=1'b1;cinw=1'b1; // READ AC
		#10 I=3'b111;di=8'h0;cina=1'b0;cinw=1'b1; // ENABLE AC
		#50;
		#10 I=3'b100;di=8'h0;cina=1'b1;cinw=1'b1; // REINITIALIZE AC
		#10 I=3'b011;di=8'h0;cina=1'b1;cinw=1'b1; // READ AC(AR)


		#10 I=3'b000;di=8'h6;cina=1'b1;cinw=1'b1; // WRITE CR = 110 <-----------
		#10 I=3'b001;di=8'h0;cina=1'b1;cinw=1'b1; // READ CR

		#10 I=3'b101;di=8'hcc;cina=1'b1;cinw=1'b1; // LOAD ADDRESS
		#10 I=3'b011;di=8'h0;cina=1'b1;cinw=1'b1; // READ AC
		#10 I=3'b111;di=8'h0;cina=1'b0;cinw=1'b1; // ENABLE AC
		#50;
		#10 I=3'b100;di=8'h0;cina=1'b1;cinw=1'b1; // REINITIALIZE AC
		#10 I=3'b011;di=8'h0;cina=1'b1;cinw=1'b1; // READ AC(AR)


		#10 I=3'b000;di=8'h7;cina=1'b1;cinw=1'b1; // WRITE CR = 111 <-----------
		#10 I=3'b001;di=8'h0;cina=1'b1;cinw=1'b1; // READ CR

		#10 I=3'b101;di=8'hdd;cina=1'b1;cinw=1'b1; // LOAD ADDRESS
		#10 I=3'b011;di=8'h0;cina=1'b1;cinw=1'b1; // READ AC
		#10 I=3'b111;di=8'h0;cina=1'b0;cinw=1'b1; // ENABLE AC
		#50;
		#10 I=3'b100;di=8'h0;cina=1'b1;cinw=1'b1; // REINITIALIZE AC
		#10 I=3'b011;di=8'h0;cina=1'b1;cinw=1'b1; // READ AC(AR)

		// ENCNT, DONE

		#10 I=3'b000;di=8'h0;cina=1'b1;cinw=1'b1; // MODE 0, CR2 = 0
		#10 I=3'b101;di=8'hfc;cina=1'b1;cinw=1'b1; // AC = FC
		#10 I=3'b110;di=8'h0a;cina=1'b1;cinw=1'b1; // WC = 0A
		#10 I=3'b111;di=8'h0;cina=1'b0;cinw=1'b0; // ENCNT
		#120;
		#10 I=3'b000;di=8'h4;cina=1'b1;cinw=1'b1; // MODE 0, CR2 = 1
		#10 I=3'b110;di=8'h0f;cina=1'b1;cinw=1'b1; // WC = 0F
		#10 I=3'b111;di=8'h0;cina=1'b0;cinw=1'b0; // ENCNT
		#200;

		#10 I=3'b000;di=8'h1;cina=1'b1;cinw=1'b1; // MODE 1, CR2 = 0
		#10 I=3'b101;di=8'hf0;cina=1'b1;cinw=1'b1; // AC = F0
		#10 I=3'b110;di=8'h0a;cina=1'b1;cinw=1'b1; // WC = 0A
		#10 I=3'b111;di=8'h0;cina=1'b0;cinw=1'b0; // ENCNT
		#120;
		#10 I=3'b000;di=8'h5;cina=1'b1;cinw=1'b1; // MODE 1, CR2 = 1
		#10 I=3'b110;di=8'h0f;cina=1'b1;cinw=1'b1; // WC = 0F
		#10 I=3'b111;di=8'h0;cina=1'b0;cinw=1'b0; // ENCNT
		#200;

		#10 I=3'b000;di=8'h2;cina=1'b1;cinw=1'b1; // MODE 2, CR2 = 0
		#10 I=3'b101;di=8'hab;cina=1'b1;cinw=1'b1; // AC = AB
		#10 I=3'b110;di=8'hba;cina=1'b1;cinw=1'b1; // WC = BA
		#10 I=3'b111;di=8'h0;cina=1'b0;cinw=1'b0; // ENCNT
		#180;
		#10 I=3'b000;di=8'h6;cina=1'b1;cinw=1'b1; // MODE 2, CR2 = 1
		#10 I=3'b101;di=8'hdc;cina=1'b1;cinw=1'b1; // AC = DC
		#10 I=3'b110;di=8'hcd;cina=1'b1;cinw=1'b1; // WC = CD
		#10 I=3'b111;di=8'h0;cina=1'b0;cinw=1'b0; // ENCNT
		#180;

		#10 I=3'b000;di=8'h3;cina=1'b1;cinw=1'b1; // MODE 3, CR2 = 0
		#10 I=3'b101;di=8'hfb;cina=1'b1;cinw=1'b1; // AC = FB
		#10 I=3'b110;di=8'hf0;cina=1'b1;cinw=1'b1; // WC = F0
		#10 I=3'b111;di=8'h0;cina=1'b0;cinw=1'b0; // ENCNT
		#180;
		#10 I=3'b000;di=8'h7;cina=1'b1;cinw=1'b1; // MODE 3, CR2 = 1
		#10 I=3'b110;di=8'hf0;cina=1'b1;cinw=1'b1; // WC = F0
		#10 I=3'b111;di=8'h0;cina=1'b0;cinw=1'b0; // ENCNT
		

		#200 $finish;
	end
endmodule

module TEST_NUMARATOR_8_BIT;
	reg clk,res,plc,en,inc,dec;
	reg [7:0] di;
	reg cin;
	wire con;
	wire [7:0] do;
	
	NUMARATOR_8_BIT my_num(clk,res,plc,en,inc,dec,cin,di,con,do);	
	initial begin
	#0 clk =1'b0;
	forever
		#1 clk =~clk;
	end

	initial begin
	#3 res=1'b0;plc=1'b1;en=1'b1;di=8'h4;inc=1'h0;dec=1'h0;cin=1'h0;
	#3 res=1'b0;plc=1'b0;en=1'b1;di=8'h4;inc=1'h0;dec=1'h1;cin=1'h0;
	#3 res=1'b0;plc=1'b0;en=1'b1;di=8'h4;inc=1'h0;dec=1'h1;cin=1'h0;
	#3 res=1'b0;plc=1'b0;en=1'b1;di=8'h4;inc=1'h0;dec=1'h1;cin=1'h0;
	#3 res=1'b0;plc=1'b0;en=1'b1;di=8'h4;inc=1'h0;dec=1'h1;cin=1'h0;
	#3 res=1'b0;plc=1'b0;en=1'b1;di=8'h4;inc=1'h0;dec=1'h1;cin=1'h0;
	#3 res=1'b0;plc=1'b0;en=1'b1;di=8'h4;inc=1'h0;dec=1'h1;cin=1'h1;
	#3 res=1'b1;plc=1'b0;en=1'b1;di=8'h4;inc=1'h0;dec=1'h1;cin=1'h0;
	#3 res=1'b1;plc=1'b0;en=1'b1;di=8'h4;inc=1'h0;dec=1'h1;cin=1'h0;
	#3 res=1'b1;plc=1'b0;en=1'b0;di=8'h4;inc=1'h0;dec=1'h1;cin=1'h0;
	#3 res=1'b1;plc=1'b0;en=1'b0;di=8'h4;inc=1'h0;dec=1'h1;cin=1'h0;

	#2 $finish();
	end
endmodule

module TEST_MUX_1_DIN_2;
	reg en;
	reg [7:0] a,b;
	reg  s;
	wire [7:0] o;
	
	MUX_1_DIN_2 my_mux(.en(en), .a(a), .b(b), .s(s), .o(o));
	integer i;
	integer nr_iteratii =30;
	initial begin
		for(i=0;i< nr_iteratii;i=i+1) begin
			#1 en = $random%2; a = $random%256;  b=$random%256; s= $random%2;
		end
		$finish;
	end
endmodule

module TEST_MUX_1_DIN_3;
	reg en;
	reg [7:0] a,b,c;
	reg  [1:0] s;
	wire [7:0] o;
	
	MUX_1_DIN_3 my_mux(.en(en), .a(a), .b(b), .c(c), .s(s), .o(o));
	integer i;
	integer nr_iteratii =30;
	initial begin
		for(i=0;i< nr_iteratii;i=i+1) begin
			#1 en = $random%2; a = $random%256;  b=$random%256; c=$random%256; s= $random%3;
		end
		$finish;
	end
endmodule



module TEST_reg8ResPld;
	reg clk,res,pld;
	reg [7:0] data_i;
	wire [7:0] data_o;
	
	reg8ResPld my_num(.data_i(data_i),.data_o(data_o),.clk(clk),.res(res),.pld(pld));
	
	initial begin
	#0 clk =1'b0;
	forever
		#1 clk =~clk;
	end

	initial begin
	#5 res=1'b1;pld=1'b0; data_i=8'h4;
	#5 res=1'b0;pld=1'b1; data_i=8'h8;
	#5 res=1'b0;pld=1'b0; data_i=8'hA;
	#5 res=1'b0;pld=1'b0; data_i=8'hB;	
	#5 res=1'b1;pld=1'b1; data_i=8'hC;	
	#5 res=1'b0;pld=1'b0; data_i=8'hD;
	#5 $finish();
	end
endmodule
