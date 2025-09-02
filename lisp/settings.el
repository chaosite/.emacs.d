;; -*- lexical-binding: t; -*-

;;
;; Main configuration file - loads all other configuration modules
;;

;; Load configuration modules
(require 'visual-appearance)
(require 'editor-behavior)
(require 'security)
(require 'programming-modes)
(require 'development-tools)
(require 'latex-setup)
(require 'completion-framework)
(require 'project-management)
(require 'ai-tools)
(require 'org-config)
(require 'utilities)
(require 'custom-functions)
(require 'user-macros)

(provide 'settings)
