dofile(minetest.get_modpath("skyboard").."/lib/skyboard_modlib.lua")

-- no collide function in minetest  ???
-- vanilla collide box
local mesh_size_L = {x = 1.2,y = 0.2,z = 1.2}
local mesh_size_S = {x = 0.7,y = 0.2,z = 0.7}

local skyboard = modlib_createmod()
skyboard:setname("skyboard")
skyboard:lib("minetest_ext")
skyboard:lib("collide")


local function _item_fonplaceS(itemstack, user, pointed_thing)
  local ppos = user:get_pos()
  ppos.y = ppos.y + 0.1
  minetest.add_entity(ppos, skyboard:getname()..":boardS")
  if itemstack:get_count()>1 then
    local items = itemstack
    items:set_count(itemstack:get_count()-1)
    return ItemStack(items)
  end
  return ItemStack()
end
local function _item_fonplaceL(itemstack, user, pointed_thing)
  local ppos = user:get_pos()
  ppos.y = ppos.y + 0.1
  minetest.add_entity(ppos, skyboard:getname()..":boardL")
  if itemstack:get_count()>1 then
    local items = itemstack
    items:set_count(itemstack:get_count()-1)
    return ItemStack(items)
  end
  return ItemStack()
end
skyboard:createegg("groundboard","Groundboard","S_item.png",_item_fonplaceS)
skyboard:createegg("skyboard","Skyboard","L_item.png",_item_fonplaceL)
-- minetest crafting
if mt_itemexist("default:steel_ingot") then
  skyboard:createcraft("groundboard",
    {
      {"","",""},
      {"default:steel_ingot","default:bronze_ingot",""},
      {"","",""}
    }
  )
-- mineclone ctafting
elseif mt_itemexist("mcl_core:iron_ingot") then
  skyboard:createcraft("groundboard",
    {
      {"","",""},
      {"mcl_core:iron_ingot","mcl_copper:copper_ingot",""},
      {"","",""}
    }
  )
end
skyboard:createcraft("skyboard",
  {
    {"","",""},
    {skyboard:getname()..":groundboard",skyboard:getname()..":groundboard",""},
    {"","",""}
  }
)

local function _board_getdriver(obj)
  for _, child in pairs(obj:get_children()) do
    if (not driver) and child:is_player() then
      return child
    else
      child:set_detach()
    end
  end
  return nil
end

local function _board_getposition(obj)
  return obj.object:get_pos()
end

local function _board_gravity(force,obj)
  local position = _board_getposition(obj)
  position.y = position.y-force
  if mt_ifnodeair(position.x,position.y,position.z) then
    obj.object:set_pos(position)
  end
end

local function _board_frclick(self, puncher, time_from_last_punch, tool_capabilities, dir, damage)
  if self.object then
    if not _board_getdriver(self.object) then
      puncher:set_attach(self.object)
    else 
      puncher:set_detach(self.object)
    end
  end
end

local function _board_Sfall(pobj,pcolbox)
	local velocity = vector.new(0, 0, 0)
	local driver = _board_getdriver(pobj.object)
	local position = pobj.object:get_pos()
	if driver then
		local ahor = driver:get_look_horizontal()+math.rad(90)
 
		if NotCollide_VertDown(position,ahor,pcolbox) then
			velocity.y = velocity.y - 1
		end
	end
	position = vector.add(position,velocity)
	pobj.object:set_pos(position)
end

--local function _board_Sjump(pobj,pcolbox)
	--local velocity = vector.new(0, 0, 0)
	--local driver = _board_getdriver(pobj.object)
	--local position = pobj.object:get_pos()
	--if driver then
	    --local controls = driver:get_player_control()
		--local ahor = driver:get_look_horizontal()+math.rad(90)
		--if controls.jump then
			--if NotCollide_Horx2(position,ahor,pcolbox)==false and
				--NotCollide_Vert(position,ahor,3)then
				--velocity.y = velocity.y + 0.5
			--end
		--end
	--end
	--position = vector.add(position,velocity)
	--pobj.object:set_pos(position)
