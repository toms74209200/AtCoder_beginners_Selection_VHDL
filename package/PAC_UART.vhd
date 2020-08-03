-- =====================================================================
--	Title       : UART library package
--
--	File Name   : PAC_UART.vhd
--	Project     :
--	Designer    : toms74209200
--	Created     : 2017/11/13
--  License     : MIT License.
--                http://opensource.org/licenses/mit-license.php
-- ============================================================================

library IEEE;
use IEEE.std_logic_1164.all;

package PAC_UART is

-- ============================================================================
--  ASCII code
-- ============================================================================
-- 00 - 0f --
constant    ASCII_BS    : std_logic_vector(7 downto 0) := X"08";    -- Back Space
constant    ASCII_HT    : std_logic_vector(7 downto 0) := X"09";    -- Horizontal Tabulation
constant    ASCII_LF    : std_logic_vector(7 downto 0) := X"0A";    -- Line Feed
constant    ASCII_CR    : std_logic_vector(7 downto 0) := X"0D";    -- Carriage Return

-- 10 - 1f --


-- 20 - 2f --
constant    ASCII_SP    : std_logic_vector(7 downto 0) := X"20";    -- Space
constant    ASCII_CMM   : std_logic_vector(7 downto 0) := X"2c";    -- Comma(,)
constant    ASCII_HYP   : std_logic_vector(7 downto 0) := X"2d";    -- Hyphen(-)
constant    ASCII_PRD   : std_logic_vector(7 downto 0) := X"2e";    -- Period(.)

-- 30 - 3f
constant    ASCII_0     : std_logic_vector(7 downto 0) := X"30";    -- 0
constant    ASCII_1     : std_logic_vector(7 downto 0) := X"31";    -- 1
constant    ASCII_2     : std_logic_vector(7 downto 0) := X"32";    -- 2
constant    ASCII_3     : std_logic_vector(7 downto 0) := X"33";    -- 3
constant    ASCII_4     : std_logic_vector(7 downto 0) := X"34";    -- 4
constant    ASCII_5     : std_logic_vector(7 downto 0) := X"35";    -- 5
constant    ASCII_6     : std_logic_vector(7 downto 0) := X"36";    -- 6
constant    ASCII_7     : std_logic_vector(7 downto 0) := X"37";    -- 7
constant    ASCII_8     : std_logic_vector(7 downto 0) := X"38";    -- 8
constant    ASCII_9     : std_logic_vector(7 downto 0) := X"39";    -- 9
constant    ASCII_CLN   : std_logic_vector(7 downto 0) := X"3A";    -- Colon(:)

-- 40 - 4f --
constant    ASCII_C_A   : std_logic_vector(7 downto 0) := X"41";    -- Capital A
constant    ASCII_C_B   : std_logic_vector(7 downto 0) := X"42";    -- Capital B
constant    ASCII_C_C   : std_logic_vector(7 downto 0) := X"43";    -- Capital C
constant    ASCII_C_D   : std_logic_vector(7 downto 0) := X"44";    -- Capital D
constant    ASCII_C_E   : std_logic_vector(7 downto 0) := X"45";    -- Capital E
constant    ASCII_C_F   : std_logic_vector(7 downto 0) := X"46";    -- Capital F
constant    ASCII_C_G   : std_logic_vector(7 downto 0) := X"47";    -- Capital G
constant    ASCII_C_H   : std_logic_vector(7 downto 0) := X"48";    -- Capital H
constant    ASCII_C_I   : std_logic_vector(7 downto 0) := X"49";    -- Capital I
constant    ASCII_C_J   : std_logic_vector(7 downto 0) := X"4A";    -- Capital J
constant    ASCII_C_K   : std_logic_vector(7 downto 0) := X"4B";    -- Capital K
constant    ASCII_C_L   : std_logic_vector(7 downto 0) := X"4C";    -- Capital L
constant    ASCII_C_M   : std_logic_vector(7 downto 0) := X"4D";    -- Capital M
constant    ASCII_C_N   : std_logic_vector(7 downto 0) := X"4E";    -- Capital N
constant    ASCII_C_O   : std_logic_vector(7 downto 0) := X"4F";    -- Capital O

