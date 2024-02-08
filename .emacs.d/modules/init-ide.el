;;; python
(setenv "WORKON_HOME" "~/Workspace/coding/.venv")
(use-package elpy
  :ensure t
  :init
  (elpy-enable))

(use-package flycheck
  :after elpy
  :config
  ;; add to elpy
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; run autopep8 on save
;;(use-package py-autopep8
;;  :after elpy
;;  :config
;;  (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save))
;; black formatting on save
(use-package blacken)

(provide 'init-ide)
