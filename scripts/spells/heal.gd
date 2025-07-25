extends Spell


var has_exploded : bool = false


func _ready():
	print("you cast ", self.name, " !")
	print("nnn   ", caster)
	this_spell = SpellDatabase.heal
	var healing = this_spell.spell_healing
	var healing_type = this_spell.spell_healing_type
	noise = this_spell.spell_noise
	texture = $Sprite2D
	ray_cast = $RayCast2D
	max_range = this_spell.spell_range

	if caster is Player:
		orb_cost = this_spell.spell_orb_cost
		var healing_multiplier = get_multiplier(orb_cost)
		healing = this_spell.spell_healing * healing_multiplier
		kleurenbalkje_change = this_spell.spell_kleurenbalkje_change
		position = get_global_mouse_position() # when cast by an enemy, it will be simply set as : spell.position = (target_pos)

	target = await get_body_at_position_with_area(position)

	#direction = origin_position.angle_to(get_global_mouse_position())
	#direction = get_local_mouse_position().angle()
	#max_range = min(position.distance_to(target_position), this_spell.spell_range)
	#self.look_at(target_position)
	#rotation += PI
	print("max_range: ", max_range, "   position   ", position, "   global_position   ", global_position, "   target_position   ", target_position, "   length:   ", self.position.distance_to(origin_position))

	if caster is Player:
		if pay_mana(orb_cost):
			change_kleurenbalkje(["green","blue"])
		else:
			print("out of orbs miscast!")
			return

		if target_position.distance_to(to_local(caster.global_position)) > max_range: # right now enemies are immune for this. do i want to keep it this way ?
			print("range miscast!")
			return

	print("hhh  ", target)
	if target:
		target.take_healing(healing, healing_type)
	#queue_free()

func _physics_process(delta: float,) -> void:
	pass
	#print("local ", get_local_mouse_position())
	#position = position.move_toward(target_position, speed * delta)
	##print("max_range: ", max_range, "   position   ", position, "   global_position   ", global_position, "   target_position   ", target_position, "   length:   ", self.position.distance_to(origin_position))
	##print(position, "   target_position   ", target_position)
	##print(position.length(), "   fff   ", self)
	#if self.position.distance_to(origin_position) >= max_range or position == target_position:
		#on_max_range()
