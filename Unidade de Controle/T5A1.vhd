entity signExtend is
    port(
    i: in  bit_vector(31 downto 0);
    o: out bit_vector(63 downto 0)
    );
end signExtend;

-- Resultado do envio: Sucesso (arquivo processado).
-- Mensagem: Judge could not find your grade. Check garbage printed on screen before resubmission. Nota: 0.00
-- Submissão #9478 (use isto se precisar falar com o seu professor)
-- #9498
architecture arch_signE of signExtend is
    constant LDUR : bit_vector (31 downto 21):= "11111000010";
    constant STUR : bit_vector (31 downto 21) := "11111000000";
    constant CBZ : bit_vector (31 downto 24) := "10110100";
    constant B : bit_vector (31 downto 26) := "000101";
    signal addr_D : bit_vector (20 downto 12);
    signal addr_CBZ : bit_vector (23 downto 5);
    signal addr_B : bit_vector (25 downto 0);
    signal opcode_B : bit_vector (31 downto 26);
    signal opcode_CBZ : bit_vector (31 downto 24);
    signal opcode_D : bit_vector (31 downto 21);
begin
    addr_B <= i(25 downto 0);
    addr_CBZ <= i(23 downto 5);
    addr_D <= i(20 downto 12);
    opcode_B <= i(31) & i(30) & i(29) & i(28) & i(27) & i(26);
    opcode_CBZ <= i(31) & i(30) & i(29) & i(28) & i(27) & i(26) & i(25) & i(24);
    opcode_D <= i(31) & i(30) & i(29) & i(28) & i(27) & i(26) & i(25) & i(24) & i(23) & i(22) & i(21);
    
    
    o <="11111111111111111111111111111111111111" & addr_B when (opcode_B = B and addr_B(25) = '1') else 
        "00000000000000000000000000000000000000" & addr_B when (opcode_B = B and addr_B(25) = '0') else
        "111111111111111111111111111111111111111111111" & addr_CBZ when (opcode_CBZ = CBZ and addr_CBZ(23) = '1') else  
        "000000000000000000000000000000000000000000000" & addr_CBZ when (opcode_CBZ = CBZ and addr_CBZ(23) = '0') else
        "1111111111111111111111111111111111111111111111111111111" & addr_D when ((opcode_D = LDUR or (opcode_D = STUR)) and addr_D(20) = '1') else 
        "0000000000000000000000000000000000000000000000000000000" & addr_D when ((opcode_D = LDUR or (opcode_D = STUR)) and addr_D(20) = '0');  
end architecture arch_signE;