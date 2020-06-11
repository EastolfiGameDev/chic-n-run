class_name Stats extends Node

signal no_health

export(bool) var is_player := false
export(int) var max_health := 1 setget set_max_health

var health: int setget set_health

func _ready() -> void:
    set_max_health(max_health, true)

func set_health(value: int):
    health = value
    var stats_changes = {
        health = health
    }
    
    # Review max health increase
    if health > max_health:
        max_health = health
        stats_changes.max_health = max_health

    _notify_player_stats(stats_changes)
    
    if health <= 0:
        emit_signal("no_health")

func set_max_health(value: int, replenish = false):
    max_health = value
    
    if replenish:
        health = max_health
    else:
        health = min(health, max_health)

    _notify_player_stats({
        health = health,
        max_health = max_health
    })

func _notify_player_stats(stats: Dictionary):
    if is_player:
        Game.update_player_stats(stats)
