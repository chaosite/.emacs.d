;; -*- lexical-binding: t; -*-

(defconst lark-mode-syntax-table
  (let ((table (make-syntax-table)))
    ;; strings
    (modify-syntax-entry ?\" "\"" table)

    ;; comments
    (modify-syntax-entry ?/ "\" 12" table)
    ;; \n ends comments
    (modify-syntax-entry ?\n ">" table)

    table))

(defconst lark-font-lock-highlights
  '(("^_?[A-Z][A-Z0-9_]*\\(\\.[0-9]+\\)?" . font-lock-variable-name-face)
    ("^[_?]?[a-z][A-Za-z0-9_]*" . font-lock-function-name-face)
    ("^%\\(import\\|ignore\\).*" . font-lock-preprocessor-face)))

(define-derived-mode lark-mode prog-mode "Lark grammar"
  :syntax-table lark-mode-syntax-table
  (setq font-lock-defaults '(lark-font-lock-highlights))
  (font-lock-fontify-buffer))

(provide 'lark-mode)
