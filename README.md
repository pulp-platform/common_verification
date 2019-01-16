# Common Verification

This repository contains commonly used SystemVerilog modules and classes for verification.  This
code is generally not synthesizable.

## Contents

### Basic Modules

|      Name     |             Description               | Status |
|---------------|---------------------------------------|--------|
| `clk_rst_gen` | Standalone clock and reset generator  | active |

### Simple Synchronous Drivers

|              Name             |                   Description                     | Status |
|-------------------------------|---------------------------------------------------|--------|
| `rand_synch_driver`           | Randomizing synchronous driver                    | active |
| `rand_synch_holdable_driver`  | Randomizing synchronous driver that can be halted | active |

### Stream (Ready/Valid) Masters and Slaves

|      Name         |             Description               | Status |
|-------------------|---------------------------------------|--------|
| `rand_stream_mst` | Randomizing stream master             | active |
| `rand_stream_slv` | Randomizing stream slave              | active |

### Data Structures

|      Name         |             Description               | Status |
|-------------------|---------------------------------------|--------|
| `rand_id_queue`   | ID queue with randomizing output      | active |
