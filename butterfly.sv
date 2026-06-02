module butterfly (
    input  logic [4:0] a,
    input  logic [4:0] b,
    input  logic [4:0] w,
    output logic [4:0] u,
    output logic [4:0] v
);
    localparam int Q = 17;

    logic [4:0] t;

    function automatic [4:0] mod_add(input [4:0] x, input [4:0] y);
        reg [5:0] s;
        begin
            s = x + y;
            if (s >= Q) begin 
                mod_add = s - Q;
            end
            else begin 
                mod_add = s[4:0];
            end
        end
    endfunction

    function automatic [4:0] mod_sub(input [4:0] x, input [4:0] y);
        begin
            if (x >= y) begin 
                mod_sub = x - y;
            end
            else begin 
                mod_sub = x + Q - y;
            end
        end
    endfunction

    function automatic [4:0] mod_mul(input [4:0] x, input [4:0] y);
        reg [9:0] p;
        begin
            p = x * y;
            mod_mul = p % Q;
        end
    endfunction

    always_comb  begin
        t = mod_mul(w, b);
        u = mod_add(a, t);
        v = mod_sub(a, t);
    end
endmodule
