class_name Spell

extends Node2D

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

var spell_name
var damage_multiplier = 1
var noise_waiting = false # where wehn why is this used??
var is_making_noise = false
var noise : int

#func _physics_process(delta: float,) -> void:
	#print("spell_area ", is_making_noise)
	#if is_making_noise:
		##print("spell_area ", is_making_noise)
		#if randi_range(1, 2) == 1:
			#make_noise_part_two(noise)
		#


func spell_builtin_function_test(spell_name):
	print("cast ",)
	print(spell_name)
	#explode()

func explode():
	pass


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
	# overlap is calculated once a frame. so there isnt overlap here yet.
	# solution: call all the stuff below on the next frame.
	# or await get_tree().process_frame / await get_tree().physics_frame

	print("spell_area 0")
	await get_tree().physics_frame
	print("spell_area 1")
	await get_tree().physics_frame
	print("spell_area 2")

	#await get_tree().create_timer(0.0).timeout

	#await Engine.get_main_loop().process_frame
	#await Engine.get_main_loop().process_frame
	
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

	#print("spell_area spell_area", noise_area.get_overlapping_bodies())
	#for enemy in noise_area.get_overlapping_bodies():
		#if enemy is Enemy:
			#print("its an enemy")
	
	#!!! #noise_area.queue_free() !!!
	#noise_area.queue_free() # 15-07-25
	# did it.`

#func make_noise_part_two(noise):
	#is_making_noise = false
	#print("spell_area spell_area", noise_area.get_overlapping_bodies())
	#for enemy in noise_area.get_overlapping_bodies(): # overlap is calculated once a frame. so there isnt overlap here yet.
		#print("spell_area ", "spell_area")
		#print("spell_area ", noise_area.get_overlapping_bodies())
	#pass

# make area2D    ✔
# for enemy in in_area:
#    var placeholder_name : int
#    if enemy == Enemy:
#      draw_ray2D
#      for obstacle in whatever_ray_returns:
#        var placeholder_name -= obstacle.noise_isolation
#    if placeholder_name >= enemy.ears:
#      enemy.anger = true
# this_area.queue_free()
