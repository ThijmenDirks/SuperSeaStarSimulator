#if event is InputEventMouseButton:
	#if event.button_index == MOUSE_BUTTON_WHEEL_UP:
		#print("wheel up")
	#elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		#print("wheel down")


class_name Player extends Entity

@export var speed = 100
@export var animation_tree : AnimationTree
@export var max_hp = 200_
#@export var animation_player : AnimationPlayer

@onready var coyote_timer_to_cast_spell = $CTimerToCastSpell
@onready var coyote_timer_to_press_simoultaniously = $CTimerToPressSimoultaniously
@onready var hp_stars = get_node("Interface/Control/HPStars")
#@onready var hp_bar = $HPBar

var hp = max_hp
var game_over_screen = load("res://scenes/UI_and_the_like/game_over_screen.tscn").instantiate()
var spell_database = SpellDatabase
var input : Vector2
#var playback : AnimationNodeStateMachinePlayback
#var keys_for_spellcasting = ["q", "w", "r", "z", "x", "c","f", "v", "shift","control","left_mouse_click","right_mouse_click","shift_left_mouse_click","shift_right_mouse_click"]
var keys_for_spellcasting = ["r"]
var ESDF = ["up","left","down","right"]
var current_spell_input = []
var input_pressed_almost_simoultaniously = ""
var equiped_spells = ["fireball", "heal", "chain_lightning", "disintegrate", "magic_missile", "teleport", "block_of_stone"]
var spell_slot_keys: Array = ["1", "2", "3" ,"4" ,"5", "6"]
var is_casting = false
#var resistances_and_weaknesses : Dictionary
#var last_z_height: int
#var current_z_height: int
var  spawn_point: Marker2D
var saved_area: Node2D

var selected_school = SPELL_SCHOOLS.FIRE
var selected_spell_slot: int = 0
#var selected_spell: int = 1 # var selected_spell: int = spellDatabse.fireball
var selected_spell = spell_database.fireball
var scroll_wheel_school_index: float = 0.4
var scroll_sensitivity: float = 1
	#if int(scroll_wheel_school_index) > SPELL_SCHOOLS.size():

enum SPELL_SCHOOLS {
	FIRE,
	BUFF,
	OTHER,
}


func _ready():
	if false:
		_init_spells()
	super()
	if get_parent() is Level:
		SaveSystem.load_data()
	else:
		hp = max_hp # right now i undo all the saved stuff

	#hp_bar.max_value = max_hp
	#hp_bar.value = hp
	#playback = animation_tree["parameters/playback"]
	#get_viewport().size = DisplayServer.screen_get_size()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var old_school = floor(scroll_wheel_school_index)
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			scroll_wheel_school_index += 0.2 * scroll_sensitivity
			print("wheel up to ", scroll_wheel_school_index)
			#if floor(scroll_wheel_school_index) > SPELL_SCHOOLS.size(): # this line and the line below, along with the other variatnt of this block within this func, should actulaay go in update_selected_school() # done !
				#scroll_wheel_school_index = 0.0
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			scroll_wheel_school_index -= 0.2 * scroll_sensitivity
			print("wheel down to ", scroll_wheel_school_index)
			#if floor(scroll_wheel_school_index) < 0:
				#scroll_wheel_school_index = SPELL_SCHOOLS.size()
		#print("wheel asdf", scroll_wheel_school_index)
		#print(floor(scroll_wheel_school_index), " wheel ", old_school)
		if floor(scroll_wheel_school_index) != old_school:
			update_selected_school()
		if Input.is_action_just_pressed("left_mouse_click"):
			print("cast")
			cast(selected_spell)
		#print(floor(scroll_wheel_school_index), " asdf ", floor(scroll_wheel_school_index))


func update_selected_school():
	if floor(scroll_wheel_school_index) > SPELL_SCHOOLS.size() - 1:
		scroll_wheel_school_index = 0.0
	#print("asdf ", floor(scroll_wheel_school_index))
	if floor(scroll_wheel_school_index) < 0:
		#print("asdf")
		scroll_wheel_school_index = SPELL_SCHOOLS.size() - 0.2
	#selected_school = SPELL_SCHOOLS.keys()[floor(scroll_wheel_school_index)]
	selected_school = int(floor(scroll_wheel_school_index)) % SPELL_SCHOOLS.size()
	update_selected_spell()
	print("wheel, school updated to ", SPELL_SCHOOLS.keys()[floor(scroll_wheel_school_index)], " on index ", scroll_wheel_school_index)
	visible = false
	await get_tree().create_timer(0.2).timeout
	visible = true

