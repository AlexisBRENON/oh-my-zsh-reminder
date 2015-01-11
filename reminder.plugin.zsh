touch ~/.todo_list
colors
todo_color=(red green yellow blue magenta cyan)
color_index=1

function todo {
    task=$(echo -E "$@" | tr '\n' '\r' | sed -e 's/\r$//' -e 's/\r/\n    /g')
    task="$task\x1E"
    echo "  - ${fg[${todo_color[${color_index}]}]}$task${fg[default]}" >> ~/.todo_list
    (( color_index %= ${#todo_color} ))
    (( color_index += 1 ))
}

function task_done {
    pattern="$1"
    touch /tmp/todo_list
    IFS=''
    while read line
    do
        if [[ ! "${line}" =~ "${pattern}" ]] then
            echo "$line" >> /tmp/todo_list
        fi
    done < ~/.todo_list
    mv -f /tmp/todo_list ~/.todo_list
}

function display_todo {
    if [[ -s ~/.todo_list ]] then
        echo "${fg_bold[default]}Todo :${fg_no_bold[default]}"
        cat ~/.todo_list
    fi
}

precmd_functions+=(display_todo)
