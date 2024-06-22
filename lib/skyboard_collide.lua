-- test node collide
local angleV = 20
function NotCollide_Hor(pos,rot,pcolbox)
  local rbool = false
  local ly = pos.y
  local vp = vector.new(
    pos.x+((pcolbox.x*0.85)*math.cos(rot)),
    ly,
    pos.z+((pcolbox.z*0.85)*math.sin(rot))
  )
  local vright = vector.new(
    pos.x+(pcolbox.x*math.cos(rot-math.rad(angleV))),
    ly,
    pos.z+(pcolbox.z*math.sin(rot-math.rad(angleV)))
  )
  local vleft = vector.new(
    pos.x+(pcolbox.x*math.cos(rot+math.rad(angleV))),
    ly,
    pos.z+(pcolbox.z*math.sin(rot+math.rad(angleV)))
  )
  if(minetest.get_node(vp).name=="air" and
  minetest.get_node(vleft).name=="air" and
  minetest.get_node(vright).name=="air")then
    rbool=true
  end
  return rbool
end

function NotCollide_Horx2(pos,rot,pcolbox)
	return NotCollide_Hor(pos,rot,pcolbox) and
	NotCollide_Hor(vector.new(pos.x,pos.y+1,pos.z),rot,pcolbox)
end

function NotCollide_Vert(pos,rot,height)
  local rbool=false
  local vup = vector.new(
    pos.x, 
    pos.y+height,
    pos.z 
  )
  if minetest.get_node(vup).name=="air" then
    rbool=true
  end
  return rbool
end

function NotCollide_VertUp(pos,rot,pcolbox)
  local rbool = false
  local vp = vector.new(
    pos.x+((pcolbox.x*0.85)*math.cos(rot)),
    pos.y+2,
    pos.z+((pcolbox.z*0.85)*math.sin(rot))
  )
  local vup = vector.new(
    pos.x, 
    pos.y+2,
    pos.z 
  )
  if(minetest.get_node(vp).name=="air" and
	minetest.get_node(vup).name=="air")then
    rbool=true
  end
  return rbool
end

function NotCollide_VertDown(pos,rot,pcolbox)
  local rbool = false
  local vp = vector.new(
    pos.x+((pcolbox.x)*math.cos(rot)),
    pos.y-1,
    pos.z+((pcolbox.z)*math.sin(rot))
  )
  local vdown = vector.new(
    pos.x,
    pos.y-1,
    pos.z
  )
  if minetest.get_node(vp).name=="air" and
    minetest.get_node(vdown).name=="air" then
    rbool=true
  end
  return rbool
end
