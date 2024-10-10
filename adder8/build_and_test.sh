#!/bin/bash
# Convenience script to build and test adder8 assignment
set -e  # exit if any command fails (non-zero exit code)
ghdl -a adder.vhdl
ghdl -e adder

ghdl -a adder4.vhdl
ghdl -e adder4

ghdl -a adder8.vhdl
ghdl -e adder8

ghdl -a adder8_tb.vhdl
ghdl -e adder8_tb
ghdl -r adder8_tb