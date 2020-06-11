extends Node2D

var score: int = 0
var score_timer: Timer

func _ready() -> void:
    add_to_group("Level")

    score_timer = Timer.new()
    score_timer.one_shot = false
    score_timer.wait_time = 1.0
    score_timer.connect("timeout", self, "_update_score")
    add_child(score_timer)

    Game.connect("scroll_started", self, "on_Game_scroll_started")
    Game.start_run()

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        get_tree().call_group("HUD", "pause")

func _update_score():
    score += 1
    get_tree().call_group("HUD", "update_score", score)

func on_Game_scroll_started():
    score_timer.start()
