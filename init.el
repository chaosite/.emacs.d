;; -*- lexical-binding: t; -*-
;;
;; Initial Emacs load file
;;
;(byte-recompile-directory (expand-file-name "~/.emacs.d") 0)

;; Set up ELPA repos
(setq load-prefer-newer t)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Try: $ gpg --homedir .emacs.d/elpa/gnupg --keyserver keyserver.ubuntu.com --receive-keys F8D0B4E7D2D21191
;; (add-to-list 'package-archives
;;             '("user42" . "https://download.tuxfamily.org/user42/elpa/packages/") t)

;; Add the given path to the load-path variable.
(defun add-to-load-path (path-string)
  (message (format "Passed %S..." path-string))
  (if (stringp path-string)
      (when (file-exists-p path-string)
        (message (format "Adding %S to load-path..." path-string))
        (add-to-list 'load-path (expand-file-name path-string)))
    (crs-add-to-load-path (car path-string))
    (if (cdr path-string)
        (crs-add-to-load-path (cdr path-string)))))

(add-to-load-path (expand-file-name "~/.emacs.d/lisp"))

(setq backup-directory-alist '(("." . "~/.emacs.d/saves")))

;; initialize packages
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; This is only needed once, near the top of the file
(eval-when-compile
  (require 'use-package))

;; Auto compile elisp files
(use-package auto-compile
  :ensure t
  :init
  (setq auto-compile-display-buffer nil)
  (setq auto-compile-mode-line-counter t)
  :config
  (auto-compile-on-load-mode +1)
  (auto-compile-on-save-mode +1))

;; load the custom settings file which sets most everything up
(require 'settings)
(require 'quick-yes)

;; Make Emacs split horizontally by default (i.e when doing grep/completion/C-h b)
(setq split-height-threshold nil)
(setq split-width-threshold nil)

;; Turn off bell alarms
(setq ring-bell-function 'ignore)

;; Turn off welcome screen
(setq inhibit-startup-message t)

;; Set a nice scratch message
(setq initial-scratch-message ";; welcome, h4x0r.

")

;; load theme
(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t)
  (enable-theme 'zenburn))

;; Load keys the last, in order to override bad key bindings
(require 'keys)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bell-volume 0)
 '(blink-cursor-mode nil)
 '(blink-matching-paren t)
 '(compilation-scroll-output t)
 '(frame-brackground-mode 'dark)
 '(global-font-lock-mode t nil (font-lock))
 '(indent-tabs-mode nil)
 '(jiralib-update-issue-fields-exclude-list :components)
 '(linum-format " %6d ")
 '(load-home-init-file t t)
 '(main-line-separator-style 'chamfer)
 '(org-agenda-files '("~/org/agenda/tasks.org"))
 '(package-selected-packages
   '(aider all-the-icons-ivy-rich amx auctex-latexmk auto-compile blackout capnp-mode clang-format+ company-quickhelp
           consult counsel-projectile eglot find-file-in-project forge format-all google-c-style latex-pretty-symbols
           lua-mode marginalia nerd-icons-completion orderless org-jira powerline protobuf-ts-mode python-black pyvenv
           rainbow-mode sqlite3 ssh-config-mode string-inflection tide vertico vue-mode web-mode zenburn-theme))
 '(powerline-color1 "#222912")
 '(powerline-color2 "#09150F")
 '(proof-three-window-mode-policy 'hybrid)
 '(standard-indent 4)
 '(warning-suppress-log-types '((comp))))
