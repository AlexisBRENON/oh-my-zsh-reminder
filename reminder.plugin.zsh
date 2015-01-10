function todo {
    echo "  - $@" >> ~/.todo_list
}

function task_done {
    grep -v -E -i -e "^  - $1" ~/.todo_list > /tmp/todo_list
    mv -f /tmp/todo_list ~/.todo_list
}

function display_todo {
    if [[ -s ~/.todo_list ]] then
        echo "Todo :"
        cat ~/.todo_list
    fi
}

touch ~/.todo_list

precmd_functions+=(display_todo)
