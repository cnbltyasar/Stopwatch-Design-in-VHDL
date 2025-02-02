library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_tb is
end top_tb;

architecture Behavioral of top_tb is
    signal clk      : std_logic := '0';
    signal start    : std_logic := '0';
    signal reset    : std_logic := '0';
    signal anode    : std_logic_vector(7 downto 0);
    signal sevenseg : std_logic_vector(7 downto 0);
    
    constant clk_period : time := 10 ns;
    
begin
    -- Instantiate the top-level design
    uut: entity work.top
        generic map (
            clkfreq => 100_000_000
        )
        port map (
            clk      => clk,
            start    => start,
            reset    => reset,
            anode    => anode,
            sevenseg => sevenseg
        );
    
    -- Clock generation process
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    -- Stimulus process
    stim_process : process
    begin
        -- Apply a reset pulse
        wait for 100 ns;
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        
        -- Start the stopwatch
        wait for 100 ns;
        start <= '1';
        wait for 20 ns;
        start <= '0';
        
        -- Let the stopwatch run for some time (simulate for 5 ms)
        wait for 5 ms;
        
        -- Stop the stopwatch
        start <= '1';
        wait for 20 ns;
        start <= '0';
        
        -- Run for a while then reset again
        wait for 5 ms;
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        
        wait;
    end process;
end Behavioral;
