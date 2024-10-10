--  A testbench has no ports.
entity adder_tb is
end adder_tb;

architecture behav of adder_tb is
    --  Declaration of the component that will be instantiated.
    component adder
    port (a, b : in bit; c_in : in bit; sum : out bit; c_out : out bit);
    end component;

    --  Specifies which entity is bound with the component.
    for adder_0: adder use entity work.adder;
    signal a, b, c_in, sum, c_out : bit;
begin
    --  Component instantiation.
    adder_0: adder port map (a => a, b => b, c_in => c_in, sum => sum, c_out => c_out);

    --  This process does the real job.
    process
    type pattern_type is record
        --  The inputs of the adder.
        a, b, c_in : bit;
        --  The expected outputs of the adder.
        sum, c_out : bit;
    end record;
    --  The patterns to apply.
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
        (('0', '0', '0', '0', '0'),
        ('0', '0', '1', '1', '0'),
        ('0', '1', '0', '1', '0'),
        ('0', '1', '1', '0', '1'),
        ('1', '0', '0', '1', '0'),
        ('1', '0', '1', '0', '1'),
        ('1', '1', '0', '0', '1'),
        ('1', '1', '1', '1', '1'));
    begin
    --  Check each pattern.
    for i in patterns'range loop
        --  Set the inputs.
        a <= patterns(i).a;
        b <= patterns(i).b;
        c_in <= patterns(i).c_in;
        --  Wait for the results.
        wait for 1 ns;
        --  Check the outputs.
        assert sum = patterns(i).sum
        report "bad sum value" severity error;
        assert c_out = patterns(i).c_out
        report "bad carry out value" severity error;
    end loop;
    assert false report "end of test" severity note;
    --  Wait forever; this will finish the simulation.
    wait;
    end process;

end behav;