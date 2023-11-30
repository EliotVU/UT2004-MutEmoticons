/* Copyright (c) 2007-2023 Eliot van Uytfanghe. All rights reserved. */
class EmoticonsServerActor extends Info;

event PreBeginPlay()
{
    Level.Game.AddMutator(string(Class'MutEmoticons'));
}