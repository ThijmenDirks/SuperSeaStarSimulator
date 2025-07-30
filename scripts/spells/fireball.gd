extends Spell


var has_exploded : bool = false


func get_damage_by_explosion(base_damage, distance_enemy_to_center, aoe_size):
	var distance_to_center_ratio : float =  (1 - float(float(distance_enemy_to_center)/float(aoe_size))) # 1 op center, 0 op rand)
	print("HP   ", distance_to_center_ratio)
	return int((2 ** distance_to_center_ratio) * float(base_damage))
	#return 100

func deal_damage(a,b):
	pass
	#anti-eroor func!
	#don't leave it here!
	#^true!


func _ready():
	print("you cast ", self.name, " !")
	#print("nnn   ", caster)
	#texture = load("res://art/Small-8-Direction-Characters_by_AxulArt/Small-8-Direction-Characters_by_AxulArt.png")
	#other_texture = $Sprite2D
	#hit_enemies = ["goblin", "goblin", "orc"]
	this_spell = SpellDatabase.fireball
	aoe_size = this_spell.spell_aoe_size
	noise = this_spell.spell_noise
	speed = this_spell.spell_speed
	ray_cast = $RayCast2D
	origin_position = caster.position
	base_damage = this_spell.spell_damage
	damage_type = this_spell.spell_damage_type
	print("damage_type ", damage_type)
	if caster is Player:
		orb_cost = this_spell.spell_orb_cost
		var damage_multiplier = get_multiplier(orb_cost)  #caster.get_node("interface/Control/Kleurenbalkje/PanelContainer/HBoxContainer").get_color_bar("red").size_flags_stretch_ratio
		base_damage *= damage_multiplier
		kleurenbalkje_change = this_spell.spell_kleurenbalkje_change
		target_position = get_global_mouse_position()

	#direction = origin_position.angle_to(get_global_mouse_position())
	#direction = get_local_mouse_position().angle()

	max_range = min(position.distance_to(target_position), this_spell.spell_range)
	self.look_at(target_position)
	rotation += PI
	print("max_range: ", max_range, "   position   ", position, "   global_position   ", global_position, "   target_position   ", target_position, "   length:   ", self.position.distance_to(origin_position))

	if caster is Player:
		if pay_mana(orb_cost):
			change_kleurenbalkje(["red"])
		else:
			print("gigantic miscast!")
			return


func _physics_process(delta: float,) -> void:
	#print("local ", get_local_mouse_position())
	position = position.move_toward(target_position, speed * delta)
	#print("max_range: ", max_range, "   position   ", position, "   global_position   ", global_position, "   target_position   ", target_position, "   length:   ", self.position.distance_to(origin_position))
	#print(position, "   target_position   ", target_position)
	#print(position.length(), "   fff   ", self)
	if self.position.distance_to(origin_position) >= max_range or position == target_position:
		on_max_range()



func on_max_range():
	print("on_max_range")
	explosion("small")


func _on_body_entered(body: Node) -> void:
	if body == caster:
		return
	print("big_explosion")
	explosion()


# porbalbly this should go to spell_class_definition
func explosion(size : String = "big"):
	print("damage                      ", damage_type)
	if has_exploded:
		return
	has_exploded = true
	var explosion_area
	if size == "big":
		explosion_area = $BigExplosion
	else:
		explosion_area = $SmallExplosion
	var hit_targets = explosion_area.get_overlapping_bodies()
	for target in hit_targets:
		if target is Enemy or target is Player:
			#var ray_cast = RayCast2D.new() # uiteindeijk wil ik wel weer gewoon terug naar een raycast hergebruiken
			ray_cast.set_collision_mask_value(1, false)
			ray_cast.set_collision_mask_value(2, true)
			#add_child(ray_cast)
			ray_cast.target_position = to_local(target.global_position)
			#ray_cast.rotation -= rotation + PI
			ray_cast.force_raycast_update()
			print("coll   ", ray_cast.get_collider(), rotation_degrees)
			if not ray_cast.is_colliding():
				print("hit an enemy  ", target, "   damage:   ", get_damage_by_explosion(base_damage, self.global_position.distance_to(target.global_position) , aoe_size), damage_type)
				target.take_damage(get_damage_by_explosion(base_damage, self.global_position.distance_to(target.global_position) , aoe_size), damage_type)
	await make_noise(noise)
	queue_free()


func small_explosion():
	print("no big_explosion")
	var small_explosion_area = $SmallExplosion
	var hit_enemies = small_explosion_area.get_overlapping_bodies()
	for enemy in hit_enemies:
		if enemy is Enemy or enemy is Player:
			var ray_cast = RayCast2D.new() # uiteindeijk wil ik wel weer gewoon terug naar een raycast hergebruiken
			ray_cast.set_collision_mask_value(1, false)
			ray_cast.set_collision_mask_value(2, true)
			add_child(ray_cast)
			ray_cast.target_position = to_local(enemy.global_position)
			#ray_cast.rotation -= rotation + PI
			ray_cast.force_raycast_update()
			print("coll   ", ray_cast.get_collider(), rotation_degrees)
			if not ray_cast.is_colliding():
				print("hit an enemy  ", enemy)
				enemy.take_damage(get_damage_by_explosion(base_damage, self.global_position.distance_to(enemy.global_position) , aoe_size), damage_type)
	await make_noise(noise)
	#await get_tree().create_timer(1).timeout
	queue_free()


