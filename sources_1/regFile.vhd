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

entity regFile is
    port(ra1:in STD_LOGIC_VECTOR(2 downto 0);
        ra2:in STD_LOGIC_VECTOR(2 downto 0);
        wa:in STD_LOGIC_VECTOR(2 downto 0);
        wd:in STD_LOGIC_VECTOR(15 downto 0);
        clk:in STD_LOGIC;
        en:in STD_LOGIC;
        regWr:in STD_LOGIC;
        rd1:out STD_LOGIC_VECTOR(15 downto 0);
        rd2:out STD_LOGIC_VECTOR(15 downto 0));
end regFile;

architecture Behavioral of regFile is

type t_mem is array(0 to 7) of STD_LOGIC_VECTOR(15 downto 0);
signal mem:t_mem;

begin

process(clk)
begin
    if(clk='1' and clk'event) then
        if(en='1' and regWr='1') then
            mem(conv_integer(wa)) <= wd;
        end if;
    end if;
end process;

rd1 <= mem(conv_integer(ra1));
rd2 <= mem(conv_integer(ra2));

end Behavioral;