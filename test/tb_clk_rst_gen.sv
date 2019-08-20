module tb_clk_rst_gen #(
  parameter time          ClkPeriod = 2ns,
  parameter int unsigned  RstClkCycles = 5
) ();

  logic clk, rst_n;

  clk_rst_gen #(
    .ClkPeriod    (ClkPeriod),
    .RstClkCycles (RstClkCycles)
  ) i_dut (
    .clk_o  (clk),
    .rst_no (rst_n)
  );

  int unsigned rst_cycles;
  initial begin
    rst_cycles = 0;
    wait(rst_n);
    forever begin
      @(posedge clk);
      if (!rst_n) begin
        rst_cycles++;
      end
      if (rst_cycles > RstClkCycles) begin
        $error("Number of reset clock cycles exceeded!");
      end
      if (rst_n) begin
        break;
      end
    end
  end

  initial begin
    automatic int unsigned cycles = 0;
    forever begin
      @(posedge clk);
      cycles++;
      if (cycles > 100) begin
        $display("Generated 100 cycles.");
        $finish();
      end
    end
  end

endmodule
