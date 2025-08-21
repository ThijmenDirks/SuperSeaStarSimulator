extends Spell


var has_exploded : bool = false


func _ready():
	print("teleport test 0")
	print("you cast ", self.name, " !")
	print("nnn   ", caster)
	this_spell = SpellDatabase.teleport
	#var healing = this_spell.spell_healing
	#var healing_type = this_spell.spell_healing_type
	noise = this_spell.spell_noise
	texture = $Sprite2D
	ray_cast = $RayCast2D
	max_range = this_spell.spell_range
	print("teleport test 1")

	if caster is Player:
		orb_cost = this_spell.spell_orb_cost
		var healing_multiplier = get_multiplier(orb_cost)
		#healing = this_spell.spell_healing * healing_multiplier
		kleurenbalkje_change = this_spell.spell_kleurenbalkje_change
		target_position = get_global_mouse_position() # when cast by an enemy, it will be simply set as : spell.position = (target_pos)
	print("teleport test 2")

	position = target_position

	#var area = $Area2D
	var ray_cast = $RayCast2D # this one has already been made in spell_class_def, so actually not needed
	ray_cast.target_position = to_local(caster.global_position)
	ray_cast.force_raycast_update()
	#area.get_child(1).shape.radius = caster.get_node(CollisionShaoe2D).shpae.radius # wont wrk right now cause player has square collision
	#await get_tree().physics_frame
	#await get_tree().physics_frame
	#var bodies = area.get_overlapping_bodies()
	#print("hhh bodies: ", bodies)
	if ray_cast.get_collider() != null:
		queue_free()
		return


	target = await get_body_at_position_with_area(position)
	target = true
	print("teleport test 3")

	#direction = origin_position.angle_to(get_global_mouse_position())
	#direction = get_local_mouse_position().angle()
	#max_range = min(position.distance_to(target_position), this_spell.spell_range)
	#self.look_at(target_position)
	#rotation += PI
	print("max_range: ", max_range, "   position   ", position, "   global_position   ", global_position, "   target_position   ", target_position, "   length:   ", self.position.distance_to(origin_position))
	print("teleport test 4")

	if caster is Player: # this should be done in the above block, during making variables
		if pay_mana(orb_cost):
			change_kleurenbalkje(["green","blue"])
		else:
			print("out of orbs miscast!")
			queue_free()
			return
		print("teleport test 5")
		#print("teleport test position:   ", self.position, "   caster ", caster.position, "   distance:   ", position.distance_to(caster.position))
		if position.distance_to(caster.position) > max_range: # right now enemies are immune for this. do i want to keep it this way ?
			print("range miscast!")
			queue_free()
			return
	print("teleport test 6")

	print("hhh  ", target)
	if target:
		caster.global_position = global_position
		#target.take_healing(healing, healing_type)
	# once you hit, it wont queue_free ?
	print("teleport test 7")
	# maybe here the animantion ?
	queue_free()

func _physics_process(delta: float,) -> void:
	pass
	#print("local ", get_local_mouse_position())
	#position = position.move_toward(target_position, speed * delta)
	##print("max_range: ", max_range, "   position   ", position, "   global_position   ", global_position, "   target_position   ", target_position, "   length:   ", self.position.distance_to(origin_position))
	##print(position, "   target_position   ", target_position)
	##print(position.length(), "   fff   ", self)
	#if self.position.distance_to(origin_position) >= max_range or position == target_position:
		#on_max_range()
