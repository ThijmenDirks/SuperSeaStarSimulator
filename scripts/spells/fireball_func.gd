extends Spell


@onready var small_explosion_area = $SmallExplosion

func get_damage_by_explosion(base_damage, distance_enemy_to_center, aoe_size):
	var distance_to_center_ratio : float =  (1 - float(distance_enemy_to_center/aoe_size)) # 1 op center, 0 op rand)
	print("HP   ", distance_to_center_ratio)
	return (2 ** distance_to_center_ratio) * base_damage


func deal_damage(a,b):
	pass
	#anti-eroor func!
	#don't leave it here!
	#^true!


func _ready():
	print("nnn   ", caster)
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
	speed = this_spell.spell_speed

	origin_position = caster.position
	#direction = origin_position.angle_to(get_global_mouse_position())
	#direction = get_local_mouse_position().angle()
	target_position = get_global_mouse_position()
	max_range = min(position.distance_to(target_position), this_spell.spell_range)
	self.look_at(target_position)
	rotation += PI
	print("max_range: ", max_range, "   position   ", position, "   global_position   ", global_position, "   target_position   ", target_position, "   length:   ", self.position.distance_to(origin_position))

	if caster:
		if pay_mana(["red"]):
			change_kleurenbalkje(["red"])
		else:
			print("gigantic miscast!")
			return


func _physics_process(delta: float,) -> void:
	#print("local ", get_local_mouse_position())
	position = position.move_toward(target_position, speed * delta)
	print("max_range: ", max_range, "   position   ", position, "   global_position   ", global_position, "   target_position   ", target_position, "   length:   ", self.position.distance_to(origin_position))
	print(position, "   target_position   ", target_position)
	print(position.length(), "   fff   ", self)
	if self.position.distance_to(origin_position) >= max_range or position == target_position:
		on_max_range()
	#if get_contact_count():
		#print("big_explosion n")
		#big_explosion()

func on_max_range():
	print("on_max_range")
	small_explosion()


func small_explosion():
	print("no big_explosion")
	var small_explosion_area = $SmallExplosion
	var hit_enemies = small_explosion_area.get_overlapping_bodies()
	for enemy in hit_enemies:
		if enemy is Enemy or enemy is Player:
			print("hit an enemy  ", enemy)
			enemy.take_damage(get_damage_by_explosion(base_damage, self.global_position.distance_to(enemy.global_position) , aoe_size), damage_type)
	await make_noise(noise)
	queue_free()


func big_explosion():
	var big_explosion_area = $BigExplosion
	var hit_enemies = big_explosion_area.get_overlapping_bodies()
	for enemy in hit_enemies:
		if enemy is Enemy or Player:
			print("hit an enemy  ", enemy)
			enemy.take_damage(get_damage_by_explosion(base_damage, self.global_position.distance_to(enemy.global_position) , aoe_size), damage_type)
	await make_noise(noise)
	queue_free()

func _on_body_entered(body: Node) -> void:
	print("big_explosion")
	big_explosion()


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
	if caster: # == player	#CharacterBody2D/interface/kleurenalbkje/PanelContainer/HBoxContainer/@Panel@2
		pay_mana(["red"])
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
