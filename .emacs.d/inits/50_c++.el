;; c++-mode

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-hook 'c++-mode-hook
          '(lambda ()
             (local-set-key (kbd "C-x m") 'compile)
             (c-set-style "cc-mode")))

(defun my-c-namespace-indent (langelem)
  (save-excursion
    (if (or (looking-at "[ \t]*namespace[ \t{]")
            (looking-at "[ \t]*namespace[ \t]+[_a-zA-Z]")
            (looking-at "[ \t]*}"))
        0
      (if (progn (goto-char (cdr langelem))
                 (skip-chars-backward " \t")
                 (bolp))
          0))))

(add-hook 'c-mode-common-hook
          (lambda ()
			(c-set-style "linux")
			(c-set-offset 'innamespace 'my-c-namespace-indent)
			(setq tab-width 4
				  indent-tabs-mode nil
				  c-basic-offset tab-width)
            (gtags-mode 1)))
