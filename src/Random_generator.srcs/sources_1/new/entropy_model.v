module entropy_model (
    input wire clk, rst,
    input wire [4:0] tap_sel,
    output reg rnd_raw
);
    reg [31:0] jitter;
    reg [15:0] phase;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            jitter <=  $random;
            phase <= 0;
            rnd_raw <= 0;
        end else begin
            jitter <= {jitter[30:0], jitter[31] ^ jitter[21] ^ jitter[1]};
            phase <= phase + 16'd513 + jitter[7:0];
            rnd_raw <= (phase > (tap_sel * 1000 + 2000)) ^ jitter[0];
        end
    end
endmodule

module window_filter (
    input wire clk, rst, in_bit,
    output reg out_bit
);
    reg [7:0] count, ones;
    always @(posedge clk or posedge rst) begin
        if (rst) {count, ones, out_bit} <= 0;
        else begin
            count <= count + 1;
            ones <= ones + in_bit;
            if (count == 8'd255) begin
                out_bit <= (ones > 8'd128);
                count <= 0; ones <= 0;
            end
        end
    end
endmodule

module von_neumann_corrector (
    input wire clk, rst, in_bit,
    output reg out_bit, out_valid
);
    reg prev, have_prev;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            have_prev <= 0; out_valid <= 0;
        end else begin
            out_valid <= 0;
            if (!have_prev) begin
                prev <= in_bit;
                have_prev <= 1;
            end else begin
                if (prev != in_bit) begin
                    out_bit <= prev;
                    out_valid <= 1;
                end
                have_prev <= 0;
            end
        end
    end
endmodule