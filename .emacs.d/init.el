(add-to-list 'load-path "~/.emacs.d/site-lisp")

(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/site-lisp/")

(require 'init-loader)
(init-loader-load "~/.emacs.d/inits")
