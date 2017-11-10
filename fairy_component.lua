local Point3 = _radiant.csg.Point3
local rng = _radiant.math.get_default_rng()
local FairyComponent = class()

function FairyComponent:initialize()
	self._sv.facing_timer = nil
	self._sv.fairy = nil
end

function FairyComponent:create()
	self._sv.fairy = radiant.entities.create_entity("fairy:fairy", {owner = self._entity})
	local random_x = rng:get_int(0, 1) * 2 -1
	local random_y = rng:get_real(3.5, 4)
	local random_z = rng:get_int(0, 1) * 2 -1
	local offset = Point3(random_x, random_y, random_z)
	radiant.entities.add_child(self._entity, self._sv.fairy, offset, true)

	self._sv.facing_timer = stonehearth.calendar:set_persistent_interval("FairyComponent facing_timer", "5m+1m", radiant.bind(self, 'face_direction'), "5m+1m")
	self.__saved_variables:mark_changed()
end

function FairyComponent:face_direction()
	local parent_facing = radiant.entities.get_facing(self._entity)
	radiant.entities.turn_to(self._sv.fairy, parent_facing+180)

	local random_x = rng:get_real(-0.1, 0.1)
	local random_y = rng:get_real(-0.1, 0.1)
	local random_z = rng:get_real(-0.1, 0.1)
	local location = radiant.entities.get_location(self._sv.fairy)
	local offset = location+Point3(random_x, random_y, random_z)

	radiant.math.bound(offset.x, -1, 1)
	radiant.math.bound(offset.y, 3.5, 4)
	radiant.math.bound(offset.z, -1, 1)

	radiant.entities.move_to(self._sv.fairy, offset)
end

function FairyComponent:destroy()
	if self._sv.fairy then
		radiant.entities.destroy_entity(self._sv.fairy)
		self._sv.fairy = nil
	end
	if self._sv.facing_timer then
		self._sv.facing_timer:destroy()
		self._sv.facing_timer = nil
		self.__saved_variables:mark_changed()
	end
end

return FairyComponent