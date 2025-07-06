;; -*- lexical-binding: t; -*-

;;
;; LaTeX configuration
;;

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
                                                   (output-html "xdg-open")))))

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
  (advice-remove 'require #'my-auctex-latexmk-advice))

(provide 'latex-setup)
