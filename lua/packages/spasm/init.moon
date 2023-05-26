require 'class-war', 'https://github.com/toxidroma/class-war'
    --provides UPLINK

import ReadEntity, WriteEntity,
    ReadString, WriteString,
    ReadUInt, WriteUInt,
    ReadFloat, WriteFloat from net
class UPLINK_SPASM extends UPLINK
    @Write: (ply, sequence, slot=GESTURE_SLOT_CUSTOM, speed=1, start=0) =>
        WriteEntity ply
        WriteString sequence
        WriteUInt slot, 3
        WriteUInt speed, 3
        WriteFloat start
    @Read: => ReadEntity!, ReadString!, ReadUInt(3), ReadUInt(3), ReadFloat!
    @Callback: (ply, who, sequence, slot, speed, start) => 
        return unless IsValid who
        return if who\IsDormant!
        who\Spasm {
            sequence: who\FindSequence sequence
            :slot
            :speed
            :start
        }

import Random from table
export SEQUENCE_LOOKUP = {}
hook.Add 'PostLoadAnimations', tostring(_PKG), -> SEQUENCE_LOOKUP = {}
with FindMetaTable 'Player'
    .FindSequence = (act) =>
        return SEQUENCE_LOOKUP[act] if SEQUENCE_LOOKUP[act]
        seq = @LookupSequence act
        SEQUENCE_LOOKUP[act] = seq if seq > -1
        seq
    .Spasm = (choreo) =>
        import sequence, slot, speed, start, SS from choreo
        slot or= GESTURE_SLOT_CUSTOM
        start or= 0
        sequence = Random sequence if istable sequence
        if SERVER
            if SS
                UPLINK_SPASM\Broadcast @, sequence, slot, speed, start
            else
                UPLINK_SPASM\SendOmit @, @, sequence, slot, speed, start
        sequence = @FindSequence sequence if isstring sequence
        @AddVCDSequenceToGestureSlot slot, sequence, start, not loop
        @SetLayerPlaybackRate slot, speed if isnumber speed
        sequence, slot