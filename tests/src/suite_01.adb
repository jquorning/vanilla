with Test_Substitutes;
with AUnit.Test_Caller;

package body Suite_01
is
   use AUnit.Test_Suites;

   package Caller is new AUnit.Test_Caller (Test_Substitutes.Test);

   function Suite return Access_Test_Suite
   is
      use Test_Substitutes;

      Ret : constant Access_Test_Suite := new Test_Suite;
   begin
      Ret.Add_Test (Caller.Create ("Item 01", Item_01'Access));
      Ret.Add_Test (Caller.Create ("Item 02", Item_02'Access));
      Ret.Add_Test (Caller.Create ("Item 03", Item_03'Access));
      Ret.Add_Test (Caller.Create ("Item 04", Item_04'Access));
      Ret.Add_Test (Caller.Create ("Item 05", Item_05'Access));
      Ret.Add_Test (Caller.Create ("Item 06", Item_06'Access));
      Ret.Add_Test (Caller.Create ("Item 07", Item_07'Access));
      Ret.Add_Test (Caller.Create ("Item 08", Item_08'Access));
      Ret.Add_Test (Caller.Create ("Item 09", Item_09'Access));

      return Ret;
   end Suite;

end Suite_01;