func big_explosion():
	var big_explosion_area = $BigExplosion
	var hit_enemies = big_explosion_area.get_overlapping_bodies()
	print("coll   ", hit_enemies)
	for enemy in hit_enemies:
		if enemy is Enemy or enemy is Player:
			var ray_cast = RayCast2D.new()
			ray_cast.set_collision_mask_value(1, false)
			ray_cast.set_collision_mask_value(2, true)
			add_child(ray_cast)
			ray_cast.target_position = to_local(enemy.global_position)
			#ray_cast.rotation -= rotation + PI
			ray_cast.force_raycast_update()
			print("collider   ", ray_cast.get_collider())
			if not ray_cast.is_colliding():
				print("hit an enemy  ", enemy)
				enemy.take_damage(get_damage_by_explosion(base_damage, self.global_position.distance_to(enemy.global_position) , aoe_size), damage_type)
	await make_noise(noise)
	#await get_tree().create_timer(1).timeout
	queue_free()


func cast_this_spell(caster):
	#source = caster
	texture = load("res://art/Small-8-Direction-Characters_by_AxulArt/Small-8-Direction-Characters_by_AxulArt.png")
	other_texture = $Sprite2D
	this_spell = SpellDatabase.fireball
	hit_enemies = ["goblin", "goblin", "orc"]
	damage_multiplier = caster.get_node("interface/Control/Kleurenbalkje/PanelContainer/HBoxContainer").get_color_bar("red").size_flags_stretch_ratio
	base_damage = this_spell.spell_damage * damage_multiplier
	damage_type = this_spell.spell_damage_type
	aoe_size = this_spell.spell_aoe_size
	noise = this_spell.spell_noise
	kleurenbalkje_change = this_spell.spell_kleurenbalkje_change
	orb_cost = this_spell.spell_orb_cost
	
	#self.position = caster.position # JUST FOR DEBUGING  PURPOSES! REMOVE ASAP !
#------- hierzo kijken of je kan betalen
	#if caster: # == player	#CharacterBody2D/interface/kleurenalbkje/PanelContainer/HBoxContainer/@Panel@2
		#pay_mana(["red"])
#-------
	print("boom")
	print(this_spell)
	print(this_spell.spell_type)
	print(self)
	spell_builtin_function_test(this_spell.spell_name)
#_get enemies hit:------------------------------
	var damage_area = Area2D.new() # gets automatically deleted when this function is done # ?
	var damage_area_collision = CollisionShape2D.new()
	damage_area_collision.shape = CircleShape2D.new()
	damage_area_collision.shape.radius = aoe_size
	damage_area.set_collision_mask_value(5, true)
	damage_area.add_child(damage_area_collision)
	add_child(damage_area)
	await get_tree().physics_frame
	await get_tree().physics_frame
	print("damage_area", damage_area.get_overlapping_bodies())
	for enemy in damage_area.get_overlapping_bodies():
		if enemy is Enemy:
			print("hit an enemy")
			enemy.take_damage(get_damage_by_explosion(base_damage, self.global_position.distance_to(enemy.global_position) , aoe_size), damage_type)
	damage_area.queue_free()
#-------------------------------------
	for enemy in hit_enemies:
#-
		var distance_enemy_to_center = 30
		var current_enemy_damage = get_damage_by_explosion(base_damage, distance_enemy_to_center, aoe_size)
		deal_damage(enemy, current_enemy_damage)
		print(enemy)
#----- en hiezro kleurenbalkje aanpassen
	if caster: # == player	#CharacterBody2D/interface/kleurenalbkje/PanelContainer/HBoxContainer/@Panel@2
		print("color_bar debug   ", caster)
		change_kleurenbalkje(["red"])
		#print("kleurkleurkl ", caster.get_node("interface/Control/Kleurenbalkje/PanelContainer/HBoxContainer").get_color_bar("red").size_flags_stretch_ratio)
		#if caster.get_node("interface/Control/Kleurenbalkje/PanelContainer/HBoxContainer").get_color_bar("red").size_flags_stretch_ratio == 1.0:
			#caster.get_node("interface/Control/Kleurenbalkje/PanelContainer/HBoxContainer").get_color_bar("red").size_flags_stretch_ratio /= kleurenbalkje_change
			#caster.get_node("interface/Control/Kleurenbalkje/PanelContainer/HBoxContainer").keep_scales_fancy()
		#else:
			#caster.get_node("interface/Control/Kleurenbalkje/PanelContainer/HBoxContainer").get_color_bar("red").size_flags_stretch_ratio /= kleurenbalkje_change
#----
	print("PATH ",self.position)
	await make_noise(noise)
	#await animation
	#self.queue_free() # MOET WEL WEER TERUG!
	#print_tree_pretty()