-- 50 - 5f --
constant    ASCII_C_P   : std_logic_vector(7 downto 0) := X"50";    -- Capital P
constant    ASCII_C_Q   : std_logic_vector(7 downto 0) := X"51";    -- Capital Q
constant    ASCII_C_R   : std_logic_vector(7 downto 0) := X"52";    -- Capital R
constant    ASCII_C_S   : std_logic_vector(7 downto 0) := X"53";    -- Capital S
constant    ASCII_C_T   : std_logic_vector(7 downto 0) := X"54";    -- Capital T
constant    ASCII_C_U   : std_logic_vector(7 downto 0) := X"55";    -- Capital U
constant    ASCII_C_V   : std_logic_vector(7 downto 0) := X"56";    -- Capital V
constant    ASCII_C_W   : std_logic_vector(7 downto 0) := X"57";    -- Capital W
constant    ASCII_C_X   : std_logic_vector(7 downto 0) := X"58";    -- Capital X
constant    ASCII_C_Y   : std_logic_vector(7 downto 0) := X"59";    -- Capital Y
constant    ASCII_C_Z   : std_logic_vector(7 downto 0) := X"5A";    -- Capital x

-- 60 - 6f --
constant    ASCII_S_A   : std_logic_vector(7 downto 0) := X"61";    -- Small a
constant    ASCII_S_B   : std_logic_vector(7 downto 0) := X"62";    -- Small b
constant    ASCII_S_C   : std_logic_vector(7 downto 0) := X"63";    -- Small c
constant    ASCII_S_D   : std_logic_vector(7 downto 0) := X"64";    -- Small d
constant    ASCII_S_E   : std_logic_vector(7 downto 0) := X"65";    -- Small e
constant    ASCII_S_F   : std_logic_vector(7 downto 0) := X"66";    -- Small f
constant    ASCII_S_G   : std_logic_vector(7 downto 0) := X"67";    -- Small g
constant    ASCII_S_H   : std_logic_vector(7 downto 0) := X"68";    -- Small h
constant    ASCII_S_I   : std_logic_vector(7 downto 0) := X"69";    -- Small i
constant    ASCII_S_J   : std_logic_vector(7 downto 0) := X"6A";    -- Small j
constant    ASCII_S_K   : std_logic_vector(7 downto 0) := X"6B";    -- Small k
constant    ASCII_S_L   : std_logic_vector(7 downto 0) := X"6C";    -- Small l
constant    ASCII_S_M   : std_logic_vector(7 downto 0) := X"6D";    -- Small m
constant    ASCII_S_N   : std_logic_vector(7 downto 0) := X"6E";    -- Small n
constant    ASCII_S_O   : std_logic_vector(7 downto 0) := X"6F";    -- Small o

-- 70 - 7f --
constant    ASCII_S_P   : std_logic_vector(7 downto 0) := X"70";    -- Small p
constant    ASCII_S_Q   : std_logic_vector(7 downto 0) := X"71";    -- Small q
constant    ASCII_S_R   : std_logic_vector(7 downto 0) := X"72";    -- Small r
constant    ASCII_S_S   : std_logic_vector(7 downto 0) := X"73";    -- Small s
constant    ASCII_S_T   : std_logic_vector(7 downto 0) := X"74";    -- Small t
constant    ASCII_S_U   : std_logic_vector(7 downto 0) := X"75";    -- Small u
constant    ASCII_S_V   : std_logic_vector(7 downto 0) := X"76";    -- Small v
constant    ASCII_S_W   : std_logic_vector(7 downto 0) := X"77";    -- Small w
constant    ASCII_S_X   : std_logic_vector(7 downto 0) := X"78";    -- Small x
constant    ASCII_S_Y   : std_logic_vector(7 downto 0) := X"79";    -- Small y
constant    ASCII_S_Z   : std_logic_vector(7 downto 0) := X"7A";    -- Small z


end package;
