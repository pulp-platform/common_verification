// Copyright (c) 2021 ETH Zurich, University of Bologna
// Licensed under the Solderpad Hardware License, Version 0.51.
// SPDX-License-Identifier: SHL-0.51
//
// Authors:
// - Andreas Kurth <akurth@iis.ee.ethz.ch>

module tb_clk_rst_gen #(
  parameter time TbClkPeriod = 10ns,
  parameter int unsigned TbClkCycles = 12,
  parameter int unsigned TbRstClkCycles = 7,
  parameter bit TbDebugPrint = 1'b0
) ();

  logic clk,
        rst_n;

  // DUT
  clk_rst_gen #(
    .ClkPeriod    (TbClkPeriod),
    .RstClkCycles (TbRstClkCycles)
  ) i_dut (
    .clk_o  (clk),
    .rst_no (rst_n)
  );

  int unsigned  clk_cnt,
                rst_cnt;
  initial begin
    clk_cnt = 0;
    rst_cnt = 0;
    while (1) begin
      #(TbClkPeriod - 1); // Advance to end of clock cycle.
      if (rst_n == 1'b0) begin
        rst_cnt++;
        if (TbDebugPrint) $info("Reset clock cycle complete");
      end
      @(posedge clk);
      clk_cnt++;
      if (TbDebugPrint) $info("Clock cycle complete");
    end
  end

  initial begin
    static time TB_RUN_TIME = TbClkCycles * TbClkPeriod + (TbClkPeriod / 2);
    assert (TbRstClkCycles < TbClkCycles)
      else $fatal(1, "The number of clock cycles must be larger than the number of reset cycles!");
    #TB_RUN_TIME;
    assert (clk_cnt == TbClkCycles)
      else $error("Counted %0d instead of %0d clock cycles!", clk_cnt, TbClkCycles);
    assert (rst_cnt == TbRstClkCycles)
      else $error("Counted %0d instead of %0d reset clock cycles!", rst_cnt, TbRstClkCycles);
    $finish();
  end

endmodule
