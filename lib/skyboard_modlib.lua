-- lib for help to create mod

function modlib_createmod()

local modlib = {
	mod_name=""
}

function modlib:setname(name)
	self.mod_name=name
	minetest.log("Start mod "..self:getname())
end

function modlib:getname()
	return self.mod_name
end

function modlib:lib(pname)
  return dofile(minetest.get_modpath(self:getname()).."/lib/"..self:getname().."_"..pname..".lua")
end

function modlib:createblock(pname,pdesc,ptiles,pgroups,psounds,pdrop)
  local ldrop = ""
  if pdrop then
    ldrop = self:getname()..":"..pdrop
  end
	minetest.register_node(self:getname()..":"..pname, 
	{
    description = pdesc,
    tiles = {self:getname().."_"..ptiles}, --{mod_name.."_block1.png"},
    groups = pgroups,
    sounds = psounds,
    drop = ldrop
	}
	)
end

-- group solidity
-- cracky -> stone
-- crumbly -> dirt
-- choppy -> wood
function modlib:getgroups(ptype,plevel)

	local t={}
	if(ptype=="stone")then
		t.cracky=plevel
	elseif(ptype=="dirt")then
		t.crumbly=plevel
	elseif(ptype=="wood")then
		t.choppy=plevel
	end
	return t
end

function modlib:createcraft(pnameout,precipe)
  minetest.register_craft({
      output = self:getname()..":"..pnameout,
      recipe = precipe
  })
end

function modlib:createcraftE(pnameout,precipe)
  minetest.register_craft({
      output = pnameout,
      recipe = precipe
  })
end

function modlib:createegg(pname,pdesc,pinv_img,pfunc)
  minetest.register_craftitem(modlib:getname()..":"..pname,
  {
    description = pdesc,
    inventory_image = modlib:getname().."_"..pinv_img,
    on_place = pfunc
  })
end

function modlib:createentity(pname,pmesh,ptexture,pcolbox,pfunc_rclick,pfunc_step,pfunc_punch)
  minetest.register_entity(modlib:getname()..":"..pname,
  {
    initial_properties = {
      visual = "mesh",
      mesh = modlib:getname().."_"..pmesh,
      textures = {modlib:getname().."_"..ptexture},
    }, 
    collide_with_objects = true,
    physical = true,
    collisionbox = pcolbox,
    selectionbox = {
      pcolbox[1],pcolbox[2],pcolbox[3],pcolbox[4],pcolbox[5],pcolbox[6],rotate = true},
    on_rightclick = pfunc_rclick,
    on_step = pfunc_step,
    on_punch = pfunc_punch
  })
end

return modlib
end