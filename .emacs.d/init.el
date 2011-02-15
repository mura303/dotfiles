(add-to-list 'load-path "~/.emacs.d/lisp")

(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/lisp/")

(require 'init-loader)
(init-loader-load "~/.emacs.d/inits")
