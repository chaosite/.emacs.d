;; -*- lexical-binding: t; -*-

;; Functions that I wrote/found on the internet, and are useful.

(defun shell-command-on-region-inplace (start end command)
  "Run shell-command-on-region interactivly replacing the region in place"
  (interactive (let (string)
                 (unless (mark)
                   (error "The mark is not set now, so there is no region"))
                 ;; Do this before calling region-beginning
                 ;; and region-end, in case subprocess output
                 ;; relocates them while we are in the minibuffer.
                 ;; call-interactively recognizes region-beginning and
                 ;; region-end specially, leaving them in the history.
                 (setq string (read-from-minibuffer "Shell command on region: "
                                                    nil nil nil
                                                    'shell-command-history))
                 (list (region-beginning) (region-end)
                       string)))
  (shell-command-on-region start end command t t)
  )

;; C language - insert header guard.
;; Greatly inspired by (i.e. copied from) https://www.emacswiki.org/emacs/AutoInsertHeaderGuards
(defun c-insert-header-guard ()
  (interactive)
  (if (buffer-file-name)
      (let*
          ((name (upcase (file-name-nondirectory (file-name-sans-extension buffer-file-name))))
           (guard-name (concat "__" name "_H__"))
           (start-guard (concat "#ifndef " guard-name "\n#define " guard-name "\n"))
           (end-guard (concat "\n#endif /* " guard-name "*/\n"))
           (begin (point-marker))
           )
        (progn
          ;; Insert the Header Guard
          (goto-char (point-min))
          (insert start-guard)
          (goto-char (point-max))
          (insert end-guard)
          (goto-char begin))
        )
    ;; else
    (message (concat "Buffer " (buffer-name) " must have a filename"))
  )
)

;; LaTeX indentation options
(defcustom LaTeX-indent-level-item-continuation 4
  "*Indentation of continuation lines for items in itemize-like
environments."
  :group 'LaTeX-indentation
  :type 'integer)


(defun LaTeX-indent-item ()
  "Provide proper indentation for LaTeX \"itemize\",\"enumerate\", and
\"description\" environments.

  \"\\item\" is indented `LaTeX-indent-level' spaces relative to
  the the beginning of the environment.

  Continuation lines are indented either twice
  `LaTeX-indent-level', or `LaTeX-indent-level-item-continuation'
  if the latter is bound."
  (save-match-data
    (let* ((offset LaTeX-indent-level)
           (contin (or (and (boundp 'LaTeX-indent-level-item-continuation)
                            LaTeX-indent-level-item-continuation)
                       (* 2 LaTeX-indent-level)))
           (re-beg "\\\\begin{")
           (re-end "\\\\end{")
           (re-env "\\(itemize\\|\\enumerate\\|description\\)")
           (indent (save-excursion
                     (when (looking-at (concat re-beg re-env "}"))
                       (end-of-line))
                     (LaTeX-find-matching-begin)
                     (current-column))))
      (cond ((looking-at (concat re-beg re-env "}"))
             (or (save-excursion
                   (beginning-of-line)
                   (ignore-errors
                     (LaTeX-find-matching-begin)
                     (+ (current-column)
                        (if (looking-at (concat re-beg re-env "}"))
                            contin
                          offset))))
                 indent))
             ((looking-at (concat re-end re-env "}"))
              indent)
            ((looking-at "\\\\item")
             (+ offset indent))
            (t
             (+ contin indent))))))

(defun check-interpreter-mode-for-current-buffer ()
  "Check what interpreter-based mode Emacs would use for the current buffer.
This follows the same logic as `set-auto-mode` for interpreter detection."
  (interactive)
  (let* ((interp (save-excursion
                   (goto-char (point-min))
                   (if (looking-at auto-mode-interpreter-regexp)
                       (match-string 2))))
         (mode (when interp
                 (assoc-default
                  (file-name-nondirectory interp)
                  (mapcar (lambda (e)
                            (cons
                             (format "\\`%s\\'" (car e))
                             (cdr e)))
                          interpreter-mode-alist)
                  #'string-match-p))))
    (if interp
        (if mode
            (message "Interpreter: %s\nMode that would be set: %s"
                     interp mode)
          (message "Interpreter: %s\nNo matching mode in interpreter-mode-alist"
                   interp))
      (message "No interpreter directive found using auto-mode-interpreter-regexp"))))


(provide 'custom-functions)
