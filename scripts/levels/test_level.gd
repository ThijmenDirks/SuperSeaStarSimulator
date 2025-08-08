extends Level


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_areas = [$SpawnAreas/SpawnArea1, $SpawnAreas/SpawnArea2, $SpawnAreas/SpawnArea3]
	print("all_waves", all_waves)

#func _physics_process(delta: float) -> void:
	#spawn_next_wave()

func _unhandled_input(_event):
	if Input.is_action_just_pressed("z"):
		spawn_next_wave()

		#"goblins" = 3,
		#"time" = 10,


# WIL ik, voor elke wave een nieuwe var, of alles in een grote dict?

#var spawn_area_one: Area2D
#var spawn_area_two: Area2D
#var spawn_area_three: Area2D


#var wave_one = {
	#subwave_one = 
	#{
		#subwave_one = 
		#{
		#"goblin" = 3,
		#"time" = 10,
		#},
		#subwave_two = 
		#{
		#"goblin" = 5,
		#"time" = 15,
		#},
		#
	#},
	#subwave_two = 
	#{
		#
	#},
	#subwave_three = 
	#{
		#
	#}
#}
#
#var wave_two = {
	#spawn_area_one = 
	#{
		#subwave_one = 
		#{
		#"goblin" = 3,
		#"time" = 10,
		#},
		#subwave_two = 
		#{
		#"goblin" = 5,
		#"time" = 15,
		#},
		#
	#},
	#spawn_area_two = 
	#{
		#
	#},
	#spawn_area_three = 
	#{
		#
	#}
#}
