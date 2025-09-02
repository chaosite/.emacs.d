;; -*- lexical-binding: t; -*-

;;
;; Org-mode configuration
;;

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

(provide 'org-config)
