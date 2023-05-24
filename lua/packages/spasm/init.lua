require('class-war', 'https://github.com/toxidroma/class-war')
local ReadEntity, WriteEntity, ReadString, WriteString, ReadUInt, WriteUInt, ReadFloat, WriteFloat
do
  local _obj_0 = net
  ReadEntity, WriteEntity, ReadString, WriteString, ReadUInt, WriteUInt, ReadFloat, WriteFloat = _obj_0.ReadEntity, _obj_0.WriteEntity, _obj_0.ReadString, _obj_0.WriteString, _obj_0.ReadUInt, _obj_0.WriteUInt, _obj_0.ReadFloat, _obj_0.WriteFloat
end
local UPLINK_SPASM
do
  local _class_0
  local _parent_0 = UPLINK
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "UPLINK_SPASM",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  self.Write = function(self, ply, sequence, slot, speed, start)
    if slot == nil then
      slot = GESTURE_SLOT_CUSTOM
    end
    if speed == nil then
      speed = 1
    end
    if start == nil then
      start = 0
    end
    WriteEntity(ply)
    WriteString(sequence)
    WriteUInt(slot, 3)
    WriteUInt(speed, 3)
    return WriteFloat(start)
  end
  self.Read = function(self)
    return ReadEntity(), ReadString(), ReadUInt(3), ReadUInt(3), ReadFloat()
  end
  self.Callback = function(self, ply, who, sequence, slot, speed, start)
    if not (IsValid(who)) then
      return 
    end
    if who:IsDormant() then
      return 
    end
    return who:Spasm({
      sequence = who:FindSequence(sequence),
      slot = slot,
      speed = speed,
      start = start
    })
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  UPLINK_SPASM = _class_0
end
local Random
Random = table.Random
SEQUENCE_LOOKUP = { }
do
  local _with_0 = FindMetaTable('Player')
  _with_0.FindSequence = function(self, act)
    if SEQUENCE_LOOKUP[act] then
      return SEQUENCE_LOOKUP[act]
    end
    local seq = self:LookupSequence(act)
    if seq > -1 then
      SEQUENCE_LOOKUP[act] = seq
    end
    return seq
  end
  _with_0.Spasm = function(self, choreo)
    local sequence, slot, speed, start, SS
    sequence, slot, speed, start, SS = choreo.sequence, choreo.slot, choreo.speed, choreo.start, choreo.SS
    slot = slot or GESTURE_SLOT_CUSTOM
    start = start or 0
    if istable(sequence) then
      sequence = Random(sequence)
    end
    if SERVER then
      if SS then
        UPLINK_SPASM:Broadcast(self, sequence, slot, speed, start)
      else
        UPLINK_SPASM:SendOmit(self, self, sequence, slot, speed, start)
      end
    end
    if isstring(sequence) then
      sequence = self:FindSequence(sequence)
    end
    self:AddVCDSequenceToGestureSlot(slot, sequence, start, not loop)
    if isnumber(speed) then
      self:SetLayerPlaybackRate(slot, speed)
    end
    return sequence, slot
  end
  return _with_0
end
