entity fulladder is
    port (
      a, b, cin: in bit;
      s, cout: out bit
    );
  end entity;
  -------------------------------------------------------
  architecture structural of fulladder is
    signal axorb: bit;
  begin
    axorb <= a xor b;
    s <= axorb xor cin;
    cout <= (axorb and cin) or (a and b);
  end architecture;

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
        constant PASSB : bit_vector (1 downto 0) := "11";
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
            aoub when OPORR,
            amaisb when OPADD,
            b when PASSB;
        
        overflow <= cin xor cout_mid;
        
        cout <= cout_mid;
end architecture alu1_arch;
    
entity alu is
generic (
size : natural := 10 --bitsize
) ;
port (
A, B : in bit_vector  (size-1 downto 0); -- i n p u t s
F    : out bit_vector (size-1 downto 0); -- o u t p u t
S    : in bit_vector  (3 downto 0); -- op s e l e c t i o n
Z    : out bit; -- z e r o f l a g
Ov   : out bit; -- o v e r f l o w f l a g  
Co   : out bit -- c a r r y o u t
) ;
end entity alu ;

architecture alu_arch of alu is
---
    component alu1bit
    port(
    a,b,less,cin : in bit ;
    result, cout, set , overflow : out bit ;
    ainvert , binvert : in bit ;
    operation : in bit_vector (1 downto 0)
    );    
    end component;
    signal   a_inv : bit;
    signal   b_inv : bit;
    signal   s_set : bit;
    signal   issub : bit;
    signal   opcod : bit_vector (1      downto 0);
    signal   sgcin : bit_vector (size-1 downto 0);
    signal   reslt : bit_vector (size-1 downto 0);
    signal   v_cin : bit_vector (size-1 downto 0); 
    constant OPAND : bit_vector (3      downto 0) := "0000";
    constant OPORR : bit_vector (3      downto 0) := "0001";
    constant OPADD : bit_vector (3      downto 0) := "0010";
    constant OPSUB : bit_vector (3      downto 0) := "0110";
    constant PASSB : bit_vector (3      downto 0) := "0111";
    constant OPNOR : bit_vector (3      downto 0) := "1100";
    constant zeros : bit_vector (size-1 downto 0) := (others => '0');
---
begin
    alu1_generator: for i in 0 to size-1 generate
        alu1_ini: if i = 0 generate
            alu1_0: alu1bit port map(a(i), b(i), s_set, v_cin(i), reslt(i), v_cin(i+1),open,open,a_inv, b_inv, opcod);
        end generate alu1_ini;
        alu1_mid: if (i > 0 and i < size-1)  generate 
            alu1_i: alu1bit port map(a(i), b(i), s_set, v_cin(i), reslt(i), v_cin(i+1),open,open,a_inv, b_inv, opcod);
        end generate alu1_mid;
        alu1_fin: if i = size-1 generate
            alu1_e: alu1bit port map(a(i), b(i), s_set, v_cin(i), reslt(i), Co,open,Ov, a_inv, b_inv, opcod);
        end generate alu1_fin;
    end generate alu1_generator;
    
    a_inv <= S(3);
    b_inv <= S(2);
    opcod <= S(1) & S(0);
    s_set <= '1' when S = PASSB else '0';
    issub <= S(3) or S(2);
    v_cin(0) <= '1' when (issub = '1') else '0';
    Z <= '1' when reslt = zeros else '0';
    F <= reslt;
end architecture alu_arch;