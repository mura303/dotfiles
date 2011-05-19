(provide 'mura-util)
(defun my-open-explorer ()
  (interactive)
  (call-process "explorer" nil 0 nil "."))

(defun my-xyzzy-grep ()
  (interactive)
  (call-process "xyzzy.exe" nil 0 nil "-f" "grep-dialog"))

(defun my-insert-function-comment ()
  (interactive)
  (insert 
   "
/*---------------------------------------------------------------------------*
  
  
  
 *---------------------------------------------------------------------------*/
"
))


(defun my-get-filename-if-exists (filenames)
  (if (not (car filenames)) nil
    (if (file-exists-p (car filenames))
        (car filenames)
      (my-get-filename-if-exists (cdr filenames))
      )
    )
  )

(defun my-compile ()
  (interactive)
  (let ((filename (my-get-filename-if-exists '("makefile" "../makefile" "../../makefile"))))
    (if (not filename)
        (error "makefile doesnt exist.")
      (find-file filename)
      (call-interactively 'compile))))



(defun my-c-insert-static-func-prototype
  ()
  (interactive)
  (save-excursion
    (kill-ring-save (point-at-bol) (search-forward ")"))
    (goto-char (point-min))
    (search-forward "// static functions\n")
    (yank)
    (insert ";\n")
    )
  )


(defun my-c-copy-func-prototype
  ()
  (interactive)
  (kill-ring-save (point-at-bol) (search-forward ")"))
  (kill-append ";\n" nil)
  )
  

(defun my-c-header-include-guard 
  ()
  (interactive)
  (save-excursion
    (let ((str (concat (upcase
                        (subst-char-in-string ?. ?_ (file-name-nondirectory
                                                     buffer-file-name))
                        ) "_"))
          )
      (goto-char (point-min))
      (insert "#ifndef " str "\n"
              "#define " str "\n")
      (goto-char (point-max))
      (insert "\n\n#endif // " str "\n")
      )))



(defun my-window-size-save ()
  (let* ((rlist (frame-parameters (selected-frame)))
         (ilist initial-frame-alist)
         (nCHeight (frame-height))
         (nCWidth (frame-width))
         (tMargin (if (integerp (cdr (assoc 'top rlist)))
                      (cdr (assoc 'top rlist)) 0))
         (lMargin (if (integerp (cdr (assoc 'left rlist)))
                      (cdr (assoc 'left rlist)) 0))
         buf
         (file mmemo-frame-size)
         (font (cdr (assoc 'font (frame-parameters))))
         )
    (when (or (file-writable-p file)
              (not (file-exists-p file)))
      (if (get-file-buffer (expand-file-name file))
          (setq buf (get-file-buffer (expand-file-name file)))
        (setq buf (find-file-noselect file)))
      (set-buffer buf)
      (erase-buffer)
      (insert (concat
               (if font
                   "(delete 'font initial-frame-alist)\n")
               "(delete 'width initial-frame-alist)\n"
               "(delete 'height initial-frame-alist)\n"
               "(delete 'top initial-frame-alist)\n"
               "(delete 'left initial-frame-alist)\n"
               "(setq initial-frame-alist (append (list\n"
               (if font
                   (concat
                    "'(font . \"" font "\")\n"))
               "'(width . " (int-to-string nCWidth) ")\n"
               "'(height . " (int-to-string nCHeight) ")\n"
               "'(top . " (int-to-string tMargin) ")\n"
               "'(left . " (int-to-string lMargin) "))\n"
               "initial-frame-alist))\n"

               (if font
                   "(delete 'font default-frame-alist)\n")
               "(delete 'width default-frame-alist)\n"
               "(delete 'height default-frame-alist)\n"
               "(delete 'top default-frame-alist)\n"
               "(delete 'left default-frame-alist)\n"
               "(defun mmemo-set-default-frame ()\n"
               "(setq default-frame-alist (append (list\n"
               ;;"'(vertical-scroll-bars . 'right)\n"
               (if font
                   (concat
                    "'(font . \"" font "\")\n"))
               "'(width . " (int-to-string nCWidth) ")\n"
               "'(height . " (int-to-string nCHeight) ")\n"
               "'(top . " (int-to-string tMargin) ")\n"
               "'(left . " (int-to-string lMargin) "))\n"
               "default-frame-alist))\n"
               ")\n(add-hook 'after-init-hook 'mmemo-set-default-frame)\n"
               ))
      (save-buffer)
      )))



(defun my-window-ctrl ()
  "Window size and position control."
  (interactive)
  (let* ((rlist (frame-parameters (selected-frame)))
         (tMargin (if (integerp (cdr (assoc 'top rlist)))
                      (cdr (assoc 'top rlist)) 0))
         (lMargin (if (integerp (cdr (assoc 'left rlist)))
                      (cdr (assoc 'left rlist)) 0))
         (displaywidth (x-display-pixel-width))
         (displayheight (x-display-pixel-height))
         (fObj (selected-frame))
         (nCHeight (frame-height))
         (nCWidth (frame-width))
         (ilist initial-frame-alist)
         (tMarginD (if (assoc 'top ilist)
                       (cdr (assoc 'top ilist)) tMargin))
         (lMarginD (if (assoc 'left ilist)
                       (cdr (assoc 'left ilist)) lMargin))
         (nCHeightD (if (assoc 'height ilist)
                        (cdr (assoc 'height ilist)) nCHeight))
         (nCWidthD (if (assoc 'width ilist)
                       (cdr (assoc 'width ilist)) nCWidth))
         endFlg
         c)
    (catch 'endFlg
      (while t
        (message "locate[%d:%d] size[%dx%d] display[%dx%d]"
                 lMargin tMargin nCWidth nCHeight
                 displaywidth displayheight)
        (set-mouse-position
         (if (featurep 'meadow)
             (selected-frame)
           (selected-window))
         nCWidth 0)
        (condition-case err
            (setq c (read-key-sequence nil))
          (error
           (throw 'endFlg t)))
        (cond ((or (equal c "f") (equal c [S-right]))
               ;;enlarge horizontally
               (set-frame-width fObj (setq nCWidth (+ nCWidth 2))))
              ((or (equal c "b") (equal c [S-left]))
               ;;shrink horizontally
               (set-frame-width fObj (setq nCWidth (- nCWidth 2))))
              ((or (equal c "n") (equal c [S-down]))
               ;;enlarge vertically
               (set-frame-height fObj (setq nCHeight (+ nCHeight 2))))
              ((or (equal c "p") (equal c [S-up]))
               ;;shrink vertically
               (set-frame-height fObj (setq nCHeight (- nCHeight 2))))
              ((or (equal c "\C-f") (equal c [right]))
               ;;move right
               (modify-frame-parameters
                nil (list (cons 'left (setq lMargin (+ lMargin 20))))))
              ((or (equal c "\C-b") (equal c [left]))
               ;;move left
               (modify-frame-parameters
                nil (list (cons 'left (setq lMargin (- lMargin 20))))))
              ((or (equal c "\C-n") (equal c [down]))
               ;;move down
               (modify-frame-parameters
                nil (list (cons 'top (setq tMargin (+ tMargin 20))))))
              ((or (equal c "\C-p") (equal c [up]))
               ;;move up
               (modify-frame-parameters
                nil (list (cons 'top (setq tMargin (- tMargin 20))))))
              ((or (equal c "\C-a") (equal c [home]))
               ;;move left end
               (modify-frame-parameters
                nil (list (cons 'left (setq lMargin 0)))))
              ((or (equal c "\C-e") (equal c [end]))
               ;;move left hand
               (modify-frame-parameters
                nil (list
                     (cons 'left
                           (setq lMargin
                                 (-
                                  (- displaywidth (frame-pixel-width))
                                  10) ;; 少し右端を空ける
                                 )))))
              ((or (equal c "\C-x") (equal c "x"))
               ;;maximize
               (modify-frame-parameters
                nil (list (cons 'left (setq lMargin 0))))
               (modify-frame-parameters
                nil (list (cons 'top (setq tMargin 0))))
               (set-frame-width
                ;; フレーム最大化時に (frame-width) で得た値
                fObj (setq nCWidth 154)) ;; 要変更
               ;; 環境によっては，以下でもうまくいくかも
               ;; fObj (setq nCWidth (/ displaywidth (frame-char-width))))
               (set-frame-height
                ;; フレーム最大化時に (frame-height) で得た値
                fObj (setq nCHeight 34)) ;; 要変更
               ;; 環境によっては，以下でもうまくいくかも
               ;; (- (/ displayheight (frame-char-height)) 8)))
               )
              ((or (equal c "\C-d") (equal c "d"));;default size
               (modify-frame-parameters
                nil (list (cons 'left (setq lMargin lMarginD))))
               (modify-frame-parameters
                nil (list (cons 'top (setq tMargin tMarginD))))
               (set-frame-width fObj (setq nCWidth nCWidthD))
               (set-frame-height fObj (setq nCHeight nCHeightD))
               )
              ((or (equal c "\C-i") (equal c "i"));;initial size
               (modify-frame-parameters
                nil (list (cons 'left (setq lMargin 0))))
               (modify-frame-parameters
                nil (list (cons 'top (setq tMargin 0))))
               (set-frame-width fObj (setq nCWidth 80))
               (set-frame-height fObj (setq nCHeight 32))
               )
              ((equal c "w");;write out
               (insert (concat
                        "'(width . " (int-to-string nCWidth) ")\n"
                        "'(height . " (int-to-string nCHeight) ")\n"
                        "'(top . " (int-to-string tMargin) ")\n"
                        "'(left . " (int-to-string lMargin) ")\n"))
               (throw 'endFlg t))
              ((or (equal c "\C-z") (equal c "z"))
               (iconify-or-deiconify-frame)
               (throw 'endFlg t))
              ((equal c "q") (message "quit") (throw 'endFlg t))
              ;; デフォルトは終了
              (t (message "quit") (throw 'endFlg t))
              )))))




