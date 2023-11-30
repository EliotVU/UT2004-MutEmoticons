/* 
    Copyright (c) 2023 Eliot van Uytfanghe. All rights reserved.

    This work is licensed under the terms of the MIT license.  
    For a copy, see <https://opensource.org/licenses/MIT>.
*/
#include UnflectPackage.uci
class LocalPatcherInteraction extends Interaction;

var LocalPatcher Patcher;

event Initialized()
{
    // Log("Applying local patches", Name);
    Patcher.ApplyFunctionPatches();
}

event NotifyLevelChange()
{
    // Stay clear from a potential memory leak.
    Class'MutEmoticons'.default.EmoticonsState = none;

    // Log("Undoing local patches", Name);
    Patcher.UndoFunctionPatches();
    Patcher = none;
	Master.RemoveInteraction(self);
}

defaultproperties
{

}