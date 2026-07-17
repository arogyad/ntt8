module butterfly #(
parameter logic [2:0] WIDTH = 3'd5
)(
    input  logic [WIDTH - 1:0] a,
    input  logic [WIDTH - 1:0] b,
    input  logic [WIDTH - 1:0] w,
    output logic [WIDTH - 1:0] u,
    output logic [WIDTH - 1:0] v
);
    localparam logic [WIDTH - 1:0] Q = 5'd17;
    localparam logic [WIDTH:0]   Q_EXT = 6'd17;

    logic [WIDTH * 2 - 1:0] p;  
    logic [WIDTH - 1:0]   mod_mul;  
    logic [WIDTH:0]     sum;  

    logic [WIDTH:0] reducer = 1 << WIDTH; // this is the R
    logic [WIDTH:0] r_inv = 6'd8; // R^-1, calculated this using FLT a^{p - 2} (mod 17)
    logic [WIDTH:0] k = ((reducer * r_inv) - 1) / Q_EXT; // st R.R^-1 - q.k = 1 

    logic [WIDTH - 1:0] b_;
    logic [WIDTH - 1:0] w_;
    logic [WIDTH - 1: 0] temp;
    logic [2 * WIDTH:0] sum_full;
    logic [WIDTH - 1:0] reduced;

    function logic [WIDTH - 1:0] convert_in(logic [WIDTH - 1: 0] x);
        logic [2 * WIDTH: 0] x_shifted;
        begin
            x_shifted = ((2 * WIDTH + 1)'(x)) << WIDTH;
            convert_in = WIDTH'(x_shifted % (2 * WIDTH + 1)'(Q_EXT));
        end
    endfunction

    function logic [WIDTH - 1:0] convert_out(logic [WIDTH - 1: 0] x);
        logic [2 * WIDTH: 0] x_prod;
        begin
            x_prod = ((2 * WIDTH)'(x)) * ((2 * WIDTH)'(r_inv));
            convert_out = WIDTH'(x_prod % (2 * WIDTH + 1)'(Q_EXT));
        end
    endfunction

    always_comb begin
        // p = b * w;
        // mod_mul = WIDTH'( p % (WIDTH*2)'(Q) );
        b_ = convert_in(b);
        w_ = convert_in(w);
        p = b_ * w_;
        temp = WIDTH'(((p & ((2 * WIDTH)'(reducer - 1))) * k) & ((2*WIDTH)'(reducer - 1)));
        sum_full = {1'b0, p} + {1'b0, ((2*WIDTH)'(temp) * (2*WIDTH)'(Q_EXT))};
        reduced  = WIDTH'(sum_full >> WIDTH);
        mod_mul = convert_out(WIDTH'( (reduced < Q) ? reduced : reduced - Q ));

        sum = a + mod_mul;
        if (sum >= Q_EXT) begin
            u = WIDTH'(sum - Q_EXT);
        end else begin
            u = WIDTH'(sum);
        end

        if (a < mod_mul) begin
            v = WIDTH'( ({1'b0, a} + Q_EXT) - {1'b0, mod_mul} );
        end else begin
            v = WIDTH'(a - mod_mul);
        end
    end


endmodule
