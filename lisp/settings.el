;; -*- lexical-binding: t; -*-

;;
;; Packages, colors, and other settings
;;
(require 'custom-functions)

(defun switch-to-other-buffer ()
  (interactive)
  (switch-to-buffer nil)
)

;; UTF-8 forever
(prefer-coding-system 'utf-8)

;; Run "xlsfonts | grep courier-medium-r" to view available fonts For this font,
;; you should install on your machine the the package xfonts-75dpi.
(set-frame-font "Fira Code-14")

;; Set the default font for new frames. This is helpful when doing
;; new-frame[-on-display] or when running emacsclient.
(add-to-list 'default-frame-alist
             '(font . "Fira Code-14"))

;; Shell mode
(setq ansi-color-names-vector ; better contrast colors
      ["black" "orangered" "green4" "yellow4"
       "deepskyblue" "magenta4" "cyan4" "white"])
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; Get rid of toolbar
(tool-bar-mode -1)

(setq grep-find-history '("find . -type f -print0 | xargs -0 -e grep -n "))
(setq lazy-highlight-initial-delay '0)

;; Some visual things
(line-number-mode t)
(column-number-mode t)

;; Font lock is enabled by default in modern Emacs

;; auto-revert all the files
(global-auto-revert-mode)

;; Set C-x c to quit, not C-x C-c
(global-set-key [(control x) (control c)]
                (defun dont-kill-emacs() (interactive)
                       (message "Use C-x c to leave emacs")))
(global-set-key [(control x) c] 'save-buffers-kill-terminal)
(global-set-key "\C-xc" 'save-buffers-kill-terminal)

;; Colors displayed by diff mode.
(defun update-diff-colors ()
  "update the colors for diff faces"
  (set-face-attribute 'diff-added nil
                      :foreground "white" :background "darkgreen")
  (set-face-attribute 'diff-removed nil
                      :foreground "white" :background "darkred")
  (set-face-attribute 'diff-changed nil
                      :foreground "white" :background "purple"))
(eval-after-load "diff-mode"
  '(update-diff-colors))

;; Only disable process kill queries, keep other safety checks
(setq kill-buffer-query-functions
      (delq 'process-kill-buffer-query-function kill-buffer-query-functions))

;; Set firefox as the default browser.
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox")

;; Set consistent fill column
(setq-default fill-column 119)

;; Look for passwords in .authinfo.gpg
(setq auth-sources
      '((:source "~/.authinfo.gpg")))

;; ask for gpg passwords in the minibuffer
(setq epa-pinentry-mode 'loopback)

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

;; use tree-sitter modes
(setq major-mode-remap-alist
 '((bash-mode . bash-ts-mode)
   (js2-mode . js-ts-mode)
   (typescript-mode . typescript-ts-mode)
   (json-mode . json-ts-mode)
   (css-mode . css-ts-mode)
   (lua-mode . lua-ts-mode)
   (python-mode . python-ts-mode)))

;; interpret "uv run --script" as python
(add-to-list 'interpreter-mode-alist
             '("uv" . python-ts-mode))


;; == Packages ==

;; aider
(use-package aider
  :ensure t
  :config
  (setq aider-program (or (executable-find "aider")
                          (expand-file-name "~/.local/bin/aider"))
        aider-args `("--model" "sonnet"
                     "--cache-prompts"
                     "--cache-keepalive-pings" "6"
                     "--no-auto-commits"
                     "--attribute-co-authored-by"
                     "--no-auto-accept-architect"
;;                     "--lint"
                     "--lint-cmd" "python: uvx ruff check"
                     "--env-file" ,(expand-file-name "~/.config/aider/.env")))
  (global-set-key (kbd "C-c a") 'aider-transient-menu)
  (aider-magit-setup-transients))

;; powerline
(use-package powerline
  :ensure t
  :config
  (powerline-default-theme))

;; toml-ts-mode comes with emacs but we need to load it so it's added to the auto-mode-alist
(use-package toml-ts-mode)
(use-package yaml-ts-mode)

(use-package pyvenv
  :ensure t
  :config
  (pyvenv-activate "~/.venv/"))

;; Eglot LSP
(use-package eglot
  :ensure t
  :defer t
  :hook ((python-ts-mode . eglot-ensure)))

;; Major mode for Docker files
(use-package dockerfile-ts-mode
  :ensure t
  :mode (("\\[dD]ockerfile\\'" . dockerfile-ts-mode)
         ("\\.dockerignore\\'" . dockerfile-ts-mode)))

;; Major mode for proto files
(use-package protobuf-ts-mode
  :ensure t
  :mode (("\\.proto\\'" . protobuf-ts-mode)))

;; LaTeX settings
(use-package latex
  :ensure auctex
  :mode ("\\.tex\\'" . latex-mode)
  :functions font-latex-add-keywords
  :bind
  ("C-c /" . latex-close-block)
  :hook ((plain-TeX-mode-hook . (lambda ()
                                  (set (make-local-variable 'TeX-electric-math)
                                       (cons "$" "$"))))
         (LaTeX-mode-hook . (lambda () (set (make-local-variable 'TeX-electric-math)
                                            (cons "\\(" "\\)"))))
         (LaTeX-mode-hook . visual-line-mode)
         (LaTeX-mode-hook . flyspell-mode)
         (LaTeX-mode-hook . LaTeX-math-mode)
         (LaTeX-mode-hook . turn-on-reftex)
         (LaTeX-mode-hook . turn-on-auto-fill)
         (LaTeX-mode-hook . autoref-latex-mode-hook))
  :config
  (add-to-list 'LaTeX-indent-environment-list
               '("itemize" LaTeX-indent-item))
  (add-to-list 'LaTeX-indent-environment-list
               '("enumerate" LaTeX-indent-item))
  (add-to-list 'LaTeX-indent-environment-list
               '("description" LaTeX-indent-item))
  (defun autoref-latex-mode-hook ()
    (font-latex-add-keywords '(("autoref" "*{") ("Autoref" "{") ("nameref" "*{"))
                             'reference))
  (add-to-list 'TeX-command-list '("Make" "make" TeX-run-compile nil t))
  (setq LaTeX-indent-level 2
        LaTeX-indent-level-item-continuation 8
        bibtex-text-indentation 2
        bibtex-contline-indentation 4
        bibtex-entry-offset 0
        bibtex-align-at-equal-sign nil
        bibtex-entry-format '(numerical-fields
                              page-dashes
                              last-comma
                              delimiters
                              unify-case))
  (setq-default TeX-auto-save t
                TeX-parse-self t
                TeX-master nil
                TeX-PDF-mode t
                TeX-engine 'xetex
                TeX-source-correlate-mode t
                TeX-view-program-selection (quote ((engine-omega "dvips and gv")
                                                   (output-dvi "xdvi")
                                                   (output-pdf "Okular")
                                                   (output-html "xdg-open"))))
  )

(add-hook 'before-save-hook 'delete-trailing-whitespace nil t)

;; Make symbols pretty in LaTeX
(use-package latex-pretty-symbols
  :ensure t)

(defun my-auctex-latexmk-advice (req feature &rest args)
  "Call REQ with FEATURE and ARGS, unless FEATURE is `tex-buf'."
  (unless (eq feature 'tex-buf)
    (apply req feature args)))

;; Add compilation with latexmk to AucTeX
(use-package auctex-latexmk
  :ensure t
  :after latex
  :init
  (advice-add 'require :around #'my-auctex-latexmk-advice)
  (auctex-latexmk-setup)
  (advice-remove 'require #'my-auctex-latexmk-advice)
  )

;; projectile
(use-package projectile
  :ensure t
  :bind ((:map projectile-mode-map
               ("C-c p" . projectile-command-map)))
  :demand t ; We need projectile immediatly
  :init
  (setq projectile-mode-line-prefix " 🚧")
  :config

  (setq projectile-completion-system 'ivy
        projectile-enable-caching t)

  ;; ignore some common files for projectile
  (setq projectile-globally-ignored-file-suffixes '(".elc" ".pyc" ".o")
        projectile-globally-ignored-files '(".DS_Store" "Icon" "TAGS"))

  ;; include the project root directory in projectile-find-dir list
  (setq projectile-find-dir-includes-top-level t)

  ;; http://emacs.stackexchange.com/a/10187/115
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
              ;; Preserve buffers with names starting with *scratch or *Messages
              (unless (string-match "^\\*\\(\\scratch\\|Messages\\)" buf-name)
                (message "Killing buffer %s" buf-name)
                (kill-buffer buf))))))))

  (defun modi/projectile-find-file-literally (&optional arg)
    "Jump to a project's file literally (see `find-file-literally') using
completion.  With a prefix ARG invalidates the cache first.
Using this function over `projectile-find-file' is useful for opening files that
are slow to open because of their major mode. `find-file-literally' always opens
files in Fundamental mode."
    (interactive "P")
    (projectile-maybe-invalidate-cache arg)
    (projectile-completing-read
     "Find file literally: "
     (projectile-current-project-files)
     :action `(lambda (file)
                (find-file-literally (expand-file-name file ,(projectile-project-root)))
                (run-hooks 'projectile-find-file-hook))))

  (bind-keys
   ("C-c p K" . modi/kill-non-project-buffers)
   ("C-c p r" . projectile-replace-regexp)
   ("C-c s m" . modi/projectile-switch-project-magit-status))


  (defun modi/projectile-switch-project-magit-status ()
    "Switch to other project and open Magit status there."
    (interactive)
    (let ((projectile-switch-project-action #'magit-status))
      (call-interactively #'projectile-switch-project)))

  (projectile-mode))

(use-package find-file-in-project
  :ensure t)

;; clang-format
(use-package clang-format+
  :ensure t
  :hook (c-mode-common-hook . clang-format+-mode))

;; google c++ style
(use-package google-c-style
  :ensure t
  :hook (c-mode-common-hook . google-set-c-style))

;; company mode (auto completions)
(use-package company
  :ensure t
  :init
  (setq company-tooltip-align-annotations t
        company-show-quick-access t
        company-minimum-prefix-length 1
        company-idle-delay 0.0)
  :config (global-company-mode)
  :blackout company-mode)

(use-package company-quickhelp
  :ensure t
  :after company
  :config
  (company-quickhelp-mode))


;; TypeScript setup
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

;; React/Node.js/Vue settings
(use-package web-mode
  :ensure t
  :blackout "🌎"
  :mode
  (("\\.phtml\\'" . web-mode)
  ("\\.tpl\\.php\\'" . web-mode)
  ("\\.jsp\\'" . web-mode)
  ("\\.as[cp]x\\'" . web-mode)
  ("\\.erb\\'" . web-mode)
  ("\\.mustache\\'" . web-mode)
  ("\\.djhtml\\'" . web-mode)
  ("\\.jst.ejs\\'" . web-mode)
  ("\\.html?\\'" . web-mode)
  ("\\.jsx?$" . web-mode)
  ("\\.tsx\\'" . web-mode))
  :init
  (setq web-mode-enable-block-face t
        web-mode-enable-comment-keywords t
        web-mode-enable-current-element-highlight t
        web-mode-enable-current-column-highlight t
        web-mode-script-padding 2
        web-mode-style-padding 2
        web-mode-comment-style 2
        web-mode-code-indent-offset 2
        web-mode-markup-indent-offset 2))

(use-package vue-mode
  :ensure t
  :mode (("\\.vue\\'" . vue-mode)))


;; Lua configuration
(use-package lua-mode
  :ensure t
  :mode "\\.lua$"
  :interpreter "lua"
  :config
  (setq lua-indent-level 4)
  (setq lua-indent-string-contents t))

;; activate rainbow mode (look for colors and show them nicely)
(use-package rainbow-mode
  :ensure t
  :hook prog-mode
  :blackout rainbow-mode)

;; Whitespace mode: Mark columns that go past 120
;; But actually, don't enable in magit buffers (consider giving up on global?)
(defun prevent-whitespace-mode-for-magit ()
  (not (derived-mode-p 'magit-mode)))
(setq-default whitespace-style '(face empty tabs lines-tail trailing))
(setq-default whitespace-line-column 120)
(global-whitespace-mode t)
(add-function :before-while whitespace-enable-predicate 'prevent-whitespace-mode-for-magit)

;; Prefer spaces to tabs
(setq-default indent-tabs-mode nil)

;; Kill fucking annoying eldoc mode which jumps to definition when I don't want it
(global-eldoc-mode -1)

;; Syntax highlight Cap'n Proto
(use-package capnp-mode
  :ensure t
  :mode "\\.capnp\\'")

;; Org-mode stuff
(use-package org
  :init
  (setq org-agenda-files '("~/org/agenda")
        org-agenda-start-on-weekday 0
        org-columns-default-format
        "%60ITEM(Task) %8Effort(Estim){:} %40DEADLINE(Deadline) %40SCHEDULED(Schedule)"))

;; org-jira stuff
(use-package org-jira
  :after org
  :ensure t
  :init
  (setq jiralib-url "https://airis-labs.atlassian.net"
        jiralib-update-issue-fields-exclude-list '(components reporter)))


;; vertico/marginalia/consult
(use-package vertico
  :ensure t
  :bind (:map vertico-map
              ("C-j" . vertico-next)
              ("C-k" . vertico-previous)
              ("C-f" . vertico-exit))
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode))

;; Configure directory extension -- makes find-file work like counsel-find-file
(use-package vertico-directory
  :after vertico
  :ensure nil
  ;; More convenient directory navigation commands
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("<backspace>" . vertico-directory-delete-word))
  ;; Tidy shadowed file names
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(use-package savehist
  :init (savehist-mode))

(use-package recentf
  :init (recentf-mode))

(use-package marginalia
  :after vertico
  :ensure t
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

(use-package nerd-icons-completion
  :after marginalia
  :ensure t
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons
  :ensure t)

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package consult
  :ensure t
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
)



;; Coq/iris
;(use-package proof-general
;  :mode ("\\.v'" . coq-mode)
;  :ensure t
;  :init
;  (dolist (var (car (read-from-string
;                     (shell-command-to-string
;                      "~/.local/bin/opam config env --sexp"))))
;    (setenv (car var) (cadr var)))
;  (setq coq-prog-name "/home/mip/.opam/default/bin/coqtop"))

;(use-package company-coq
;  :ensure t
;  :after company proof-general)

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

;; string inflections (camelize stuff)
(use-package string-inflection
  :ensure t
  :bind (:map prog-mode-map
              ("C-c C-u" . string-inflection-all-cycle)))

;; Mode for editing .ssh/config
(use-package ssh-config-mode
  :ensure t)

;; Remove stuff I always use from the modeline
(use-package blackout
  :ensure t
  :config
  (blackout 'global-whitespace-mode)
  (blackout 'whitespace-mode)
  (blackout 'auto-revert-mode)
  (blackout 'eldoc-mode)
  (blackout 'company-mode))

(provide 'settings)
