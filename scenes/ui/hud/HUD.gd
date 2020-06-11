extends CanvasLayer

const HEART_SIZE = Vector2(32, 32)
const MAX_HEARTS_PER_ROW = 6

onready var pause_dialog: Popup = $PausePopup
onready var gameover_dialog: Popup = $GameoverPopup
onready var score_label: Label = $TextureRect/Score
onready var final_score: Label = $GameoverPopup/MarginContainer/Content/TextureRect/Score
onready var HeartEmpty: TextureRect = $HealthDisplay/HeartEmpty
onready var HeartFull: TextureRect = $HealthDisplay/HeartFull
onready var countdown: Control = $Countdown
onready var username_input: LineEdit = $GameoverPopup/MarginContainer/Content/HBoxContainer/UsernameText
onready var http_request: HTTPRequest = $HTTPRequest

func _ready() -> void:
    Game.connect("game_ended", self, "_on_Game_ended")
    Game.connect("player_stats_updated", self, "on_player_stats_updated")

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

func update_health(value: int):
    HeartFull.rect_size.x = clamp(value, 0, Game.max_health) * HEART_SIZE.x

func update_max_health(value: int):
    if value > MAX_HEARTS_PER_ROW:
        # TODO - Handle several rows
        HeartEmpty.rect_size.x = max(value, 1) * HEART_SIZE.x
    else:
        HeartEmpty.rect_size.x = max(value, 1) * HEART_SIZE.x

func start_countdown() -> void:
    countdown.start_countdown()

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

func on_player_stats_updated(stats: Dictionary):
    if stats.has("health"):
        update_health(stats.health)
    if stats.has("max_health"):
        update_max_health(stats.max_health)


func _on_SubmitButton_pressed() -> void:
    if username_input.text:
        var url = "https://chic-n-run-leaderboard.glitch.me/api/1.0/leaderboard/add"
        var score: Dictionary = {
            username = username_input.text,
            score = Game.last_score
        }
        var headers = ["Content-Type: application/json"]
        http_request.request(url, headers, false, HTTPClient.METHOD_POST, to_json(score))
    else:
        print("do nothing")
