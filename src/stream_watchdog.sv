// Copyright (c) 2022 ETH Zurich, University of Bologna
//
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// Author: Thomas Benz <tbenz@ethz.ch>

/// Terminates simulation in case a ready-valid handshake is inactive or deadlocked for NumCycles
module stream_watchdog #(
    parameter int unsigned NumCycles
)(
    input logic clk_i,
    input logic rst_ni,
    input logic valid_i,
    input logic ready_i
);

    int unsigned cnt;

    initial begin : wd
        // initialize counter
        cnt = NumCycles;

        // count down when inactive, restore on activity
        while (cnt > 0) begin
            if (valid_i && ready_i || !rst_ni) begin
                cnt = NumCycles;
            end else begin
                cnt--;
            end
            @(posedge clk_i);
        end

        // tripped watchdog
        $fatal(1, "Tripped Watchdog (%m) at %dns, Inactivity for %d cycles", $time(), NumCycles);
    end

endmodule
