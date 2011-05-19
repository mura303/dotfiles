(autoload 'gtags-mode "gtags" "" t)
(add-hook 'gtags-mode-hook
          (function 
           (lambda ()
             (local-set-key "\C-c," 'gtags-find-with-grep)
             (local-set-key "\C-c." 'gtags-find-symbol)
             (local-set-key "\M-." 'gtags-find-tag)
             (local-set-key "\M-," 'gtags-find-rtag)
             )))
(setq gtags-select-mode-hook
  '(lambda ()
     (setq hl-line-face 'underline)
     (hl-line-mode 1)
))
