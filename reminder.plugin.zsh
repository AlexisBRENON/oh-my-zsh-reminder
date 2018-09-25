TODO_SAVE_TASKS_FILE="$HOME/.todo.sav"
TODO_SAVE_COLOR_FILE="$HOME/.todo_color.sav"

# Allow to use colors
colors
typeset -T -x -g TODO_TASKS todo_tasks
typeset -T -x -g TODO_TASKS_COLORS todo_tasks_colors
typeset -a -x -g todo_colors
typeset -i -x -g todo_color_index

function load_tasks() {
# Load previous tasks from saved file
if [[ -e "$TODO_SAVE_TASKS_FILE" &&
      -e "$TODO_SAVE_COLOR_FILE" ]] then
    TODO_TASKS="$(cat $TODO_SAVE_TASKS_FILE)"
    TODO_TASKS_COLORS="$(head -n1 $TODO_SAVE_COLOR_FILE)"
    todo_color_index="$(tail -n1 $TODO_SAVE_COLOR_FILE)"
    if [[ -z "$TODO_TASKS" ]] then
        todo_tasks[1]=()
        todo_tasks_colors[1]=()
    fi
else
    todo_tasks=()
    todo_tasks_colors=()
    todo_color_index=1
fi
}

todo_colors=(red green yellow blue magenta cyan)
autoload -U add-zsh-hook
add-zsh-hook precmd todo_display

function todo_add_task {
    if [[ $# -gt 0 ]] then
      # Source: http://stackoverflow.com/a/8997314/1298019
      task=$(echo -E "$@" | tr '\n' '\000' | sed 's:\x00\x00.*:\n:g' | tr '\000' '\n')
      color="${fg[${todo_colors[${todo_color_index}]}]}"
	    load_tasks
      todo_tasks+="$task"
      todo_tasks_colors+="$color"
      (( todo_color_index %= ${#todo_colors} ))
      (( todo_color_index += 1 ))
      todo_save
    fi
}

alias todo=todo_add_task

function todo_task_done {
    pattern="$1"
	  load_tasks
    index=${(M)todo_tasks[(i)${pattern}*]}
    todo_tasks[index]=()
    todo_tasks_colors[index]=()
    todo_save
}

function _todo_task_done {
    load_tasks
    if [[ ${#todo_tasks} -gt 0 ]] then
      compadd $(echo ${TODO_TASKS} | tr ':' '\n')
    fi
  }

compdef _todo_task_done todo_task_done
alias task_done=todo_task_done

function todo_display {
    load_tasks
    if [[ ${#todo_tasks} -gt 0 ]] then
      printf "$fg_bold[default]Todo :$fg_no_bold[default]\n"
      for (( i = 1; i <= ${#todo_tasks}; i++ )); do
        printf "  - %s%s$fg[default]\n" "${todo_tasks_colors[i]}" "${todo_tasks[i]}"
      done
    fi
}

function todo_save {
    echo "$TODO_TASKS" > $TODO_SAVE_TASKS_FILE
    echo "$TODO_TASKS_COLORS" > $TODO_SAVE_COLOR_FILE
    echo "$todo_color_index" >> $TODO_SAVE_COLOR_FILE
}

