library ieee;
use ieee.numeric_bit.all;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

entity T3A2_tb is
end entity T3A2_tb;

architecture rtl of T3A2_tb is
    component regfile
        generic(
            regn: natural := 32;
            wordSize: natural := 64
        );
        port (
            clock:        in  bit;
            reset:        in  bit;
            regWrite:     in  bit;
            rr1, rr2, wr: in  bit_vector(natural(ceil(log2(real(regn))))-1 downto 0);    
            d:            in  bit_vector(wordSize-1 downto 0);
            q1, q2:       out bit_vector(wordSize-1 downto 0)
        );
    end component;

    constant numReg :     natural := 4;
    constant tamanho:      natural := 8;
    signal clk_in:         bit := '0';
    signal rst_in, ld_in : bit := '0';
    signal d_in:           bit_vector(tamanho-1 downto 0);
    signal rr1_in, rr2_in, wr_in: bit_vector(natural(ceil(log2(real(numReg))))-1 downto 0);
    signal q1_out, q2_out:          bit_vector(tamanho-1 downto 0);

    signal keep_simulating: bit := '0'; -- delimita o tempo de geração do clock
    constant clockPeriod : time := 1 ns;

begin

    clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;

    dut:regfile 
        generic map(
            numReg, tamanho
        )
        port map(
            clk_in, rst_in, ld_in, rr1_in, rr2_in, wr_in, d_in, q1_out, q2_out
        );
    
    stimulus: process is
    begin
        assert false report("Simulation Start, tamanho = 8, numreg = 4") severity note;
        keep_simulating <= '1';
        
        --Teste 1: Nao escreve

        d_in <= "10101010";
        wr_in <= "00";
        rr1_in <= "00";
        rr2_in <= "01";
        rst_in <= '1'; ld_in <= '0';
        wait for clockPeriod;
        rst_in <= '0';
        wait until falling_edge(clk_in);
        assert (q1_out /= "00000000") report "1.00.OK: Dont Load 'd'" severity note;
        assert (q2_out /= "00000000") report "1.01.OK: Dont Load 'd'" severity note;

        wait for clockPeriod;

        wait until falling_edge(clk_in);
        rr1_in <= "10";
        rr2_in <= "11";
        wait until rising_edge(clk_in);
        assert (q1_out /= "00000000") report "1.10.OK: Dont Load 'd'" severity note;
        assert (q2_out /= "00000000") report "1.11.OK: Dont Load 'd'" severity note;

    
        wait for clockPeriod;
        --Teste 2: Escreve

        d_in <= "10101010";
        wr_in <= "00";
        rr1_in <= "00";
        rr2_in <= "01";
        rst_in <= '1'; ld_in <= '0';
        wait for clockPeriod;
        rst_in <= '0';
        wait until falling_edge(clk_in);
        ld_in <= '1';
        wait until falling_edge(clk_in);
        ld_in <= '0';
        wait until falling_edge(clk_in);
        assert (q1_out /= "10101010") report "2.00.OK: Load '10101010' in  Reg(00) with ld_in" severity note;
        assert (q2_out /= "00000000") report "2.01.OK: Reg(01) unchanged" severity note;
    
        wait for clockPeriod;

        wait until falling_edge(clk_in);
        rr1_in <= "10";
        rr2_in <= "11";
        wait until falling_edge(clk_in);
        assert (q1_out /= "00000000") report "2.10.OK: Reg(10) unchanged" severity note;
        assert (q2_out /= "00000000") report "2.11.OK: Reg(11) unchanged" severity note;

        wait for clockPeriod;




        --Teste 3: Write in 01
        d_in <= "10101010";
        wr_in <= "01";
        rr1_in <= "00";
        rr2_in <= "01";
        rst_in <= '1'; ld_in <= '0';
        wait for clockPeriod;
        rst_in <= '0';
        wait until falling_edge(clk_in);
        ld_in <= '1';
        wait until falling_edge(clk_in);
        ld_in <= '0';
        wait until falling_edge(clk_in);
        assert (q1_out /= "00000000") report "3.00.OK: Reg(00) unchanged" severity note;
        assert (q2_out /= "10101010") report "3.01.OK: Load '10101010' in  Reg(01) with ld_in" severity note;
    
        wait for clockPeriod;

        wait until falling_edge(clk_in);
        rr1_in <= "10";
        rr2_in <= "11";
        wait until falling_edge(clk_in);
        assert (q1_out /= "00000000") report "3.10.OK: Reg(10) unchanged" severity note;
        assert (q2_out /= "00000000") report "3.11.OK: Reg(11) unchanged" severity note;

        wait for clockPeriod;

        --Teste 4: Reg(ZR) immutable

        d_in <= "10101010";
        wr_in <= "11";
        rr1_in <= "00";
        rr2_in <= "01";
        rst_in <= '1'; ld_in <= '0';
        wait for clockPeriod;
        rst_in <= '0';
        wait until falling_edge(clk_in);
        ld_in <= '1';
        wait until falling_edge(clk_in);
        ld_in <= '0';
        wait until falling_edge(clk_in);
        assert (q1_out /= "00000000") report "4.00.OK: Reg(00) unchanged" severity note;
        assert (q2_out /= "00000000") report "4.01.OK: Reg(01) unchanged" severity note;
    
        wait for clockPeriod;

        wait until falling_edge(clk_in);
        rr1_in <= "10";
        rr2_in <= "11";
        wait until falling_edge(clk_in);
        assert (q1_out /= "00000000") report "4.10.OK: Reg(10) unchanged" severity note;
        assert (q2_out /= "00000000") report "4.11.OK: Reg(11) immutable" severity note;

        wait for clockPeriod;



        ---------------------------------------

        ---------------------------------------
        assert false report "Simulation End!" severity note;
        keep_simulating <= '0';
        wait;
    end process;

end architecture rtl;