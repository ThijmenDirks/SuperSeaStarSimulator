class_name Player extends CharacterBody2D

@export var speed = 100
@export var animation_tree : AnimationTree
@export var max_hp = 250_00000
#@export var animation_player : AnimationPlayer

@onready var coyote_timer_to_cast_spell = $CTimerToCastSpell
@onready var coyote_timer_to_press_simoultaniously = $CTimerToPressSimoultaniously
@onready var hp_bar = $HPBar

var hp = max_hp
var game_over_screen = load("res://scenes/UI_and_the_like/game_over_screen.tscn").instantiate()
var spell_database = SpellDatabase
var input : Vector2
#var playback : AnimationNodeStateMachinePlayback
var keys_for_spellcasting = ["q", "e", "z", "x", "c","F","shift","control","left_mouse_click","right_mouse_click","shift_left_mouse_click","shift_right_mouse_click"]
var WASD = ["up","left","down","right"]
var current_spell_input = []
var input_pressed_almost_simoultaniously = ""
var equiped_spells = ["fireball", "heal", "chain_lightning", "disintegrate"]
var is_casting = false
var resistances_and_weaknesses : Dictionary


func _ready():
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	#playback = animation_tree["parameters/playback"]
	#get_viewport().size = DisplayServer.screen_get_size()


func _physics_process(delta: float) -> void:
	input = Input.get_vector("left", "right", "up", "down")
	velocity = input * speed# * delta
	#position += velocity
	move_and_slide()
	#select_animation()
	update_animation_parameters()
#	print("hi", check_if_input_is_in_list(keys_for_spellcasting))
	natius()
	#if input_is_in_list(keys_for_spellcasting):
		#spell_cast_funtion_one()
	#natius()
#	print("-")

## the below part can be deleted
	#for i in get_slide_collision_count():
		#var c = get_slide_collision(i)
		#var collider = c.get_collider()
		#if c.get_collider() is MoveableBlock:
			##print("is to the   ", c.get_position())
			#var my_pos = global_position
			#var other_pos = c.get_position()
			#var diff = my_pos - other_pos
#
			#if abs(diff.x) > abs(diff.y):
				#if diff.x > 0:
					#print("Character is to the RIGHT of the rigidbody")
					#collider.move(Vector2(-1, 0), speed)
				#else:
					#print("Character is to the LEFT of the rigidbody")
					#collider.move(Vector2(1, 0), speed)
			#else:
				#if diff.y > 0:
					#print("Character is BELOW the rigidbody")
					#collider.move(Vector2(0, -1), speed)
				#else:
					#print("Character is ABOVE the rigidbody")
					#collider.move(Vector2(0, 1), speed)
				#var push_force = 10
				#c.get_collider().apply_central_impulse(-c.get_normal() * push_foararce)


func update_animation_parameters():
	if input == Vector2.ZERO:
		return
	animation_tree["parameters/Idle/blend_position"] = input
	animation_tree["parameters/Walk/blend_position"] = input
	animation_tree["parameters/IdleCast/blend_position"] = input
	animation_tree["parameters/WalkCast/blend_position"] = input


func input_is_in_list(list):
	for key in list:
		if Input.is_action_just_pressed(key):
			return true
	return false

# credits
# was it natanius ?
func natius():
	var potential_approved_input = []
	var approved_input = ""
	for key in keys_for_spellcasting:
		if Input.is_action_just_pressed(key):
			approved_input += key
			#print(key)
			#print(approved_input)
		#potential_approved_input.append(Input.is_action_just_pressed(key))
	if approved_input:
#		coyote_timer_to_press_simoultaniously.stop()
		if coyote_timer_to_press_simoultaniously.is_stopped():
			coyote_timer_to_press_simoultaniously.start()
		input_pressed_almost_simoultaniously += approved_input
		#print(input_pressed_almost_simoultaniously)
#		if coyote_timer_to_cast_spell.is_stopped():
		coyote_timer_to_cast_spell.stop()
		coyote_timer_to_cast_spell.start()
	elif false:
		pass #miscast


func sort_almost_simoultanious_input(input: String,order: Array): #works
	var fixed_input = ""
	for i in order:
		if i in input:
			fixed_input += i
	#print("sort ",fixed_input)
	return fixed_input


func _on_ctimer_to_press_simoultaniously_timeout() -> void:
	#print("_on_ctimer_to_press_simoultaniously_timeout has stopped")
	input_pressed_almost_simoultaniously = sort_almost_simoultanious_input(input_pressed_almost_simoultaniously, keys_for_spellcasting)
#	print("sorted input", input_pressed_almost_simoultaniously)
	current_spell_input.append_array([input_pressed_almost_simoultaniously])
	#print("currentspelllinput",current_spell_input)
	input_pressed_almost_simoultaniously = ""
#	coyote_timer_to_cast_spell.start()


func _on_ctimer_to_cast_spell_timeout() -> void:
	var spell_has_been_cast = false
	for spell_that_is_about_to_be_cast in equiped_spells:
		#print(get_spell_by_name(spell_that_is_about_to_be_cast).spell_recipe)
		print(current_spell_input)
		var spell_that_will_be_cast = spell_database.get_spell_by_name(spell_that_is_about_to_be_cast)
		if spell_that_will_be_cast.spell_recipe == current_spell_input:
			print("succesfully cast spell! ", (current_spell_input))
			print("[[]]", spell_that_will_be_cast)#spell_that_will_be_cast)
			print(spell_that_will_be_cast["spell_function"])
			cast(spell_that_will_be_cast)
			#(spell_that_will_be_cast["functie"]).boom()
			#print("aaa", animation_tree.get("parameters/playback").get_current_node())
			if velocity == Vector2.ZERO:
				print("aaa")
				#playback.travel("IdleCast")
				#print("aaaa", animation_tree.get("parameters/playback").get_current_node())
			else:
				print("aaa")
				#playback.travel("WalkCast")
				#print("aaaa", animation_tree.get("parameters/playback").get_current_node())
				# ^ this part of code is quite old and most likely can bedeleted ( these 8 lines)
			print(spell_that_will_be_cast)
			spell_has_been_cast = true
			is_casting = true
			await get_tree().create_timer(0.3).timeout # for the animation # shouldnt this be before the actual casting?
			is_casting = false
	if not spell_has_been_cast:
		print("Nonexistent spell Miscast! ", (current_spell_input))
	current_spell_input = []
	spell_has_been_cast = false
	#casst spell


