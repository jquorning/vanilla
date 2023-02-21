--
--  (c) 2023 Jesper Quorning, license: MIT OR Apache 2.0
--  DANMARK
--

package body Vanilla_Replacer_V1
is
   -------------
   -- Process --
   -------------

   procedure Process (Item : Character_In)
   is
   begin
      if State_Break then
--         if Map (Item) = null then
--            raise Program_Error;
--         else
            for X in Map (Item)'Range loop
               Put (Map (Item) (X));
            end loop;
--         end if;
      else
         if Item = Break then
            State_Break := True;
         else
            Put (To_Character_Out (Item));
         end if;
      end if;
   end Process;

   -------------
   -- Process --
   -------------

   -- procedure Process (Item : String)
   -- is
   -- begin
   --    for A in Item'Range loop
   --       Process (Character (Item (A)));
   --    end loop;
   -- end Process;

end Vanilla_Replacer_V1;

-----------------------------------------------------------------------------
-----  - - -- = = ==  G U D  B E V A R E  D A N M A R K  == = = -- - -  -----
-----------------------------------------------------------------------------
