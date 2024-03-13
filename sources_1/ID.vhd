----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2023 06:39:56 PM
-- Design Name: 
-- Module Name: ID - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID is
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
end ID;

architecture Behavioral of ID is

component regFile is
    port(ra1:in STD_LOGIC_VECTOR(2 downto 0);
        ra2:in STD_LOGIC_VECTOR(2 downto 0);
        wa:in STD_LOGIC_VECTOR(2 downto 0);
        wd:in STD_LOGIC_VECTOR(15 downto 0);
        clk:in STD_LOGIC;
        en:in STD_LOGIC;
        regWr:in STD_LOGIC;
        rd1:out STD_LOGIC_VECTOR(15 downto 0);
        rd2:out STD_LOGIC_VECTOR(15 downto 0));
end component;

signal wAddr:STD_LOGIC_VECTOR(2 downto 0):=(others => '0');
signal signExt:STD_LOGIC_VECTOR(15 downto 0):=(others => '0');


begin

registerFile: regFile port map(Instr(12 downto 10),Instr(9 downto 7),wAddr,WD,clk,en,RegWrite,RD1,RD2);

process(Instr(9 downto 7),Instr(6 downto 4),RegDst)
begin
    if(RegDst='0') then
        wAddr <= Instr(9 downto 7);
    else
        wAddr <= Instr(6 downto 4);
    end if;
end process;

process(Instr(6 downto 0),ExtOp)
begin
    if(ExtOp='0') then
        signExt <= "000000000"&Instr(6 downto 0);
    else
        signExt <= Instr(6)&Instr(6)&Instr(6)&Instr(6)&Instr(6)&Instr(6)&Instr(6)&Instr(6)&Instr(6)&Instr(6 downto 0);
    end if;
end process;

Ext_Imm <= signExt;
func <= Instr(2 downto 0);
sa <= Instr(3);

end Behavioral;
