package kabam.rotmg.ui.view {
import com.company.assembleegameclient.appengine.SavedCharacter;
import com.company.assembleegameclient.screens.CharacterSelectionAndNewsScreen;
import com.company.assembleegameclient.screens.NewCharacterScreen;
import com.company.assembleegameclient.ui.dialogs.Dialog;

import flash.events.Event;

import kabam.rotmg.classes.model.CharacterClass;
import kabam.rotmg.classes.model.ClassesModel;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.core.signals.SetScreenSignal;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.game.model.GameInitData;
import kabam.rotmg.game.signals.PlayGameSignal;
import kabam.rotmg.servers.api.ServerModel;
import kabam.rotmg.ui.signals.NameChangedSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

public class CurrentCharacterMediator extends Mediator {

    [Inject]
    public var view:CharacterSelectionAndNewsScreen;

    [Inject]
    public var playerModel:PlayerModel;

    [Inject]
    public var classesModel:ClassesModel;

    [Inject]
    public var setScreen:SetScreenSignal;

    [Inject]
    public var playGame:PlayGameSignal;

    [Inject]
    public var nameChanged:NameChangedSignal;

    [Inject]
    public var servers:ServerModel;

    [Inject]
    public var openDialog:OpenDialogSignal;

    [Inject]
    public var closeDialog:CloseDialogsSignal;

    [Inject]
    public var noServersDialogFactory:NoServersDialogFactory;

    public function CurrentCharacterMediator() {
        super();
    }

    override public function initialize():void {
        this.view.close.add(this.onClose);
        this.view.newCharacter.add(this.onNewCharacter);
        this.view.showClasses.add(this.onNewCharacter);
        this.view.playGame.add(this.onPlayGame);
        this.view.oryxSleeping.add(this.onOryxSleeping);
        this.view.initialize(this.playerModel, this.servers);
        this.nameChanged.add(this.onNameChanged);
    }

    override public function destroy():void {
        this.nameChanged.remove(this.onNameChanged);
        this.view.close.remove(this.onClose);
        this.view.newCharacter.remove(this.onNewCharacter);
        this.view.showClasses.remove(this.onNewCharacter);
        this.view.playGame.remove(this.onPlayGame);
        this.view.oryxSleeping.remove(this.onOryxSleeping);
    }

    private function onNameChanged(name:String):void {
        this.view.setName(name);
    }

    private function onNewCharacter():void {
        this.setScreen.dispatch(new NewCharacterScreen());
    }

    private function onClose():void {
        this.setScreen.dispatch(new TitleView());
    }

    private function onPlayGame():void {
        var character:SavedCharacter = this.playerModel.getCharacterByIndex(0);
        this.playerModel.currentCharId = character.charId();
        var characterClass:CharacterClass = this.classesModel.getCharacterClass(character.objectType());
        characterClass.setIsSelected(true);
        characterClass.skins.getSkin(character.skinType()).setIsSelected(true);
        var game:GameInitData = new GameInitData();
        game.createCharacter = false;
        game.charId = character.charId();
        game.isNewGame = true;
        this.playGame.dispatch(game);
    }

    private function onOryxSleeping():void{
        var dialog:Dialog = this.noServersDialogFactory.makeDialog();
        dialog.addEventListener(Dialog.BUTTON1_EVENT, this.onOk);
        this.openDialog.dispatch(dialog);
    }

    private function onOk(e:Event):void{
        this.closeDialog.dispatch();
    }
}
}
