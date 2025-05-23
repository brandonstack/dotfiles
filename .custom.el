;; -*- coding: utf-8; lexical-binding: t; -*-

;;; Code:

;; Font
(setq *wsl* (getenv "WSL_DISTRO_NAME"))
(set-face-attribute 'default nil
                    :family "LXGW WenKai Mono"
                    :height (cond (*is-a-mac* 130)
                                  (*win64* 110)
                                  (*wsl* 200)
                                  (t 100)))

;; 小鹤双拼
(require-package 'posframe)
(with-eval-after-load 'pyim
  (setq pyim-default-scheme 'xiaohe-shuangpin))

;; org-journal
(setq org-folder "~/org")
(setq org-task-folder (concat org-folder "/projects"))
(setq org-journal-folder (concat org-folder "/daily"))

(setq org-journal-prefix-key "C-c j ")
(require-package 'org-journal)

(setq org-journal-dir org-journal-folder)
(setq org-journal-date-format "%Y-%m-%d %A") ;; 例如: 2025-05-09 Friday
(setq org-journal-file-format "%Y-%m/%Y-%m-%d.org")

;; beancount mode
(require 'beancount)

;; eat
(require 'eat)
(setq eat-shell "/usr/bin/zsh")
(defun sanityinc/on-eat-exit (process)
    (when (zerop (process-exit-status process))
      (kill-buffer)
      (unless (eq (selected-window) (next-window))
        (delete-window))))
(add-hook 'eat-exit-hook 'sanityinc/on-eat-exit)

(with-eval-after-load 'eat
  (custom-set-variables
   `(eat-semi-char-non-bound-keys
     (quote ,(cons [?\e ?w] (cl-remove [?\e ?w] eat-semi-char-non-bound-keys :test 'equal))))))

(defcustom sanityinc/eat-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "t") 'eat-other-window)
    map)
  "Prefix map for commands that create and manipulate eat buffers.")
(fset 'sanityinc/eat-map sanityinc/eat-map)
(global-set-key (kbd "C-c t") 'sanityinc/eat-map)

(require-package 'org-cliplink)
;; (setq org-capture-templates
;;    '(("K" "Cliplink capture task" entry (file "")
;;       "* TODO %(org-cliplink-capture) \n  SCHEDULED: %t\n" :empty-lines 1)))

(provide 'custom)
