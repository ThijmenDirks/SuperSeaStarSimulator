extends Spell


var has_exploded : bool = false

@onready var beam = $Beam
@onready var life_time_timer = $LifeTimeTimer


func _ready():
	#life_time_timer.start()
	#print("heal test 0")
	print("you cast ", self.name, " !")
	print("nnn   ", caster)
	this_spell = SpellDatabase.disintegrate
	damage = this_spell.spell_damage
	damage_type = this_spell.spell_damage_type
	noise = this_spell.spell_noise
	texture = $Sprite2D # do i need these two ?
	ray_cast = $RayCast2D # do i need these two ?
	max_range = this_spell.spell_range
	life_time_timer.wait_time = this_spell.spell_lifetime
	life_time_timer.start()
	print("heal test 1")

	beam.base_grow_speed = this_spell.spell_base_grow_speed
	beam.rotation_speed = this_spell.spell_rotation_speed

	if caster is Player:
		orb_cost = this_spell.spell_orb_cost
		var damage_multiplier = get_multiplier(orb_cost)
		damage = this_spell.spell_damage * damage_multiplier
		kleurenbalkje_change = this_spell.spell_kleurenbalkje_change
		#target_position = get_global_mouse_position() # when cast by an enemy, it will be simply set as : spell.position = (target_pos)
	print("heal test 2")

	#position = target_position

	#target = await get_body_at_position_with_area(position)
	print("heal test 3")

	#direction = origin_position.angle_to(get_global_mouse_position())
	#direction = get_local_mouse_position().angle()
	#max_range = min(position.distance_to(target_position), this_spell.spell_range)
	#self.look_at(target_position)
	#rotation += PI
	print("max_range: ", max_range, "   position   ", position, "   global_position   ", global_position, "   target_position   ", target_position, "   length:   ", self.position.distance_to(origin_position))
	print("heal test 4")

	if caster is Player: # this should be done in the above block, during making variables
		if pay_mana(orb_cost):
			change_kleurenbalkje(["green","blue"])
		else:
			print("out of orbs miscast!")
			queue_free()
			return
		print("heal test 5")
		#print("heal test position:   ", self.position, "   caster ", caster.position, "   distance:   ", position.distance_to(caster.position))
		#if position.distance_to(caster.position) > max_range: # right now enemies are immune for this. do i want to keep it this way ?
			#print("range miscast!")
			#queue_free()
			#return
	print("heal test 6")

	print("hhh  ", target)
	if target:
		target.take_damage(damage, damage_type)
	print("heal test 7")
	# maybe here the animantion ?
	#queue3_free()


#func _on_hit():
	#print("hit 1")

#func __on_hit():
	#print("hit 5")

func _physics_process(delta: float,) -> void:
	position = caster.position
	#pass
	#print("local ", get_local_mouse_position())
	#position = position.move_toward(target_position, speed * delta)
	##print("max_range: ", max_range, "   position   ", position, "   global_position   ", global_position, "   target_position   ", target_position, "   length:   ", self.position.distance_to(origin_position))
	##print(position, "   target_position   ", target_position)
	##print(position.length(), "   fff   ", self)
	#if self.position.distance_to(origin_position) >= max_range or position == target_position:
		#on_max_range()


func on_hit(body) -> void:
	print("hit 7   ", body)
	if body is Enemy or body is Player:
		body.take_damage(damage, damage_type)
		queue_free()


func _on_life_time_timer_timeout() -> void:
	queue_free()
