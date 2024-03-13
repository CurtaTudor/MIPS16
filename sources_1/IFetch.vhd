----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2023 07:04:45 PM
-- Design Name: 
-- Module Name: IFetch - Behavioral
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

entity IFetch is
    port(Jump: in STD_LOGIC;
         JumpAddress: in STD_LOGIC_VECTOR(15 downto 0);
         PCSrc: in STD_LOGIC;
         BranchAddress: in STD_LOGIC_VECTOR(15 downto 0);
         en: in STD_LOGIC;
         rst: in STD_LOGIC;
         clk: in STD_LOGIC;
         PCinc: out STD_LOGIC_VECTOR(15 downto 0);
         Instruction: out STD_LOGIC_VECTOR(15 downto 0));
end IFetch;

architecture Behavioral of IFetch is

type tRom is array(0 to 31) of STD_LOGIC_VECTOR(15 downto 0);
signal ROM:tRom:=(
    B"001_000_010_0000011", -- X"2103" -- ADDI $2 $0 3 - 1
    B"001_000_011_0000101", -- X"2185" -- ADDI $3 $0 5 - 2 
    B"000_010_011_001_0_000", -- X"0990" -- ADD $1 $2 $3 - 3
    B"000_011_010_100_0_001", -- X"0D41" -- SUB $4 $3 $2 - 4
    B"000_001_100_101_0_100", -- X"0654" -- AND $5 $1 $4 - 5 
    B"000_010_011_110_0_101", -- X"09E5" -- OR $6 $2 $3 - 6 
    B"000_001_100_111_0_110", -- X"0676" -- XOR $7 $1 $4 - 7      
    B"000_000_111_111_1_010", -- X"03FA" -- SLL $7 $7 - 8    
    B"000_000_001_001_1_011", -- X"009B" -- SRL $1 $1 - 9
    B"101_100_000_0000011", -- X"B003" -- BGTZ $4 3 - 10
    B"001_100_110_0000001", -- X"3301" -- ADDI $6 $4 1 - 11 INSTRUCTIUNEA ESTE SARITA DE BGTZ
    B"000_101_011_111_0_101", -- X"15F5" -- OR $7 $5 $3 - 12 INSTRUCTIUNEA ESTE SARITA DE BGTZ
    B"000_101_001_011_0_110", -- X"14B6" -- XOR $3 $5 $1 - 13 INSTRUCTIUNEA ESTE SARITA DE BGTZ
    B"011_100_000_0000000", -- X"7000" -- SW $0 0($4) - 14
    B"010_100_001_0000000", -- X"5080" -- LW $1 0($4) - 15
    B"001_001_001_0000001", -- X"2481" -- ADDI $1 $1 1 - 16
    B"101_000_000_0000010", -- X"A002" -- BGTZ $0 2 - 17
    B"000_001_000_000_0_000", -- X"0400" -- ADD $0 $1 $0 - 18
    B"111_0000000001111", -- X"E00F" -- J 15 - 19
    B"001_001_001_0000001", -- X"2481" -- ADDI $1 $1 1 - 20
    
    
    
    others => X"0000");

signal mux1: STD_LOGIC_VECTOR(15 downto 0):=(others => '0');
signal pcIn: STD_LOGIC_VECTOR(15 downto 0):=(others => '0');
signal pcOut: STD_LOGIC_VECTOR(15 downto 0):=(others => '0');
signal aluOut: STD_LOGIC_VECTOR(15 downto 0):=(others => '0');

begin

process(Jump,JumpAddress,mux1)
begin
    if(Jump='0') then
        pcIn <= mux1;
    else
        pcIn <= JumpAddress;
    end if;
end process;

process(clk)
begin
    if(clk='1' and clk'event) then
        if(rst='1') then
            pcOut <= x"0000";
        elsif en='1' then
            pcOut <= pcIn;
        end if;
    end if;
end process;

aluOut <= pcOut + 1;
PCinc <= aluOut;

process(PCSrc,BranchAddress,aluOut)
begin
    if(PCSrc='0') then
        mux1 <= aluOut;
    else
        mux1 <= BranchAddress;
    end if;
end process;

Instruction <= ROM(conv_integer(pcOut));
        
end Behavioral;
