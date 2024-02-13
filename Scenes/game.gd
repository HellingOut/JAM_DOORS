extends Node2D

@onready var translation = $CanvasLayer/Translation
@onready var door = $Door
@onready var animations = $Animations
@onready var camera = $Camera
@onready var textbox = $CanvasLayer/Textbox
@onready var textbox_text = $CanvasLayer/Textbox/Text

const file_path = "res://Timeline.rk"

var current_question = 0

var hint:Node2D

func _ready():
	animations.play("appearance")
	Rakugo.sg_say.connect(_on_say)
	Rakugo.parse_and_execute_script(file_path)
	Rakugo.sg_execute_script_finished.connect(_on_execute_script_finished)

func _on_say(_character:Dictionary, text:String):
	textbox_text.text = text

func _on_step():
	prints("Press 'Enter' to continue...")

func _on_execute_script_finished(_script_name:String, _error_str:String):
	textbox.hide()

func _process(_delta):
	if Rakugo.is_waiting_step() and Input.is_action_just_pressed("mb_left"):
		Rakugo.do_step()

func _on_door_pressed():
	animations.play("to_door")

func _on_animations_animation_finished(_anim_name):
	if(_anim_name == "to_door"):
		camera.zoom = Vector2(0.6, 0.6)
		camera.position = Vector2()
		hint = preload("res://Scenes/hint.tscn").instantiate()
		add_child(hint)
		animations.play("appearance")
	if(textbox.visible == true):
		translation.visible = true
