extends Enemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var animation_tree : AnimationTree
@export var spell_cooldown_time: int = 3 # i might want to do this in enemy_class_def

@onready var spell_ability_cooldown_timer = $SpellAbilityCooldownTimer

var spell_that_will_be_cast : String

func _ready() -> void:
	spell_ability_cooldown_timer.wait_time = spell_cooldown_time
	base_speed = 40 # 50
	speed = base_speed
	chase_end_distance = 100

	look_for_player_area = $LookForPlayerArea
	#timer.start(1)
	attack_damage = 50
	spells_known = ["heal", "fireball"]
	animation_tree = $AnimationTree

	state = STATES.IDLE_STAND
	idle_stand(randi_range(3, 3), "enter") # shuoldnt you just call change_state(IDLE_STAND) ?


func _physics_process(delta: float) -> void:
	print("goblin_state: ", state)
	update_animation_parameters()


func on_something_in_vision_field(bodies : Array):
	#print("get_bodies_in_vision_field   ", get_bodies_in_vision_field())
	var most_favourable_target # not self if possible
	#var player_is_in_vision_field
	for body in get_bodies_in_vision_field():
		if body is Enemy: # for some reason shaman onlyseas hiself # thats (most likely) becuase hes the first body in the returnded array # i think it says "sees" and not "heals"..
			#print(get_bodies_in_vision_field(), "on_something_in_vision_field 1.1  ", body.hp, body.max_hp)
			if body.hp < body.max_hp:
				if body != self:
					if ready_spell("heal", body):
						request_change_state(STATES.CAST)
						return
	if self.hp != max_hp:
		if ready_spell("heal", self):
			request_change_state(STATES.CAST)

				#most_favourable_target = body
				#print($HealAbilityCooldownTimer.is_stopped(), "   HealAbilityCooldownTimer   ", $HealAbilityCooldownTimer.time_left)
				#if spell_ability_cooldown_timer.is_stopped():
					#print("on_something_in_vision_field 2.1")
					#spell_target_position = body.global_position #+ Vector2(randi_range(-100, 100), randi_range(-100, 100))
					#spell_that_will_be_cast = "heal"
					#used_timer = spell_ability_cooldown_timer
		if most_favourable_target:
			print("zucht  ", most_favourable_target.name)
			if ready_spell("heal", most_favourable_target):
				request_change_state(STATES.CAST)
						#return
		#if body is Player:
			#player_is_in_vision_field = body
	
	#if player_is_in_vision_field:
		#print("timer has stopped?  ", spell_ability_cooldown_timer.is_stopped())
		#if spell_ability_cooldown_timer.is_stopped():
			#print("timer hass")
			##print("on_something_in_vision_field 2.1")
			#spell_target_position = player_is_in_vision_field.global_position #+ Vector2(randi_range(-100, 100), randi_range(-100, 100))
			#spell_that_will_be_cast = "fireball"
			#used_timer = spell_ability_cooldown_timer
			#request_change_state(STATES.CAST)
			#return
# ^ this block might have to come back
# the problemm with this blck is that, when te enemy is in sight, first there should be chase before casting.
# thus, casting_state should only be entered trhough chase_tate.
# that means there must come a func holding this stuff, called when about to enter cast_state.
# that doesnt fix healing allies, though.
# maybe the healing part can stay? which might result in shaman stopping the chase to heal allies.
# i think the best following steps for shamant to do would be:
# 1. look around for player. 2. walk/chase to where the healed ally stood. 3. once there, look around for player 4. if still no player, idle.
# so just like after casting offensive spell, but walk to ally instead of player.
# now just the self-healing aftermath
# get back to last_state ?


func ready_spell(spell = "fireball", target = null) -> bool:
	print("ready_spell test 0")
	#print("timer has stopped?  ", spell_ability_cooldown_timer.is_stopped())
	if spell_ability_cooldown_timer.is_stopped():
		print("ready_spell test 1")
		#print("timer starts now")
		#print("on_something_in_vision_field 2.1")
		if not target:
			target = look_for_player_in_vision_field()
		if target:
			print("ready_spell test 2")
			spell_target_position = target.global_position
			spell_that_will_be_cast = spell
			used_timer = spell_ability_cooldown_timer
			return true
	print("ready_spell test 3")
	return false


	#print("on_something_in_vision_field 1")
	#if enemy_in_vision_field:
		#print("on_something_in_vision_field 2")
		#for body in bodies:
			#print("on_something_in_vision_field 3")
			#if body is Enemy:
				#print("on_something_in_vision_field 4")
				#if body.hp < body.max_hp:
					#print($HealAbilityCooldownTimer.is_stopped(), "   HealAbilityCooldownTimer   ", $HealAbilityCooldownTimer.time_left)
					#if $HealAbilityCooldownTimer.is_stopped():
						#print("on_something_in_vision_field 5")
						#spell_target = body.global_position #+ Vector2(randi_range(-100, 100), randi_range(-100, 100))
						#spell_that_will_be_cast = "heal"
						#used_timer = $HealAbilityCooldownTimer
						#request_change_state(STATES.CAST)
						#return
	#elif player_in_vision_field:
		#chase_target = player_in_vision_field
		#request_change_state(STATES.CHASE)


