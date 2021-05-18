" SHELLSCRIPTS REMAPPPINGS - those that do depend on my shellscripts and external programs

nnoremap <Leader>u :!update-notes.sh<CR> | " update-notes (github/devops/bin/update-notes.sh)
nnoremap <Leader>r :!update-reminders.sh<CR> | " update-reminders (github/devops/bin/update-reminders.sh)
nnoremap <leader>sc :!show-calendar.sh<CR>| " show calendar (github/devops/bin/show-calendar.sh)

nnoremap <Leader>gs :!git status && lock-terminal-for-input.sh<CR> | " (git) status
nnoremap <Leader>gl :!git glog && lock-terminal-for-input.sh<CR> | " (git) log

