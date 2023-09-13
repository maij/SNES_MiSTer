library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity core_control is
   port
   (
      clk_sys     : in     std_logic;
      pause       : in     std_logic;
      ce          : out    std_logic := '0'
   );
end entity;

architecture arch of core_control is
   type tstate is
   (
      NORMAL,
      PAUSED
   );
   signal state : tstate := NORMAL;

begin

   process(clk_sys)
   begin
      if falling_edge(clk_sys) then
         case (state) is
            when NORMAL =>
               ce       <= '1';
               if (pause = '1') then
                  state       <= PAUSED;
               end if;
               
            when PAUSED =>
               ce <= '0';
               if (pause = '0') then
                     state <= NORMAL;
               end if;
         end case;
         
      end if;
   end process;
end architecture;
