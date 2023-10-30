package kabam.rotmg.ui.view
{
import com.company.assembleegameclient.parameters.Parameters;

import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class CharacterSlotNeedGoldMediator extends Mediator
   {
       
      
      [Inject]
      public var view:CharacterSlotNeedGoldDialog;
      
      [Inject]
      public var closeDialog:CloseDialogsSignal;
      
      [Inject]
      public var model:PlayerModel;
      
      public function CharacterSlotNeedGoldMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.cancel.add(this.onCancel);
         this.view.setPrice(this.model.characterSlotPrice);
      }
      
      override public function destroy() : void
      {
         this.view.cancel.remove(this.onCancel);
      }
      
      public function onCancel() : void
      {
         this.closeDialog.dispatch();
      }
   }
}
