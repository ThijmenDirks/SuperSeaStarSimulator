class_name Enemy

extends  CharacterBody2D

@onready var ray_cast = $RayCast2D
@onready var vision_field = $VisionField
var speed : int
var jump_hight : int
var direction : Vector2 #float # wil dit liever in rad of degree hebben # bij nader inzien: gewoon V2
#@onready var timer = $Timer
var max_HP = 100#: int# = 100
var HP = 100#: int
var resistances_and_weaknesses : Dictionary
var threat_range : int
var vision_range : int
var loot_table : Dictionary
var state = IDLE
var angry = false
var is_casting = null
var jump_distance : int
var hoever_deze_jump_al_was = 0
var s_and_x = 0
var last_delta : float
var hoeveelheid_waarmee_hij_nu_veranderd = 0
#var jump_duration = 10
var jump_height = 20
var jump_timer = 0.0
var ground_position : Vector2
var destination : Vector2
var z_for_jumping = 0.0
var jump_time = 2.0
var sprite : Sprite2D
var rng = RandomNumberGenerator.new()
var look_for_player_area : Area2D
var spell_heard

enum {
	IDLE,
	WALK,
	ATTACK,
	CAST,
	SLIME_IDLE,
	JUMP_ATTACK,
	JUMP,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(0)
	#timer.start(2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if (randi_range(0, 1) == 1 or true) and false:
		#on_noise_heard()
	#^ these two lines are for testing, should be delted ^
	if HP != 0:
		print("HP", HP)
	##change_state()
	match(state):
		#IDLE:
			#idle()
		WALK:
			walk()
		#JUMP_ATTACK:
			#jump(delta)
		#ATTACK:
			#attack()
# ^ dit is zo onnodig ingewikkeld...
# bij nader inzien toch niet want walk..


## word vanaf nu in elke enemy gedaan? want: ze hebben elk eigen dingen nodig om state te veranderen (en ze hebben allemaal anderes taes (?)()
#func change_state():
	#if state == IDLE:
		#state = WALK
		#walk()
	#elif state == WALK:
		#state = IDLE
		#idle
	#print("goblin awa goblin")


func idle():
	velocity = Vector2.ZERO
	print("goblinidle ", velocity)


func walk():
	if velocity == Vector2.ZERO:
		velocity = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * speed # dit moet natuurlijk eigenlijk in chage_state
	move_and_slide()
	print("goblinwalk ", velocity, speed)


func attack():
	pass


func take_damage(damage : int, damage_type : String):
	if damage_type in resistances_and_weaknesses:
		damage *= resistances_and_weaknesses.damage_type
	HP -= damage
	if HP < 0:
		die()


func die():
	#drop_loot()
	self.queue_free()


func drop_loot():
	var loot_possible : Array
	var loot_drop_rate : Array
	for loot in loot_table:
		loot_possible.append(loot)
		loot_drop_rate.append(loot_table[loot])
	return loot_possible[rng.rand_weighted(loot_drop_rate)]

 #my_array[rng.rand_weighted(weights)]