func request_change_state(new_state):
	match new_state:
		STATES.CHASE:
			change_state(STATES.CHASE)
		STATES.PATHFIND:
			change_state(STATES.PATHFIND)
		STATES.IDLE_STAND:
			change_state(STATES.IDLE_STAND)
		STATES.IDLE_WALK:
			change_state(STATES.IDLE_WALK)
		STATES.ATTACK:
			if ready_spell():
				change_state(STATES.CAST) # gotcha !
		#STATES.CHASE:
			#pass
		STATES.CAST:
			#if ready_spell(): # cant be here becasse of parameters
			change_state(STATES.CAST)


func change_state(new_state):
	state_duration_timer.stop()
# right now im changing state here, but might do that in state funcionts self because of on_stae("exit"): state = state.last # i dont think so..
	if state_is_locked:
		return
	state_history.append(state)
	match new_state:
		STATES.IDLE_STAND:
			state = STATES.IDLE_STAND
			idle_stand(randi_range(3, 5), "enter")
		STATES.IDLE_WALK:
			state = STATES.IDLE_WALK
			idle_walk(0, randi_range(3, 5), "enter")
		STATES.CHASE:
			state = STATES.CHASE
			chase_state(0, "enter")
		STATES.PATHFIND:
			state = STATES.PATHFIND
			pathfind_state(0, "enter")
		#STATES.MELEE_ATTACK:
			#melee_attack_state(0, "enter")
			#state = STATES.MELEE_ATTACK
		STATES.CAST:
			state = STATES.CAST
			casting_state(spell_that_will_be_cast, spell_target_position, "enter")


func exit_last_state(last_state): # not in use yet
	state_duration_timer.stop()
# right now im changing state here, but might do that in state funcionts self because of on_stae("exit"): state = state.last # i dont think so..
	if state_is_locked:
		return
	state_history.append(state)
	match last_state:
		STATES.IDLE_STAND:
			state = STATES.IDLE_STAND
			idle_stand(0, "exit")
		STATES.IDLE_WALK:
			state = STATES.IDLE_WALK
			idle_walk(0, 0, "exit")
		STATES.CHASE:
			state = STATES.CHASE
			chase_state(0, "exit")
		STATES.PATHFIND:
			state = STATES.PATHFIND
			pathfind_state(0, "exit")
		#STATES.MELEE_ATTACK:
			#melee_attack_state(0, "exit")
			#state = STATES.MELEE_ATTACK
		STATES.CAST:
			state = STATES.CAST
			casting_state(spell_that_will_be_cast, spell_target_position, "exit")


	#if state == STATES.IDLE_STAND:
		#state = STATES.IDLE_WALK
		#idle_walk(0, "enter")
		#rotate_vision_field()
		#timer.start(3)
	#elif state == STATES.IDLE_WALK:
		#state = STATES.IDLE_STAND
		#idle_stand() # ?
		#timer.start(2)


func update_animation_parameters():
	if velocity == Vector2.ZERO:
		return
	animation_tree["parameters/Idle/blend_position"] = velocity
	animation_tree["parameters/Walk/blend_position"] = velocity
	animation_tree["parameters/IdleCast/blend_position"] = velocity
	animation_tree["parameters/WalkCast/blend_position"] = velocity


#func _on_timer_timeout() -> void:
	#match state:
		#STATES.IDLE_STAND:
			#change_state(STATES.IDLE_WALK)
		#STATES.IDLE_WALK:
			#change_state(STATES.IDLE_STAND)
	#timer.start(randi_range(1,5)) # dit moet eigenlijk in WALK, IDLE, ETC


#func _on_vision_field_body_entered(body: Node2D) -> void:
	#if body is Player:
		#if look_for_player_in_vision_field(body):
			#chase_target = body
			#change_state(STATES.CHASE)
# this does not work when the players is in visionfield but there is a wall between them,
# casuse when the wall is gone but the player didnt left the visionField, ithis wont trigger again.
