extends ParallaxBackground

@onready var hint: Control = $".."

func _process(_delta: float) -> void:
	offset = get_viewport().get_visible_rect().size / 2
	scale = (get_viewport().get_visible_rect().size / Vector2(2560, 1440)) * 1.1
	scroll_offset = get_viewport().get_mouse_position() - Vector2(get_viewport().get_visible_rect().size) / 2
	scroll_limit_begin =  get_viewport().get_visible_rect().size - get_viewport().get_visible_rect().size * 1.1
	scroll_limit_end =  get_viewport().get_visible_rect().size * 1.1


func _on_button_pressed() -> void:
	hint.queue_free()
