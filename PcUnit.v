module PcUnit(PCSel,PCIn,PCOut,PCOut_plus4,PcReSet,PCWrite,clk);

	input   PcReSet;
    input   PCSel;
	input   clk;
    input   PCWrite;
	input [31:0] PCIn;	
	output reg[31:0] PCOut;
	output reg[31:0] PCOut_plus4;
	
	always@(posedge clk or posedge PcReSet)
	begin
		if(PcReSet == 1)
            begin
			    PCOut = 32'h0000_3000;
                PCOut_plus4 = PCOut+4;
            end
		else if (PCWrite)
            begin 
                if(PCSel == 1)
                    PCOut = PCIn;
                else
                    PCOut = PCOut_plus4;
                PCOut_plus4 = PCOut+4;
            end
            /* begin
                if(PC <= 32'h0000_3078)
                    PC = PC+4;
                if(PcSel == 1)
                    begin
                        temp = Adress << 2;
                        PC = PC+temp;
                    end
                if(Jump == 1)
                    begin
                        temp[27:2] = Jumpaddr[25:0];
                        temp[1:0] = 2'b00;
                        PC = {PC[31:28], temp[27:0]};
                    end 
            end */
	end
endmodule