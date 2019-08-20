module tb_rand_stream_mst_and_slv #(
  parameter time  ClkPeriod = 10ns,
  parameter type  data_t = logic,
  parameter int   MstMinWaitCycles = 0,
  parameter int   MstMaxWaitCycles = 10,
  parameter int   SlvMinWaitCycles = 0,
  parameter int   SlvMaxWaitCycles = 10,
  parameter time  ApplDelay = 2ns,
  parameter time  AcqDelay = 7ns
) ();

  logic clk, rst_n;
  clk_rst_gen #(
    .ClkPeriod    (ClkPeriod),
    .RstClkCycles (10)
  ) i_clk_gen (
    .clk_o  (clk),
    .rst_no (rst_n)
  );

  sim_timeout #(
    .Cycles (10000)
  ) i_timeout (
    .clk_i  (clk),
    .rst_ni (rst_n)
  );

  data_t  data;
  logic   valid, ready;
  rand_stream_mst #(
    .data_t         (data_t),
    .MinWaitCycles  (MstMinWaitCycles),
    .MaxWaitCycles  (MstMaxWaitCycles),
    .ApplDelay      (ApplDelay),
    .AcqDelay       (AcqDelay)
  ) i_dut_mst (
    .clk_i    (clk),
    .rst_ni   (rst_n),
    .data_o   (data),
    .valid_o  (valid),
    .ready_i  (ready)
  );
  rand_stream_slv #(
    .data_t         (data_t),
    .MinWaitCycles  (SlvMinWaitCycles),
    .MaxWaitCycles  (SlvMaxWaitCycles),
    .ApplDelay      (ApplDelay),
    .AcqDelay       (AcqDelay),
    .Enqueue        (1'b0)
  ) i_dut_slv (
    .clk_i    (clk),
    .rst_ni   (rst_n),
    .data_i   (data),
    .valid_i  (valid),
    .ready_o  (ready)
  );

  // Check handshakes.
  int unsigned handshakes;
  initial begin
    handshakes = 0;
    wait(rst_n);
    forever begin
      @(posedge clk);
      #(AcqDelay);
      if (valid && ready) begin
        handshakes += 1;
      end
      if (handshakes > 100) begin
        $display("Successfully checked 100 random handshakes.");
        $finish();
      end
    end
  end

endmodule
