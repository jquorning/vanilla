-----------------------------------------------------------------------------
-----  - - -- = = ==  G U D  B E V A R E  D A N M A R K  == = = -- - -  -----
-----------------------------------------------------------------------------
--
--  (c) 2023 Quorning Apps, license: MIT OR Apache 2.0
--  DANMARK
--

package body Vanilla_Replacer_V1
is
   ---------
   -- Put --
   ---------

   procedure Put (Item : Character)
   is
   begin
      if State_Break then
         if Map (Item) = null then
            raise Program_Error;
         else
            for X in Map (Item)'Range loop
               Process (Map (Item) (X));
            end loop;
         end if;
      else
         if Item = Break then
            State_Break := True;
         else
            Process (Item);
         end if;
      end if;
   end Put;

   ---------
   -- Put --
   ---------

   procedure Put (Item : String)
   is
   begin
      for A in Item'Range loop
         Process (Item (A));
      end loop;
   end Put;

end Vanilla_Replacer_V1;