func _physics_process(delta: float) -> void:
	input = Input.get_vector("left", "right", "up", "down")
	velocity = input * speed# * delta
	#position += velocity
	move_and_slide()
	#select_animation()
	update_animation_parameters()
#	print("hi", check_if_input_is_in_list(keys_for_spellcasting))
	#natius()
	new_natius()
	update_hp_bar()
	#if input_is_in_list(keys_for_spellcasting):
		#spell_cast_funtion_one()
	#natius()
#	print("-")



func update_animation_parameters():
	if input == Vector2.ZERO:
		return
	animation_tree["parameters/Idle/blend_position"] = input
	animation_tree["parameters/Walk/blend_position"] = input
	animation_tree["parameters/IdleCast/blend_position"] = input
	animation_tree["parameters/WalkCast/blend_position"] = input

#-
var spell_slots: Dictionary = {
	SPELL_SCHOOLS.FIRE : [spell_database.fireball, spell_database.disintegrate],
	SPELL_SCHOOLS.BUFF : [spell_database.heal, spell_database.teleport, spell_database.block_of_stone],
	SPELL_SCHOOLS.OTHER : [spell_database.magic_missile],
}
#var learned_spells: Dictionary = {
	#SPELL_SCHOOLS.FIRE: [spell_database.fireball, spell_database.magic_missile]
#}
#
#var equipped_slots: Dictionary = {
	#SPELL_SCHOOLS.FIRE: [null, null, null], # 3 slots
	#SPELL_SCHOOLS.BUFF: [null, null],
#}
var learned_spells: Dictionary = {}
var equipped_slots: Dictionary = {}

#func _ready():
	#_init_spells()

func _init_spells():
	# Ensure all schools exist in dicts
	for school in SPELL_SCHOOLS.values():
		learned_spells[school] = []
		equipped_slots[school] = []

	# Loop over all spells in SpellDatabase
	for spell in SpellDatabase.all_spells:
		var school = spell["spell_school"]
		
		# Add to learned spells
		learned_spells[school].append(spell)

		# Expand equipped_slots until it can fit standard slot index
		var slot_index = spell["spell_slot"]
		while equipped_slots[school].size() <= slot_index:
			equipped_slots[school].append(null)
		
		# Place spell in its standard slot
		equipped_slots[school][slot_index] = spell
		for i in learned_spells:
			pass
			#print("learned_spells ", learned_spells[i])
			#print("")
		for i in equipped_slots:
			pass
			#print("equipped_slots ", equipped_slots[i])
			#print("")
		#print("learned_spells ", learned_spells, "equipped_slots ", equipped_slots)
		print(pretty_print_dict(spell_slots))


func pretty_print_dict(d: Dictionary) -> String:
	var result = "{ "
	for k in d.keys():
		result += str(k) + ": " + str(d[k]) + ", "
	result = result.trim_suffix(", ")
	return result + " }"

#print(pretty_print_dict(equipped_slots))

#-this blockis chatGPT and not ye used, though it has potential

func new_natius():
	for key in spell_slot_keys:
		if Input.is_action_just_pressed(key):
			selected_spell_slot = spell_slot_keys.find(key)
			print("selected_spell_slot: ", selected_spell_slot)
			update_selected_spell()
			#if spell_slots[SPELL_SCHOOLS[selected_school]]:
				#selected_spell = spell_slots[SPELL_SCHOOLS[selected_school]][selected_spell_slot]

func update_selected_spell():
	var spells = spell_slots.get(selected_school, [])
	if selected_spell_slot >= 0 and selected_spell_slot < spells.size():
		selected_spell = spells[selected_spell_slot]
	else:
		# fallback if index is invalid
		selected_spell = spell_database.fireball


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
		print("magic  ",spell_that_will_be_cast)
		print("magic")
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


