library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity test_env is
    port(sw: in STD_LOGIC_VECTOR(15 downto 0);
         btn: in STD_LOGIC_VECTOR(4 downto 0);
         clk:in STD_LOGIC;
         led:out STD_LOGIC_VECTOR(15 downto 0);
         an:out STD_LOGIC_VECTOR(3 downto 0);
         cat:out STD_LOGIC_VECTOR(6 downto 0));
end test_env;

architecture arh of test_env is

component MPG is
    Port ( en : out STD_LOGIC;
           input : in STD_LOGIC;
           clock : in STD_LOGIC);
end component;

component SSD is
    Port ( clk: in STD_LOGIC;
           digits: in STD_LOGIC_VECTOR(15 downto 0);
           an: out STD_LOGIC_VECTOR(3 downto 0);
           cat: out STD_LOGIC_VECTOR(6 downto 0));
end component;

component MainControl is
    port(Instr:in STD_LOGIC_VECTOR(2 downto 0);
        Br_gtz:out STD_LOGIC;
        RegDst:out STD_LOGIC;
        ExtOp:out STD_LOGIC;
        AluSrc:out STD_LOGIC;
        Branch:out STD_LOGIC;
        Jump:out STD_LOGIC;
        AluOp:out STD_LOGIC_VECTOR(1 downto 0);
        MemWrite:out STD_LOGIC;
        MemtoReg:out STD_LOGIC;
        RegWrite:out STD_LOGIC);
end component;

component ID is
    port(RegWrite: in STD_LOGIC;
        Instr: in STD_LOGIC_VECTOR(15 downto 0);
        RegDst: in STD_LOGIC;
        clk: in STD_LOGIC;
        en: in STD_LOGIC;
        ExtOp:in STD_LOGIC;
        WD:in STD_LOGIC_VECTOR(15 downto 0);
        RD1:out STD_LOGIC_VECTOR(15 downto 0);
        RD2:out STD_LOGIC_VECTOR(15 downto 0);
        Ext_Imm:out STD_LOGIC_VECTOR(15 downto 0);
        func:out STD_LOGIC_VECTOR(2 downto 0);
        sa:out STD_LOGIC);
end component;

component IFetch is
    port(Jump: in STD_LOGIC;
         JumpAddress: in STD_LOGIC_VECTOR(15 downto 0);
         PCSrc: in STD_LOGIC;
         BranchAddress: in STD_LOGIC_VECTOR(15 downto 0);
         en: in STD_LOGIC;
         rst: in STD_LOGIC;
         clk: in STD_LOGIC;
         PCinc: out STD_LOGIC_VECTOR(15 downto 0);
         Instruction: out STD_LOGIC_VECTOR(15 downto 0));
end component;

component EX is
    port(RD1:in STD_LOGIC_VECTOR(15 downto 0);
        RD2:in STD_LOGIC_VECTOR(15 downto 0);
        ALUSrc:in STD_LOGIC;
        Ext_Imm:in STD_LOGIC_VECTOR(15 downto 0);
        sa:in STD_LOGIC;
        func:in STD_LOGIC_VECTOR(2 downto 0);
        ALUOp:in STD_LOGIC_VECTOR(1 downto 0);
        PCplus:in STD_LOGIC_VECTOR(15 downto 0);
        GT:out STD_LOGIC;
        Zero:out STD_LOGIC;
        ALURes:out STD_LOGIC_VECTOR(15 downto 0);
        BranchAddress:out STD_LOGIC_VECTOR(15 downto 0));
end component;

component MEM is
    port(MemWrite: in STD_LOGIC;
        ALUResIn: in STD_LOGIC_VECTOR(15 downto 0);
        RD2: in STD_LOGIC_VECTOR(15 downto 0);
        clk: in STD_LOGIC;
        en: in STD_LOGIC;
        ALUResOut: out STD_LOGIC_VECTOR(15 downto 0);
        MemData: out STD_LOGIC_VECTOR(15 downto 0));
end component;

signal en0,en1:STD_LOGIC;
signal Instr,PCPlus1,JumpAddr,BranchAddr:STD_LOGIC_VECTOR(15 downto 0);

signal PCSrc,Jump,RegDst,ExtOp,ALUSrc,Branch,Br_gtz,MemWrite,MemtoReg,RegWrite:STD_LOGIC;
signal ALUOp:STD_LOGIC_VECTOR(1 downto 0);

signal RD1,RD2,Ext_Imm:STD_LOGIC_VECTOR(15 downto 0);
signal func:STD_LOGIC_VECTOR(2 downto 0);
signal sa:STD_LOGIC;

signal ALUResIn,ALUResOut,MemData,WriteBack:STD_LOGIC_VECTOR(15 downto 0);
signal Zero,GT:STD_LOGIC;

signal finalRes:STD_LOGIC_VECTOR(15 downto 0);

begin

button0: MPG port map(en0,btn(0),clk);
button1: MPG port map(en1,btn(1),clk);

instructionFetch: IFetch port map(Jump,JumpAddr,PCSrc,BranchAddr,en0,en1,clk,PCPlus1,Instr);
main: MainControl port map(Instr(15 downto 13),Br_gtz,RegDst,ExtOp,ALUSrc,Branch,Jump,ALUOp,MemWrite,MemtoReg,RegWrite);
JumpAddr <= PCPlus1(15 downto 13) & Instr(12 downto 0);
PCSrc <= ((Zero and Branch) or (GT and Br_gtz));
led(10 downto 0) <= ALUOp & RegDst & ExtOp & ALUSrc & Branch & Br_gtz & Jump & MemWrite & MemtoReg & RegWrite;

instructionDecode: ID port map(RegWrite,Instr,RegDst,clk,en0,ExtOp,WriteBack,RD1,RD2,Ext_Imm,func,sa);
execution: EX port map(RD1,RD2,ALUSrc,Ext_Imm,sa,func,ALUOp,PCPlus1,GT,Zero,ALUResIn,BranchAddr);
memory: MEM port map(MemWrite,ALUResIn,RD2,clk,en0,ALUResOut,MemData);

WB: process(MemtoReg,ALUResOut,MemData)
begin
    if(MemtoReg='0') then
        WriteBack <= ALUResOut;
    else
        WriteBack <= MemData;
    end if;
end process WB;

MUX: process(sw(7 downto 5),Instr,PCPlus1,RD1,RD2,Ext_Imm,ALUResIn,MemData,WriteBack)
begin
    case sw(7 downto 5) is
        when "000" => finalRes <= Instr;
        when "001" => finalRes <= PCPlus1;
        when "010" => finalRes <= RD1;
        when "011" => finalRes <= RD2;
        when "100" => finalRes <= Ext_Imm;
        when "101" => finalRes <= ALUResIn;
        when "110" => finalRes <= MemData;
        when "111" => finalRes <= WriteBack;
        when others => finalRes <= (others => 'X');
    end case;
end process MUX;

display: SSD port map(clk,finalRes,an,cat);

end arh;