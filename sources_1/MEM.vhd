----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2023 06:37:45 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM is
    port(MemWrite: in STD_LOGIC;
        ALUResIn: in STD_LOGIC_VECTOR(15 downto 0);
        RD2: in STD_LOGIC_VECTOR(15 downto 0);
        clk: in STD_LOGIC;
        en: in STD_LOGIC;
        ALUResOut: out STD_LOGIC_VECTOR(15 downto 0);
        MemData: out STD_LOGIC_VECTOR(15 downto 0));
end MEM;

architecture Behavioral of MEM is

type t_mem is array(0 to 31) of STD_LOGIC_VECTOR(15 downto 0);
signal mem:t_mem:=(x"0000",x"0001",x"0002",x"0003",x"0002",x"0005",x"0006",x"0007",others => "0000");

begin

process(clk)
begin
    if(clk'event and clk='1') then
        if(en='1' and MemWrite='1') then
            mem(conv_integer(ALUResIn)) <= RD2;
        end if;
    end if;
end process;

MemData <= mem(conv_integer(ALUResIn));
ALUResOut <= ALUResIn;
    
end Behavioral;
