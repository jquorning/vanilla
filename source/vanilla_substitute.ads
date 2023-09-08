--
--  (c) 2023 Jesper Quorning
--  License: MIT OR Apache 2.0
--

package Vanilla_Substitute
is
   --  General rule is to translate a Source string into a Target string
   --  replacing break/key characters using a mapping function.
   --  The break is by default the '$' character. The Key is a single
   --  character following the Break character.
   --
   --  function Map (Key : Character) return String is
   --  begin
   --     case Key is
   --        when 'A' => return "Ada";
   --        when '2' => return "2012";
   --     end case;
   --  end Map;
   --
   --  Target : constant String :=
   --     Translate_V2
   --        ("Hello $A $2012 !, Break => '$', Map'Access);
   --  -- Target is now "Hello Ada 2012 !"
   --
   --  or
   --
   --  function Translate
   --     is new Translator_V1 (Map   => Map,
   --                           Break => '$');
   --
   --  Target : constant String := Translate ("Hello $A $2 !");
   --  -- Target is now "Hello Ada 2012 !".
   --

   Default_Break : Character := '$';

   -------------
   -- Item_V1 --
   -------------

   --  Item_V1 is a generic replacement package on streams of TBD types.

   generic
      type Item_In  is (<>);
      type Item_Out is (<>);

      with function
        To_Item_Out (Item : Item_In)
                    return Item_Out;

      type Item_String (<>)
        is array (Positive range <>)
        of Item_In;

      with function Map (Item : Item_In)
                        return Item_String;

      with procedure Put (Item : Item_Out);

   package Items_V1
   is
      Break : Item_In := Item_In'Last;

      State_Break : Boolean  := False;

      procedure Process (Item : Item_In);
      procedure Process (Item : Item_String);

   end Items_V1;

   ----------------
   -- Strings_V1 --
   ----------------

   --  Strings_V1 is a generic replacement package on Character streams.

   generic
      with function Map (Key : Character)
                        return String;

      with procedure Put (Item : Character);

   package Strings_V1
   is
      Break : Character := Default_Break;

      State_Break : Boolean  := False;

      procedure Process (Item : Character);
      procedure Process (Item : String);

   end Strings_V1;

   ------------------
   -- Translate_V1 --
   ------------------

   generic
      Break : Character := Default_Break;
      --  Break Character indicating next Character is Key to Map function.

      with function Map (Key : Character)
                        return String;
      --  Map from Key to String.

   function Translate_V1 (Source : String)
                         return String;
   --  Translate Source with Breek/Key replaced by Map.

   type Map_Function_Access is access function (Key : Character)
                                               return String;
   --  Map from Key into String. Map must be stable.


   function Translate_V2 (Source : String;
                          Map    : Map_Function_Access;
                          Break  : Character := Default_Break)
                         return String;
   --  Translate Source with Breek/Key replaced by Map.
   --  Map must be stable.

end Vanilla_Substitute;
