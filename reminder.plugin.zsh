TODO_SAVE_TASKS_FILE="$HOME/.todo.sav"
TODO_SAVE_COLOR_FILE="$HOME/.todo_color.sav"

# Allow to use colors
colors
typeset -T -x -g TODO_TASKS todo_tasks
typeset -a -x -g todo_colors
typeset -i -x -g todo_color_index

# Load previous tasks from saved file
if [[ -e "$TODO_SAVE_TASKS_FILE" &&
      -e "$TODO_SAVE_COLOR_FILE" ]] then
    TODO_TASKS="$(cat $TODO_SAVE_TASKS_FILE)"
    todo_color_index="$(cat $TODO_SAVE_COLOR_FILE)"
    if [[ -z "$TODO_TASKS" ]] then
        todo_tasks[1]=()
    fi
else
    todo_tasks=()
    todo_color_index=1
fi
todo_colors=(red green yellow blue magenta cyan)

precmd_functions+=(todo_display)
zshexit_functions+=(todo_save)

function todo_add_task {
    if [[ $# -gt 0 ]] then
      # Cross-platform newline replacement solution for BSD's (Mac OS X) and GNU's (Linux and Cygwin)
      # Source: http://stackoverflow.com/a/8997314/1298019
      task=$(echo -E "$@" | tr '\n' '\000' | sed -e 's:\x00\x00.*:\n:g' -e 's/\000$//' -e 's/\000/\n    /g')
      task="  - ${fg[${todo_colors[${todo_color_index}]}]}$task$fg[default]"
      todo_tasks+="$task"
      (( todo_color_index %= ${#todo_colors} ))
      (( todo_color_index += 1 ))
    fi
}

function todo_task_done {
    pattern="$1"
    todo_tasks[${(M)todo_tasks[(i)*\[3?m*${pattern}*\[39m*]}]=()
}

function todo_display {
    if [[ ${#todo_tasks} -gt 0 ]] then
      print -l "$fg_bold[default]Todo :$fg_no_bold[default]" ${todo_tasks}
    fi
}

function todo_save {
    echo "$TODO_TASKS" > $TODO_SAVE_TASKS_FILE
    echo "$todo_color_index" > $TODO_SAVE_COLOR_FILE
}

alias todo=todo_add_task
alias task_done=todo_task_done
