--
--  (c) 2023 Jesper Quorning, license: MIT OR Apache 2.0
--  DANMARK
--

package Vanilla_Replace_V1
is
   ----------------
   -- Characters --
   ----------------
   
   generic
      type Character_In  is (<>);
      type Character_Out is (<>);

      with function
         To_Character_Out (Item : Character_In)
           return Character_Out;

--   type String_Access is access String;
      type String (<>)
        is array (Positive range <>)
        of Character_Out;

--   type Map_Array is
--     array (Character)
--       of String_Access;
--   Map : Map_Array;
--   with function Map (Item : Character) return String_Access;

      with function
         Map (Item : Character_In)
           return String;

--   New_Line : Character;

      with procedure
         Put (Item : Character_Out);
--   with procedure Put (Item : String_Out);

   package Characters
   is
      Break : Character_In := Character_In'Last;

      State_Break : Boolean  := False;

--   Map :
--     array (Character)
--       of String_Access
--         := (others => null);

      procedure
        Process (Item : Character_In);

--   procedure Process (Item : String);
   --  Convinience.

   end Characters;
   
   --------------
   -- Strings --
   --------------

   generic
   package Strings
   is
   end Strings;

   -------------
   -- Streams --
   -------------

   generic
   package Streams
   is
   end Streams;
   
end Vanilla_Replace_V1;

-----------------------------------------------------------------------------
-----  - - -- = = ==  G U D  B E V A R E  D A N M A R K  == = = -- - -  -----
-----------------------------------------------------------------------------
