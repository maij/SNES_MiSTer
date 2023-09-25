library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity core_control is
   port
   (
      clk_mem     : in     std_logic;
      clk_sys     : in     std_logic;
      pause       : in     std_logic;
      ce          : out    std_logic := '0';
      refresh     : out    std_logic := '0'
   );
end entity;

architecture arch of core_control is
   signal unpause_count : integer range 0 to 15 := 0;    
   signal send_refresh  : std_logic;
   signal refresh_buf   : std_logic_vector(1 downto 0);

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
         send_refresh <= '0';
         ce <= '0';

         case (state) is
            when NORMAL =>
               ce       <= '1';
               if (pause = '1') then
                  state       <= PAUSED;
                  unpause_count <= 0;
               end if;
               
            when PAUSED =>
               if (unpause_count = 0) then
                  send_refresh <= '1';
               end if;
               
               if (pause = '0') then
                     state <= NORMAL;
               end if;
               
               if (pause = '0') then
                  if (unpause_count = 15) then
                     state <= NORMAL;
                  else
                     unpause_count <= unpause_count + 1;
                  end if;
               end if;
         end case;
      end if;
   end process;

   process(clk_mem)
   begin 
      if falling_edge(clk_mem) then
         refresh <= '0';
         refresh_buf(1) <= refresh_buf(0);
         if (send_refresh = '1') then
            refresh_buf(0) <= '1';
         end if;

         if refresh_buf(1) = '1' then
            refresh <= '1';
         end if;
      end if;
   end process;
end architecture;
