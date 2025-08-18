class_name Subwaves
extends Resource

@export_enum("goblin", "shaman", "ogre", "blue_slime", "green_slime", "red_slime", "king_slime") var enemy
@export var amount: int
@export var time: float
@export var spawn_area: int # and then somewhere, when getting the area, you can do Areas.get_child(area), where Areas is a Node (or something like that), that has only all SpawnAreas ass children 
