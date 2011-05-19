(global-set-key (kbd "C-h")       'backward-delete-char)
(global-set-key (kbd "C-c d")     'delete-indentation)
(global-set-key (kbd "C-x C-v")   'anything)
(global-set-key (kbd "C-x M-f")   'fill-region)
(global-set-key (kbd "M-g")       'goto-line)
(global-set-key (kbd "C-S-i")     'indent-region)
(global-set-key (kbd "C-m")       'newline-and-indent)
(global-set-key (kbd "C-t")       'next-multiframe-window)
(global-set-key (kbd "C-S-t")     'previous-multiframe-window)
(global-set-key (kbd "C-/")       'undo)
(global-set-key (kbd "C-?") 'redo)
(global-set-key (kbd "C-z")       'scroll-down)

(global-set-key (kbd "C-x C-b")   'electric-buffer-list)

(require 'mura-util)
(global-unset-key "\C-q")
(global-set-key "\C-q\C-q" 'quoted-insert)
(global-set-key "\C-q\C-e" 'my-open-explorer)
(global-set-key "\C-q\C-s" 'my-xyzzy-grep)

(global-set-key (kbd "C-;") 'other-window)
(global-set-key (kbd "M-.") 'dabbrev-expand)
(global-set-key (kbd "C-o") 'call-last-kbd-macro)

(global-set-key  [C-tab] 'other-frame)
(global-set-key  [C-S-tab] (lambda () (interactive) (other-frame -1) ) )

(global-set-key "\C-xt" 'ff-find-other-file)
