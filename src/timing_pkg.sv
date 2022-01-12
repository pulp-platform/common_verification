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

/// Package with functions and tasks commonly used in ATI timing
package timing_pkg;

    class ati_utility;
        
        typedef virtual clk_if clk_vif_t;

        bit initialized;
        clk_vif_t clk_vif;
        time appl_delay, test_delay;

        function new(clk_vif_t clk_vif);
            this.clk_vif = clk_vif;
            this.appl_delay = 0;
            this.test_delay = 0;
            this.initialized = 0;
        endfunction

        function void uninit_warning();
            if (!this.initialized) $warning("ATI delays uninitialized");
        endfunction

        task init(time appl_delay, test_delay);
            // Measure clock period
            time st, clk_period;
            @(posedge clk_vif.clk);
            st = $time;
            @(posedge clk_vif.clk);
            clk_period = $time - st;

            // Consistency checks on delays
            assert (appl_delay < clk_period) else $error("Application delay greater than clock period");
            assert (test_delay < clk_period) else $error("Test delay greater than clock period");

            // Configure
            this.appl_delay  = appl_delay;
            this.test_delay  = test_delay;
            this.initialized = 1;
        endtask

        task wait_cycles(int unsigned n);
            repeat(n) @(posedge(clk_vif.clk));
        endtask

        task appl_wait_cycles(int unsigned n);
            uninit_warning();
            this.wait_cycles(n);
            #(appl_delay);
        endtask

        task test_wait_cycles(int unsigned n);
            uninit_warning();
            repeat(n) @(posedge(clk_vif.clk));
            #(test_delay);
        endtask

        task test_wait_sig(ref logic sig);
            uninit_warning();
            do begin
                @(posedge(clk_vif.clk));
                #(test_delay);
            end while(sig == 1'b0);
        endtask

        task wait_test();
            uninit_warning();
            #(test_delay);
        endtask

        task wait_appl();
            uninit_warning();
            #(appl_delay);
        endtask

        task wait_appl_to_test();
            uninit_warning();
            #(test_delay - appl_delay);
        endtask

    endclass

endpackage