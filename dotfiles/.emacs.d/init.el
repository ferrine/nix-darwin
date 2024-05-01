;; Theme
(add-to-list 'default-frame-alist '(font . "IBM Plex Mono" ))
(set-face-attribute 'default t :font "IBM Plex Mono")
(load-theme `modus-operandi)
(scroll-bar-mode -1)

;; Navigation

(use-package winner
  :hook after-init
  :commands (winner-undo winnner-redo)
  :custom
  (winner-boring-buffers '("*Completions*" "*Help*" "*Apropos*"
                           "*Buffer List*" "*info*" "*Compile-Log*")))

;; Developement
(setq-default indent-tabs-mode nil)


;; Treesitter remapping

(use-package nix-ts-mode
  :mode "\\.nix\\'")

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

;; Helm related stuff

(use-package helm
  :config
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (global-set-key (kbd "C-x b") 'helm-buffers-list)
  (global-set-key (kbd "M-y") 'helm-show-kill-ring))

(load "~/.emacs.d/lib/helm-fzf.el")

;; IDE Features

(use-package eglot
  :defer t
  :hook ((python-ts-mode . eglot-ensure)
         (nix-ts-mode . eglot-ensure))
  :config
  (add-to-list 'eglot-server-programs '(nix-ts-mode . ("nixd")))
  (add-to-list 'eglot-server-programs '(elixir-ts-mode . ("elixir-ls"))))

;; Writing

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
