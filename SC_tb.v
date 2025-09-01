// tb_simple_riscv.v
module tb_simple_riscv;
    reg clk, rst;
    simple_riscv_core cpu(clk, rst);

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, cpu); // dump everything in cpu
        clk = 0; rst = 1;
        #5 rst = 0;
        #100 $finish;
    end

    always #1 clk = ~clk; // clock toggles every 1 time unit
endmodule
