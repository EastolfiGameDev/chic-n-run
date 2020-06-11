extends Control

onready var max_score: Label = $MarginContainer/HBoxContainer/TitleImageContainer/TextureRect/MaxScore

func _ready() -> void:
    var score = Game.get_max_score()
    max_score.text = str(score)
    get_tree().paused = false

func _on_PlayButton_pressed() -> void:
    get_tree().change_scene("res://scenes/levels/grass/BeachLevel.tscn")

func _on_CollectionButton_pressed() -> void:
    get_tree().change_scene("res://scenes/ui/menu/CollectionScreen.tscn")
