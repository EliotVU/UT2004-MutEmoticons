/* 
    Copyright (c) 2023 Eliot van Uytfanghe. All rights reserved.

    This work is licensed under the terms of the MIT license.  
    For a copy, see <https://opensource.org/licenses/MIT>.
*/
class LocalPatcher extends Mutator
    abstract
    hidedropdown
    cacheexempt;

const Unflect = Class'Unflect';

var() const Class<LocalPatcherInteraction> LocalPatcherInteractionClass;

/** Patches to be applied as soon as possible, will be reversed as soon the level changes. */
var() private editconst const array<struct FunctionPatch { var() Function Source, Destination; }> 
    /** Patches to be applied to clients only or to a standalone client. */
    LocalPatches;

public final simulated function ApplyFunctionPatches()
{
    local int i;
    if (Level.NetMode != NM_DedicatedServer) {
        for (i = 0; i < LocalPatches.Length; ++i) {
            Log("    Applying local patch" @ i @ LocalPatches[i].Source @ LocalPatches[i].Destination, Name);
            Unflect.static.HookFunction(
                Class'UFunction'.static.AsFunction(LocalPatches[i].Source), 
                Class'UFunction'.static.AsFunction(LocalPatches[i].Destination)
            );
        }
    }
}

public final simulated function UndoFunctionPatches()
{
    local int i;

    if (Level.NetMode != NM_DedicatedServer) {
        for (i = 0; i < LocalPatches.Length; ++i) {
            Log("    Undoing local patch" @ i @ LocalPatches[i].Source @ LocalPatches[i].Destination, Name);
            Unflect.static.HookFunction(
                Class'UFunction'.static.AsFunction(LocalPatches[i].Destination),
                Class'UFunction'.static.AsFunction(LocalPatches[i].Source)
            );
        }
    }
}
    
simulated event PreBeginPlay()
{
    super.PreBeginPlay();

    ApplyFunctionPatches();
    
    if (Role < ROLE_Authority) {
        InstallLocalPatcherInteraction();
    }
}

function ServerTraveling(string URL, bool bItems)
{
    super.ServerTraveling(URL, bItems);

    if (Role == ROLE_Authority) {
        UndoFunctionPatches();
    }
}

private simulated function InstallLocalPatcherInteraction()
{
    local PlayerController localPlayer;

    localPlayer = Level.GetLocalPlayerController();
    if (localPlayer != none 
     && localPlayer.Player != none 
     && localPlayer.Player.InteractionMaster != none)
    {
        LocalPatcherInteraction(localPlayer.Player.InteractionMaster.AddInteraction(string(LocalPatcherInteractionClass), localPlayer.Player)).Patcher = self;
    }
}

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
    bAlwaysRelevant=true

    LocalPatcherInteractionClass=Class'LocalPatcherInteraction'
}