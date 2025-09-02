;; -*- lexical-binding: t; -*-

;;
;; Keys configuration
;;


;; Set C-x c to quit, not C-x C-c
(global-set-key [(control x) (control c)]
                (defun dont-kill-emacs() (interactive)
                       (message "Use C-x c to leave emacs")))
(global-set-key [(control x) c] 'save-buffers-kill-terminal)
(global-set-key "\C-xc" 'save-buffers-kill-terminal)

(global-set-key [pause] 'kill-this-buffer)
(global-set-key [(control tab)] 'other-window)
(global-set-key [f6] 'switch-to-other-buffer)
(global-set-key [(control \`)] 'switch-to-other-buffer)
(global-set-key [(control shift iso-lefttab)] (lambda () (interactive) (other-window -1)))
(global-set-key [(control z)] 'undo)
(global-set-key [f2] 'new-shell)
(global-set-key [(control f2)] 'shell)
(global-set-key [f10] 'call-last-kbd-macro)
(global-set-key [f9] 'compile)
(global-set-key [(alt f9)] 'grep)
(global-set-key [(control f9)] 'grep-find)
(global-set-key [f4] 'next-error)
(global-set-key [f5] 'delete-other-windows)
(global-set-key [(shift f4)] 'previous-error)
(global-set-key [f11] 'kmacro-name-last-macro)

;; Buffer switching
(global-set-key (kbd "C-1") 'delete-other-windows)
(global-set-key (kbd "C-2") 'split-horizontally-change-other-window)
(global-set-key (kbd "C-3") 'split-vertically-change-other-window)
(global-set-key (kbd "C-0") 'delete-window)

;; More convenient mark bindings (we override C-SPC later on)
(global-set-key (kbd "C-c m") 'set-mark-command)
(global-set-key (kbd "C-c C-m") 'set-mark-command)
;; C-x C-x will exchange point with the mark, here we also highlight it.
(global-set-key (kbd "C-S-x C-S-x") 'exchange-point-and-mark)
(global-set-key (kbd "C-x <up>") 'pop-to-mark-command)
(global-set-key (kbd "C-x C-<up>") 'pop-to-mark-command)


(global-set-key [(f1)] 'man)

;; Use M-/ for company in various things. It's better then dabbrev.
(eval-after-load "elpy"
  '(define-key elpy-mode-map (kbd "M-/") 'elpy-company-backend))
(global-set-key (kbd "M-/") 'company-complete)
;; s-TAB cycles through completions
(global-set-key (kbd "s-TAB") 'company-complete-common-or-cycle)

(global-set-key (kbd "C-c y") 'company-yasnippet)

(global-set-key "\M-g" 'goto-line)
(global-set-key (kbd "s-g") 'goto-line)
(global-set-key [(control meta b)] 'toggle-truncate-lines)

(global-set-key "\M-\\" 'shell-command-on-region-inplace)

(global-set-key (kbd "C-c b") 'browse-url)

(global-set-key (kbd "C-c r") 'revert-buffer)

(global-set-key (kbd "M-3") 'comment-region)
(global-set-key (kbd "M-#") 'uncomment-region) ;; This is actually M-S-3

;; C-Mode - When pressing on Enter, the next line should be indented. Also, allow to make a newline without indendation.

(eval-after-load "cc-mode"
  '(progn
     (define-key c-mode-base-map (kbd "RET") 'newline-and-indent)
     (define-key c-mode-base-map [(shift return)] 'newline)
     ;; C-Scope keys
     (define-key c-mode-base-map (kbd "C-c h") 'c-insert-header-guard)
     ))

;; ggtags

(eval-after-load "ggtags-mode"
  '(progn
     (define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)

     (define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
     (define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
     (define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
     (define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
     (define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)
     (define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)
     ))


(fset 'python-breakpoint
   [up end return ?i ?m ?p ?o ?r ?t ?  ?p ?d ?b ?\; ?  ?p ?d ?b ?. ?s ?e ?t ?_ ?t ?r ?a ?c ?e ?\( ?\) down])

;; Undo the idiotic Python C-backspace, this will be set back to default
;(eval-after-load "python-mode"
;  '(progn
;     (define-key py-mode-map [(control backspace)] nil)
;     (define-key py-mode-map (kbd "C-c C-b") 'python-breakpoint)
;     (define-key py-mode-map (kbd "C-c C-u") 'string-inflection-python-style-cycle)
;     ))


(global-set-key (kbd "C-c C-q") 'prettify)

(provide 'keys)
