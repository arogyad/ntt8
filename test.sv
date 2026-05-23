module test;
    logic clk;
    logic rst;
    logic start;
    logic done;

    logic [4:0] in_data [0:7];
    logic [4:0] out_data [0:7];
    logic [4:0] expected [0:7];

    integer i;

    ntt8_top dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .in_data(in_data),
        .done(done),
        .out_data(out_data)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
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

        wait(done == 1);
        #1;

        for (i = 0; i < 8; i = i + 1) begin
            if (out_data[i] !== expected[i]) begin
                $display("Mismatch at index %0d: got %0d expected %0d", i, out_data[i], expected[i]);
                $fatal;
            end
        end

        $display("PASS");
        for (i = 0; i < 8; i = i + 1) begin
            $display("out[%0d] = %0d", i, out_data[i]);
        end

        $finish;
    end
endmodule