;;;; system setup

;;; Variables
(setq user-home-dir (expand-file-name (getenv "USERPROFILE")))
(setq org-folder (concat user-home-dir "/Workspace/SecondBrain"))
(setq org-tasks-folder (concat user-home-dir "/Workspace/SecondBrain/projects"))
(defvar my/frame-transparency '(95 . 95))
;;; end of variables

;;; Package management
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                       ;;  ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; straight
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
;; Configure straight.el
;; (straight-use-package 'use-package)
;; (setq straight-use-package-by-default t)

;; automatic package updates
(use-package auto-package-update
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-prompt-before-update t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe)
  (auto-package-update-at-time "09:00"))
;;; end of package management

;;; configs
(setq default-directory user-home-dir)
(defalias 'yes-or-no-p 'y-or-n-p)

;; Encoding
(set-locale-environment)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))
;;; end of configs

;;; ivy, counsel, swiper
(use-package better-defaults)
(use-package swiper)
(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-<tab>" . counsel-switch-buffer)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
         ("C-c C-q" . counsel-org-tag))
	 ;; :map minibuffer-local-map
	 ;; ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)) ; Don't start with ^

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

;; 主要作用是在 ivy 的完成列表中添加更丰富的信息
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))
;;; end of ivy, counsel, swiper

;;; helpful
(use-package helpful
  :custom
  ; 让counsel调用这个函数
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ; 将键位重新绑定
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))
;;; end of helpful
;;;; end of system setup

;;;; UI
;;; basic config
;; startup message
(setq inhibit-startup-message t)
;; bars
(scroll-bar-mode -1)        ; disable visual scrollbar
(tool-bar-mode -1)          ; disable the toolbar
(tooltip-mode -1)           ; diable tooltips
(set-fringe-mode 10)        ; got some breathing room
(menu-bar-mode -1)          ; disable menu bar
;; setup visiable bell
(setq visible-bell t)
;; fonts
;; (set-face-attribute 'default nil :font "LXGW WenKai Mono" :height 140)
;; (set-fontset-font "fontset-default" nil "LXGW WenKai Mono")
;; 字体设置增强
;; 主字体设置
(set-face-attribute 'default nil :font "LXGW WenKai Mono" :height 140)

;; Unicode符号覆盖
(dolist (ft (fontset-list))
  (set-fontset-font ft 'unicode "LXGW WenKai Mono" nil 'prepend)
  (set-fontset-font ft 'unicode "Segoe UI Symbol" nil 'append)
  (set-fontset-font ft 'unicode "Symbola" nil 'append)
  (set-fontset-font ft 'unicode "Noto Color Emoji" nil 'append))

;;; end of basic config

;;; theme
(use-package all-the-icons)
(use-package nerd-icons)
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))
(use-package doom-themes
  :config
  (load-theme 'doom-gruvbox t))
;;; end of theme

;;; frame transparency
(set-frame-parameter (selected-frame) 'alpha my/frame-transparency)
(add-to-list 'default-frame-alist `(alpha . ,my/frame-transparency))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;;; end of frame transparency

;;; number line
(column-number-mode)
(global-display-line-numbers-mode t)
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook
		pdf-view-mode))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))
;;; end of number line

;;; window
(use-package olivetti
  :ensure t
  :config
  (setq olivetti-body-width 100)  ;; Width in characters
  (setq olivetti-minimum-body-width 80))

;; tree
(use-package neotree
  :ensure t
  :bind ("C-x C-n" . neotree-toggle)
  :config (setq neo-smart-open t))
;;; end of window

;;; plugins
;; rainbow-delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
;; page-break-lines
(use-package page-break-lines
  :ensure t
  :config
  (setq page-break-lines-character ?=
        page-break-lines-face '(:weight bold))
  (eval-after-load 'page-break-lines
    '(global-page-break-lines-mode 1)))
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))
;;; end of plugins
;;;; end of UI

;;;; Keybindings and Shortcuts
;;; 快捷键提示
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;;; jump
;; ace jump
(use-package ace-jump-mode
  :ensure t
  :bind ("M-j" . ace-jump-mode))
;; window move
(use-package ace-window
  :config
  :bind (("M-o" . ace-window))
  :requires (avy)
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))
;;; end of jump

