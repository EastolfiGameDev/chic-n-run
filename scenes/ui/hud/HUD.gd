extends CanvasLayer

onready var pause_dialog: Popup = $PausePopup
onready var gameover_dialog: Popup = $GameoverPopup
onready var score_label: Label = $TextureRect/Score
onready var final_score: Label = $GameoverPopup/MarginContainer/Content/TextureRect/Score

func _ready() -> void:
    Game.connect("game_ended", self, "_on_Game_ended")

func open_dialog(dialog: Popup) -> void:
    dialog.popup_centered()
    get_parent().modulate.a = 0.4
    get_tree().paused = true

func close_dialog(dialog: Popup) -> void:
    dialog.hide()
    get_parent().modulate.a = 1.0
    get_tree().paused = false

func pause() -> void:
    open_dialog(pause_dialog)

func game_over() -> void:
    open_dialog(gameover_dialog)

func update_score(score: int) -> void:
    score_label.text = str(score)

# SIGNALS #

func _on_Game_ended(score: int) -> void:
    final_score.text = str(score)
    game_over()

func _on_CloseButton_pressed() -> void:
    close_dialog(pause_dialog)

func _on_QuitButton_pressed() -> void:
    if pause_dialog.visible:
        close_dialog(pause_dialog)
    elif gameover_dialog.visible:
        close_dialog(gameover_dialog)
    
    get_tree().change_scene("res://scenes/ui/menu/TitleScreen.tscn")


func _on_RetryButton_pressed() -> void:
    close_dialog(gameover_dialog)
    get_tree().reload_current_scene()
