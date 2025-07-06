;; -*- lexical-binding: t; -*-

;;
;; Editor behavior and convenience settings
;;

(require 'custom-functions)

;; Turn off bell alarms
(setq ring-bell-function 'ignore)

;; Turn off welcome screen
(setq inhibit-startup-message t)

;; Set a nice scratch message
(setq initial-scratch-message ";; welcome, h4x0r.

")

;; Make Emacs split horizontally by default
(setq split-height-threshold nil)
(setq split-width-threshold nil)

(defun switch-to-other-buffer ()
  (interactive)
  (switch-to-buffer nil))

;; Search and navigation
(setq grep-find-history '("find . -type f -print0 | xargs -0 -e grep -n "))
(setq lazy-highlight-initial-delay '0)

;; Auto-revert all the files
(global-auto-revert-mode)

;; Only disable process kill queries, keep other safety checks
(setq kill-buffer-query-functions
      (delq 'process-kill-buffer-query-function kill-buffer-query-functions))

;; Set firefox as the default browser
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox")

;; Set consistent fill column
(setq-default fill-column 119)

;; Essential backup and history configuration
(setq backup-directory-alist `(("." . ,(expand-file-name "backups" user-emacs-directory)))
      backup-by-copying t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; Enable essential convenience features
(recentf-mode 1)
(save-place-mode 1)
(savehist-mode 1)

;; Prefer spaces to tabs
(setq-default indent-tabs-mode nil)

;; Kill annoying eldoc mode
(global-eldoc-mode -1)

;; Clean up whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace nil t)

(provide 'editor-behavior)
