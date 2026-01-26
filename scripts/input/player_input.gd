class_name PlayerInput extends BaseInput

# --- Helper Inputs (accessible by states) ---
func button1(): return Input.is_action_just_pressed("button1")
func hold1(): return Input.is_action_pressed("button1")
func button2(): return Input.is_action_just_pressed("button2")
func hold2(): return Input.is_action_pressed("button2")
func button3(): return Input.is_action_just_pressed("button3")
func hold3(): return Input.is_action_pressed("button3")

func getinput() -> Vector2: 
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")
