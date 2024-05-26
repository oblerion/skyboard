local function include(pmod,ppath)
  return dofile(minetest.get_modpath(pmod).."/"..ppath)
end
include("skyboard","lib/modlib.lua")

local skyboard = modlib_createmod()
skyboard:set_modname("skyboard")
skyboard:createblock("block","Skyboard pack","block.png",skyboard:getgroups("dirt",3),default.node_sound_dirt_defaults(),skyboard:getname()..":item 9")
skyboard:createegg("item","Skyboard","item.png",
  function(itemstack, user, pointed_thing)
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
)


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

function skyboard_frclick(self, puncher, time_from_last_punch, tool_capabilities, dir, damage)
  if self.object then
    if not skyboard_get_driver(self.object) then
      puncher:set_attach(self.object)
    else 
      puncher:set_detach(self.object)
    end
  end
end

function skyboard_fstep(self,dtime)
  local velocity = vector.new(0, 0, 0)
  local driver = skyboard_get_driver(self.object)
  local position = self.object:get_pos()
  if driver then
    local controls = driver:get_player_control()
    local ahor = driver:get_look_horizontal()+math.rad(90)
    if controls.up then
      velocity.z = math.sin(ahor) * (5 * 0.07)
      velocity.x = math.cos(ahor) * (5 * 0.07)
    end
    if controls.down then
      velocity.z = math.sin(ahor) * (-5 * 0.05)
      velocity.x = math.cos(ahor) * (-5 * 0.05)
    end
    if controls.jump then
      velocity.y = velocity.y +1
    end
    
    if controls.sneak and minetest.get_node(
    vector.new(position.x,position.y-1,position.z)
      ).name == "air" then
      position.y = position.y - 1
    end
    --self.object:rotate(vector.new(0,1,0))
    
    position = vector.add(position,velocity)
    self.object:set_rotation(vector.new(0,ahor,0))
    if minetest.get_node(position).name=="air" then
      self.object:set_pos(position)
    end
  elseif minetest.get_node(
    vector.new(position.x,position.y-1,position.z)
      ).name == "air" then
      position.y = position.y - 1
      self.object:set_pos(position)
  end
end
function skyboard_fpunch(self, puncher)
  minetest.add_item(self.object:get_pos(),skyboard:getname()..":item")
  self.object:remove()
end

skyboard:createentity("board","mesh.obj","texture.png",
  {-0.5, -0.25, -0.5, 0.5, 0.5, 0.5},
  skyboard_frclick,
  skyboard_fstep,
  skyboard_fpunch
)
