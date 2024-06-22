
# V3
## Add:
- 	skyboard_collide.lua (node collider lib)
- 	skyboard_minetest_ext.lua (extend minetest API)
-	upgrade node collider for entity
### groundboard
- 	collide up + test case up
- 	collide down + test case down
- 	small auto jump
- 	climb on wall
### skyboard
- 	small auto jump
- 	unlimited flight
-	fall when collide

## Delete:
-   move entity left,right (collider bug source)

# V2
## Add:
- 	skyboard_modlib.lua (mod creating lib)
-   Groundboard (entity/item)
-   craft groundboard -> iron ingot + copper ingot
-   basic collide system

## Edit:
-   craft skyboard -> 2x groundboard

-   no hard depends, can work with minetest/mineclone

## Delete:
-   block skyboard pack (craft/item/block) (to many bug)

# V1
## Add:
- 	skyboard entity
- 	skyboard item
- 	skyboard crafting : 2 steel ingot + copper ingot
- 	player attach/detach entity
- 	punch entity destroy it and give item
- 	entity fall when player detach
- 	entity move to player look
- 	depends : default

## Fix:
- 	use item consume item
