;;; appearence
(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; disable visual scrollbar
(tool-bar-mode -1)          ; disable the toolbar
(tooltip-mode -1)           ; diable tooltips
(set-fringe-mode 10)        ; got some breathing room
(menu-bar-mode -1)          ; disable menu bar

;; setup visiable bell
(setq visible-bell t)

(add-to-list 'load-path "~/.emacs.d/modules")
;; set font
(set-face-attribute 'default nil :font "Fira Code Retina" :height 120)

;;; global config
;; (global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;;; packages
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; initialize use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package better-defaults)
(use-package swiper)
(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-<tab>" . counsel-switch-buffer)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
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

(use-package nerd-icons)
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))
(use-package doom-themes)
(load-theme 'doom-one t)

(column-number-mode)
(global-display-line-numbers-mode t)

(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))


(require 'init-org)
(require 'init-tools)
(require 'init-keybinding)
(require 'init-ide)

;; global config
(defun open-init-file ()
  "Open the init file."
  (interactive)
  (find-file user-init-file))

(global-set-key (kbd "C-c i") 'open-init-file)
(setq vc-follow-symlinks t)
(defalias 'yes-or-no-p 'y-or-n-p)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(delete-selection-mode nil)
 '(package-selected-packages
   '(better-defaults elpy plantuml-mode org-cliplink org-roam-ui general evil projectile magit org-roam visual-fill-column org-bullets helpful ivy-rich which-key rainbow-delimiters doom-themes doom-modeline nerd-icons counsel swiper)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
