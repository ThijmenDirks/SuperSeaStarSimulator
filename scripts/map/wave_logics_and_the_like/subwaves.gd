class_name Subwaves
extends Resource

@export var name: String
@export var amount: int
@export var time: float
@export var area: int # and then somewhere, when getting the area, you can do Areas.get_child(area), where Areas is a Node (or something like that), that has only all SpawnAreas ass children 
