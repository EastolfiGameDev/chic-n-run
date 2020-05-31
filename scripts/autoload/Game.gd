extends Node

signal scroll_started
signal game_ended(score)

const SAVE_FILE = "user://game.save"

func start_countdown() -> void:
    print("3")
    yield(get_tree().create_timer(1.0), "timeout")
    print("2")
    yield(get_tree().create_timer(1.0), "timeout")
    print("1")
    yield(get_tree().create_timer(1.0), "timeout")
    print("Start")

    emit_signal("scroll_started")

func end_run() -> void:
    var levels = get_tree().get_nodes_in_group("Level")
    var score: int = levels[0].score
    
    _save_max_score(score)
    
    emit_signal("game_ended", score)


func get_max_score() -> int:
    var file = File.new()
    file.open(SAVE_FILE, File.READ)
    var save_info = parse_json(file.get_as_text())
    file.close()
    
    return save_info.max_score as int

func _save_max_score(score: int) -> void:
    var file = File.new()
    file.open(SAVE_FILE, File.READ_WRITE)
    var save_info = parse_json(file.get_as_text())
    
    if score > save_info.max_score:
        save_info.max_score = score
        file.store_string(to_json(save_info))
    
    file.close()
