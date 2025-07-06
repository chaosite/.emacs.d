;; -*- lexical-binding: t; -*-

;;
;; Programming language modes and tree-sitter configuration
;;

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

;; Load built-in tree-sitter modes
(use-package toml-ts-mode)
(use-package yaml-ts-mode)

;; Major mode for Docker files
(use-package dockerfile-ts-mode
  :ensure t
  :mode (("\\[dD]ockerfile\\'" . dockerfile-ts-mode)
         ("\\.dockerignore\\'" . dockerfile-ts-mode)))

;; Major mode for proto files
(use-package protobuf-ts-mode
  :ensure t
  :mode (("\\.proto\\'" . protobuf-ts-mode)))

;; Syntax highlight Cap'n Proto
(require 'capnp-mode)

;; Lark grammar mode
(require 'lark-mode)

;; Lua configuration
(use-package lua-mode
  :ensure t
  :mode "\\.lua$"
  :interpreter "lua"
  :config
  (setq lua-indent-level 4)
  (setq lua-indent-string-contents t))

;; LLVM tree-sitter mode
;(use-package llvm-ts-mode
;  :ensure t
;  :vc (:url "https://github.com/nverno/llvm-ts-mode")
;  :mode "\\.ll$"
;  :init
;  (add-to-list
;   'treesit-language-source-alist
;   '(llvm . ("https://github.com/benwilliamgraham/tree-sitter-llvm.git" "f26ac0d")))
;  (treesit-install-language-grammar 'llvm))

;; Mode for editing .ssh/config
(use-package ssh-config-mode
  :ensure t)

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

(provide 'programming-modes)
