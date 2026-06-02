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

    logic [WIDTH:0]     sum;
    logic [WIDTH - 1:0]   diff;
    logic [WIDTH * 2 - 1:0] p;

    always_comb begin
        sum = a + b;
        if (sum >= Q_EXT) begin
            u = WIDTH'(sum - Q_EXT); 
        end else begin
            u = WIDTH'(sum);
        end

        if (a < b) begin
            diff = WIDTH'( ({1'b0, a} + Q_EXT) - {1'b0, b} );
        end else begin
            diff = WIDTH'(a - b);
        end

        p = diff * w;
        v = WIDTH'( p % (WIDTH*2)'(Q) ); 
    end
endmodule
