module von_neumann_corrector (
    input  wire clk,
    input  wire rst,
    input  wire in_bit,     // bit de intrare (random brut sau filtrat)
    output reg  out_bit,    // bit corectat
    output reg  out_valid   // 1 = out_bit este valid
);

    reg prev;
    reg have_prev;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            prev      <= 0;
            have_prev <= 0;
            out_bit   <= 0;
            out_valid <= 0;
        end 
        else begin
            out_valid <= 0;   // implicit nu avem bit nou

            if (!have_prev) begin
                // salvăm primul bit din pereche
                prev      <= in_bit;
                have_prev <= 1;
            end 
            else begin
                // avem perechea prev + in_bit
                if (prev == 0 && in_bit == 1) begin
                    out_bit   <= 0;
                    out_valid <= 1;
                end 
                else if (prev == 1 && in_bit == 0) begin
                    out_bit   <= 1;
                    out_valid <= 1;
                end

                // după procesarea perechii, resetăm pentru următoarea pereche
                have_prev <= 0;
            end
        end
    end

endmodule
