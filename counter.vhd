library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
    generic (
        birler_lim : integer := 9;
        onlar_lim  : integer := 5
    );
    port (
        clk    : in std_logic;
        add    : in std_logic;
        reset  : in std_logic;
        birler : out std_logic_vector(3 downto 0);
        onlar  : out std_logic_vector(3 downto 0)
    );
end counter;

architecture Behavioral of counter is
    signal units : integer range 0 to birler_lim := 0;
    signal tens  : integer range 0 to onlar_lim := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                units <= 0;
                tens  <= 0;
            elsif add = '1' then
                if units = birler_lim then
                    units <= 0;
                    if tens = onlar_lim then
                        tens <= 0;
                    else
                        tens <= tens + 1;
                    end if;
                else
                    units <= units + 1;
                end if;
            end if;
        end if;
    end process;
    
    birler <= std_logic_vector(to_unsigned(units, 4));
    onlar  <= std_logic_vector(to_unsigned(tens, 4));
end Behavioral;
