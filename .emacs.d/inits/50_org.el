(require 'org-install)
(setq org-agenda-files '("~/main.org", "~/others.org"))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cr" 'org-remember)
(setq org-log-done 'time)
(setq org-startup-truncated nil)
(setq org-return-follows-link t)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

(org-remember-insinuate)
(setq org-directory "C:/home/wc/note/")
(setq org-default-notes-file (concat org-directory "agenda.org"))

(setq org-remember-templates
      '(("Note" ?n "* %?\n  %i\n  %a" nil "Tasks")
        ("Todo" ?t "* TODO %?\n  %i\n  %a" nil "Tasks")))