func pay_mana(spell : Dictionary) -> bool:
	var orb_cost = spell.spell_orb_cost
	var used_mana_thingies: Array
	for child in get_node("Interface").get_mana_thingies():
		if child.my_color in orb_cost:
			used_mana_thingies.append(child)
	for mana_thingy in used_mana_thingies:
		if mana_thingy.filled_orbs < orb_cost.get(mana_thingy.my_color):
			return false
	for mana_thingy in used_mana_thingies:
		mana_thingy.filled_orbs -= orb_cost.get(mana_thingy.my_color)
	return true


func cast(spell):
	if is_casting:
		return
	if not pay_mana(spell): # WARNING pay_mana() also gets called in the spell itself. # fixed it! kinda dirty, but still
		print("out of orbs miscast !")
		return
	var spell_scene = spell.spell_scene.instantiate()
	spell_scene.caster = self
	spell_scene.position = position
	self.get_parent().add_child(spell_scene)
	is_casting = true
	await get_tree().create_timer(0.3).timeout # for the animation (and anti-spam) # shouldnt this be before the actual casting?
	is_casting = false
	# the selected spell is in the form of a dict in SpellDatabase.
	# first, there should be paid, so if the player cant pay, the spell doesnt spawn at all.
	# then the paying itself can be done. the colorbar should be postponed to after the spell is instanced, and thus done by the spell itself. (or should it?)

	#var this_spell_function = spell_that_is_being_cast["spell_functie"].cast_this_spell
	#print("schenetree", get_tree())

	#print("leng  ", global_position)
	#scene_of_spell_that_is_being_cast.global_position = global_position
	#scene_of_spell_that_is_being_cast.position = Vector2.ZERO

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


#func update_hp_bar():
	#var times: int = 0
	#var critical_star_reached: bool = false
	#for star in hp_stars.get_children():
		#times += 1
		##if critical_star_reached:
			##star.frame = 0
		#if times * 40 >= hp:
			#star.frame = 8
		#else:
			#critical_star_reached = true
			#star.frame = ceil(times * 40 - hp) / float(5)
		##star.frame = randi_range(0, 8)
			#print("player hp  ", star.frame)
#func update_hp_bar():
	#var star_index: int = 0
	#for star in hp_stars.get_children():
		#star_index += 1
		#var star_hp = clamp(hp - (star_index - 1) * 40, 0, 40)
		#var fill = int(round((star_hp / 40.0) * 8))
		#star.frame = fill
		#print("Star %s: hp=%s, frame=%s" % [star_index, star_hp, fill])
func update_hp_bar():
	var star_index: int = 0
	for star in hp_stars.get_children():
		star_index += 1
		# Bereken hoeveel "damage" in deze ster past
		var star_damage = clamp(max_hp - hp - (star_index - 1) * 40, 0, 40)
		
		# Bepaal vulgraad (0 = leeg, 8 = vol)
		var fill = int(round((star_damage / 40.0) * 8))
		star.frame = fill
		
		#print("Star %s: damage=%s, frame=%s" % [star_index, star_damage, fill])


func take_healing(healing : int, healing_type : String):
	if healing_type in resistances_and_weaknesses: # should this be a thing ?
		healing *= resistances_and_weaknesses.damage_type
	hp = max(hp + healing, max_hp)
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

#
#func is_on_z_height(z : int, digit : int = 4):
	#return int((self.z_index / 10 ** (digit - 1)) % 10) == int((z / 10 ** (digit - 1)) % 10)
#
#
#func is_on_same_z_height(target: Object) -> bool:
	#return int((self.z_index / 1000) % 10) == int((target.z_index / 1000) % 10)

#
#func on_z_changed():
	#set_collision_layer_value(20 + last_z_height, false)
	#set_collision_layer_value(20 + current_z_height, true)




func get_save_stats() -> Dictionary:
	print("data save test 1")
	return {
		"hp": hp,
		"spawn_point" : spawn_point,
		"saved_area": saved_area,
	}


func set_save_stats(stats: Dictionary) -> void:
	print("data load test 1")
	for key in stats:
		#if has_variable(key):
		self[key] = stats[key]
		print(key, "  key   ", self[key])
		print("data load test 2")


#func get_save_stats() -> Dictionary:
	#return {"hp": hp}
#
#
#func set_save_stats(stats: Dictionary) -> void:
	#for key in stats:
		##if has_variable(key):
			##self.set(key, stats[key]) # can both be used
		#self[key] = stats[key]
#







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

#func input_is_in_list(list):
	#for key in list:
		#if Input.is_action_just_pressed(key):
			#return true
	#return false
