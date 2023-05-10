--
--  (c) 2023 Jesper Quorning, license: MIT OR Apache 2.0
--

package Vanilla_Replace
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
        of Item_Out;

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

end Vanilla_Replace;
