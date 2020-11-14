entity controlunit is
    port(
        -- To Datapath
        reg2loc : out bit;
        uncondBranch : out bit;
        branch : out bit;
        memRead : out bit;
        memToReg : out bit;
        aluOp : out bit_vector (1 downto 0);
        memWrite : out bit;
        aluSrc : out bit;
        regWrite : out bit;
        -- From Datapath
        opcode : in bit_vector (10 downto 0)
    );
end entity;

architecture arch_contrunit of controlunit is
    constant LDUR : bit_vector (10 downto 0) := "11111000010";
    constant STUR : bit_vector (10 downto 0) := "11111000000";
    constant CADD : bit_vector (10 downto 0) := "10001011000";
    constant SUB : bit_vector (10 downto 0) := "11001011000";
    constant CAND : bit_vector (10 downto 0) := "10001010000";
    constant ORR : bit_vector (10 downto 0) := "10101010000";
    constant CBZ : bit_vector (10 downto 0) := "10110100000";
    constant B : bit_vector (10 downto 0) := "00010100000";
begin
    reg2loc <= '1' when ((opcode = LDUR) or (opcode = STUR) or (opcode = CBZ) or (opcode = B)) else 
               '0' when ((opcode = CADD) or (opcode = SUB) or (opcode = CAND) or (opcode = ORR));
    aluSrc <= '1' when ((opcode = LDUR) or (opcode = STUR)) else 
              '0' when ((opcode = CBZ) or (opcode = B) or (opcode = CADD) or (opcode = SUB) or (opcode = CAND) or (opcode = ORR));
    UncondBranch <= '1' when opcode = b else '0';
    memToReg <= '1' when ((opcode = LDUR) or (opcode = STUR) or (opcode = CBZ) or (opcode = B)) else 
                '0' when ((opcode = CADD) or (opcode = SUB) or (opcode = CAND) or (opcode = ORR));
    regWrite <= '1' when ((opcode  = LDUR) or (opcode = CADD) or (opcode = SUB) or (opcode = ORR) or (opcode = CAND)) else 
                '0' when ((opcode = STUR) or (opcode = CBZ) or (opcode = B));
    memRead <= '1' when (opcode = LDUR) else '0';
    memWrite <=  '1' when opcode = STUR else '0';
    branch <= '1' when opcode = CBZ else '0';
    aluOp <= "00" when opcode = LDUR or opcode = STUR or opcode = B else
             "01" when opcode = CBZ else
             "10";

    
    
end architecture arch_contrunit;