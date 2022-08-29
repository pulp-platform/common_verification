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

/// Highlights a signal in the waveform for easier viewing
module signal_highlighter #(
    parameter type T = logic
)(
    input logic ready_i,
    input logic valid_i,
    input T data_i
);

    T in_wave;

    always_comb begin
        in_wave = 'Z;
        if (ready_i & valid_i) begin
            in_wave = data_i;
        end
    end

endmodule
