module trng_top(
    input  wire clk,
    input  wire rst,
    output wire rnd_raw,
    output wire rnd_entropy,
    output wire vn_bit,
    output wire vn_valid,
    output reg [7:0] final_number,
    output reg number_ready
);

    entropy_model entropy_inst (
        .clk(clk),
        .rst(rst),
        .tap_sel(5'd10),
        .rnd_raw(rnd_raw)
    );

    window_filter filter_inst (
        .clk(clk),
        .rst(rst),
        .in_bit(rnd_raw),
        .out_bit(rnd_entropy)
    );

    von_neumann_corrector vn_inst (
        .clk(clk),
        .rst(rst),
        .in_bit(rnd_raw),
        .out_bit(vn_bit),
        .out_valid(vn_valid)
    );

    reg [7:0] shift_reg;
    reg [2:0] bit_cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_cnt <= 0;
            shift_reg <= 0;
            final_number <= 0;
            number_ready <= 0;
        end else begin
            number_ready <= 0;
            if (vn_valid) begin
                shift_reg <= {shift_reg[6:0], vn_bit};
                if (bit_cnt == 3'd7) begin
                    final_number <= {shift_reg[6:0], vn_bit};
                    number_ready <= 1;
                    bit_cnt <= 0;
                end else begin
                    bit_cnt <= bit_cnt + 1;
                end
            end
        end
    end

endmodule