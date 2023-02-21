-----------------------------------------------------------------------------
-----  - - -- = = ==  G U D  B E V A R E  D A N M A R K  == = = -- - -  -----
-----------------------------------------------------------------------------
--
--  (c) 2023 Quorning Apps, license: MIT OR Apache 2.0
--  DANMARK
--

generic
   type Character is (<>);

   type String (<>)
     is array (Positive range <>)
     of Character;

   type String_Access is access String;

   New_Line : Character;

   with procedure Process (Item : Character);

package Vanilla_Replacer_V1
is
   Break : Character := Character'Last;

   State_Break : Boolean  := False;

   Map :
     array (Character)
       of String_Access
         := (others => null);

   procedure Put (Item : Character);

   procedure Put (Item : String);
   --  Convinience.

end Vanilla_Replacer_V1;
