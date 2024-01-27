(use-package general
  :config
  (general-define-key
   :prefix "C-c"
   ;; bind "C-c a" to 'org-agenda
   "a" 'org-agenda
   "b" 'counsel-bookmark
   "c" 'org-capture))

;; diabling evil mode
;; (use-package evil
;;   :config
;;   (evil-mode 1))

(provide 'init-keybinding)
