// simple_riscv_core.v
module simple_riscv_core(
    input clk, 
    input rst
);
    reg [31:0] regfile [0:31];    // 32 registers
    reg [31:0] pc;
    wire [31:0] instr;
    
    // instruction memory (4 instructions)
    reg [31:0] imem [0:3];
    initial begin
        // R-type Instructions (opcode = 0110011)
        imem[0] = 32'b0000000_00010_00001_000_00011_0110011; // add x3, x1, x2
        imem[1] = 32'b0100000_00011_00001_000_00100_0110011; // sub x4, x1, x3
        imem[2] = 32'b0000000_00100_00010_111_00101_0110011; // and x5, x2, x4
        imem[3] = 32'b0000000_00101_00001_110_00110_0110011; // or  x6, x1, x5
    end
    
    assign instr = imem[pc];

    // decode fields
    wire [4:0] rs1    = instr[19:15];
    wire [4:0] rs2    = instr[24:20];
    wire [4:0] rd     = instr[11:7];
    wire [6:0] funct7 = instr[31:25];
    wire [2:0] funct3 = instr[14:12];

    // ALU operations
    reg [31:0] alu;
    always @(*) begin
        case (funct3)
            3'b000: alu = (funct7[5]) ? regfile[rs1] - regfile[rs2] : regfile[rs1] + regfile[rs2]; // ADD/SUB
            3'b111: alu = regfile[rs1] & regfile[rs2]; // AND
            3'b110: alu = regfile[rs1] | regfile[rs2]; // OR
            default: alu = 0;
        endcase
    end

    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 0;
            for (i = 0; i < 32; i = i + 1) regfile[i] <= 0;
            // preload registers with values
            regfile[1] <= 5;  // x1 = 5
            regfile[2] <= 7;  // x2 = 7
        end else begin
            if (rd != 0) regfile[rd] <= alu;
            pc <= pc + 1;
        end
    end
endmodule
