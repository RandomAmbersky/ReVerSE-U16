-------------------------------------------------------------------[12.09.2015]
-- TurboSound
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity turbosound is
	port ( 
		I_CLK		: in std_logic;
		I_ENA		: in std_logic;
		I_ADDR		: in std_logic_vector(15 downto 0);
		I_DATA		: in std_logic_vector(7 downto 0);
		I_WR_N		: in std_logic;
		I_IORQ_N	: in std_logic;
		I_M1_N		: in std_logic;
		I_RESET_N	: in std_logic;
		O_SEL		: out std_logic;
		-- ssg0
		I_SSG0_IOA	: in std_logic_vector(7 downto 0);
		O_SSG0_IOA	: out std_logic_vector(7 downto 0);
		I_SSG0_IOB	: in std_logic_vector(7 downto 0);
		O_SSG0_IOB	: out std_logic_vector(7 downto 0);
		O_SSG0_DA	: out std_logic_vector(7 downto 0);
		O_SSG0_AUDIO	: out std_logic_vector(7 downto 0);
		O_SSG0_AUDIO_A	: out std_logic_vector(7 downto 0);
		O_SSG0_AUDIO_B	: out std_logic_vector(7 downto 0);
		O_SSG0_AUDIO_C	: out std_logic_vector(7 downto 0);
		-- ssg1
		I_SSG1_IOA	: in std_logic_vector(7 downto 0);
		O_SSG1_IOA	: out std_logic_vector(7 downto 0);
		I_SSG1_IOB	: in std_logic_vector(7 downto 0);
		O_SSG1_IOB	: out std_logic_vector(7 downto 0);
		O_SSG1_DA	: out std_logic_vector(7 downto 0);
		O_SSG1_AUDIO	: out std_logic_vector(7 downto 0);
		O_SSG1_AUDIO_A	: out std_logic_vector(7 downto 0);
		O_SSG1_AUDIO_B	: out std_logic_vector(7 downto 0);
		O_SSG1_AUDIO_C	: out std_logic_vector(7 downto 0)
	);
end turbosound;
 
architecture rtl of turbosound is
	signal bc1	: std_logic;
	signal bdir	: std_logic;
	signal ssg	: std_logic;
begin
	bdir	<= '1' when (I_M1_N = '1' and I_IORQ_N = '0' and I_WR_N = '0' and I_ADDR(15) = '1' and I_ADDR(1) = '0') else '0';
	bc1	<= '1' when (I_M1_N = '1' and I_IORQ_N = '0' and I_ADDR(15) = '1' and I_ADDR(14) = '1' and I_ADDR(1) = '0') else '0';

	O_SEL	<= ssg;
	
	process(I_CLK, I_RESET_N)
	begin
		if (I_RESET_N = '0') then
			ssg <= '0';
		elsif (I_CLK'event and I_CLK = '1') then
			if (I_DATA(7 downto 1) = "1111111" and bdir = '1' and bc1 = '1') then
				ssg <= I_DATA(0);
			end if;
		end if;
	end process;

	ssg0: entity work.ym2149
		port map(
			I_RESET_N 		=> I_RESET_N,
			I_CLOCK     		=> I_CLK,
			I_ENA			=> I_ENA,
			I_DA    		=> I_DATA,
			O_DA    		=> O_SSG0_DA,
			O_DA_OE_N		=> open,
			I_A9_N			=> '0',
			I_A8			=> not ssg,
			I_BDIR			=> bdir,
			I_BC2			=> '1',
			I_BC1			=> bc1,
			I_SEL_N 		=> '1',
			O_AUDIO			=> O_SSG0_AUDIO,
			O_AUDIO_A		=> O_SSG0_AUDIO_A,
			O_AUDIO_B		=> O_SSG0_AUDIO_B,
			O_AUDIO_C		=> O_SSG0_AUDIO_C,
			I_IOA			=> I_SSG0_IOA,
			O_IOA			=> O_SSG0_IOA,
			O_IOA_OE_N		=> open,
			I_IOB			=> I_SSG0_IOB,
			O_IOB			=> O_SSG0_IOB,
			O_IOB_OE_N		=> open
		);

	ssg1: entity work.ym2149
		port map(
			I_RESET_N 		=> I_RESET_N,
			I_CLOCK     		=> I_CLK,
			I_ENA			=> I_ENA,
			I_DA    		=> I_DATA,
			O_DA    		=> O_SSG1_DA,
			O_DA_OE_N		=> open,
			I_A9_N			=> '0',
			I_A8			=> ssg,
			I_BDIR			=> bdir,
			I_BC2			=> '1',
			I_BC1			=> bc1,
			I_SEL_N 		=> '1',
			O_AUDIO			=> O_SSG1_AUDIO,
			O_AUDIO_A		=> O_SSG1_AUDIO_A,
			O_AUDIO_B		=> O_SSG1_AUDIO_B,
			O_AUDIO_C		=> O_SSG1_AUDIO_C,
			I_IOA			=> I_SSG1_IOA,
			O_IOA			=> O_SSG1_IOA,
			O_IOA_OE_N		=> open,
			I_IOB			=> I_SSG1_IOB,
			O_IOB			=> O_SSG1_IOB,
			O_IOB_OE_N		=> open
		);
end rtl;