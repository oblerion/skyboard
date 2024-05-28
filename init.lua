local function include(pmod,ppath)
  return dofile(minetest.get_modpath(pmod).."/"..ppath)
end
include("skyboard","lib/skyboard_modlib.lua")

-- no collide function in minetest

local mesh_size = {x = 1.2,y = 1,z = 1.2}

local skyboard = modlib_createmod()
skyboard:set_modname("skyboard")
skyboard:createblock("block","Skyboard pack","block.png",skyboard:getgroups("dirt",3),default.node_sound_dirt_defaults(),"item 9")

local function skyboard_item_fonplace(itemstack, user, pointed_thing)
  local ppos = user:get_pos()
  ppos.y = ppos.y + 0.1
  minetest.add_entity(ppos, skyboard:getname()..":board")
  if itemstack:get_count()>1 then
    local items = itemstack
    items:set_count(itemstack:get_count()-1)
    return ItemStack(items)
  end
  return ItemStack()
end
skyboard:createegg("item","Skyboard","item.png",skyboard_item_fonplace)

skyboard:createcraft("item",{
    {"","",""},
    {"default:steel_ingot","default:bronze_ingot","default:steel_ingot"},
    {"","",""}
  }
)
skyboard:createcraft("block",{
    {skyboard:getname()..":item",skyboard:getname()..":item", skyboard:getname()..":item"},
    {skyboard:getname()..":item",skyboard:getname()..":item", skyboard:getname()..":item"},
    {skyboard:getname()..":item",skyboard:getname()..":item", skyboard:getname()..":item"}
})
skyboard:createcraft("item 9",{{skyboard:getname()..":block"}})


local function skyboard_get_driver(obj)
  --local driver = {}
  for _, child in pairs(obj:get_children()) do
    if (not driver) and child:is_player() then
      --driver = child
      return child
    else
      child:set_detach()
    end
  end
  return nil
end

local function skyboard_frclick(self, puncher, time_from_last_punch, tool_capabilities, dir, damage)
  if self.object then
    if not skyboard_get_driver(self.object) then
      puncher:set_attach(self.object)
    else 
      puncher:set_detach(self.object)
    end
  end
end

local function mt_ifnodeair(px,py,pz)
  local v = vector.new(px,py,pz)
  return minetest.get_node(v).name == "air" 
end

local function skyboard_fstep(self,dtime)
  local velocity = vector.new(0, 0, 0)
  local driver = skyboard_get_driver(self.object)
  local position = self.object:get_pos()
  if driver then
    local controls = driver:get_player_control()
    local ahor = driver:get_look_horizontal()+math.rad(90)
    if controls.up  and mt_ifnodeair(
      position.x+(mesh_size.x*math.cos(ahor)),
      position.y,
      position.z+(mesh_size.z*math.sin(ahor))) then
      velocity.z = velocity.z + math.sin(ahor) * (5 * 0.07)
      velocity.x = velocity.x + math.cos(ahor) * (5 * 0.07)
    elseif controls.down and mt_ifnodeair(
      position.x-(mesh_size.x*math.cos(ahor)),
      position.y,
      position.z-(mesh_size.z*math.sin(ahor))) then
      velocity.z = velocity.z + math.sin(ahor) * (-5 * 0.05)
      velocity.x = velocity.x + math.cos(ahor) * (-5 * 0.05)
    end
    if controls.left  and mt_ifnodeair(
      position.x+(mesh_size.x*math.cos(ahor+math.rad(90))),
      position.y,
      position.z+(mesh_size.z*math.sin(ahor+math.rad(90)))) then
      velocity.z = velocity.z + math.sin(ahor+math.rad(90)) * (5 * 0.05)
      velocity.x = velocity.x + math.cos(ahor+math.rad(90)) * (5 * 0.05)
    elseif controls.right and mt_ifnodeair(
      position.x-(mesh_size.x*math.cos(ahor+math.rad(90))),
      position.y,
      position.z-(mesh_size.z*math.sin(ahor+math.rad(90)))) then
      velocity.z = velocity.z + math.sin(ahor+math.rad(90)) * (-5 * 0.05)
      velocity.x = velocity.x + math.cos(ahor+math.rad(90)) * (-5 * 0.05)
    end
    if controls.jump and mt_ifnodeair(position.x,position.y+2,position.z) then
      velocity.y = velocity.y + 1
    end
    
    if controls.sneak and mt_ifnodeair(position.x,position.y-1,position.z) then
      position.y = position.y - 1
    end
    --self.object:rotate(vector.new(0,1,0))
    
    position = vector.add(position,velocity)
    self.object:set_rotation(vector.new(0,ahor,0))
--    if minetest.get_node(position).name=="air" then
      self.object:set_pos(position)
--    end
  elseif mt_ifnodeair(position.x,position.y-1,position.z) then
      position.y = position.y - 1
      self.object:set_pos(position)
  end
end
local function skyboard_fpunch(self, puncher)
  minetest.add_item(self.object:get_pos(),skyboard:getname()..":item")
  self.object:remove()
end

skyboard:createentity("board","mesh.obj","texture.png",
  {-0.5, -0.25, -0.5, 0.5, 0.05, 0.5},
  skyboard_frclick,
  skyboard_fstep,
  skyboard_fpunch
)
