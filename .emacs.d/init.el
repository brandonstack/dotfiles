;;; package --- summary
;;; Commentary:

;;; Code:
;; load files from org-babel
(org-babel-load-file "~/.emacs.d/config.org")

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

(provide 'init)
;;; init.el ends here
