extends Slime # please dont forget to fix raycast collision masks !!

@onready var blob_spawn_area_collision_circle = $BlobSpawnArea/CollisionShape2D.shape
@onready var min_range_blob_spawn_area_collision_circle = $MinRangeBlobSpawnArea/CollisionShape2D.shape
@onready var blob: PackedScene = load("res://scenes/enemies/slimes/blob.tscn")
@onready var slime: PackedScene = load("res://scenes/enemies/slimes/red_slime.tscn")

@export var max_slimes: int = 40

var active_slimes: int = 0

#const JUMP_VELOCITY = -400.0
var timer_is_already_running = true

var progression: float = 0.00 # up to 1.00

var is_beast_mode: bool = false

#var jump_duration = 1.0 # in sec

#@export var animation_tree : AnimationTree

#@onready var timer = $Timer

func _ready() -> void:
	bounty = 5000
	max_hp = 5000
	hp = max_hp#max_HP
	base_speed = 20 # 20
	speed = base_speed
	chase_end_distance = 250
	melee_range = 50
	attack_damage = 5

	hp_bar.max_value = max_hp
	hp_bar.value = hp


	jump_hight = 20
	state = STATES.IDLE_WALK
	idle_walk(0, jump_duration, "enter")
	look_for_player_area = $LookForPlayerArea
	#print("slime_", state)
	#timer.start(1)
	sprite = $Sprite2D
	loot_table = {
		"green_slimeball" = 50, # %
		"super_legendary_drop" = 0.001,
	}

	ability_cooldown_timer_1.start()

func _physics_process(delta: float) -> void:
	print("active slimes: ", active_slimes)
	progression = (max_hp-hp) / max_hp # this shouldbe in get_damage() and get_healing() ?
	#scale *= 1.1 # right here is the jumpscare line ! dont even think about delteing this line !
	#scale *= (1-progression)
	super(delta)


func request_change_state(new_state):
	match new_state:
		STATES.CHASE: # might want to make slimes unable to chase adn use jump_attack for it instaed
			if state != STATES.JUMP_ATTACK:
				change_state(STATES.CHASE)
		#STATES.PATHFIND:
			#change_state(STATES.PATHFIND)
		#STATES.IDLE_STAND:
			#change_state(STATES.IDLE_STAND)
		STATES.IDLE_WALK:
			change_state(STATES.IDLE_WALK)
		STATES.JUMP_ATTACK:
			change_state(STATES.CHASE)
		STATES.ATTACK:
			change_state(STATES.CHASE)


func change_state(new_state):
	state_duration_timer.stop()
# right now im changing state here, but might do that in state funcionts self because of on_stae("exit"): state = state.last # i dont think so..
	if state_is_locked:
		return
	state_history.append(state)
	match new_state:
		#STATES.IDLE_STAND:
			#state = STATES.IDLE_STAND
			#idle_stand(randi_range(3, 5), "enter")
		STATES.IDLE_WALK:
			state = STATES.IDLE_WALK
			idle_walk(0, jump_duration, "enter") # the time given here should be the same as N jumps in the animation
		STATES.CHASE:
			state = STATES.CHASE
			chase_state(0, "enter")
		#STATES.PATHFIND:
			#pathfind_state(0, "enter")
			#state = STATES.PATHFIND
		STATES.JUMP_ATTACK:
			state = STATES.JUMP_ATTACK
			jump_attack_state(0, jump_duration, "enter")


var damage_taken_total: int = 0
var damage_threshold_counter: int = 0


#func take_damage(damage: int, damage_type: String):
	#super(damage, damage_type)
	#scale .x = (1 - (max_hp-hp) / float(max_hp))
	#scale .y = (1 - (max_hp-hp) / float(max_hp))
	#if scale.x >= 0.2:
		#is_beast_mode = true
		#enter_beast_mode()
#
	#damage_taken_total += damage
#
	#var thresholds_crossed = damage_taken_total / 50
	#if thresholds_crossed > damage_threshold_counter:
	## Trigger once for each threshold crossed
		#for i in range(damage_threshold_counter, thresholds_crossed):
			#if active_slimes < max_slimes:
				#spawn_slime()
			##_on_damage_threshold_reached((i + 1) * 50)
	#damage_threshold_counter = thresholds_crossed

func take_damage(damage: int, damage_type: String):
	super(damage, damage_type)

	var scale_sensitivity := 0.5  # smaller = slower scale change
	var min_scale := 0.6          # higher = minimum visible size

	var damage_ratio := (max_hp - hp) / float(max_hp)
	var new_scale := 1.0 - (damage_ratio * scale_sensitivity)
	new_scale = clamp(new_scale, min_scale, 1.0)

	scale.x = new_scale
	scale.y = new_scale

	damage_taken_total += damage

	var thresholds_crossed = damage_taken_total / 50
	if thresholds_crossed > damage_threshold_counter:
		for i in range(damage_threshold_counter, thresholds_crossed):
			if active_slimes < max_slimes:
				spawn_slime()
	damage_threshold_counter = thresholds_crossed

func enter_beast_mode():
	print("king_slime entered beast mode !")

#func _on_damage_threshold_reached(total_damage: int) -> void:
	#print("Threshold reached at: %d damage taken" % total_damage)


func spawn_slime():
	var new_slime = slime.instantiate()
	var x_ofset = cos(randf() * TAU)
	var y_offset = cos(randf() * TAU)
	new_slime.position = global_position + Vector2(x_ofset, y_offset)
	new_slime.is_spawned_by_king_slime = true
	new_slime.king_slime = self
	active_slimes += 1
	# radius veranderd niet als lsime.scale veranderd, dus moet manual *scale
	get_parent().get_parent().get_parent().add_child(new_slime)


func _on_ability_cooldown_timer_1_timeout() -> void:
	blob_attack()


func blob_attack() -> void:
	for i in range(15):
		var blob_target_position = get_random_in_circle(16, blob_spawn_area_collision_circle)
		if blob_target_position:
			var new_blob = blob.instantiate()
			new_blob.position = blob_target_position
			if active_slimes >= max_slimes:
				new_blob.can_spawn_slimes = false
			else:
				new_blob.king_slime = self
			self.get_parent().get_parent().get_parent().add_child(new_blob)
			await get_tree().create_timer(0.01).timeout


func get_random_in_circle(tries: int, shape: Resource):
	for try in range(tries):
		#var min_r = min_range_blob_spawn_area_collision_circle.radius
		#var max_r = blob_spawn_area_collision_circle.radius
		#var r = sqrt(randf_range((min_r / max_r) ** 2, 1.0)) * max_r
		var r = sqrt(randf() * (blob_spawn_area_collision_circle.radius * blob_spawn_area_collision_circle.radius - min_range_blob_spawn_area_collision_circle.radius * min_range_blob_spawn_area_collision_circle.radius) + min_range_blob_spawn_area_collision_circle.radius * min_range_blob_spawn_area_collision_circle.radius)
		#var r = shape.radius * sqrt(randf_range(min_range_blob_spawn_area_collision_circle.radius / blob_spawn_area_collision_circle.radius, 1.0))  # sqrt to ensure uniform distribution
		var angle = randf() * TAU
		return (Vector2(cos(angle), sin(angle)) * r) + global_position



# shouldnt this be in Enemy?
#func _physics_process(delta: float) -> void:
	##super(delta)
	#print("HP ", hp)
	#update_animation_parameters()
	#if state == STATES.JUMP:
		#jump(delta)
	#if state == STATES.IDLE_STAND:
		#if not timer_is_already_running:
			##timer.start(1)
			#pass
