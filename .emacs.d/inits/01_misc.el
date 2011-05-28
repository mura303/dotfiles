;;; GCを減らす
(setq gc-cons-threshold (* 50 gc-cons-threshold))

;;; ログの記録量を増やす
(setq message-log-max 10000)

;;; 履歴存数を増やす
(setq history-length 1000)


;;; ダイアログボックスを使わない
(setq use-dialog-box nil)
(defalias 'message-box 'message)

;;; yesで答る部分もyで答えられるように
(defalias 'yes-or-no-p 'y-or-n-p)



(setq
 column-number-mode     t
 line-number-mode       t
 kill-whole-line        t
 dabbrev-case-fold-search nil
 dabbrev-check-all-buffers t
 default-tab-width 4
 delete-old-versions t
 frame-title-format "%b"
 lazy-highlight-initial-delay 0
 ls-lisp-dirs-first t
 make-backup-files t
 next-line-add-newlines nil
 recentf-max-saved-items 100
 resize-mini-windows nil

 vc-make-backup-files   t
 version-control nil
 view-read-only t
 visible-bell t
 scroll-conservatively 35
 scroll-margin 0
 scroll-step 1
 )

(setq backup-directory-alist
      (cons (cons "\\.*$" (expand-file-name "~/.emacs.d/auto-save-list"))
            backup-directory-alist))
