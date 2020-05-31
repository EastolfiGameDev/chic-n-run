extends Node2D

func _ready() -> void:
    Game.start_countdown()

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        get_tree().call_group("HUD", "pause")