 #hierzo was ik bezig
 #25-05-25
func on_noise_heard(noise_source):
	if not look_for_player():
		if not look_for_sound_source(noise_source):
			pass
			#way_find()
	#ray_cast.target_position
	for i in 1000:
		ray_cast.force_raycast_update()
	#if add_child(RayCast2D.new()).get_collider():
	if ray_cast.get_collider() is PLayer:# or ray_cast.is_colliding():
		print("ddd", ray_cast.get_collider())
		pass
	#if ray_to_player() == player: # and thus not something like a wall:
		#move_to_player()
	#if ray_to_sound() == sound: # and thus not something like a wall:
		#move_to_sound()
	#pass


#func ray_to_player():
	#if ray_to_player.succeeds():
		#move_to_sound()
		#return true
	#else:
		#return false
#
#func ray_to_sound():
	#if ray_to_sound.succeeds():
		#attack_player()
		#return true
	#else:
		#return false

#anti-error placeholder, altough it might get to be used.
func attack_player():
	pass


func rotate_vision_field():
	print("velocity.angle()", velocity.angle())
	vision_field.rotation = velocity.angle()


# no works...
func look_for_player():
	print("eee")
	#var old_rotation = vision_field.rotation
	#var look_for_player_area = Area2D.new()
	for body in look_for_player_area.get_overlapping_bodies():
		if body is PLayer:
			ray_cast.target_position = to_local(body.position)
			ray_cast.force_raycast_update()
			if ray_cast.get_collider() is PLayer:
				#some_func() , like attacking the player,different for each enemy
				print(self, " dddd ", "player detected! ", randf_range(-1.0, 1.0))
				var label = Label.new()
				self.add_child(label)
				label.set_text("i see you")
				label.position = Vector2(randi_range(-50, 50), randi_range(-50, 50))
				#vision_field.rotation = old_rotation
				return true
	var label = Label.new()
	self.add_child(label)
	label.set_text("mustvbeen a wall")
	label.position = Vector2(randi_range(-50, 50), randi_range(-50, 50))
	return false





func look_for_sound_source(noise_source):
	ray_cast.target_position = to_local(noise_source.position)
	ray_cast.force_raycast_update()
	if ray_cast.get_collider() is Spell:
		#some_func() , like attacking the player,different for each enemy
		print("dddd ", "spell detected! ", randf_range(-1.0, 1.0))
		#print(self, " dddd ", "player detected! ", randf_range(-1.0, 1.0))
		var label = Label.new()
		self.add_child(label)
		label.set_text("i hear you")
		label.position = Vector2(randi_range(-50, 50), randi_range(-50, 50))
		return true
	var label = Label.new()
	self.add_child(label)
	label.set_text("no idea")
	label.position = Vector2(randi_range(-50, 50), randi_range(-50, 50))
	return false


func singal_test(argumeng):
	print("kukiric", randf_range(-1.0, 1.0))


