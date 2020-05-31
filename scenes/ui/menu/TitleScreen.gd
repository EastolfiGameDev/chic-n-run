extends Control

func _on_PlayButton_pressed() -> void:
    get_tree().change_scene("res://scenes/levels/grass/GrassLevel.tscn")

func _on_CollectionButton_pressed() -> void:
    get_tree().change_scene("res://scenes/ui/menu/CollectionScreen.tscn")
