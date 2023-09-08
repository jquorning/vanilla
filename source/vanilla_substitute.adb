--
--  (c) 2023 Jesper Quorning, license: MIT OR Apache 2.0
--

package body Vanilla_Substitute
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

   ------------------
   -- Translate_V1 --
   ------------------

   function Translate_V1 (Source : String) return String
   is
      Length : Natural := 0;
      Index  : Natural := Source'First;
   begin
      --  Find length of Target string.
      while Index <= Source'Last loop
         if Source (Index) = Break then
            declare
               Key_Index : Natural := Index + 1;
               Key       : Character renames Source (Key_Index);
               Word      : String    renames Map (Key);
            begin
               Length := Length + Word'Length;
               Index  := Index + 2;  -- Break and Key
            end;
         else
            Length := Length + 1;
            Index  := Index + 1;
         end if;
      end loop;

      --  Fill into Target string.
      declare
         Target : String (1 .. Length);
         Last   : Natural  := Target'First - 1;
         Index  : Natural  := Source'First;
      begin
         while Index <= Source'Last loop
            if Source (Index) = Break then
               declare
                  Key_Index : Natural := Index + 1;
                  Key       : Character renames Source (Key_Index);
                  Word      : String    renames Map (Key);
                  First     : constant Positive := Last + 1;
               begin
                  Last := Last + Word'Length;
                  Target (First .. Last) := Word;
               end;
               Index := Index + 2;
            else
               Last := Last + 1;
               Target (Last) := Source (Index);
               Index := Index + 1;
            end if;
         end loop;

         return Target;
      end;
   end Translate_V1;

   ------------------
   -- Translate_V2 --
   ------------------

   function Translate_V2 (Source : String;
                          Map    : Map_Function_Access;
                          Break  : Character := Default_Break)
                         return String
   is
      function Translator
        is new Translate_V1 (Break => Break, Map => Map.all);
   begin
      return Translator (Source);
   end Translate_V2;

end Vanilla_Substitute;
