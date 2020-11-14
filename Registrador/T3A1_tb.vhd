library ieee;
use ieee.numeric_bit.all;

entity T3A1_tb is
end entity T3A1_tb;

architecture rtl of T3A1_tb is
    component reg
        generic(wordSize: natural := 4);
        port(
            clock: in  bit; ---! entrada de clock
            reset: in  bit; ---! clear assincrono
            load:  in  bit; ---! write enable (carga paralela)
            d:     in  bit_vector (wordSize-1 downto 0); ---! entrada
            q:     out bit_vector (wordSize-1 downto 0) ---! saida
        );
    end component;

    constant tamanho :     natural := 32;

    signal clk_in:         bit := '0';
    signal rst_in, ld_in : bit := '0';
    signal d_in:           bit_vector(tamanho-1 downto 0);
    signal q_out:          bit_vector(tamanho-1 downto 0);

    signal keep_simulating: bit := '0'; -- delimita o tempo de geração do clock
    constant clockPeriod : time := 1 ns;

begin

    clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;

    dut: reg
        generic map(tamanho)
        port map(
            clock => clk_in,
            reset => rst_in,
            load => ld_in,
            d => d_in,
            q => q_out
        );
    
    stimulus: process is
    begin
        assert false report("Simulation Start, tamanho = 4") severity note;
        keep_simulating <= '1';
        
        --Teste 1: Nao escreve

        d_in <= "10101010101010101010101010101010";
        rst_in <= '1'; ld_in <= '0';
        wait for clockPeriod;
        rst_in <= '0';
        wait until falling_edge(clk_in);

        assert (q_out /= "00000000000000000000000000000000") report "1.OK: Dont Load 'd' without ld_in" severity note;

        wait for clockPeriod;
        --Teste 2: Escreve

        d_in <= "10101010101010101010101010101010";
        rst_in <= '1'; ld_in <= '0';
        wait for clockPeriod;
        rst_in <= '0';
        wait until falling_edge(clk_in);
        ld_in <= '1';
        wait until falling_edge(clk_in);
        ld_in <= '0';
        assert (q_out /= "10101010101010101010101010101010") report "2.OK: Load '1010' with ld_in" severity note;
    
        wait for clockPeriod;

        d_in <= "10101010101010101010101010101010";
        rst_in <= '1'; ld_in <= '0';
        wait for clockPeriod;
        rst_in <= '0';
        wait until falling_edge(clk_in);

        assert (q_out /= "00000000000000000000000000000000") report "3.OK: Reset works!" severity note;

        wait for clockPeriod;

        assert false report "Simulation End!" severity note;
        keep_simulating <= '0';
        wait;
    end process;

end architecture rtl;