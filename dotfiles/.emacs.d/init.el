;; Theme
(add-to-list 'default-frame-alist '(font . "IBM Plex Mono" ))
(set-face-attribute 'default t :font "IBM Plex Mono")
(load-theme `modus-operandi)
(scroll-bar-mode -1)

;; Developement
(setq-default indent-tabs-mode nil)
(use-package nix-ts-mode
  :mode "\\.nix\\'")
(use-package treesit-auto
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package helm
  :config
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (global-set-key (kbd "C-x b") 'helm-buffers-list))

