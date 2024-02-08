;;; python
(setenv "WORKON_HOME" "~/Workspace/coding/.venv")
(use-package elpy
  :ensure t
  :init
  (elpy-enable)
  (pyvenv-mode)
  :config
  (pyvenv-workon "."))

(use-package flycheck
  :after elpy
  :config
  ;; add to elpy
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; run autopep8 on save
(use-package py-autopep8
  :after elpy
  :hook ((python-mode) . py-autopep8-mode))

;; black formatting on save
;; (use-package blacken)

(provide 'init-ide)
