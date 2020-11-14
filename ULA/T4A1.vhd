entity alu1bit is
port (
a,b,less,cin : in bit ;
result, cout, set , overflow : out bit ;
ainvert , binvert : in bit ;
operation : in bit_vector (1 downto 0)
);
end entity ;

architecture alu1_arch of alu1bit is
    component fulladder
    port (
        a, b, cin: in bit;
        s, cout: out bit
    );
    end component;

    signal a_usado, b_usado : bit;
    signal amaisb : bit;
    signal aeb, aoub : bit;
    signal cout_mid : bit;
    constant OPAND : bit_vector (1 downto 0) := "00";
    constant OPORR : bit_vector (1 downto 0) := "01";
    constant OPADD : bit_vector (1 downto 0) := "10";
    constant OPSLT : bit_vector (1 downto 0) := "11";
begin
    ---Sinais Intermediarios---
    a_usado <= a xor ainvert;
    b_usado <= b xor binvert;
    somador : fulladder port map (a_usado, b_usado, cin, amaisb, cout_mid);
    aeb <= a_usado and b_usado;
    aoub <= a_usado or b_usado;

    ---Saidas---
    set <= amaisb;

    with operation select result <=
        aeb when OPAND,
        aoub when OPORR;
        amaisb when OPADD,
        less when OPSLT;
    
    overflow <= cin xor cout_mid;
    
    cout <= cout_mid;
end architecture alu1_arch;