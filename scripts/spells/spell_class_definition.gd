class_name Spell extends RigidBody2D

# VERY IMPORTANT CODE

#var spell_name : String
#var type = "defensive"
#
#var spell_recipe : Array
#var spell_type : String
#var target : String
#var spell_damage : int
#var spell_spell_damage_type : String
#var spell_func = null

#var noise_area : Area2D # probably not neccesary outside make_noise(noise)
#var noise_area_collision : CollisionShape2D

var spell_name : String
var damage_multiplier = 1
var noise_waiting = false # where wehn why is this used??
var is_making_noise = false
var noise : int
var max_range : int
var speed: int

var caster : Object
var origin_position: Vector2
var direction
var target_position : Vector2
var ray_cast : RayCast2D
var orb_cost : Dictionary
var target
#var base_damage : int
#var damage_type : String

var kleurenbalkje_change : int
var texture
var other_texture
var this_spell
var hit_enemies
var base_damage : int # these two should stay ! (most likely)
var damage_type : String # might get to be an array if multiple types
var aoe_size

# ^ this is a mess right now, most/some of it is for debugging.

func _physics_process(delta: float,) -> void:
	#print(position.length(), "   fff   ", self)
	if self.position.length() >= max_range:
		on_max_range()
	#print("spell_area ", is_making_noise)
	#if is_making_noise:
		##print("spell_area ", is_making_noise)
		#if randi_range(1, 2) == 1:
			#make_noise_part_two(noise)
		#


func transform_to_own_scene():
	pass


func spell_builtin_function_test(spell_name):
	print("cast ",)
	print(spell_name)
	#explode()


func explode():
	pass


func on_max_range():
	pass


func pay_mana(orb_cost : Dictionary):
	print("nnn   ", caster)
	var used_mana_thingies : Array
	for child in caster.get_node("interface").get_mana_thingies():
		if child.my_color in orb_cost:
			used_mana_thingies.append(child)
	for mana_thingy in used_mana_thingies:
		if mana_thingy.filled_orbs < orb_cost.get(mana_thingy.my_color):
			return false
	for mana_thingy in used_mana_thingies:
		mana_thingy.filled_orbs -= orb_cost.get(mana_thingy.my_color)
	return true


func change_kleurenbalkje(colors : Array):
	var color_bar = caster.get_node("interface/Control/Kleurenbalkje/PanelContainer/HBoxContainer")
	for color in colors:
		var used_color_bar = color_bar.get_color_bar(color)
		if used_color_bar.size_flags_stretch_ratio == 1.0:
			used_color_bar.size_flags_stretch_ratio /= kleurenbalkje_change
			color_bar.keep_scales_fancy()
		else:
			used_color_bar.size_flags_stretch_ratio /= kleurenbalkje_change


func get_multiplier(orb_cost):
	var color_bar = caster.get_node("interface/Control/Kleurenbalkje/PanelContainer/HBoxContainer")
	var total = 0
	var amount = 0
	for color in orb_cost:
		total += color_bar.get_color_bar(color).size_flags_stretch_ratio * orb_cost.get(color)
		amount += orb_cost.get(color)
	return total / amount


func make_noise(noise):
	#is_making_noise = true
	var noise_area = Area2D.new() # gets automatically eleted when this function is done # or do they?
	var noise_area_collision = CollisionShape2D.new()
	
	noise_area.visible = false # 19-07 for debuging,pleace delete !
	
	noise_area_collision.shape = CircleShape2D.new()
	#print("spell_area ", noise_area_collision.shape)
	noise_area_collision.shape.radius = noise
	noise_area.set_collision_mask_value(10, true)# = 10 # .bit(10,true)
	print("spell_area_layer ", noise_area.get_collision_mask_value(10))
	# DOE NOG IETS MET MASKS!!!
	noise_area.add_child(noise_area_collision)
	add_child(noise_area)
	#noise_area# = -0
	print("spell_area ", noise_area.get_overlapping_bodies())
	noise_waiting = true

	print("spell_area 0")
	await get_tree().physics_frame
	print("spell_area 1")
	await get_tree().physics_frame
	print("spell_area 2")

	var enemies : Array
	var temporary_counter = 0 # just for testing, should be deleted
	for enemy in noise_area.get_overlapping_bodies():
		if enemy is Enemy:
			enemies.append(enemy)
	print("enemies ", enemies.size(), "   ", enemies)

	for area in noise_area.get_overlapping_areas():
		for enemy in area.get_overlapping_bodies():
			if enemy in enemies:
				enemy.on_noise_heard(self)
				enemy.angry = true
				print("noisee", enemy, "   ")
				temporary_counter += 1
	print("noisee ", temporary_counter)
	temporary_counter = 0


func get_body_at_position_with_area(position: Vector2):# -> Node2D:
	var area = $Area2D
	await get_tree().physics_frame
	await get_tree().physics_frame
	var bodies = area.get_overlapping_bodies()
	print("hhh bodies: ", bodies)
	if bodies.size() > 0:
		if bodies.size() > 1:
			print("you might want to take a look at this. spell_class_definition -> get_body_at_position_with_area")
		return bodies[0]
	return null
