;; Theme
(use-package emacs
  :config
  (add-to-list 'default-frame-alist '(font . "IBM Plex Mono" ))
  (set-face-attribute 'default t :font "IBM Plex Mono")
  (load-theme `modus-operandi)

  :custom
  (user-mail-address "justferres@yandex.ru")
  (user-full-name "Max Kochurov")
  (setq display-line-numbers-type 'relative)
  (setq-default indent-tabs-mode nil)
  (setq-default trash-directory "~/.Trash")

  :init
  (scroll-bar-mode -1)
  (display-time-mode t))

;; Clock

(use-package time
  :config
  (setq world-clock-list
        '(("Europe/Moscow" "EU/Moscow")
          ("Europe/Berlin" "EU/Berlin")
          ("Europe/London" "EU/London")
          ("Europe/Budapest" "EU/Budapest")
          ("America/New_York" "US/New York")
          ("Etc/UTC" "*UTC*")
          ("Asia/Bangkok" "AS/Bangkok")))

  (setq world-clock-time-format "%a, %d %b %I:%M %p %Z"))

(use-package winner
  :hook after-init
  :commands (winner-undo winnner-redo)
  :custom
  (winner-boring-buffers '("*Completions*" "*Help*" "*Apropos*"
                           "*Buffer List*" "*info*" "*Compile-Log*")))

;; Developement


;; Tramp
(use-package tramp
  :config
  (add-to-list 'tramp-remote-path "~/.nix-profile/bin/"))

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

(use-package ibuffer
  :bind ("C-x C-b" . ibuffer)
  :custom
  (ibuffer-default-display-maybe-show-predicates t)
  (ibuffer-expert t)
  (ibuffer-formats
   '((mark modified read-only " "
           (name 16 -1)
           " "
           (size 6 -1 :right)
           " "
           (mode 16 16)
           " " filename)
     (mark " "
           (name 16 -1)
           " " filename)))
  (ibuffer-maybe-show-regexps nil)
  (ibuffer-saved-filter-groups
   '(("default"
      ("Magit"
       (or
        (mode . magit-status-mode)
        (mode . magit-log-mode)
        (name . "\\*magit")
        (name . "magit-")
        (name . "git-monitor")))
      ("Coq"
       (or
        (mode . coq-mode)
        (name . "\\<coq\\>")
        (name . "_CoqProject")))
      ("Commands"
       (or
        (mode . shell-mode)
        (mode . eshell-mode)
        (mode . term-mode)
        (mode . compilation-mode)))
      ("Haskell"
       (or
        (mode . haskell-mode)
        (mode . haskell-cabal-mode)
        (mode . haskell-literate-mode)))
      ("Rust"
       (or
        (mode . rust-mode)
        (mode . cargo-mode)
        (name . "\\*Cargo")
        (name . "^\\*rls\\(::stderr\\)?\\*")))
      ("Eglot"
       (or
        (name . "eglot")))
      ("Nix"
       (mode . nix-mode))
      ("C++"
       (or
        (mode . c-mode)
        (mode . c++-mode)))
      ("Lisp"
       (mode . emacs-lisp-mode))
      ("Dired"
       (mode . dired-mode))
      ("Gnus"
       (or
        (mode . message-mode)
        (mode . mail-mode)
        (mode . gnus-group-mode)
        (mode . gnus-summary-mode)
        (mode . gnus-article-mode)
        (name . "^\\.newsrc-dribble")
        (name . "^\\*\\(sent\\|unsent\\|fetch\\)")
        (name . "^ \\*\\(nnimap\\|nntp\\|nnmail\\|gnus\\|server\\|mm\\*\\)")
        (name . "\\(Original Article\\|canonical address\\|extract address\\)")))
      ("Org"
       (or
        (name . "^\\*Calendar\\*$")
        (name . "^\\*Org Agenda")
        (name . "^ \\*Agenda")
        (name . "^diary$")
        (mode . org-mode)))
      ("Emacs"
       (or
        (name . "^\\*scratch\\*$")
        (name . "^\\*Messages\\*$")
        (name . "^\\*\\(Customize\\|Help\\)")
        (name . "\\*\\(Echo\\|Minibuf\\)"))))))
  (ibuffer-show-empty-filter-groups nil)
  (ibuffer-shrink-to-minimum-size t t)
  (ibuffer-use-other-window t)
  :init
  (add-hook 'ibuffer-mode-hook
            #'(lambda ()
                (ibuffer-switch-to-saved-filter-groups "default"))))

(load "~/.emacs.d/lib/helm-fzf.el")

;; IDE Features

(use-package eglot
  :defer t
  :hook ((python-ts-mode . eglot-ensure)
         (nix-ts-mode . eglot-ensure))
  :config
  (add-to-list
   'eglot-server-programs
   '(nix-ts-mode
     . ("nixd")))
  (add-to-list 'eglot-server-programs '(elixir-ts-mode . ("elixir-ls")))
  (setq-default
   eglot-workspace-configuration
   '(:nixd
     (:nixpkgs
      (:expr "import <nixpkgs> { }")))))

(use-package projectile
  :init
  (projectile-mode t)
  :bind (:map projectile-mode-map
              ("M-p" . projectile-command-map))
  :config
  (setq projectile-completion-system 'helm))

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

;; Vterm
(use-package vterm
  :defer t)
