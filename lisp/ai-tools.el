;; -*- lexical-binding: t; -*-

;;
;; AI development tools
;;

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

(provide 'ai-tools)
