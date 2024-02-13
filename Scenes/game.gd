extends Node2D

@onready var animations = $Animations
@onready var camera = $Camera

var current_question = 0

var hint:Node2D

func _ready():
	pass

func _process(_delta):
	pass

func _on_door_pressed():
	animations.play("to_door")

func _on_animations_animation_finished(_anim_name):
	camera.zoom = Vector2(0.6, 0.6)
	camera.position = Vector2()
	hint = preload("res://Scenes/hint.tscn").instantiate()
	add_child(hint)
	animations.play("appearance")
