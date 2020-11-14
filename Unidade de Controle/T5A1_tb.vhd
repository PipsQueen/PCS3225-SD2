entity T5A1_tb is
end entity;

architecture arch_T5A1_tb of T5A1_tb is
    component signExtend is
        port(
        i: in  bit_vector(31 downto 0);
        o: out bit_vector(63 downto 0)
        );
    end component;

    signal simulando : bit;
    signal tb_input : bit_vector (31 downto 0);
    signal tb_output: bit_vector (63 downto 0);
begin
    
    sigex : signExtend port map (tb_input, tb_output);
    stim_proc: process
    begin
        report "Testando...";
        simulando <= '1';

        tb_input <= "11111000010011111111000000000000";
        assert tb_output = "0000000000000000000000000000000000000000000000000000000011111111" report "1. LDUR in addr 0FF is OK";
        wait for 1 ns;
        tb_input <= "11111000010111111111000000000000";
        assert tb_output = "1111111111111111111111111111111111111111111111111111111111111111" report "2. LDUR in addr 1FF is OK";
        wait for 1 ns;
        tb_input <= "11111000000011111111000000000000";
        assert tb_output = "0000000000000000000000000000000000000000000000000000000011111111" report "3. STUR in addr 0FF is OK";
        wait for 1 ns;
        tb_input <= "11111000000111111111000000000000";
        assert tb_output = "1111111111111111111111111111111111111111111111111111111111111111" report "4. STUR in addr 1FF is OK";
        wait for 1 ns;
        tb_input <= "10110100011111111111111111100000";
        assert tb_output = "0000000000000000000000000000000000000000000000111111111111111111" report "5. CBZ in addr 3FFFF is OK";
        wait for 1 ns;
        tb_input <= "10110100111111111111111111100000";
        assert tb_output = "1111111111111111111111111111111111111111111111111111111111111111" report "6. CBZ in addr 7FFFF is OK";
        wait for 1 ns;
        tb_input <= "00010101111111111111111111111111";
        assert tb_output = "0000000000000000000000000000000000000000111111111111111111111111" report "7. B in addr 0FFFFFF is OK";
        wait for 1 ns;
        tb_input <= "00010111111111111111111111111111";
        assert tb_output = "1111111111111111111111111111111111111111111111111111111111111111" report "8. B in addr 1FFFFFF is OK";
        wait for 1 ns;


        simulando <= '0';
        report "Fim dos testes.";
        wait;
    end process;
    
    
end architecture arch_T5A1_tb;