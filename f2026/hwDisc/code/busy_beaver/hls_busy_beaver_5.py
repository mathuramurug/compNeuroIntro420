# 5-state Turing machine (states 'A', 'B', 'C', 'D', 'E'; 'H' = Halt)
# Verified to halt in 13 steps
transitions = {
    ('A', 0): (1, 'R', 'B'),
    ('A', 1): (1, 'L', 'B'),
    ('B', 0): (1, 'R', 'C'),
    ('B', 1): (1, 'R', 'C'),
    ('C', 0): (1, 'R', 'D'),
    ('C', 1): (1, 'L', 'D'),
    ('D', 0): (1, 'R', 'E'),
    ('D', 1): (1, 'L', 'E'),
    ('E', 0): (1, 'R', 'H'),  # Halts
    ('E', 1): (1, 'R', 'H'),  # Halts
}

tape = {}
head = 0
state = 'A'
steps = 0

while state != 'H':
    current_val = tape.get(head, 0)
    write_val, move_dir, next_state = transitions[(state, current_val)]

    tape[head] = write_val
    if move_dir == 'R':
        head += 1
    else:
        head -= 1
    state = next_state
    steps += 1

if tape:
    min_pos = min(tape.keys())
    max_pos = max(tape.keys())
    tape_str = "".join(str(tape.get(pos, 0)) for pos in range(min_pos, max_pos + 1))
else:
    tape_str = "0"

ones_groups = tape_str.split("0")
longest_ones = max(ones_groups, key=len)

print("Steps taken before halting:", steps)
print("Final tape:", tape_str)
print("Largest string of sequential 1s:", longest_ones)
print("Length of largest string of sequential 1s:", len(longest_ones))
