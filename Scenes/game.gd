extends Node2D

@onready var translation = $CanvasLayer/Translation
@onready var door = $Door
@onready var animations = $Animations
@onready var camera = $Camera
@onready var textbox = $CanvasLayer/Textbox
@onready var textbox_text = $CanvasLayer/Textbox/Text
@onready var choice_1 = $Choice1
@onready var choice_2 = $Choice2
@onready var choice_3 = $Choice3
@onready var choice_4 = $Choice4

const file_path = "res://Timeline.rk"

var current_question = 0

var hint:Node2D

var right_answers = [
	1, 2, 3, 4, 3, 4, 2, 1
]

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
	translation.visible = false
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

func _on_choice_1_pressed():
	if(right_answers[current_question] == 1):
		choice_2.hide()
		choice_3.hide()
		choice_4.hide()
func _on_choice_2_pressed():
	if(right_answers[current_question] == 2):
		choice_1.hide()
		choice_3.hide()
		choice_4.hide()
func _on_choice_3_pressed():
	if(right_answers[current_question] == 3):
		choice_2.hide()
		choice_1.hide()
		choice_4.hide()
func _on_choice_4_pressed():
	if(right_answers[current_question] == 4):
		choice_2.hide()
		choice_3.hide()
		choice_1.hide()
