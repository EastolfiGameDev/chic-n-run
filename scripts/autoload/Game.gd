extends Node

signal scroll_started
signal scroll_speed_increased(factor)
signal game_ended(score)
signal player_stats_updated(stats)

const SAVE_FILE = "user://game.save"
const INITIAL_MAX_HEALTH = 3

var player_stats: Dictionary = {}
var max_health = INITIAL_MAX_HEALTH
var last_score = 0
var speed_factor: float = 1

func _ready() -> void:
    init_player_stats()

func start_run() -> void:
    start_countdown()

func start_countdown() -> void:
    get_tree().call_group("HUD", "start_countdown")

func start_scroll() -> void:
    emit_signal("scroll_started")

func end_run() -> void:
    var levels = get_tree().get_nodes_in_group("Level")
    var score: int = levels[0].score
    
    last_score = score
    _save_max_score(score)
    
    emit_signal("game_ended", score)

func increase_scroll_speed(factor: float) -> void:
    emit_signal("scroll_speed_increased", factor)

func get_save_file() -> Dictionary:
    var save_info = {}
    var file := File.new()
    
    if file.file_exists(SAVE_FILE):
        file.open(SAVE_FILE, File.READ)
        save_info = parse_json(file.get_as_text())
    else:
        print(file.open(SAVE_FILE, File.WRITE))
        file.store_line("{}")
    
    file.close()
    
    return save_info

func get_max_score() -> int:
    var save_info = get_save_file()
    
    if save_info.has("max_score"):
        return save_info.max_score as int
    else:
        return 0

func _save_max_score(score: int) -> void:
    var save_info = {}
    var file = File.new()
    
    file.open(SAVE_FILE, File.READ_WRITE)
    if file.file_exists(SAVE_FILE):
        save_info = parse_json(file.get_as_text())
    
    if not save_info.has("max_score") or score > save_info.max_score:
        save_info.max_score = score
        file.store_string(to_json(save_info))
    
    file.close()

func init_player_stats() -> void:
    var save_info = get_save_file()
    
    if save_info.has("max_health"):
        max_health = save_info.max_health
    else:
        max_health = INITIAL_MAX_HEALTH

func update_player_stats(new_stats: Dictionary) -> void:
    for stat in new_stats:
        player_stats[stat] = new_stats[stat]
    
    emit_signal("player_stats_updated", new_stats)
