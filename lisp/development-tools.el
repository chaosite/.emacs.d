;; -*- lexical-binding: t; -*-

;;
;; Development tools (LSP, linting, formatting, etc.)
;;

;; Eglot LSP
(use-package eglot
  :ensure t
  :defer t
  :hook ((python-ts-mode . eglot-ensure)))

;; Show box with documentation
(use-package eldoc-box
  :ensure t
  :after eglot
  :hook (eglot-managed-mode . eldoc-box-hover-at-point-mode)
  :custom
  (add-to-list 'eglot-ignored-server-capabilites :hoverProvider))


;; Python virtual environment
(use-package pyvenv
  :ensure t
  :config
  (pyvenv-activate "~/.venv/"))

;; clang-format
(use-package clang-format+
  :ensure t
  :hook (c-mode-common-hook . clang-format+-mode))

;; google c++ style
(use-package google-c-style
  :ensure t
  :hook (c-mode-common-hook . google-set-c-style))

;; TypeScript/Web development tools
(use-package flycheck
  :ensure t
  :defer t
  :blackout flycheck-mode
  :init
  (setq flycheck-check-syntax-automatically '(save mode-enabled)))

(use-package tide
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (typescript-mode . flycheck-mode)
         (before-save . tide-format-before-save)))


(provide 'development-tools)
