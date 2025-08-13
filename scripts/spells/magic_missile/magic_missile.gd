extends Spell


var has_exploded : bool = false



func _ready():
	position = Vector2(0,0)
	#position = caster.global_position
	print("you cast ", self.name, " !")
	#print("nnn   ", caster)
	#texture = load("res://art/Small-8-Direction-Characters_by_AxulArt/Small-8-Direction-Characters_by_AxulArt.png")
	#other_texture = $Sprite2D
	#hit_enemies = ["goblin", "goblin", "orc"]
	this_spell = SpellDatabase.magic_missile
	noise = this_spell.spell_noise
	speed = this_spell.spell_speed
	ray_cast = $RayCast2D
	#origin_position = caster.global_position
	base_damage = this_spell.spell_damage
	damage_type = this_spell.spell_damage_type
	amount_of_bullets = this_spell.spell_amount_of_bullets
	var spell_bullets = this_spell.spell_bullet # These might have tom be declared in SCD and set here. especially when create_bullet() gets to be a func
	var rate_of_fire = this_spell.spell_rate_of_fire
	if caster is Player:
		orb_cost = this_spell.spell_orb_cost
		var damage_multiplier = get_multiplier(orb_cost)  #caster.get_node("interface/Control/Kleurenbalkje/PanelContainer/HBoxContainer").get_color_bar("red").size_flags_stretch_ratio
		base_damage *= damage_multiplier
		kleurenbalkje_change = this_spell.spell_kleurenbalkje_change
		#target_position = get_global_mouse_position()

	#direction = origin_position.angle_to(get_global_mouse_position())
	#direction = get_local_mouse_position().angle()

	#max_range = min(origin_position.distance_to(target_position), this_spell.spell_range)
	self.look_at(target_position)
	#rotation += PI
	print("max_range: ", max_range, "   position   ", position, "   global_position   ", global_position, "   origin_pos:  ", origin_position, "   target_position   ", target_position, "   length:   ", self.position.distance_to(origin_position), "   parent   ", get_parent().name, "   caster   ", caster.name,  "   caster_pos   ", caster.position,  "   caster_glob_pos   ", caster.global_position )

	if caster is Player:
		if pay_mana(orb_cost):
			change_kleurenbalkje(["purple"])
		else:
			print("out of orbs miscast!")
			queue_free()
			return
	for bullet in amount_of_bullets:
		# this should get a function
		var current_bullet = spell_bullets.instantiate()
		current_bullet.caster = caster
		get_parent().add_child(current_bullet)
		current_bullet.position = caster.global_position
		
		
		await get_tree().create_timer(rate_of_fire).timeout
	queue_free()

#func _physics_process(delta: float,) -> void:
	##print("local ", get_local_mouse_position())
	#position = position.move_toward(target_position, speed * delta)
	##print("max_range: ", max_range, "   position   ", position, "   global_position   ", global_position, "   target_position   ", target_position, "   length:   ", self.position.distance_to(origin_position))
	##print(position, "   target_position   ", target_position)
	##print(position.length(), "   fff   ", self)
	#if self.position.distance_to(origin_position) >= max_range or position == target_position:
		#on_max_range()

#
#func on_max_range():
	#print("on_max_range")
	##explosion("small")
#
#
#func _on_body_entered(body: Node) -> void:
	#if body == caster:
		#return
	##if body is MoveableBlock:
		##body.move_speed = speed
	#print("big_explosion")
	##explosion()
