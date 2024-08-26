
;; Emacs built-in settings
(use-package emacs
  :init
  ;; Disable the scroll bar to save screen space
  (scroll-bar-mode -1)
  ;; Enable display of time in the mode line
  (display-time-mode t)

  :config
  ;; Set a default font for all frames
  ;; (add-to-list 'default-frame-alist '(font . "IBM Plex Mono"))
  ;; (set-face-attribute 'default t :font "IBM Plex Mono")

  ;; Load a light theme by default
  (load-theme 'modus-operandi t) ;; Ensure to use ' instead of ` for correct theme loading

  ;; Define a mapping of major modes to their respective "ts" counterparts
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

  :custom
  ;; Settings for the Cocoa port
  (ns-alternate-modifier 'super)
  (ns-command-modifier 'meta)
  (ns-function-modifier 'hyper)
  (ns-right-alternate-modifier 'super)

  ;; Settings for the Emacs Mac-port
  (mac-command-modifier 'meta)
  (mac-option-modifier 'super)
  (mac-pass-command-to-system nil)

  ;; Allow directory local variables for remote files
  (enable-remote-dir-locals t)
  ;; User email address and full name for various Emacs packages that use this information
  (user-mail-address "justferres@yandex.ru")
  (user-full-name "Max Kochurov")
  ;; Use relative line numbers
  (display-line-numbers-type 'relative)
  ;; Use spaces instead of tabs for indentation
  (indent-tabs-mode nil)
  ;; Set directory for trashed files
  (trash-directory "~/.Trash")
  ;; Transform backup file names
  (lock-file-name-transforms '(("\\`\\(.+\\)\\'" "\\1~")))
  ;; Prefix for auto-save-list files
  (auto-save-list-file-prefix (expand-file-name "auto-save-list/.saves-" user-emacs-directory))
  ;; Set directory for backups
  (backup-directory-alist '(("." . "~/.local/share/emacs/backups")))
  ;; Delete old backup versions without confirmation
  (delete-old-versions t)

  ;; Extend auto-mode-alist to associate file extensions with modes
  :hook
  (typescript-mode
   . (lambda ()
       (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescript-ts-mode)))))

;; Clock

(use-package time
  :custom
  (world-clock-list
        '(("Europe/Moscow" "EU/Moscow")
          ("Europe/Berlin" "EU/Berlin")
          ("Europe/London" "EU/London")
          ("Europe/Budapest" "EU/Budapest")
          ("America/New_York" "US/New York")
          ("Etc/UTC" "*UTC*")
          ("Asia/Bangkok" "AS/Bangkok")))

  (world-clock-time-format "%a, %d %b %I:%M %p %Z"))

(use-package winner
  :hook after-init
  :commands (winner-undo winnner-redo)
  :custom
  (winner-boring-buffers '("*Completions*" "*Help*" "*Apropos*"
                           "*Buffer List*" "*info*" "*Compile-Log*")))

;; Developement


;; Tramp
(use-package tramp
  :custom
  (tramp-default-method "ssh" "Use SSH as the default method for tramp.")
  (tramp-ssh-controlmaster-options
   (concat "-o ControlPath=/tmp/ssh-ControlPath-%%r@%%h:%%p "
           "-o ControlMaster=auto "
           "-o ControlPersist=yes")
   "Options to enable SSH ControlMaster features in tramp.")
  (tramp-remote-path
   '(tramp-own-remote-path)
   "Add Nix and user-specific binaries to the remote path.")

  :init
  (add-to-list 'debug-ignored-errors 'remote-file-error)

  :config
  (setq tramp-lock-file-name-transforms '(("\\`\\(.+\\)\\'" "\\1~"))))

;; Treesitter remapping

(use-package nix-ts-mode
  :mode "\\.nix\\'")

(use-package protobuf-ts-mode
  :mode "\\.proto\\'")

;; Helm related stuff

(use-package helm
  :config
  (global-set-key (kbd "M-g i") 'helm-imenu)
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
     . ("nix-shell" "-p" "nixd" "--run" "nixd")))
  (add-to-list
   'eglot-server-programs
   '((elixir-ts-mode heex-ts-mode)
     ;; TODO remove elixir package from runtime shell
     . ("nix-shell" "-p" "elixir-ls" "elixir" "--run" "elixir-ls")))
  (setq-default
   eglot-workspace-configuration
   '(:nixd
     (:nixpkgs
      (:expr "import <nixpkgs> { }")))))

(use-package projectile
  :init
  (projectile-mode t)
  :bind ((:map projectile-mode-map
               ("M-p" . projectile-command-map))
         ("M-p v" . 'magit))
  :config
  (add-to-list 'projectile-other-file-alist '("ex" . ("html.heex" "html.leex")))
  (add-to-list 'projectile-other-file-alist '("html.heex" . ("ex")))
  (add-to-list 'projectile-other-file-alist '("html.leex" . ("ex")))
  (setq projectile-completion-system 'helm)
  (setq projectile-switch-project-action #'projectile-dired))

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

(use-package term
  )


(use-package magit
  )

(use-package markdown-mode)

(use-package imenu
  :config
  (setq imenu-auto-rescan t)
  (add-hook 'emacs-lisp-mode-hook
            (lambda ()
              (setq imenu-generic-expression
                    '((nil "^\\s-*(use-package\\s-+\\(\\_<.+?\\_>\\)" 1))))))

(use-package ethan-wspace
  :config
  (setq mode-require-final-newline nil)
  (global-ethan-wspace-mode t))

(use-package agenix
  )

(use-package yasnippet
  :config
  (yas-global-mode 1)
  (yas-reload-all))

(use-package yasnippet-snippets
  )

(use-package git-modes
  )

(use-package helm-projectile
  :init
  (helm-projectile-on))
