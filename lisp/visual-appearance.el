;; -*- lexical-binding: t; -*-

;;
;; Visual appearance and UI settings
;;

;; UTF-8 forever
(prefer-coding-system 'utf-8)

;; UI elements
(tool-bar-mode -1)
(line-number-mode t)
(column-number-mode t)

;; Font configuration
(set-frame-font "Fira Code-14")
(add-to-list 'default-frame-alist '(font . "Fira Code-14"))

;; Shell mode colors
(setq ansi-color-names-vector ; better contrast colors
      ["black" "orangered" "green4" "yellow4"
       "deepskyblue" "magenta4" "cyan4" "white"])
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; Diff colors
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

;; Whitespace mode: Mark columns that go past 120
(defun prevent-whitespace-mode-for-magit ()
  (not (derived-mode-p 'magit-mode)))
(setq-default whitespace-style '(face empty tabs lines-tail trailing))
(setq-default whitespace-line-column 120)
(global-whitespace-mode t)
(add-function :before-while whitespace-enable-predicate 'prevent-whitespace-mode-for-magit)

;; powerline
(use-package powerline
  :ensure t
  :config
  (powerline-default-theme))

;; activate rainbow mode (look for colors and show them nicely)
(use-package rainbow-mode
  :ensure t
  :hook prog-mode
  :blackout rainbow-mode)

;; Remove stuff from the modeline
(use-package blackout
  :ensure t
  :config
  (blackout 'global-whitespace-mode)
  (blackout 'whitespace-mode)
  (blackout 'auto-revert-mode)
  (blackout 'eldoc-mode)
  (blackout 'company-mode))

;; load theme
(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t)
  (enable-theme 'zenburn))

(provide 'visual-appearance)
