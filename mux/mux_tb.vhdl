use std.textio.all; -- Imports the standard textio package.

--  A testbench has no ports.
entity mux_tb is
end mux_tb;

architecture behav of mux_tb is
  --  Declaration of the component that will be instantiated.
  component mux
    port (a, b : in bit; s : in bit; c : out bit);
  end component;

  --  Specifies which entity is bound with the component.
  for mux_0: mux use entity work.mux;
  signal i0, i1, s, ci : bit;
begin
  --  Component instantiation.
  mux_0: mux port map (a => i0, b => i1, s => ci,
                           C => s);

  --  This process does the real job.
  process
    
    variable my_line : line; -- For debug purposes
    variable expected_result : bit;

    type pattern_type is record
      --  The inputs of the adder. 
      a, b, s1 : bit;
      --  The expected outputs of the mux.
      r : bit;
    end record;

    --  The test patterns to apply.
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (('0', '0', '0', '0'),
       ('0', '0', '1', '0'),
       ('0', '1', '0', '0'),
       ('0', '1', '1', '1'),
       ('1', '0', '0', '1'),
       ('1', '0', '1', '0'),
       ('1', '1', '0', '1'),
       ('1', '1', '1', '1'));
  begin
    --  Check each pattern.
    for i in patterns'range loop
      --  Set the inputs.
      i0 <= patterns(i).a; 	
      i1 <= patterns(i).b;
      ci <= patterns(i).s1;

      --  Wait for the results.
      wait for 10 ns;
 
      expected_result := patterns(i).r;
      write (my_line, string'("(a, b, c)"));
      write (my_line, string'("("));
      write (my_line, patterns(i).a);
      write (my_line, string'(", "));
      write (my_line, patterns(i).b);
      write (my_line, string'(", "));
      write (my_line, patterns(i).s1);
      write (my_line, string'(") Output "));
      write (my_line, s);
      write (my_line, string'("; Expected: "));
      write (my_line, expected_result);
      writeline (output, my_line);

      --  Check the outputs.
      assert ( s = expected_result )
        report "bad sum value" severity error;

    end loop;
    assert false report "end of test" severity note;
    --  Wait forever; this will finish the simulation.
    wait;
  end process;
end behav;

