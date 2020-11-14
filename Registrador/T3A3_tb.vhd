library ieee;
use ieee.numeric_bit.all;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

entity T3A3_tb is
end entity T3A3_tb;

architecture rtl of T3A3_tb is
    component calc
        port (
            clock : in bit;
            reset : in bit;
            instruction : in bit_vector(15 downto 0);
            overflow : out bit;
            q1 : out bit_vector (15 downto 0)
        );
    end component;

    signal clk_in:         bit := '0';
    signal rst_in: bit := '0';
    signal inst_in: bit_vector (15 downto 0);
--- INSTRUCTION    = |(opcod)|(oper2)|(oper1)|(desti)|
--- SIZE (15 bits) = | 1 bit | 5 bit | 5 bit | 5 bit |
---                  |1 = ADD| Addr2 | Addr1 | AddrO |
---                  |0 = ADI| Immed | Addr1 | AddrO |
    signal ovf_out : bit;
    signal q1_out : bit_vector (15 downto 0);

    signal keep_simulating: bit := '0'; -- delimita o tempo de geração do clock
    constant clockPeriod : time := 1 ns;

begin
    clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;

    dut: calc port map(
        clk_in,
        rst_in,
        inst_in,
        ovf_out,
        q1_out
    );
    
    stimulus: process is
    begin
        assert false report("Simulation Start, tamanho = 8, numreg = 4") severity note;
        keep_simulating <= '1';
        
        rst_in <= '1';
        wait until falling_edge(clk_in);
        rst_in <= '0';
        ---         0 00001 11111 00000;
        inst_in <= '0' & "00001" & "11111" & "00000"; -- Coloca 1 no endereco 00000 ADDI X0, XZR, #1
        wait until falling_edge(clk_in);    
        inst_in <= "0000000000000000"; -- ADDI X0, X0, #0 le o valor de X0
        wait for clockPeriod;
        wait for clockPeriod;
        wait for clockPeriod;
        assert (q1_out /= "0000000000000001") report ("ADDI X0, XZR, #1 --OK") severity note;

        wait for clockPeriod;

        inst_in <= '0' & "00010" & "11111" & "00001"; -- Coloca 1 no endereco 00000 ADDI X1, XZR, #1
        wait until falling_edge(clk_in);    
        inst_in <= '0' & "00000" & "00001" & "00001"; -- ADDI X1, X1, #0 le o valor de X0
        wait for clockPeriod;
        wait for clockPeriod;
        wait for clockPeriod;
        assert (q1_out /= "0000000000000010") report ("ADDI X1, XZR, #2 --OK") severity note;
        
        wait for clockPeriod;
        wait for clockPeriod;
        wait for clockPeriod;
        wait for clockPeriod;
        wait for clockPeriod;
        wait for clockPeriod;

        inst_in <= '1' & "00001" & "00000" & "00010"; -- Coloca 1 no endereco 00000 ADDI X1, XZR, #1
        wait for clockPeriod;
        wait until falling_edge(clk_in);    
        inst_in <= '0' & "00000" & "00010" & "00010"; -- ADDI X1, X1, #0 le o valor de X0
        wait for clockPeriod;
        wait for clockPeriod;
        wait for clockPeriod;
        assert (q1_out /= "0000000000000011") report ("ADDI X2, X1, X2 --OK") severity note;
        ---------------------------------------
        wait for clockPeriod;
        ---------------------------------------
        assert false report "Simulation End!" severity note;
        keep_simulating <= '0';
        wait;
    end process;

end architecture rtl;