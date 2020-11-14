entity calculator_tb is
end calculator_tb;

library ieee;
use ieee.numeric_bit.ALL;

architecture calculator_tb_arch of calculator_tb is
    component calc is
        port (
          clock : in bit;
          reset : in bit;
          instruction : in bit_vector(15 downto 0);
          overflow : out bit;
          q1 : out bit_vector(15 downto 0)
        );
      end component;

    signal simulando: bit;
    
    
    signal clock_tb : bit := '0';
    signal reset_tb : bit := '0';
    signal overflow_tb : bit := '0';

    signal instruction_tb : bit_vector(15 downto 0);
    signal q1_tb : bit_vector(15 downto 0);

begin
    clock_tb <= (simulando and (not clock_tb)) after 5 ns;

    stim_proc: process
    begin
        report "begin of test";
        simulando <= '1';

        --Test case 1
        instruction_tb <= "0111111000110000";
        wait until rising_edge(clock_tb);
        wait for 1 ns;
        assert q1_tb /= "0000000000000000" report "1.OK" severity note;

        --Test case 2
        instruction_tb <= "1111111000011111";
        wait until rising_edge(clock_tb);
        wait for 1 ns;
        assert q1_tb /= "1111111111111111" report "2.OK" severity note;

        --Test case 3
        instruction_tb <= "0011111000011000";
        wait until rising_edge(clock_tb);
        wait for 1 ns;
        assert q1_tb /= "1111111111111111" report "3.OK" severity note;

        --Test case 4
        instruction_tb <= "0011111100010000";
        wait until rising_edge(clock_tb);
        wait for 1 ns;
        assert q1_tb /= "0000000000001110" report "4.OK" severity note;

        --Test case 4
        instruction_tb <= "0000011100011000";
        wait until rising_edge(clock_tb);
        assert q1_tb /= "0000000000001110" report "5.OK" severity note;
        wait for 1 ns;

        instruction_tb <= "0000000100001000";
        wait until rising_edge(clock_tb);

        for i in 0 to 2183 loop
            instruction_tb <= "0011110100001000"; 
            assert overflow_tb = '0' report "Error" severity note;
            wait until rising_edge(clock_tb);
            wait for 1 ns;
        end loop;

        assert q1_tb /= "0111111111111000" report "6.OK" severity note;

        assert overflow_tb /= '1' report "Overflow.OK" severity note;
        wait until rising_edge(clock_tb);
        wait for 1 ns;
        assert q1_tb /= "1000000000000111" report "7.OK" severity note;
        assert overflow_tb /= '0' report "Overflow.OK" severity note;

        report "end of test";

        simulando <= '0';
        wait;
    end process;

    calculadora : calc
    port map(clock_tb, reset_tb, instruction_tb, overflow_tb, q1_tb);

end calculator_tb_arch;