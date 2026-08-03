#!/usr/bin/env bats
# shellcheck disable=SC1091
load helpers
source "$SRC/recent.sh"
source "$SRC/remove.sh"
source "$SRC/trash.sh"

setup() {
    export PD_LANG=pt_BR
    PROJECTS_DIR="$BATS_TEST_TMPDIR/projects"
    RECENT_FILE="$BATS_TEST_TMPDIR/recent"
    TRASH_DIR="$BATS_TEST_TMPDIR/trash"
    export TRASH_MAX_ITEMS=3
    export TRASH_MAX_DAYS=3
    : > "$MOCK_LOG"
    mkdir -p "$PROJECTS_DIR" "$TRASH_DIR" "$BATS_TEST_TMPDIR/bin"
    export PATH="$BATS_TEST_TMPDIR/bin:$PATH"
}

@test "trash_list: shows empty message" {
    run trash_list
    [[ "$output" == *"Lixeira vazia"* ]]
}

@test "trash_list: lists items" {
    mkdir -p "$TRASH_DIR/myproj"
    date +%s > "$TRASH_DIR/myproj/.trash_info"
    run trash_list
    [[ "$output" == *"myproj"* ]]
}

@test "trash_empty: confirms and empties" {
    mkdir -p "$TRASH_DIR/myproj"
    date +%s > "$TRASH_DIR/myproj/.trash_info"
    echo "y" > "$BATS_TEST_TMPDIR/input"
    run trash_empty < "$BATS_TEST_TMPDIR/input"
    [ ! -d "$TRASH_DIR/myproj" ]
    [[ "$output" == *"Lixeira esvaziada"* ]]
}

@test "trash_empty: cancels" {
    mkdir -p "$TRASH_DIR/myproj"
    echo "n" > "$BATS_TEST_TMPDIR/input"
    run trash_empty < "$BATS_TEST_TMPDIR/input"
    [ -d "$TRASH_DIR/myproj" ]
    [[ "$output" == *"Cancelado"* ]]
}

@test "trash_empty: shows empty when already empty" {
    run trash_empty
    [[ "$output" == *"Lixeira vazia"* ]]
}

@test "trash_remove: deletes item from trash" {
    mkdir -p "$TRASH_DIR/myproj"
    run trash_remove "myproj"
    [ ! -d "$TRASH_DIR/myproj" ]
    [[ "$output" == *"removido permanentemente"* ]]
}

@test "trash_remove: fails when not found" {
    run trash_remove "nope"
    [ "$status" -eq 1 ]
    [[ "$output" == *"não encontrado"* ]]
}

@test "trash_remove: fails without name" {
    run trash_remove ""
    [ "$status" -eq 1 ]
    [[ "$output" == *"Uso"* ]]
}

@test "trash_restore: restores single item" {
    mkdir -p "$TRASH_DIR/myproj"
    echo "test" > "$TRASH_DIR/myproj/file.txt"
    date +%s > "$TRASH_DIR/myproj/.trash_info"
    run trash_restore "myproj"
    [ -d "$PROJECTS_DIR/myproj" ]
    [ -f "$PROJECTS_DIR/myproj/file.txt" ]
    [ ! -f "$PROJECTS_DIR/myproj/.trash_info" ]
    [[ "$output" == *"restaurado"* ]]
}

@test "trash_restore: restores all" {
    mkdir -p "$TRASH_DIR/p1" "$TRASH_DIR/p2"
    date +%s > "$TRASH_DIR/p1/.trash_info"
    date +%s > "$TRASH_DIR/p2/.trash_info"
    run trash_restore "all"
    [ -d "$PROJECTS_DIR/p1" ]
    [ -d "$PROJECTS_DIR/p2" ]
    [ ! -d "$TRASH_DIR/p1" ]
    [ ! -d "$TRASH_DIR/p2" ]
    [[ "$output" == *"restaurado"* ]]
}

@test "trash_restore: fails when not found" {
    run trash_restore "nope"
    [ "$status" -eq 1 ]
}

@test "trash_restore: fails without name" {
    run trash_restore ""
    [ "$status" -eq 1 ]
}

@test "trash_restore all: empty trash shows message" {
    run trash_restore "all"
    [[ "$output" == *"Lixeira vazia"* ]]
}

@test "trash router: shows list + footer by default" {
    mkdir -p "$TRASH_DIR/myproj"
    date +%s > "$TRASH_DIR/myproj/.trash_info"
    run trash
    [[ "$output" == *"myproj"* ]]
    [[ "$output" == *"Comandos"* ]]
}

@test "trash router: empty shows footer" {
    run trash
    [[ "$output" == *"Lixeira vazia"* ]]
    [[ "$output" == *"Comandos"* ]]
}

@test "trash router: routes ls" {
    run trash ls
    [[ "$output" == *"Lixeira vazia"* ]]
}

@test "trash router: routes rm" {
    mkdir -p "$TRASH_DIR/myproj"
    run trash rm "myproj"
    [[ "$output" == *"removido permanentemente"* ]]
    [ ! -d "$TRASH_DIR/myproj" ]
}

@test "trash router: routes restore" {
    mkdir -p "$TRASH_DIR/myproj"
    date +%s > "$TRASH_DIR/myproj/.trash_info"
    run trash restore "myproj"
    [[ "$output" == *"restaurado"* ]]
    [ -d "$PROJECTS_DIR/myproj" ]
}

@test "trash router: routes empty" {
    echo "y" > "$BATS_TEST_TMPDIR/input"
    run trash empty < "$BATS_TEST_TMPDIR/input"
    [[ "$output" == *"Lixeira vazia"* ]]
}

@test "trash rm all: confirms and empties" {
    mkdir -p "$TRASH_DIR/p1" "$TRASH_DIR/p2"
    date +%s > "$TRASH_DIR/p1/.trash_info"
    date +%s > "$TRASH_DIR/p2/.trash_info"
    echo "y" > "$BATS_TEST_TMPDIR/input"
    run trash rm all < "$BATS_TEST_TMPDIR/input"
    [ ! -d "$TRASH_DIR/p1" ]
    [ ! -d "$TRASH_DIR/p2" ]
    [[ "$output" == *"Lixeira esvaziada"* ]]
}

@test "trash rm all: cancels" {
    mkdir -p "$TRASH_DIR/p1"
    echo "n" > "$BATS_TEST_TMPDIR/input"
    run trash rm all < "$BATS_TEST_TMPDIR/input"
    [ -d "$TRASH_DIR/p1" ]
    [[ "$output" == *"Cancelado"* ]]
}

@test "trash rm all: empty shows message" {
    run trash rm all
    [[ "$output" == *"Lixeira vazia"* ]]
}
