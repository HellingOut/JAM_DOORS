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

const first_dialog = "res://Timeline.rk"

var functions:Dictionary = {
	"Play Animation":play_animation
}

var current_question = 0

var hint

var right_answers:Array = [
	1, 2, 3, 4, 3, 4, 2, 1
]

var variant_text:Array = [
	["Variant 1", "Variant 2", "Variant 3", "Variant 4"],
	["Q2Variant 1", "Q2Variant 2", "Q2Variant 3", "Q2Variant 4"],
	["Q3Variant 1", "Variant 2", "Variant 3", "Variant 4"],
	["Variant 1", "Q3Variant 2", "Variant 3", "Variant 4"],
	["Variant 1", "Variant 2", "Variant 3", "Q4Variant 4"],
]

func _ready():
	Rakugo.add_custom_regex("Play Animation", "^play_animation(.*)$")
	Rakugo.sg_custom_regex.connect(_on_custom_regex)
	Rakugo.sg_say.connect(_on_say)
	Rakugo.sg_execute_script_finished.connect(_on_execute_script_finished)
	start_dialog(first_dialog)
	animations.play("appearance")
	choice_1.text = variant_text[current_question][0]
	choice_2.text = variant_text[current_question][1]
	choice_3.text = variant_text[current_question][2]
	choice_4.text = variant_text[current_question][3]

func start_dialog(script):
	textbox.show()
	Rakugo.parse_and_execute_script(script)

func _on_say(_character:Dictionary, text:String):
	textbox_text.text = text

func _on_step():
	prints("Press 'Enter' to continue...")

func _on_custom_regex(key:String, result):
	result = result.get_string()
	var current_comand = result.erase(result.find("("), len(result))
	var args = []
	var args_string = (result.erase(0, result.find("(")+1))
	args_string = args_string.erase(args_string.find(")"), len(result))
	while(args_string.find(",")!=-1):
		args.append(args_string.erase(args_string.find(","), len(args_string)))
		args_string = args_string.erase(0, args_string.find(",")+1)
	if(args_string != ""):
		args.append(args_string)
	else:
		functions[current_comand].call()
	functions[key].call(args)

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
		get_tree().root.add_child(hint)
		animations.play("appearance")
	if(textbox.visible == true):
		translation.visible = true

func next_question():
	current_question += 1
	choice_1.text = variant_text[current_question][0]
	choice_2.text = variant_text[current_question][1]
	choice_3.text = variant_text[current_question][2]
	choice_4.text = variant_text[current_question][3]

func _on_choice_1_pressed():
	if(right_answers[current_question] == 1):
		start_dialog("res://Dialogs/Right/dialog_" + str(current_question) + ".rk")
	else:
		start_dialog("res://Dialogs/Wrong/dialog_" + str(current_question) + ".rk")
	next_question()
func _on_choice_2_pressed():
	if(right_answers[current_question] == 2):
		print(right_answers[current_question])
	next_question()
func _on_choice_3_pressed():
	if(right_answers[current_question] == 3):
		print(right_answers[current_question])
	next_question()
func _on_choice_4_pressed():
	if(right_answers[current_question] == 4):
		print(right_answers[current_question])
	next_question()

func play_animation(args:Array):
	animations.play(args[0])
