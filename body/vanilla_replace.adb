--
--  (c) 2023 Jesper Quorning, license: MIT OR Apache 2.0
--

package body Vanilla_Replace
is
   ---------------
   --  Items_V1 --
   ---------------

   package body Items_V1
   is
      -------------
      -- Process --
      -------------

      procedure Process (Item : Item_In)
      is
      begin
         if State_Break then
            declare
               S : Item_String renames Map (Item);
            begin
               for I in Map (Item)'Range loop
                  Put (To_Item_Out (S (I)));
               end loop;
            end;
            State_Break := False;
         else
            if Item = Break then
               State_Break := True;
            else
               Put (To_Item_Out (Item));
            end if;
         end if;
      end Process;

      -------------
      -- Process --
      -------------

      procedure Process (Item : Item_String)
      is
      begin
         for A in Item'Range loop
            Process (Item (A));
         end loop;
      end Process;

   end Items_V1;

   ----------------
   -- Strings_V1 --
   ----------------

   package body Strings_V1
   is
      -------------
      -- Process --
      -------------

      procedure Process (Item : Character)
      is
      begin
         if State_Break then
            declare
               S : String renames Map (Item);
            begin
               for I in Map (Item)'Range loop
                  Put (S (I));
               end loop;
            end;
            State_Break := False;
         else
            if Item = Break then
               State_Break := True;
            else
               Put (Item);
            end if;
         end if;
      end Process;

      -------------
      -- Process --
      -------------

      procedure Process (Item : String)
      is
      begin
         for A in Item'Range loop
            Process (Item (A));
         end loop;
      end Process;

   end Strings_V1;

end Vanilla_Replace;
