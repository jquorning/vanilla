
with AUnit.Test_Fixtures;

package Test_Substitutes
is
   type Test
     is new AUnit.Test_Fixtures.Test_Fixture
     with null record;

   procedure Item_01 (T : in out Test);
   procedure Item_02 (T : in out Test);
   procedure Item_03 (T : in out Test);
   procedure Item_04 (T : in out Test);
   procedure Item_05 (T : in out Test);
   procedure Item_06 (T : in out Test);
   procedure Item_07 (T : in out Test);
   procedure Item_08 (T : in out Test);
   procedure Item_09 (T : in out Test);

end Test_Substitutes;