	#for i in 36:
		#vision_field.rotation_degrees += 10
		#var seen_bodies = vision_field.get_overlapping_bodies()
		#for body in seen_bodies:
			#if body is PLayer:
				#ray_cast.target_position = to_local(body.position)
				#ray_cast.force_raycast_update()
				#if ray_cast.get_collider() is PLayer:
					##some_func() , like attacking the player,different for each enemy
					#print("dddd ", "player detected! ", randf_range(-1.0, 1.0))
					#var label = Label.new()
					#self.add_child(label)
					#label.set_text("i see you")
					#label.position = Vector2(randi_range(-50, 50), randi_range(-50, 50))
					#vision_field.rotation = old_rotation
					#return true
	#return false

#----- D4NGER! ----- D4NGER! ----- D4NGER! ----- D4NGER! ----- D4NGER! ----- D4NGER! ----- D4NGER! ----- D4NGER! ----- D4NGER!

# HIERONDER VOLT JUMP!

func jump(delta):
	#velocity = direction * speed
	#print("slime_jump ", velocity, speed)
	move_and_slide()
	#print("slime_jump ", position, "  ", velocity, speed)
	# move a bit while doing jumo animation
	# dont bother keeping track of time
##---
#func walk():
	#if velocity == Vector2.ZERO:
		#velocity = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * speed # dit moet natuurlijk eigenlijk in chage_state
	#move_and_slide()
	#print("goblinwalk ", velocity, speed)
##---
		#timer.start(jump_duration)
		#var direction_angle = randf_range(0.0, TAU) # TAU = 2 * PI
		#direction = Vector2(cos(direction_angle), sin(direction_angle)).normalized()
		##velocity = direction * speed
		#velocity = Vector2(cos(direction_angle), sin(direction_angle)) * speed
		#velocity = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * speed
##---

#func jump(delta):
	## 1. Verplaatsing over de grond
	#var move_delta = direction.normalized() * speed * delta
	#ground_position += move_delta
#
	## 2. Update springtijd
	#jump_timer += delta
	#var jump_progress = clamp(jump_timer / jump_duration, 0.0, 1.0)
#
	## 3. Bereken spronghoogte met sinuscurve (0→PI → op/neer)
	#var z_offset = -sin(jump_progress * PI) * jump_height
#
	## 4. Top-down offset (projectie van sprong richting op y)
	#var direction_angle = direction.angle()
	#var topdown_angle_factor = sin(direction_angle)
	#var visual_y_offset = z_offset * topdown_angle_factor
#
	## 5. Combineer grondpositie en visuele hoogte
	#position.x = ground_position.x
	#position.y = ground_position.y + visual_y_offset

# s = v * t
# met
# t = delta
# s = x
# v = speed
# posietie op l = -(x-1)**2 + 1
# if s == 1: is_jumping = false

# y = l + m * sin(dircetion.angle())

# of

# x(t) = t
# y(t) = -t ** 2 + 2t

# y(t) = sin(t)
# t = delta

# position.x gaat *cos(direction)

# zorg dat er ook een las  _delta is
# er moet eigenlijk een "jump" eneen "jump_and_attack" zijn.
# bij "jump_and_attack" wordt gekeken of de player geraakt kan worden, bij "jump" niet
#func jump(delta):
	## er moet ook nog een jump_dtstance zijn
	#print(delta)
	#hoeveelheid_waarmee_hij_nu_veranderd += delta - hoever_deze_jump_al_was # bijna= t
	#position.x += hoeveelheid_waarmee_hij_nu_veranderd * cos(direction.angle()) * speed * 0.2# jump_height
	#position.y += (sin(hoever_deze_jump_al_was + delta * PI) - sin(hoever_deze_jump_al_was * PI))# vergeet ook niet het haakje sluiten hier links te verwijderen. # + 0.7 * delta * sin(direction.angle())) * 1
	#var direction_angle = direction.angle()
	#s_and_x += speed * delta * 0.05
	##position.x += s_and_x * 50 * cos(direction_angle)
	##position.y += -(cos((-(s_and_x - 1) ** 2 + 1) * jump_hight) + s_and_x * 0.7 * sin(direction_angle))
	##position += Vector2(10.1 * delta, 10.1 * (- delta ** 2 + 2 * delta))
	##position += Vector2(direction.x * speed * delta, -delta**2 + 2 * delta - 1 * cos(deg_to_rad(abs(deg_to_rad(direction.angle())))))
	#hoever_deze_jump_al_was += delta
	#if hoever_deze_jump_al_was >= 1:
		##jumping = false
		#state = IDLE
		#hoever_deze_jump_al_was = 0
		#hoeveelheid_waarmee_hij_nu_veranderd = 0
		#print("enemy_slime_jump_no_more")
	#print("enemy_slime_jump ", s_and_x, "   ", direction)
	#last_delta = delta

#func jump(delta):
	#print("slime_jump")
	#position += speed * direction * delta # dit werkt! (Denk/hoop ik)
	##position.x = move_toward(position.x, destination.x, delta)
	##position.y = move_toward(position.y, destination.y, delta)
	#z_for_jumping += sin(((hoever_deze_jump_al_was + delta)/jump_time) * PI) - sin((hoever_deze_jump_al_was/jump_time) * PI)
	#sprite.position.y = (z_for_jumping + (0.7 * position.y - z_for_jumping))/0.7
	#print("slime_jump_z = ", z_for_jumping, "   ", hoever_deze_jump_al_was/jump_time)
	##state = IDLE
	#hoever_deze_jump_al_was += delta
	#if hoever_deze_jump_al_was > jump_time:
		#print("slime_jump_stop")
		#state = IDLE
		#hoever_deze_jump_al_was = 0
