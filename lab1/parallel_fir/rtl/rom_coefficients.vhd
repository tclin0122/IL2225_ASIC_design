library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;

-- The rom_coefficients entity simulates an asynchronous ROM that stores the
-- FIR coefficients. The coefficients are initialized in a "triangular" pattern.
-- You are free to change the coefficinets to any value but this pattern makes
-- it easy to verify the correct output when an impulse input is applied.
entity rom_coefficients is

  port (
    --! Coefficient output
    coeff_out  : out coeff_file);

end entity rom_coefficients;

architecture behavior of rom_coefficients is

begin

  -- Permanently connect the coefficients to their value to emulate the ROM
  coeff_out(0)  <= "0000000001";
  coeff_out(1)  <= "0000000011";
  coeff_out(2)  <= "0000000111";
  coeff_out(3)  <= "0000001111";
  coeff_out(4)  <= "0000011111";
  coeff_out(5)  <= "0000111111";
  coeff_out(6)  <= "0001111111";
  coeff_out(7)  <= "0000111111";
  coeff_out(8)  <= "0000011111";
  coeff_out(9)  <= "0000001111";
  coeff_out(10) <= "0000000111";
  coeff_out(11) <= "0000000011";
  coeff_out(12) <= "0000000001";
end architecture behavior;