func cast(spell_that_is_being_cast):
	#var this_spell_function = spell_that_is_being_cast["spell_functie"].cast_this_spell
	var scene_of_spell_that_is_being_cast = spell_that_is_being_cast["spell_scene"].instantiate()
	scene_of_spell_that_is_being_cast.caster = self
	#print("schenetree", get_tree())

	scene_of_spell_that_is_being_cast.position = position
	#print("leng  ", global_position)
	#scene_of_spell_that_is_being_cast.global_position = global_position
	#scene_of_spell_that_is_being_cast.position = Vector2.ZERO

	self.get_parent().add_child(scene_of_spell_that_is_being_cast)
	#if spell_that_is_being_cast["spell_is_targetable"]:
		#move_toward(spell_that_is_being_cast.position, get_local_mouse_position(), spell_that_is_being_cast["spell_range"])
		#spell_that_is_being_cast.position = spell_that_is_being_cast.position.move_toward(get_local_mouse_position(), spell_that_is_being_cast["spell_range"])
	#scene_of_spell_that_is_being_cast.cast_this_spell(self) #
	#this_spell_function.call()
 #NIET ".BOOM()", MAAR BIJ ELKE CAST NIEUWE INSTANCE VAN FUNCTIE, ANDERS WORDT ER GEOVERWRITED BIJ SPAMMEN! + gebruik await in functie zodat de animatie niet direct weer wordt verwijderd


#func get_spell_by_name(name):
	#for i in spelldata.get_names():
		#if i == name:
			#return spelldata[i]


func update_hp_bar():
	hp_bar.value = hp


func take_healing(healing : int, healing_type : String):
	if healing_type in resistances_and_weaknesses: # should this be a thing ?
		healing *= resistances_and_weaknesses.damage_type
	hp += healing
	update_hp_bar()


func take_damage(damage : int, damage_type : String):
	if damage_type in resistances_and_weaknesses:
		damage *= resistances_and_weaknesses.damage_type
	hp -= damage
	update_hp_bar()
	print("player hp: ", hp)
	if hp <= 0:
		die()


func die():
	get_parent().add_child(game_over_screen)
	queue_free()
	get_tree().paused = true


func is_on_z_height(z : int, digit : int = 4):
	return int((self.z_index / 10 ** (digit - 1)) % 10) == int((z / 10 ** (digit - 1)) % 10)










#func cast_by_name(spell_name):
	#var spell_data = spells[spell_name]
	#if spell_data:
		#spell_data["script"].new().boom()
	#else:
		#print("Spell not found")


#func select_animation():
	#print("aa", animation_tree.get("parameters/playback").get_current_node(), animation_tree.get("parameters/playback").get_current_node())
	#if not (animation_tree.get("parameters/playback").get_current_node() == "IdleCast" or animation_tree.get("parameters/playback").get_current_node() == "WalkCast"):
		#print("raaa")
		#if velocity == Vector2.ZERO:
			#playback.travel("Idle")
		#else:
			#playback.travel("Walk")
	#else:
		#print("aaaa")
		#is_casting = false

#func spell_cast_funtion_one():
	#var action_buffer = ""
	#coyote_timer_to_press_simoultaniously.stop()
	#coyote_timer_to_press_simoultaniously.start()
	#for key in keys_for_spellcasting:
		#if Input.is_action_just_pressed(key):
			#action_buffer += key
##			print(key)
	#if coyote_timer_to_cast_spell.is_stopped():
		#coyote_timer_to_cast_spell.start()

#unc natius():
	#var potential_approved_input = []
	#var approved_input = []
	#var input_pressed_almost_simoultaniously = ""
	#for key in keys_for_spellcasting:
		#potential_approved_input.append(Input.is_action_just_pressed(key))
	#if true in potential_approved_input:
		#for i in potential_approved_input:
			#if i:
				#approved_input += keys_for_spellcasting[AAAAH]
			#print(potential_approved_input[i])
			#if potential_approved_input[i] == "true":
				#approved_input.append(keys_for_spellcasting[i])
				#print(input)
		#coyote_timerII.stop()
		#coyote_timerII.start()
		#input_pressed_almost_simoultaniously += null
	#elif false:
		#pass #miscast

#		print("HATSJOE")
#
#func check_if_input_is_in_list(list):
	#var stuff = false
	#for key in list:
		#print("hi", key)
		#if Input.is_action_just_pressed(key):
			#stuff = true
	#for key in list:
		#if not Input.is_action_pressed(key):
			#stuff = false
	#return(stuff)
#
#func _unhandled_key_input(event: InputEvent) -> void:
	#print(event)
	#if event is InputEventAction and event.is_pressed():
		#current_spell_input.append(event.action)
		#print(current_spell_input, "BOE")
#func _unhandled_key_input(event: InputEvent):
	#print(event)
	#if not input_is_in_list(WASD):
		#print("yay")
		#Input.get
##	if not input_is_in_list(["ui_up","a","s","d"]):