;;; open files
;; init file
(defun open-init-file ()
  "Open the init file."
  (interactive)
  (find-file user-init-file))
;; custom keybindings
(global-set-key (kbd "C-c i") 'open-init-file)

(defun open-org-folder ()
  "Open the org files."
  (interactive)
  (find-file org-folder))
(global-set-key (kbd "C-c o") 'open-org-folder)
;;; end of open files

;;; custom keybinding
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)
(global-set-key (kbd "C-x q") 'save-buffers-kill-emacs)
;;; end of custom keybinding
;;;; end of keybinding & shortcut

;;;; org-mode
(defun org-mode-setup ()
  (org-indent-mode) ;; 启用Org模式缩进功能
  ; (variable-pitch-mode 1) ;; 使用可变宽度的字体
  (visual-line-mode 1)) ;; 长行会自动换行显示

(defun org-font-setup ()
  ;; Set body font in org-mode.
  (set-face-attribute 'org-default nil :font "LXGW WenKai Mono" :height 120)

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 0.9)
                  (org-level-6 . 0.8)
                  (org-level-7 . 0.8)
                  (org-level-8 . 0.8)))
    (set-face-attribute (car face) nil :font "LXGW WenKai Mono" :weight 'regular :height (cdr face))))

(defun org-capture-setup ()
  "Setup org-mode capture templates."
  (setq org-capture-templates
        (quote (("t" "todo" entry (file org-default-notes-file)
                 "* TODO %?\n%U\n%a\n")
                ("n" "note" entry (file org-default-notes-file)
                 "* %? :NOTE:\n%U\n%a\n")
                ("w" "work" entry (file+headline (concat org-tasks-folder "/work.org") "Inbox")
                 "* NEXT %? :REFILE:\n%U\n%a\n")
                ))))

(defun org-todo-setup ()
  "Setup org-mode todo keywords and faces."
  (setq org-todo-keywords
        '((sequence "TODO(t)" "INPROGRESS(p)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
  (setq org-todo-keyword-faces
        (quote (("TODO" :foreground "red" :weight bold)
                ("NEXT" :foreground "tomato" :weight bold)
                ("DONE" :foreground "forest green" :weight bold)
                ("WAITING" :foreground "orange" :weight bold)
                ("CANCELLED" :foreground "forest green" :weight bold))))
  (setq org-use-fast-todo-selection t))

(defun org-agenda-setup ()
  "Setup org-agenda with custom commands for personal and work views."
  (setq org-agenda-files (directory-files-recursively org-tasks-folder "\\.org$"))

  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-agenda-start-with-log-mode t)
  (setq org-agenda-span 7) ;; default show tasks of 7 days

  ;; 高亮过期的任务
  (setq org-agenda-skip-deadline-prewarning-if-scheduled t)
  (setq org-agenda-skip-scheduled-if-deadline-is-shown t)
  
  ;; Define categories or tags for filtering
  (setq org-tag-alist '(("work" . ?w)
                        ("project" . ?p)
                        ("people" . ?e)
                        ))
  ;; Priority
  (setq org-highest-priority ?A)
  (setq org-lowest-priority ?C)
  (setq org-default-priority ?B)
  
  ;; Custom agenda views
  (setq org-agenda-custom-commands
        '(("w" "Work Tasks" 
           ((agenda "" ((org-agenda-span 'day)
                        (org-deadline-warning-days 7)
                        (org-agenda-start-day nil)
                        (org-agenda-skip-function nil)
                        (org-agenda-prefix-format '((agenda . " %i %-12:c%?-12t% s")))
                        (org-agenda-overriding-header "Today's Schedule")))
            (tags-todo "work"
                       ((org-agenda-overriding-header "Work Tasks")
                        (org-agenda-files org-agenda-files)
                        (org-agenda-todo-ignore-scheduled t)
                        (org-agenda-sorting-strategy '(priority-down category-keep todo-state-down))
                        (org-agenda-prefix-format '((tags . " %i %-12:c [%e] ")))
                        (org-agenda-group-by-todo-keyword t))))
           ((org-agenda-compact-blocks t)))
          
          ("p" "Personal Tasks" tags-todo "-work"
           ((org-agenda-overriding-header "Personal Agenda")
            (org-agenda-files org-agenda-files)
            (org-agenda-todo-ignore-scheduled t)))
          
          ("n" "Next Actions" todo "NEXT"
           ((org-agenda-overriding-header "Next Actions")
            (org-agenda-files org-agenda-files))))))

(use-package org
  :hook (org-mode . org-mode-setup)
  :config
  (setq org-directory org-folder)
  (setq org-default-notes-file (concat org-tasks-folder  "/refile.org"))
  (setq org-cycle-separator-lines -1)
  (setq org-agenda-window-setup 'current-window) ; make agenda display in current window

  ;; Improve org mode looks
  (setq-default org-startup-indented t
                org-pretty-entities t
                org-use-sub-superscripts "{}"
                org-hide-emphasis-markers t
                org-startup-with-inline-images t
                org-image-actual-width '(300))
  (org-font-setup)
  (org-todo-setup)
  (org-capture-setup)
  (org-agenda-setup))

;; PROJECT tag for project
(setq org-stuck-projects
      '("+project/-DONE" ("NEXT") nil ""))

;; Center Org Buffers
(defun org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . org-mode-visual-fill))
;;; end of org-mode

;;; org-roam
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename org-folder))
  (org-roam-dailies-directory "daily/")
  (org-roam-dailies-capture-templates
   '(("d" "default" entry
      "* %?"
      :target (file+head "%<%Y-%m-%d>.org"
                         "#+title: %<%Y-%m-%d>\n\n"))))
    ;; 定义PARA文件夹的node capture templates
  (org-roam-capture-templates
   '(("p" "project" plain
      "* Inbox\n\n* Tasks\n%?"
      :target (file+head "projects/%<%Y%m%d%H%M%S>-${slug}.org"
                         "#+title: ${title}\n#+filetags: \n")
      :unnarrowed t)
     
     ("a" "area" plain
      "* %?"
      :target (file+head "areas/%<%Y%m%d%H%M%S>-${slug}.org"
                         "#+title: ${title}\n#+filetags: \n")
      :unnarrowed t)
     
     ("r" "resource" plain
      "* 内容摘要\n%?\n\n* 详细笔记\n\n* 参考来源"
      :target (file+head "resources/%<%Y%m%d%H%M%S>-${slug}.org"
                         "#+title: ${title}\n#+filetags: \n")
      :unnarrowed t)
     
    ;;  ("A" "archive" plain
    ;;   "* 归档原因\n%?\n\n* 原始内容\n\n* 相关历史"
    ;;   :target (file+head "archives/${slug}.org"
    ;;                      "#+title: ${title}\n#+filetags: :archive:\n")
    ;;   :unnarrowed t)
      ))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ;; ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n d" . org-roam-dailies-capture-today)
         )
  :config
  (org-roam-db-autosync-mode))

