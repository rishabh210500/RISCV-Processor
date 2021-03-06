`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:38:30 11/09/2019 
// Design Name: 
// Module Name:    dmem_decoder 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module dmem_decoder(
	//Input
	input  [31:0] alu_out_i,		//ALU Output
	input  [5:0] instr_opcode_i,	//6 Bit Instruction Opcode
	input	 [31:0] indata_i,			//Raw Data to Write
	//Output
	output [31:0] w_data_o,	//Output Write Data for DMEM
	output [3:0] we_o			//Write Enable system for Write Enable
);


	reg [31:0] w_data_r;
	reg [3:0] we_r;



	// Case statement to assign the output based on instruction and given address
	
	
	//------------------------------------------------------------//
	//    Assigning output based on instuction and write address  //
	//------------------------------------------------------------//
	
	always@(*) 
		begin
			case(instr_opcode_i)
				//Store Byte
				6'b101000: 
					begin
						case (alu_out_i[1:0])
							//SB x2,x1(0)
							2'b00:
								begin
									w_data_r = {24'b0,indata_i[7:0]};
									we_r = 4'b0001;
								end
							//SB x2,x1(1)
							2'b01:
								begin			
									w_data_r = {16'b0,indata_i[7:0],8'b0};
									we_r = 4'b0010;
								end
							//SB x2,x1(2)
							2'b10:
								begin
									w_data_r = {8'b0,indata_i[7:0],16'b0};
									we_r = 4'b0100;							
								end
							//SB x2,x1(3)
							2'b11:
								begin
									w_data_r = {indata_i[7:0],24'b0};
									we_r = 4'b1000;	
								end
						endcase
					end
				//Store Half Word
				6'b101001:
					begin
						case (alu_out_i[1:0])
							//SH x2,x1(0)
							2'b00:
								begin
									w_data_r = {16'b0,indata_i[15:8],indata_i[7:0]};
									we_r = 4'b0011;	
								end
							//SH x2,x1(2)
							2'b10:
								begin
									w_data_r = {indata_i[15:8],indata_i[7:0],16'b0};
									we_r = 4'b1100;
								end
							//SH x2,x1(1,3) - Invalid Cases
							default:
								begin
									w_data_r = 'b0;
									we_r = 4'b0000;
								end
						endcase
					end
				//Store Word
				6'b101010: 
					begin
						w_data_r = {indata_i[31:24],indata_i[23:16],indata_i[7:0],indata_i[15:8]};
						we_r = 4'b1111;
					end
				//Other cases - No useful output
				default:
					begin 
						w_data_r = 'b0;
						we_r = 4'b0000;
					end
			endcase
		end
	
	
	assign w_data_o = w_data_r;
	assign we_o = we_r;
	
endmodule 
