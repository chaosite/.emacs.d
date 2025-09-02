;; -*- lexical-binding: t; -*-

;;
;; Project management (Projectile, Magit, etc.)
;;

;; projectile
(use-package projectile
  :ensure t
  :bind ((:map projectile-mode-map
               ("C-c p" . projectile-command-map)))
  :demand t
  :init
  (setq projectile-mode-line-prefix " 🚧")
  :config
  (setq projectile-completion-system 'ivy
        projectile-enable-caching t)
  (setq projectile-globally-ignored-file-suffixes '(".elc" ".pyc" ".o")
        projectile-globally-ignored-files '(".DS_Store" "Icon" "TAGS"))
  (setq projectile-find-dir-includes-top-level t)

  (defun modi/kill-non-project-buffers (&optional kill-special)
    "Kill buffers that do not belong to a `projectile' project.
With prefix argument (`C-u'), also kill the special buffers."
    (interactive "P")
    (let ((bufs (buffer-list (selected-frame))))
      (dolist (buf bufs)
        (with-current-buffer buf
          (let ((buf-name (buffer-name buf)))
            (when (or (null (projectile-project-p))
                      (and kill-special
                           (string-match "^\*" buf-name)))
              (unless (string-match "^\\*\\(\\scratch\\|Messages\\)" buf-name)
                (message "Killing buffer %s" buf-name)
                (kill-buffer buf))))))))

  (defun modi/projectile-find-file-literally (&optional arg)
    "Jump to a project's file literally using completion."
    (interactive "P")
    (projectile-maybe-invalidate-cache arg)
    (projectile-completing-read
     "Find file literally: "
     (projectile-current-project-files)
     :action `(lambda (file)
                (find-file-literally (expand-file-name file ,(projectile-project-root)))
                (run-hooks 'projectile-find-file-hook))))

  (defun modi/projectile-switch-project-magit-status ()
    "Switch to other project and open Magit status there."
    (interactive)
    (let ((projectile-switch-project-action #'magit-status))
      (call-interactively #'projectile-switch-project)))

  (bind-keys
   ("C-c p K" . modi/kill-non-project-buffers)
   ("C-c p r" . projectile-replace-regexp)
   ("C-c s m" . modi/projectile-switch-project-magit-status))

  (projectile-mode))

(use-package find-file-in-project
  :ensure t)

;; magit
(use-package sqlite3
  :ensure t)

(use-package magit
  :ensure t
  :after sqlite3
  :bind (("C-x g" . magit-status)))

(use-package forge
  :ensure t
  :after magit
  :bind ((:map forge-issue-section-map
               ("C-c C-v" . forge-browse-topic))
         (:map forge-pullreq-section-map
               ("C-c C-v" . forge-browse-topic))))

(provide 'project-management)
