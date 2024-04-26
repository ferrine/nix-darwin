;; Theme
(add-to-list 'default-frame-alist '(font . "IBM Plex Mono" ))
(set-face-attribute 'default t :font "IBM Plex Mono")
(load-theme `modus-operandi)
(scroll-bar-mode -1)

;; Developement
(setq-default indent-tabs-mode nil)

(use-package nix-ts-mode
  :mode "\\.nix\\'")
;; treesitter remapping

(setq major-mode-remap-alist
      '((yaml-mode . yaml-ts-mode)
        (bash-mode . bash-ts-mode)
        (js2-mode . js-ts-mode)
        (typescript-mode . typescript-ts-mode)
        (json-mode . json-ts-mode)
        (css-mode . css-ts-mode)
        (python-mode . python-ts-mode)
        (elixir-mode . elixir-ts-mode)
        (nix-mode . nix-ts-mode)
        (js-mode . js-ts-mode)))


(use-package helm
  :config
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (global-set-key (kbd "C-x b") 'helm-buffers-list))

(use-package eglot
  :defer t
  :hook ((python-ts-mode . eglot-ensure)
         (nix-ts-mode . eglot-ensure))
  :config
  (add-to-list 'eglot-server-programs '(nix-ts-mode . ("nixd"))))

(use-package languagetool
  :defer t
  :commands (languagetool-check
             languagetool-clear-suggestions
             languagetool-correct-at-point
             languagetool-correct-buffer
             languagetool-set-language
             languagetool-server-mode
             languagetool-server-start
             languagetool-server-stop))
