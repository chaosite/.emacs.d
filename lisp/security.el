;; -*- lexical-binding: t; -*-

;;
;; Security and authentication settings
;;

;; Look for passwords in .authinfo.gpg
(setq auth-sources
      '((:source "~/.authinfo.gpg")))

;; ask for gpg passwords in the minibuffer
(setq epa-pinentry-mode 'loopback)

(provide 'security)
