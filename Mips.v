module Mips();
    reg Clk, Reset;
    initial
        begin
            $readmemh( "Test_Signal_Pipeline2.txt", U_IM.IMem ) ; 
            $monitor("PC = 0x%8X, IR = 0x%8X", U_pcUnit.PCOut, opCode_1 );
            Clk = 1 ;
            Reset = 0 ;
            #5 Reset = 1 ;
            #20 Reset = 0 ;
        end
    always
	    #(50) Clk = ~Clk;
//////////////////////////////////////////////时钟和重置已设置好        
//PC
    wire [31:0] pcIn;
    wire [31:0] pcOut;
    wire [31:0] pcOut_1;
    reg  [31:0] pcOut_2;
    reg  [31:0] pcOut_3;
    reg  [31:0] pcAddr_3;
    reg  [27:0] jumptemp_3;
    reg  [31:0] jumpAddr_4;
    reg  [31:0] BranchAddr_4;
//IM
    wire [7:0]  imAdr;
    wire [31:0] opCode_1;
    reg  [31:0] opCode_2;
    reg  [31:0] opCode_3;
//GPR
    wire [4:0]  gprWeSel_3,gprReSel1,gprReSel2;
    reg  [4:0]  gprWeSel_4;
    reg  [4:0]  gprWeSel_5;
    wire [31:0] gprDataIn;
    wire [31:0] gprDataOut1_2,gprDataOut2_2,gprDataOut1_2_pre,gprDataOut2_2_pre,gprDataOut1_3,gprDataOut2_3;
    reg  [31:0] gprDataOut1_3_pre,gprDataOut2_3_pre,gprDataOut2_4;
//Extender
    wire [15:0] extDataIn;
    wire [31:0] extDataOut_2;
    reg  [31:0] extDataOut_3;
//DMem
    wire [7:0]  dmDataAdr;
    wire [31:0] dmDataOut_4;
    reg  [31:0] dmDataOut_5;
//Ctrl
    wire [25:0] jumpaddr;
    wire [5:0]	op;
    wire [5:0]	funct;
    wire        jump_2;						//指令跳转
    wire        RegDst_2;						
    wire        Branch_2;						//分支
    wire        MemR_2;						//读存储器
    wire        Mem2R_2;						//数据存储器到寄存器堆
    wire        MemW_2;						//写数据存储器
    wire        RegW_2;						//寄存器堆写入数据
    wire        Alusrc_2;						//运算器操作数选择
    wire [1:0]  ExtOp;						//位扩展器符号扩展选择
    wire [4:0]  Aluctrl_2;					//Alu运算选择
    reg         jump_3,jump_4;						//指令跳转
    reg         RegDst_3;						
    reg         Branch_3,Branch_4;						//分支
    reg         MemR_3,MemR_4;						//读存储器
    reg         Mem2R_3,Mem2R_4,Mem2R_5;						//数据存储器到寄存器堆
    reg         MemW_3,MemW_4;						//写数据存储器
    reg         RegW_3,RegW_4,RegW_5;						//寄存器堆写入数据
    reg         Alusrc_3;						//运算器操作数选择
    reg  [4:0]  Aluctrl_3;					//Alu运算选择
//Alu
    wire [31:0] aluDataIn2;
    wire [31:0]	aluDataOut_3;
    reg  [31:0]	aluDataOut_4;
    reg  [31:0]	aluDataOut_5;
    wire        zero_3;
    reg         zero_4;
//Other
    wire        pcSel;
    wire        pcBranch;
    reg         ControlClear_2;
    reg         ControlClear_3;
    reg         ControlClear_4;
    reg         PCWrite;
    reg         IFIDWrite;
    reg  [1:0]  ForwardA,ForwardB;
    reg         ForwardC,ForwardD;

    always@(posedge Clk)
	begin
        Mem2R_5 = Mem2R_4;
        RegW_5 = RegW_4;
        dmDataOut_5 = dmDataOut_4;
        aluDataOut_5 = aluDataOut_4;
        gprWeSel_5 = gprWeSel_4;

        if (ControlClear_4)
            begin
                jump_4 = 0;
                RegW_4 = 0;
                Mem2R_4 = 0;
                MemR_4 = 0;
                MemW_4 = 0;
                Branch_4 = 0;
            end
        else
            begin
                jump_4 = jump_3;
                RegW_4 = RegW_3;
                Mem2R_4 = Mem2R_3;
                MemR_4 = MemR_3;
                MemW_4 = MemW_3;
                Branch_4 = Branch_3;
            end
        jumpAddr_4 = {pcOut_3[31:28],jumptemp_3};
        BranchAddr_4 = pcOut_3 + pcAddr_3;
        zero_4 = zero_3;
        aluDataOut_4 = aluDataOut_3;
        gprDataOut2_4 = gprDataOut2_3;
        gprWeSel_4 = gprWeSel_3;

        if (ControlClear_3)
            begin
                jump_3 = 0;
                RegW_3 = 0;
                Mem2R_3 = 0;
                MemR_3 = 0;
                MemW_3 = 0;
                Branch_3 = 0;
                RegDst_3 = 0;
                Aluctrl_3 = 0;
                Alusrc_3 = 0;
            end
        else
            begin
                jump_3 = jump_2;
                RegW_3 = RegW_2;
                Mem2R_3 = Mem2R_2;
                MemR_3 = MemR_2;
                MemW_3 = MemW_2;
                Branch_3 = Branch_2;
                RegDst_3 = RegDst_2;
                Aluctrl_3 = Aluctrl_2;
                Alusrc_3 = Alusrc_2;
            end
        pcOut_3 = pcOut_2;
        opCode_3 = opCode_2;
        gprDataOut1_3_pre = gprDataOut1_2;
        gprDataOut2_3_pre = gprDataOut2_2;
        extDataOut_3 = extDataOut_2;
        pcAddr_3 = extDataOut_3 << 2;
        jumptemp_3[27:2] = opCode_3[25:0];
        jumptemp_3[1:0] = 2'b00;

        pcOut_2 = pcOut_1;        
        if (ControlClear_2)
            opCode_2 = 0;
        else if (IFIDWrite)
            opCode_2 = opCode_1;  
    end

    assign pcIn = (jump_4==1)?jumpAddr_4:BranchAddr_4;
    assign pcSel = ((pcBranch||jump_4)==1)?1:0;
    assign pcBranch = ((Branch_4&&zero_4)==1)?1:0;
    assign imAdr = pcOut[9:2];
    assign jumpaddr = opCode_2[25:0];
    assign op = opCode_2[31:26];
    assign funct = opCode_2[5:0];
    assign gprReSel1 = opCode_2[25:21];
    assign gprReSel2 = opCode_2[20:16];
    assign gprWeSel_3 = (RegDst_3==0)?opCode_3[20:16]:opCode_3[15:11];
    assign extDataIn = opCode_2[15:0];
    assign dmDataAdr = aluDataOut_4[9:2];
    assign gprDataIn = (Mem2R_5==1)?dmDataOut_5:aluDataOut_5;
    assign aluDataIn2 = (Alusrc_3==1)?extDataOut_3:gprDataOut2_3;
    
    assign gprDataOut1_3 = (ForwardA==0)?gprDataOut1_3_pre:((ForwardA==1)?gprDataIn:aluDataOut_4);
    assign gprDataOut2_3 = (ForwardB==0)?gprDataOut2_3_pre:((ForwardB==1)?gprDataIn:aluDataOut_4);
    assign gprDataOut1_2 = (ForwardC==0)?gprDataOut1_2_pre:gprDataIn;
    assign gprDataOut2_2 = (ForwardD==0)?gprDataOut2_2_pre:gprDataIn;

