library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debounce is
    generic (
        c_initval : std_logic := '0'
    );
    port (
        clk      : in std_logic;
        signal_i : in std_logic;
        signal_o : out std_logic
    );
end debounce;

architecture Behavioral of debounce is
    -- Adjust the debounce_time constant to suit your clock frequency and required debounce delay.
    constant debounce_time : integer := 100000; 
    signal counter   : integer := 0;
    signal debounced : std_logic := c_initval;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if signal_i = debounced then
                counter <= 0;
            else
                counter <= counter + 1;
                if counter = debounce_time then
                    debounced <= signal_i;
                    counter <= 0;
                end if;
            end if;
        end if;
    end process;
    
    signal_o <= debounced;
end Behavioral;
