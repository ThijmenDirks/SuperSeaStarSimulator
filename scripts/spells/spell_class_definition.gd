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

var orb_cost : int
var kleurenbalkje_change : int
var texture
var other_texture
var this_spell
var hit_enemies
var base_damage
var damage_type
var aoe_size

# ^ this is a mess right now, most/some of it is for debugging.

func _physics_process(delta: float,) -> void:
	print(position.length(), "   fff   ", self)
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


func change_kleurenbalkje(colors : Array):
	var color_bar = caster.get_node("interface/Control/Kleurenbalkje/PanelContainer/HBoxContainer")
	var used_color_bar = color_bar.get_color_bar("red")
	#print("kleurkleurkl ", caster.get_node("interface/Control/Kleurenbalkje/PanelContainer/HBoxContainer").get_color_bar("red").size_flags_stretch_ratio)
	if used_color_bar.size_flags_stretch_ratio == 1.0:
		used_color_bar.size_flags_stretch_ratio /= kleurenbalkje_change
		color_bar.keep_scales_fancy()
	else:
		used_color_bar.size_flags_stretch_ratio /= kleurenbalkje_change


func pay_mana(colors : Array):
	print("nnn   ", caster)
	for child in caster.get_node("interface").get_children():
		if child is ManaThingy:
			if child.my_color == "red":
				if orb_cost <= child.filled_orbs:
					child.filled_orbs -= orb_cost
					print("mana_thingy red FALSE ",child.filled_orbs)

				else:
					#print("gigantic miscast!") # wordt nu in fireball gedaan
					return false
	return true
# watch out! now, for spells with multiple colors, it canhappen you pay one color but miscast because of other color


func make_noise(noise):
	#is_making_noise = true
	var noise_area = Area2D.new() # gets automatically eleted when this function is done # or do they?
	var noise_area_collision = CollisionShape2D.new()
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
