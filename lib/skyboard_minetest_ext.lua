function mt_ifnodeair(px,py,pz)
  local v = vector.new(px,py,pz)
  local name = minetest.get_node(v).name
  return  name == "air" 
end

function mt_itemexist(sitem)
  if minetest.registered_items[sitem] then 
    return true 
  end
  return false
end
