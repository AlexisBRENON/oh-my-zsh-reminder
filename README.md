# oh-my-zsh-reminder
A very very simple OhMyZsh plugin which displays reminders above every prompt

This small plugin allows your terminal to remind you that you have somethind to do.
Start adding a task :

    $ todo Delete this task
    Todo :
      - Delete this task
    
    $
    
You can add an other one :

    $ todo Keep this one
    Todo :
      - Delete this task
      - Keep this one
    
    $

When a task is done, remove it from the list :

    $ task_done Delete
    Todo :
      - Keep this one
    
    $

When all tasks are done, reminder vanishes :

    $ task_done Keep

    $
    
That's all for the moment. As I said, very very simple. Maybe will be improved later.
