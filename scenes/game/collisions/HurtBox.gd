extends Area2D

signal invincibility_started
signal invincibility_ended

var invincible: = false setget set_invicible

onready var timer: Timer = $Timer

func set_invicible(value: bool):
    invincible = value
    
    if invincible:
        emit_signal("invincibility_started")
    else:
        emit_signal("invincibility_ended")

func start_invincibility(duration: float):
    set_invicible(true)
    timer.start(duration)

func _on_Timer_timeout() -> void:
    set_invicible(false)

func _on_HurtBox_invincibility_started() -> void:
    set_deferred("monitorable", false)


func _on_HurtBox_invincibility_ended() -> void:
    set_deferred("monitorable", true)
