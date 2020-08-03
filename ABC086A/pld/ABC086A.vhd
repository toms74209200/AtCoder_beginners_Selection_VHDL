-- ============================================================================
--  Title       : AtCoder beginners Selection ABC 086 A - Product
--
--  File Name   : ABC086A.vhd
--  Project     : AtCoder beginners Selection
--  Designer    : toms74209200 <https://github.com/toms74209200>
--  Created     : 2020/07/31
--  Copyright   : 2020 toms74209200
--  License     : MIT License.
--                http://opensource.org/licenses/mit-license.php
-- ============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.PAC_UART.all;

entity ABC086A is
    generic(
        DW              : integer := 8                              -- Data width
    );
    port(
    -- System --
        RESET_n         : in    std_logic;                          --(n) Reset
        CLK             : in    std_logic;                          --(p) Clock

    -- Control --
        SINK_VALID      : in    std_logic;                          --(p) Sink data valid
        SINK_DATA       : in    std_logic_vector(DW-1 downto 0);    --(p) Sink data
        SOURCE_VALID    : out   std_logic;                          --(p) Source data valid
        SOURCE_DATA     : out   std_logic_vector(DW-1 downto 0)     --(p) Source data
        );
end ABC086A;

architecture RTL of ABC086A is

-- ROM --
type    OddRomType      is array (0 to 3) of std_logic_vector(DW-1 downto 0);
type    EvenRomType     is array (0 to 4) of std_logic_vector(DW-1 downto 0);

constant    OUT_ODD_ROM     : OddRomType := (
    ASCII_C_O,  -- O
    ASCII_S_D,  -- d
    ASCII_S_D,  -- d
    ASCII_CR    -- \r
);
constant    OUT_EVEN_ROM    : EvenRomType := (
    ASCII_C_E,  -- E
    ASCII_S_V,  -- v
    ASCII_S_E,  -- e
    ASCII_S_N,  -- n
    ASCII_CR    -- \r
);

-- Internal signals --
signal a_dec_latch      : std_logic;                                -- Data a decision latch
signal b_dec_latch      : std_logic;                                -- Data b decision latch
signal is_a_decision    : std_logic;                                -- Data b decision flag
signal is_b_decision    : std_logic;                                -- Data b decision flag
signal data_a           : std_logic_vector(3 downto 0);             -- Data a
signal data_b           : std_logic_vector(3 downto 0);             -- Data b
signal is_odd           : std_logic;                                -- Check odd flag
signal source_valid_i   : std_logic;                                -- Source data valid
signal out_cnt          : integer range 0 to 4;                     -- Output data count
signal out_end_pls      : std_logic;                                -- Data output end pulse
signal out_end_flag     : std_logic;                                -- Data output end flag
signal source_data_i    : std_logic_vector(SOURCE_DATA'range);      -- Source data

begin
--
-- ============================================================================
--  Data a decision flag
-- ============================================================================
process (CLK, RESET_n) begin
    if (RESET_n = '0') then
        a_dec_latch <= '0';
    elsif (CLK'event and CLK = '1') then
        if (out_end_pls = '1') then
            a_dec_latch <= '0';
        elsif (SINK_VALID = '1' and SINK_DATA = ASCII_SP) then
            a_dec_latch <= '1';
        end if;
    end if;
end process;

is_a_decision <= '1' when (a_dec_latch = '1' or SINK_DATA = ASCII_SP) else '0';


-- ============================================================================
--  Data b decision flag
-- ============================================================================
process (CLK, RESET_n) begin
    if (RESET_n = '0') then
        b_dec_latch <= '0';
    elsif (CLK'event and CLK = '1') then
        if (out_end_pls = '1') then
            b_dec_latch <= '0';
        elsif (SINK_VALID = '1' and SINK_DATA = ASCII_CR) then
            b_dec_latch <= '1';
        end if;
    end if;
end process;

is_b_decision <= '1' when (b_dec_latch = '1' or SINK_DATA = ASCII_CR) else '0';


-- ============================================================================
--  Data a input
-- ============================================================================
process (CLK, RESET_n) begin
    if (RESET_n = '0') then
        data_a <= (others => '0');
    elsif (CLK'event and CLK = '1') then
        if (is_a_decision = '1') then
            data_a <= data_a;
        elsif (SINK_VALID = '1') then
            data_a <= SINK_DATA(3 downto 0);
        end if;
    end if;
end process;


-- ============================================================================
--  Data b input
-- ============================================================================
process (CLK, RESET_n) begin
    if (RESET_n = '0') then
        data_b <= (others => '0');
    elsif (CLK'event and CLK = '1') then
        if (is_b_decision = '1') then
            data_b <= data_b;
        elsif (SINK_VALID = '1') then
            data_b <= SINK_DATA(3 downto 0);
        end if;
    end if;
end process;


-- ============================================================================
--  Check Odd
-- ============================================================================
is_odd <= '1' when (data_a(0) = '1' and data_b(0) = '1') else '0';


-- ============================================================================
--  Data output valid
-- ============================================================================
process (CLK, RESET_n) begin
    if (RESET_n = '0') then
        source_valid_i <= '0';
    elsif (CLK'event and CLK = '1') then
        if (out_end_pls = '1') then
            source_valid_i <= '0';
        elsif (is_a_decision= '1' and is_b_decision = '1') then
            source_valid_i <= '1';
        end if;
    end if;
end process;

SOURCE_VALID <= source_valid_i;


-- ============================================================================
--  Data output count
-- ============================================================================
process (CLK, RESET_n) begin
    if (RESET_n = '0') then
        out_cnt <= 0;
    elsif (CLK'event and CLK = '1') then
        if (is_a_decision = '1' and is_b_decision = '1') then
            if (out_end_flag = '1') then
                out_cnt <= 0;
            else
                out_cnt <= out_cnt + 1;
            end if;
        else
            out_cnt <= 0;
        end if;
    end if;
end process;


-- ============================================================================
--  Data output end pulse
-- ============================================================================
process (CLK, RESET_n) begin
    if (RESET_n = '0') then
        out_end_pls <= '0';
    elsif (CLK'event and CLK = '1') then
        if (out_end_flag = '1') then
            out_end_pls <= '1';
        else
            out_end_pls <= '0';
        end if;
    end if;
end process;

out_end_flag <= '1' when (is_odd = '1' and out_cnt = 3) else
                '1' when (is_odd = '0' and out_cnt = 4) else
                '0';


-- ============================================================================
--  Data output
-- ============================================================================
process (CLK, RESET_n) begin
    if (RESET_n = '0') then
        source_data_i <= (others => '0');
    elsif (CLK'event and CLK = '1') then
        if (is_a_decision = '1' and is_b_decision = '1') then
            if (is_odd = '1') then
                source_data_i <= OUT_ODD_ROM(out_cnt);
            else
                source_data_i <= OUT_EVEN_ROM(out_cnt);
            end if;
        end if;
    end if;
end process;

SOURCE_DATA <= source_data_i;


end RTL;    -- ABC086A
