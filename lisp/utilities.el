;; -*- lexical-binding: t; -*-

;;
;; Utility packages and tools
;;

;; string inflections (camelize stuff)
(use-package string-inflection
  :ensure t
  :bind (:map prog-mode-map
              ("C-c C-u" . string-inflection-all-cycle)))

(provide 'utilities)
