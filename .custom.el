;; -*- coding: utf-8; lexical-binding: t; -*-

;;; Code:
;; Font
(setq *wsl* (getenv "WSL_DISTRO_NAME"))
(defun font-installed-p (font-name)
  "Check if font with FONT-NAME is available."
  (find-font (font-spec :name font-name)))
(defun my-setup-fonts ()
  "Setup fonts."
  (when (display-graphic-p)
    ;; Set default font
    (cl-loop for font in '("Cascadia Code" "Fira Code" "Jetbrains Mono"
                           "SF Mono" "Hack" "Source Code Pro" "Menlo"
                           "Monaco" "DejaVu Sans Mono" "Consolas")
             when (font-installed-p font)
             return (set-face-attribute 'default nil
                                        :family font
                                        :height (cond (*is-a-mac* 130)
                                                      (*win64* 110)
                                                      (*wsl* 180)
                                                      (t 100))))

    ;; Specify font for all unicode characters
    (cl-loop for font in '("Apple Symbols" "Segoe UI Symbol" "Symbola" "Symbol")
             when (font-installed-p font)
             return (set-fontset-font t 'symbol (font-spec :family font) nil 'prepend))

    ;; Emoji
    (cl-loop for font in '("Noto Color Emoji" "Apple Color Emoji" "Segoe UI Emoji")
             when (font-installed-p font)
             return (set-fontset-font t
                                      (if (< emacs-major-version 28)'symbol 'emoji)
                                      (font-spec :family font) nil 'prepend))

    ;; Specify font for Chinese characters
    (cl-loop for font in '("LXGW Neo Xihei" "WenQuanYi Micro Hei Mono" "LXGW WenKai Screen"
                           "LXGW WenKai Mono" "PingFang SC" "Microsoft Yahei UI" "Simhei")
             when (font-installed-p font)
             return (progn
                      (setq face-font-rescale-alist `((,font . 1.3)))
                      (set-fontset-font t 'han (font-spec :family font))))))
(my-setup-fonts)

;; 小鹤双拼
(require-package 'posframe)
(with-eval-after-load 'pyim
  (setq pyim-default-scheme 'xiaohe-shuangpin))

(provide 'custom)
