module test;

    parameter logic [3:0] N = 4'd8;
    parameter logic [2:0] WIDTH = 3'd5;

    logic clk;
    logic rst;
    logic start;
    logic done;
    
    logic [WIDTH - 1:0] in_data [0:N - 1];
    logic [WIDTH - 1:0] out_data [0:N - 1];
    logic [WIDTH - 1:0] expected [0:N - 1];

    ntt_top #(
        .N(N),
        .LOG_N(3'd3),
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .in_data(in_data),
        .done(done),
        .out_data(out_data)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        start = 0;

        $readmemh("input.mem", in_data);
        $readmemh("expected.mem", expected);

        #20;
        rst = 0;
        
        #10;
        start = 1;
        #10;
        start = 0;

        wait(done == 1'b1);
        
        #10; 

       for (int i = 0; i < 8; i = i + 1) begin
            if (out_data[i] !== expected[i]) begin
                $display("Mismatch at index %0d: got %0d expected %0d", i, out_data[i], expected[i]);
                // $fatal;
            end
        end

        $display("PASS");
        for (int i = 0; i < 8; i = i + 1) begin
            $display("out[%0d] = %0h", i, out_data[i]);
        end 

        $finish;
    end
endmodule
