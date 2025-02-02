library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sevensegment is
    port (
        bcd      : in std_logic_vector(3 downto 0);
        sevenseg : out std_logic_vector(7 downto 0)
    );
end sevensegment;

architecture Behavioral of sevensegment is
begin
    process(bcd)
    begin
        case bcd is
            when "0000" => sevenseg <= "11000000"; -- 0
            when "0001" => sevenseg <= "11111001"; -- 1
            when "0010" => sevenseg <= "10100100"; -- 2
            when "0011" => sevenseg <= "10110000"; -- 3
            when "0100" => sevenseg <= "10011001"; -- 4
            when "0101" => sevenseg <= "10010010"; -- 5
            when "0110" => sevenseg <= "10000010"; -- 6
            when "0111" => sevenseg <= "11111000"; -- 7
            when "1000" => sevenseg <= "10000000"; -- 8
            when "1001" => sevenseg <= "10010000"; -- 9
            when others => sevenseg <= "11111111"; -- blank/off
        end case;
    end process;
end Behavioral;