(use-package org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t)
  :bind (
         ("C-c n u" . org-roam-ui-open)))
;;; end of org-roam

;;; org plugins
(use-package org-cliplink)
(use-package org-pomodoro)
(use-package org-download
  :ensure t
  :requires (async)
  ;; Drag-and-drop to `dired`
  :config
  (add-hook 'dired-mode-hook 'org-download-enable)
  ;; The default value is nil, which means use `default-directory'.
  ;; (setq-default org-download-image-dir ".")
  (setq-default org-download-method 'directory)
  ;; (setq-default org-download-screenshot-method "screencapture -i %s")
  (setq-default org-download-heading-lvl nil)
  (setq-default org-download-image-dir "./images")
  ;; have an issue in emacs 29 on drag drop
  )
;;; end of org plugins
;;;; end of org-mode

;;;; dev

;;; config
(setq-default indent-tabs-mode nil) ; tab to whitespace
(setq-default tab-width 4) ; tab width: 4
(add-hook 'prog-mode-hook 'hs-minor-mode)
;;; end of config

;;; lsp
(use-package lsp-mode
  ;; :hook ((prog-mode . lsp))
  :config (setq lsp-keymap-prefix "C-c l"))
;;; end of lsp-mode

;;; dev functions
;; company
(use-package company
  :config
  (global-company-mode t))
;; end of company

;;; end of dev functions

;;; plugins
;; commenting
(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))
;; magit
(use-package magit
  :bind (("C-x g" . magit-status)))

;; projectile
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (setq projectile-project-search-path '((concat user-home-dir "/Workspace") (concat user-home-dir "/source"))))
(use-package counsel-projectile
  :ensure t
  :config (counsel-projectile-mode))
;;; end of plugins

;;; languages
;;json
(use-package json-mode
  :ensure t
  :requires (json-snatcher))

;; markdown
(use-package markdown-mode)
;;; end of languages

;;; shell

;;; end of shell

;;;; end of dev


;;;; AI
(use-package copilot-chat)
;; (use-package copilot
;;   :straight (:host github :repo "copilot-emacs/copilot.el" :files ("*.el"))
(straight-use-package
 '(copilot :type git :host github :repo "copilot-emacs/copilot.el" :files ("*.el")))
(straight-use-package 'gptel)

;; gpt4o
(defvar my-gpt4o-key (getenv "gpt4o-key")
  "OpenAI API key.")
(defvar my-deepseekr1-key (getenv "deepseek-r1-key")
  "Azure Deepseek R1 Key")
(setq
 gptel-model 'gpt-4o
 gptel-backend (gptel-make-azure "Azure-gpt4o"
                 :protocol "https"
                 :host "lxxde-m6bnrv1a-eastus2.cognitiveservices.azure.com"
                 :endpoint "/openai/deployments/xingli-OpenAI-gpt-4o/chat/completions?api-version=2024-10-21"
                 :stream t
                 :key my-gpt4o-key
                 :models '(gpt-4o)))

;; (setq gptel-model   'deepseek-reasoner
;;       gptel-backend (gptel-make-azure "Azure-DeepSeek-R1"
;;                       :protocol "https"
;;                       :host "ai-lxxdev6505ai034602906926.services.ai.azure.com"
;;                       :endpoint "/models/chat/completions?api-version=2024-05-01-preview"
;;                       :stream t
;;                       :key my-deepseekr1-key
;;                       :models '(DeepSeek-R1)))


;;;; end of AI

;;;; personal config
;; Function to pull changes from a Git repository
(defun my/git-pull-repo (directory)
  "Pull the latest changes for a Git repository in DIRECTORY."
  (interactive "DRepository directory: ")
  (when (file-exists-p (expand-path-join directory ".git"))
    (let ((default-directory directory))
      (message "Pulling latest changes for %s..." directory)
      (shell-command "git pull")
      (message "Done pulling changes for %s." directory))))

;; Function to commit and push changes with a message
(defun my/git-push-repo (directory commit-msg)
  "Commit and push changes in the Git repository at DIRECTORY."
  (interactive 
   (let* ((dir (read-directory-name "Repository directory: "))
          (msg (read-string (format "Commit message for %s: " dir))))
     (list dir msg)))
  (when (file-exists-p (expand-path-join directory ".git"))
    (let ((default-directory directory))
      (message "Pushing changes for %s..." directory)
      (shell-command "git add .")
      (shell-command (format "git commit -m \"%s\"" commit-msg))
      (shell-command "git push")
      (message "Changes pushed to remote repository for %s." directory))))

;; Helper function to join path components
(defun expand-path-join (dir &rest files)
  "Join DIR with FILES components."
  (if files
      (apply 'expand-path-join 
             (expand-file-name (car files) dir)
             (cdr files))
    dir))

;; Define your repository paths
(defvar my/repo-paths
  (list
   (cons 'emacs-config (concat user-home-dir "/Workspace/dotfiles"))
   (cons 'org-repo org-folder))
  "Alist of repository names and their paths.")

;; Function to pull both repositories
(defun my/pull-all-repos ()
  "Pull latest changes for all defined repositories."
  (interactive)
  (dolist (repo my/repo-paths)
    (my/git-pull-repo (cdr repo))))

;; Slightly more advanced interactive push function
(defun my/push-repo ()
  "Choose a repository and push changes to it."
  (interactive)
  (let* ((repo-names (mapcar #'car my/repo-paths))
         (choice (completing-read "Choose repository: " 
                                 (mapcar #'symbol-name repo-names)))
         (repo-path (cdr (assoc (intern choice) my/repo-paths)))
         (msg (read-string (format "Commit message for %s: " choice))))
    (my/git-push-repo repo-path msg)))

;;;; end of personal config


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(auto-package-update better-defaults counsel doom-modeline
			 doom-themes helpful ivy-rich magit
			 page-break-lines projectile
			 rainbow-delimiters)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
