--
--  (c) 2023 Jesper Quorning, license: MIT OR Apache 2.0
--

package Vanilla_Substitute
is
   --------------------
   -- String of Item --
   --------------------

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

   generic
      with function Map (Item : Character)
           return String;

      with procedure Put (Item : Character);

   package Strings_V1
   is
      Break : Character := '$';

      State_Break : Boolean  := False;

      procedure Process (Item : Character);
      procedure Process (Item : String);

   end Strings_V1;

   generic
      Break : Character := '$';
      with function Map (Item : Character)
                        return String;
   function Translate_V1 (Source : String)
                         return String;

   type Map_Function_Access is access function (Item : Character)
                                               return String;

   function Translate_V2 (Source : String;
                          Map    : Map_Function_Access;
                          Break  : Character := '$')
                         return String;

end Vanilla_Substitute;
