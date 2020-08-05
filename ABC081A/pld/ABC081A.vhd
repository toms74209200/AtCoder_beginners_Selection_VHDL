-- ============================================================================
--  Title       : AtCoder beginners Selection ABC 081 A - Placing Marbles
--
--  File Name   : ABC081A.vhd
--  Project     : AtCoder beginners Selection
--  Designer    : toms74209200 <https://github.com/toms74209200>
--  Created     : 2020/08/05
--  Copyright   : 2020 toms74209200
--  License     : MIT License.
--                http://opensource.org/licenses/mit-license.php
-- ============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.PAC_UART.all;

entity ABC081A is
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
end ABC081A;

architecture RTL of ABC081A is

-- Internal signals --
signal  marbles_count   : std_logic_vector(3 downto 0);             -- Marbles count
signal  input_cnt       : integer range 0 to 3;                     -- Input data count
signal  source_valid_i  : std_logic;                                -- Source data valid
signal  out_end_pls     : std_logic;                                -- Output data end pulse
signal  source_data_i   : std_logic_vector(DW-1 downto 0);          -- Source data


begin
--
-- ============================================================================
--  Marbles count
-- ============================================================================
process (CLK, RESET_n) begin
    if (RESET_n = '0') then
        marbles_count <= (others => '0');
    elsif (CLK'event and CLK = '1') then
        if (out_end_pls = '1') then
            marbles_count <= (others => '0');
        elsif (SINK_VALID = '1') then
            marbles_count <= marbles_count + SINK_DATA(3 downto 0);
        end if;
    end if;
end process;


-- ============================================================================
--  Input count
-- ============================================================================
process (CLK, RESET_n) begin
    if (RESET_n = '0') then
        input_cnt <= 0;
    elsif (CLK'event and CLK = '1') then
        if (SINK_VALID = '1') then
            if (input_cnt = 3) then
                input_cnt <= 0;
            else
                input_cnt <= input_cnt + 1;
            end if;
        end if;
    end if;
end process;


-- ============================================================================
--  Data output valid
-- ============================================================================
process (CLK, RESET_n) begin
    if (RESET_n = '0') then
        source_valid_i <= '0';
    elsif (CLK'event and CLK = '1') then
        if (out_end_pls = '1') then
            source_valid_i <= '0';
        elsif (input_cnt = 3 and SINK_VALID = '1') then
            source_valid_i <= '1';
        end if;
    end if;
end process;

SOURCE_VALID <= source_valid_i;


-- ============================================================================
--  Data output end pulse
-- ============================================================================
process (CLK, RESET_n) begin
    if (RESET_n = '0') then
        out_end_pls <= '0';
    elsif (CLK'event and CLK = '1') then
        if (source_valid_i = '1' and out_end_pls = '0') then
            out_end_pls <= '1';
        else
            out_end_pls <= '0';
        end if;
    end if;
end process;


-- ============================================================================
--  Data output
-- ============================================================================
process (CLK, RESET_n) begin
    if (RESET_n = '0') then
        source_data_i <= (others => '0');
    elsif (CLK'event and CLK = '1') then
        if (input_cnt = 3 and SINK_VALID = '1') then
            source_data_i <= (X"3" & marbles_count);
        elsif (source_valid_i = '1') then
            source_data_i <= ASCII_CR;
        end if;
    end if;
end process;

SOURCE_DATA <= source_data_i;


end RTL;    -- ABC081A