--end
local function _board_Lfall(pobj,pcolbox)
	local velocity = vector.new(0, 0, 0)
	local driver = _board_getdriver(pobj.object)
	local position = pobj.object:get_pos()
	if driver then
		local ahor = driver:get_look_horizontal()+math.rad(90)
		if NotCollide_Horx2(position,ahor,pcolbox)==false then
			if NotCollide_Vert(position,ahor,-1) then
				velocity.y = velocity.y - 1
			end
		end
	end
	position = vector.add(position,velocity)
	pobj.object:set_pos(position)
end


local function _board_controls(pobj,pcolbox)
  local velocity = vector.new(0, 0, 0)
  local driver = _board_getdriver(pobj.object)
  local position = pobj.object:get_pos()
  if driver then
    local controls = driver:get_player_control()
    local ahor = driver:get_look_horizontal()+math.rad(90)
    if controls.up then
      if NotCollide_Horx2(position,ahor,pcolbox) then
        velocity.z = velocity.z + math.sin(ahor) * (5 * 0.07)
        velocity.x = velocity.x + math.cos(ahor) * (5 * 0.07)
      end
      if  NotCollide_Hor(position,ahor,pcolbox)==false and
			NotCollide_VertUp(position,ahor,pcolbox) then
          velocity.y = velocity.y + 0.4
      end
    elseif controls.down and NotCollide_Horx2(position,ahor+math.rad(180),pcolbox) then
      velocity.z = velocity.z + math.sin(ahor) * (-5 * 0.05)
      velocity.x = velocity.x + math.cos(ahor) * (-5 * 0.05)
    end
--if controls.left and NotCollide_Hor(position,ahor+math.rad(90),pcolbox) then
--velocity.z = velocity.z + math.sin(ahor+math.rad(90)) * (5 * 0.05)
--velocity.x = velocity.x + math.cos(ahor+math.rad(90)) * (5 * 0.05)
--elseif controls.right and NotCollide_Hor(position,ahor-math.rad(90),pcolbox) then
--velocity.z = velocity.z + math.sin(ahor+math.rad(90)) * (-5 * 0.05)
--velocity.x = velocity.x + math.cos(ahor+math.rad(90)) * (-5 * 0.05)
--end

--    if controls.sneak and 
--    mt_ifnodeair(position.x+velocity.x ,position.y-1,position.z+velocity.z)==true then
--      velocity.y = velocity.y - 1
--    elseif controls.jump and 
--    mt_ifnodeair(position.x+velocity.x ,position.y+1,position.z+velocity.z) then
--      velocity.y = velocity.y + 1
--    end

    position = vector.add(position,velocity)
    pobj.object:set_rotation(vector.new(0,ahor,0))
    pobj.object:set_pos(position)
    return true
  end
  return false
end

local function _board_fstep_S(self,dtime)
	if _board_controls(self,mesh_size_S) then
		_board_Sfall(self,mesh_size_S)
		--_board_Sjump(self,mesh_size_S)
	else
		_board_gravity(1,self)
	end
end

local function _board_fstep_L(self,dtime)
  if _board_controls(self,mesh_size_L) then
	_board_Lfall(self,mesh_size_L)
  else
    _board_gravity(1,self)
  end
end
local function _board_fpunchS(self, puncher)
  minetest.add_item(self.object:get_pos(),skyboard:getname()..":groundboard")
  self.object:remove()
end

local function _board_fpunchL(self, puncher)
  minetest.add_item(self.object:get_pos(),skyboard:getname()..":skyboard")
  self.object:remove()
end

skyboard:createentity("boardS","S_mesh.obj","texture.png",
  {-0.25, -0.15, -0.25, 0.25, 0.15, 0.25},
  _board_frclick,
  _board_fstep_S,
  _board_fpunchS
)

skyboard:createentity("boardL","L_mesh.obj","texture.png",
  {-0.5, -0.25, -0.5, 0.5, 0.05, 0.5},
  _board_frclick,
  _board_fstep_L,
  _board_fpunchL
)