///////////旁路单元
    always@(*)
	begin
        if (RegW_4 && (gprWeSel_4 != 0) && (gprWeSel_4 == opCode_3[25:21])) ForwardA = 2;
        else if (RegW_5 && (gprWeSel_5 != 0) && (gprWeSel_5 == opCode_3[25:21])) ForwardA = 1;
        else ForwardA = 0;
        if (RegW_4 && (gprWeSel_4 != 0) && (gprWeSel_4 == opCode_3[20:16])) ForwardB = 2;
        else if (RegW_5 && (gprWeSel_5 != 0) && (gprWeSel_5 == opCode_3[20:16])) ForwardB = 1;
        else ForwardB = 0;
        if (RegW_5 && (gprWeSel_5 != 0) && (gprWeSel_5 == opCode_2[25:21])) ForwardC = 1;
        else ForwardC = 0;
        if (RegW_5 && (gprWeSel_5 != 0) && (gprWeSel_5 == opCode_2[20:16])) ForwardD = 1;
        else ForwardD = 0;
        if (pcSel == 1)     //如果跳转
            begin
                ControlClear_2 = 1;
                ControlClear_3 = 1;
                ControlClear_4 = 1;
            end
        else if (PCWrite == 1)
            begin
                ControlClear_2 = 0;
                ControlClear_3 = 0;
                ControlClear_4 = 0;
            end
    end

///////////冒险检测单元
    always@(posedge Clk)
	begin
        if (MemR_3 && ((opCode_3[20:16] == opCode_2[25:21]) || (opCode_3[20:16] == opCode_2[20:16])))
            begin   //stall the pipeline
                ControlClear_3 = 1;
                IFIDWrite = 0;
                PCWrite = 0;
            end
        else 
            begin
                ControlClear_3 = 0;
                IFIDWrite = 1;
                PCWrite = 1;
            end
    end

    PcUnit U_pcUnit(.PCSel(pcSel),.PCIn(pcIn),.PCOut(pcOut),.PCOut_plus4(pcOut_1),.PcReSet(Reset),.PCWrite(PCWrite),.clk(Clk));
    IM U_IM(.OpCode(opCode_1),.ImAdress(imAdr));
    GPR U_gpr(.DataOut1(gprDataOut1_2_pre),.DataOut2(gprDataOut2_2_pre),.clk(Clk),.WData(gprDataIn)
              ,.WE(RegW_5),.WeSel(gprWeSel_5),.ReSel1(gprReSel1),.ReSel2(gprReSel2));
    Ctrl U_Ctrl(.jump(jump_2),.RegDst(RegDst_2),.Branch(Branch_2),.MemR(MemR_2),.Mem2R(Mem2R_2)
                ,.MemW(MemW_2),.RegW(RegW_2),.Alusrc(Alusrc_2),.ExtOp(ExtOp),.Aluctrl(Aluctrl_2)
                ,.OpCode(op),.funct(funct));
    Extender U_extend(.ExtOut(extDataOut_2),.DataIn(extDataIn),.ExtOp(ExtOp));
    Alu U_Alu(.AluResult(aluDataOut_3),.Zero(zero_3),.DataIn1(gprDataOut1_3),.DataIn2(aluDataIn2),.Shamt(opCode_3[10:6]),.AluCtrl(Aluctrl_3));
    DMem U_DMem(.DataOut(dmDataOut_4),.DataAdr(dmDataAdr),.DataIn(gprDataOut2_4),.DMemW(MemW_4),.DMemR(MemR_4),.clk(Clk));

endmodule