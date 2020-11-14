entity alucontrol is
    port(
        aluop   : in  bit_vector(1  downto 0);
        opcode  : in  bit_vector(10 downto 0);
        aluCtrl : out bit_vector(3 downto 0)
    );
end entity;

architecture arch_aluControl of alucontrol is
    constant OPER1 : bit_vector (10 downto 0) := "10001011000";
    constant OPER2 : bit_vector (10 downto 0) := "11001011000";
    constant OPER3 : bit_vector (10 downto 0) := "10001010000";
    constant OPER4 : bit_vector (10 downto 0) := "10101010000";
begin
    aluCtrl <=  "0010" when ((aluop(1) or aluop(0)) = '0') else
                "0111" when ((aluop(0) = '1')) else
                "0010" when ((aluop(1) = '1') and (opcode = OPER1)) else
                "0110" when ((aluop(1) = '1') and (opcode = OPER2)) else
                "0000" when ((aluop(1) = '1') and (opcode = OPER3)) else
                "0001" when ((aluop(1) = '1') and (opcode = OPER4));
    
end architecture arch_aluControl;