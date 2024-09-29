library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;

entity arithmetic_unit is

  port (
    all_samples      : in  sample_file;                       -- all samples in the delay line
    all_coefficients : in  coeff_file;                        -- all coefficients in the ROM
    result           : out signed(RESULT_WIDTH-1 downto 0));  -- output of the MAC chain

end entity arithmetic_unit;

architecture structure of arithmetic_unit is

  signal result_tmp : result_type;

begin  -- architecture structure

  result_tmp(0) <= (others => '0');
  MAC_CHAIN_GEN : for i in 0 to FILTER_TAPS-1 generate
  begin
    MAC_INST : entity work.mac
      port map (
        sample_in   => all_samples(i),
        coefficient => all_coefficients(i),
        accumulate  => result_tmp(i),
        result      => result_tmp(i+1));
  end generate;
  result <= result_tmp(FILTER_TAPS);

end architecture structure;
