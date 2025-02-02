library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top is
    generic (
        clkfreq     : integer   := 100_000_000
    );
    port ( 
        clk         : in std_logic;
        start       : in std_logic;
        reset       : in std_logic;
        anode       : out std_logic_vector(7 downto 0);
        sevenseg    : out std_logic_vector(7 downto 0)
    );
end top;

architecture Behavioral of top is

    component debounce is
        generic (
            c_initval   : std_logic := '0'
        );
        port (
            clk       : in std_logic;
            signal_i  : in std_logic;
            signal_o  : out std_logic
        );
    end component;

    component counter is
        generic (
            birler_lim  : integer := 9;
            onlar_lim   : integer := 5
        );
        port ( 
            clk     : in std_logic;
            add     : in std_logic;
            reset   : in std_logic;
            birler  : out std_logic_vector(3 downto 0);
            onlar   : out std_logic_vector(3 downto 0)
        );
    end component;

    component sevensegment is
        port ( 
            bcd         : in std_logic_vector(3 downto 0);
            sevenseg    : out std_logic_vector(7 downto 0)
        );
    end component;

    constant clk_lim      : integer := clkfreq / 1000;   -- 1ms period
    constant salise_lim   : integer := clkfreq / 100;    -- Adjusted limit for hundredths
    constant saniye_lim   : integer := 100;
    constant dakika_lim   : integer := 60;

    signal salise_add         : std_logic := '0';
    signal saniye_add         : std_logic := '0';
    signal dakika_add         : std_logic := '0';
    signal continue           : std_logic := '0';
    signal start_deb          : std_logic := '0';
    signal start_deb_prev     : std_logic := '0';
    signal reset_deb          : std_logic := '0';

    signal salise_birler      : std_logic_vector(3 downto 0) := (others => '0');
    signal salise_onlar       : std_logic_vector(3 downto 0) := (others => '0');
    signal saniye_birler      : std_logic_vector(3 downto 0) := (others => '0');
    signal saniye_onlar       : std_logic_vector(3 downto 0) := (others => '0');
    signal dakika_birler      : std_logic_vector(3 downto 0) := (others => '0');
    signal dakika_onlar       : std_logic_vector(3 downto 0) := (others => '0');

    signal salise_birler_7seg : std_logic_vector(7 downto 0) := (others => '1');
    signal salise_onlar_7seg  : std_logic_vector(7 downto 0) := (others => '1');
    signal saniye_birler_7seg : std_logic_vector(7 downto 0) := (others => '1');
    signal saniye_onlar_7seg  : std_logic_vector(7 downto 0) := (others => '1');
    signal dakika_birler_7seg : std_logic_vector(7 downto 0) := (others => '1');
    signal dakika_onlar_7seg  : std_logic_vector(7 downto 0) := (others => '1');

    signal anode_s          : std_logic_vector(7 downto 0) := "11111110";
    signal timer1ms         : integer range 0 to clk_lim := 0;
    signal salise_count     : integer range 0 to salise_lim := 0;
    signal saniye_count     : integer range 0 to saniye_lim := 0;
    signal dakika_count     : integer range 0 to dakika_lim := 0;

begin

    start_debounce : debounce
    generic map(
        c_initval => '0'
    )
    port map(
        clk      => clk,
        signal_i => start,
        signal_o => start_deb
    );
    
    reset_debounce : debounce
    generic map(
        c_initval => '0'
    )
    port map(
        clk      => clk,
        signal_i => reset,
        signal_o => reset_deb
    );

    salise_increment : counter
    generic map(
        birler_lim => 9,
        onlar_lim  => 9
    )
    port map(
        clk    => clk,
        add    => salise_add,
        reset  => reset_deb,
        birler => salise_birler,
        onlar  => salise_onlar
    );

    saniye_increment : counter
    generic map(
        birler_lim => 9,
        onlar_lim  => 5
    )
    port map(
        clk    => clk,
        add    => saniye_add,
        reset  => reset_deb,
        birler => saniye_birler,
        onlar  => saniye_onlar
    );

    dakika_increment : counter
    generic map(
        birler_lim => 9,
        onlar_lim  => 5
    )
    port map(
        clk    => clk,
        add    => dakika_add,
        reset  => reset_deb,
        birler => dakika_birler,
        onlar  => dakika_onlar
    );

    salise_birler_sevensegment : sevensegment
    port map(
        bcd      => salise_birler,
        sevenseg => salise_birler_7seg
    );

    salise_onlar_sevensegment : sevensegment
    port map(
        bcd      => salise_onlar,
        sevenseg => salise_onlar_7seg
    );

    saniye_birler_sevensegment : sevensegment
    port map(
        bcd      => saniye_birler,
        sevenseg => saniye_birler_7seg
    );

    saniye_onlar_sevensegment : sevensegment
    port map(
        bcd      => saniye_onlar,
        sevenseg => saniye_onlar_7seg
    );

    dakika_birler_sevensegment : sevensegment
    port map(
        bcd      => dakika_birler,
        sevenseg => dakika_birler_7seg
    );

    dakika_onlar_sevensegment : sevensegment
    port map(
        bcd      => dakika_onlar,
        sevenseg => dakika_onlar_7seg
    );

    -- Process handling the time counting and button control
    process(clk)
    begin
        if rising_edge(clk) then
            start_deb_prev <= start_deb;

            if start_deb = '1' and start_deb_prev = '0' then
                continue <= not continue;
            end if;
            
            salise_add <= '0';
            saniye_add <= '0';
            dakika_add <= '0';
            
            if continue = '1' then
                if salise_count = (salise_lim - 1) then
                    salise_count <= 0;
                    salise_add <= '1';
                    saniye_count <= saniye_count + 1;
                else
                    salise_count <= salise_count + 1;
                end if;

                if saniye_count = (saniye_lim - 1) then
                    saniye_count <= 0;
                    saniye_add <= '1';
                    dakika_count <= dakika_count + 1;
                end if;

                if dakika_count = (dakika_lim - 1) then
                    dakika_count <= 0;
                    dakika_add <= '1';
                end if;
            end if;
            
            if reset_deb = '1' then
                salise_count <= 0;
                saniye_count <= 0;
                dakika_count <= 0;
            end if;
        end if;
    end process;
    
    -- Process for cycling the anode (digit multiplexing)
    process(clk)
    begin
        if rising_edge(clk) then
            anode_s(7 downto 6) <= "11";
            if timer1ms = clk_lim - 1 then
                timer1ms <= 0;
                anode_s(5 downto 1) <= anode_s(4 downto 0);
                anode_s(0) <= anode_s(5);
            else
                timer1ms <= timer1ms + 1;
            end if;
        end if;
    end process;
            
    -- Process for selecting which seven-segment digit to display
    process(clk)
    begin
        if rising_edge(clk) then
            if anode_s(0) = '0' then
                sevenseg <= salise_birler_7seg;
            elsif anode_s(1) = '0' then
                sevenseg <= salise_onlar_7seg;
            elsif anode_s(2) = '0' then
                sevenseg <= saniye_birler_7seg;
            elsif anode_s(3) = '0' then
                sevenseg <= saniye_onlar_7seg;
            elsif anode_s(4) = '0' then
                sevenseg <= dakika_birler_7seg;
            elsif anode_s(5) = '0' then
                sevenseg <= dakika_onlar_7seg;
            else
                sevenseg <= (others => '1');
            end if;
        end if;
    end process;

    anode <= anode_s;            

end Behavioral;
