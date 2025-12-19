module window_filter #(
    parameter WINDOW = 256
)(
    input  wire clk,
    input  wire rst,
    input  wire in_bit,        // bitul brut de intrare
    output reg  out_bit        // bitul filtrat
);

    reg [15:0] count;
    reg [15:0] ones;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count   <= 0;
            ones    <= 0;
            out_bit <= 0;
        end else begin
            count <= count + 1;
            ones  <= ones + in_bit;

            if (count == WINDOW-1) begin
                out_bit <= (ones > WINDOW/2);
                count   <= 0;
                ones    <= 0;
            end
        end
    end

endmodule
