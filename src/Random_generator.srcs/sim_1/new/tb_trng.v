`timescale 1ns/1ps

module tb_trng;
    reg clk, rst;
    wire rnd_raw, rnd_entropy, vn_bit, vn_valid, ready;
    wire [7:0] final_val;

    trng_top dut (
        .clk(clk), .rst(rst),
        .rnd_raw(rnd_raw), .rnd_entropy(rnd_entropy),
        .vn_bit(vn_bit), .vn_valid(vn_valid),
        .final_number(final_val), .number_ready(ready)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1;
        #50 rst = 0;
        
        repeat (10) begin
            @(posedge ready);
            $display("T=%t | Numar generat: %d (Hex: %h) (Bin: %b)", $time, final_val, final_val, final_val);
        end
        
        $finish;
    end
endmodule