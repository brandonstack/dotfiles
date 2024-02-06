(use-package org-roam)

;; org-mode
(defun org-mode-setup ()
  (org-indent-mode)
  ;; (variable-pitch-mode 1)
  (visual-line-mode 1))

(defun org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                            (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 0.9)
                  (org-level-6 . 0.8)
                  (org-level-7 . 0.8)
                  (org-level-8 . 0.8)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face))))

(use-package org
  :hook (org-mode . org-mode-setup)
  :config
  (setq org-ellipsis " ▾")
  (setq org-directory "~/Workspace/xing.org")
  (setq org-agenda-files '("~/Workspace/xing.org/tasks"))
  (setq org-default-notes-file (concat org-directory "/tasks/refile.org"))

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-cycle-separator-lines -1)

  (setq org-todo-keywords
   '((sequence "TODO(t)" "NEXT(n)" "ONGOING(o)" "|" "DONE(d)")
     (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)")))
  (setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "yellow" :weight bold)
	      ("ONGOING" :foreground "orange" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold))))
  (setq org-use-fast-todo-selection t)
  (setq org-agenda-custom-commands
      '(("w" "Work Agenda"
         ((agenda "" ((org-agenda-span 1)))
	  (tags      "+WORK+TODO=\"ONGOING\""
		     ((org-agenda-overriding-header "Ongoing Tasks")))
          (tags      "+WORK+TODO=\"NEXT\""
                     ((org-agenda-overriding-header "Next Tasks")
		      (org-agenda-sorting-strategy '(todo-state-down priority-down))))
          (tags-todo "+WORK+TODO=\"TODO\""
                     ((org-agenda-overriding-header "To-Do Tasks")))
          (tags-todo "+:WORK:/HOLD|WAITING"
                     ((org-agenda-overriding-header "Hold/Waiting Tasks"))))
         nil
         nil)))

  (org-font-setup))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("✸" "✤" "❇")))

(defun org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . org-mode-visual-fill))

;; org-roam
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/Workspace/xing.org/slipbox/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ;; ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ;; ("C-c n j" . org-roam-dailies-capture-today)
	 )
  :config
  (org-roam-db-autosync-mode))

(use-package org-roam-ui
    :after org-roam
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(use-package org-cliplink)
(use-package org-pomodoro)

(provide 'init-org)
