;; Garbage collect after startup
;; (add-hook 'after-init-hook #'garbage-collect t)
(defvar bootstrap-version)
(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to match
that used by the user's shell.

This is particularly useful under Mac OS X and macOS, where GUI
apps are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$" "" (shell-command-to-string
                                          "$SHELL --login -c 'echo $PATH'"
                                                    ))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(set-exec-path-from-shell-PATH)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))


(straight-use-package 'use-package)
(setq straight-use-package-by-default t)


;; Emacs built-in settings
(use-package emacs
  :init
  ;; Disable the scroll bar to save screen space
  (scroll-bar-mode -1)
  ;; Enable display of time in the mode line
  (display-time-mode t)

  :hook
  (prog-mode . display-line-numbers-mode)
  :config
  ;; Set a default font for all frames
  (defun set-default-font-fallback (font fallback-font)
    (if (member font (font-family-list))
        (set-face-attribute 'default nil :font font)
      (set-face-attribute 'default nil :font fallback-font)))

  ;; Call the function with IBM Plex Mono and a fallback font (e.g., "Courier New")
  (set-default-font-fallback "IBM Plex Mono" "Courier New")

  ;; Optional: Ensure it applies to new frames
  (add-to-list 'default-frame-alist `(font . ,(if (member "IBM Plex Mono" (font-family-list))
                                                  "IBM Plex Mono"
                                                "Courier New")))

  ;; Load a light theme by default
  (load-theme 'modus-operandi t) ;; Ensure to use ' instead of ` for correct theme loading

  :custom
  ;; Settings for the Cocoa port
  (ns-alternate-modifier 'super)
  (ns-command-modifier 'meta)
  (ns-function-modifier 'hyper)
  (ns-right-alternate-modifier 'super)
  (ns-use-native-fullscreen nil)

  ;; Settings for the Emacs Mac-port
  ;; Settings for the MacPorts build of Emacs in Terminal
  (mac-control-modifier 'control)
  (mac-option-modifier 'super)
  (mac-command-modifier 'meta)
  (mac-right-option-modifier 'super)
  (mac-use-mac-modifier-symbols nil)

  ;; Customize key bindings for Emacs in Terminal mode
  ;; Remap 'Alt' key to 'Super'
  (define-key key-translation-map (kbd "M-") (kbd "s-"))
  ;; Remap 'Command' key to 'Meta'
  (define-key key-translation-map (kbd "H-") (kbd "M-"))
  ;; Remap 'fn' key to 'Hyper'
  (define-key key-translation-map (kbd "<XF86Favorites>") 'event-apply-hyper-modifier)


  (gc-cons-threshold 20000000)
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
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p))

;; Buffer management

(use-package buffer-move
  :bind
  ("<C-s-up>" . 'buf-move-up)
  ("<C-s-down>" . 'buf-move-down)
  ("<C-s-left>" . 'buf-move-left)
  ("<C-s-right>" . 'buf-move-right))

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

;; Tramp
(use-package tramp
  :config
  (require 'ls-lisp)
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
  (setq ls-lisp-use-insert-directory-program nil)
  (setq vc-handled-backends nil)
  (setq tramp-lock-file-name-transforms '(("\\`\\(.+\\)\\'" "\\1~"))))

;; Search

(use-package ag)
(use-package rg)

;; Completions

(use-package vertico
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode))

(use-package vertico-directory
  :after vertico
  :ensure nil
  :straight nil
  ;; More convenient directory navigation commands
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  ;; Tidy shadowed file names
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(use-package vertico-mouse
  :after vertico
  :ensure nil
  :straight nil
  :config
  (vertico-mouse-mode))

(use-package orderless
  :ensure t
  :config
  (orderless-define-completion-style orderless+initialism
    (orderless-matching-styles '(orderless-initialism
                                 orderless-literal
                                 orderless-regexp)))
  (setq completion-category-overrides
        '((command (styles orderless+initialism))
          (symbol (styles orderless+initialism))
          (variable (styles orderless+initialism)))))

(use-package savehist
  :init
  (savehist-mode))

(use-package marginalia
  :after vertico

  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

;; IDE Features

(use-package dumb-jump
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  (setq xref-show-definitions-function #'xref-show-definitions-completing-read))

(use-package treesit-auto
  :ensure t
  :after emacs
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode t))

(use-package nix-ts-mode
  :mode ("\\.nix\\'" "\\.nix.in\\'"))

(use-package elixir-ts-mode
  )

(use-package blueprint-ts-mode
  )

;; Android.bp
(setq my/androidbp-tsauto-config
      (make-treesit-auto-recipe
       :lang 'android-bp                 ;; This is the language we are defining
       :ts-mode 'androidbp-ts-mode      ;; This will be the mode that uses Tree-sitter
       ;; Remap existing modes to use this new mode, if necessary
       :remap nil                ;; If there are existing modes you want to remap, specify them here
       ;; Specify the repository
       :url "https://github.com/huanie/tree-sitter-bp"
       :revision "master"        ;; Specify branch or commit you wish to use
       :source-dir "src"         ;; Directory where source code is found
       :ext "\\.bp\\'"           ;; File extension to consider
       ))

  ;; Add the new recipe to the Tree-sitter auto recipe list
(add-to-list 'treesit-auto-recipe-list my/androidbp-tsauto-config)

(defun androidbp-ts-mode ()
  "Major mode for editing Blueprint files using Tree-sitter."
  (interactive)
  (kill-all-local-variables)
  (setq major-mode 'androidbp-ts-mode)
  (setq mode-name "Android.bp")
  (setq-local tab-width 4)
  ;; Add additional setup as needed
  (run-mode-hooks 'androidbp-ts-mode-hook))

;; Register the mode
(define-derived-mode androidbp-ts-mode prog-mode "Android.bp"
  "Major mode for editing Android.bp files.")

(use-package eglot
  :defer t
  :hook
  (nix-ts-mode . eglot-ensure)
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
         ("M-p v" . 'magit)
         ("M-p x v" . 'vterm-toggle))
  :config
  (add-to-list 'projectile-other-file-alist '("ex" . ("html.heex" "html.leex")))
  (add-to-list 'projectile-other-file-alist '("html.heex" . ("ex")))
  (add-to-list 'projectile-other-file-alist '("html.leex" . ("ex")))
  (setq projectile-enable-caching nil)
  (setq projectile-switch-project-action #'projectile-dired)
  (setq projectile-project-root-files
        '(".git" ".projectile"))
  (setq projectile-project-root-files-functions
   '(projectile-root-local
     projectile-root-top-down
     projectile-root-bottom-up
     projectile-root-top-down-recurring)))

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

(use-package async
  :init
  (dired-async-mode 1))

(use-package vterm
  :config
  (defun vterm-copy-region-to-kill-ring (beg end)
    (interactive "r")
    (let ((text (buffer-substring-no-properties beg end)))
      (kill-new text)))

  (define-key vterm-mode-map (kbd "M-w") 'vterm-copy-region-to-kill-ring)
  (setq vterm-shell "zsh")
  (setq vterm-tramp-shells
        '(("docker" "sh")
          ("ssh" "zsh" "bash"))))

(use-package vterm-toggle
  :after (projectile vterm)
  :bind
  (("C-c t"        . vterm-toggle-cd)
   :map vterm-mode-map
   ("<C-return>" . vterm-toggle-insert-cd)
   ("s-n" . vterm-toggle-forward)
   ("s-p" . vterm-toggle-backward))
  :config
  (setq vterm-toggle-scope 'project)
  (add-to-list 'display-buffer-alist
     '("\*vterm\*"
       (display-buffer-in-side-window)
       (window-height . 0.3)
       (side . bottom)
       (slot . 0))))

(use-package python-mode
  :config
  (setq python-indent-def-block-scale 1))

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

(use-package git-modes
  )


(use-package org
  ;; Inspiration ideas
  ;; https://github.com/abdalazizrashid/TREE-3/blob/main/users/aziz/.config/emacs/az-emacs.org
  :bind
  ("C-c l" . 'org-store-link)
  ("C-c a" . 'org-agenda)
  ("C-c c" . 'org-capture)
  :hook (org-mode . (lambda ()
                      (auto-revert-mode)
                      (auto-fill-mode)))
  :config
  (require 'org-protocol)
  (setq org-directory "~/Org/")
  (setq org-agenda-files
        `(,(concat org-directory "universe.org")))
  (setq org-capture-templates
        `(("t" "TODO [inbox]" entry
           (file+headline ,(concat org-directory "universe.org") "Inbox")
           "* [%U]\nTODO %i%?")))
  (setq org-refile-targets
        `((,(concat org-directory "universe.org") :maxlevel . 5)))
  (setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
  (setq org-preview-latex-default-process 'dvisvgm)
  (setq org-format-latex-options
        (plist-put org-format-latex-options :scale 1.5)))

;; Setting up pdf-tools using use-package
(use-package pdf-tools
  :config
  ;; Initialize pdf-tools
  (pdf-tools-install))

(use-package xenops
  )

;; AUCTeX and TeX configuration using use-package
(use-package tex
  :straight nil
  :ensure auctex
  :defer t
  :hook ((LaTeX-mode . TeX-source-correlate-mode)
         (LaTeX-mode . TeX-PDF-mode)
         (LaTeX-mode . turn-on-reftex)
         (LaTeX-mode . prettify-symbols-mode)
         (LaTeX-mode . abbrev-mode)
         (LaTeX-mode . xenops-mode))
  :config
  ;; Enable Synctex
  (setq TeX-source-correlate-mode t
        TeX-source-correlate-start-server t
        TeX-view-program-selection '((output-pdf "PDF Tools"))
        TeX-command-extra-options "--synctex=1")

  ;; This hook enables pdf-tools integration with AUCTeX
  (add-hook 'TeX-after-compilation-finished-functions
            #'TeX-revert-document-buffer))

(use-package org-noter
  )

(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-database-connector 'sqlite-builtin)
  (org-roam-directory "~/Notes")
  (org-roam-completion-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n a" . org-roam-alias-add)
         ("C-c n c" . org-roam-capture)
         :map org-mode-map
         ("C-M-i"    . completion-at-point))
  :config
  (setq org-roam-capture-templates
        '(("d" "default" plain
           "%?"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
           :unnarrowed t)
          ("s" "Selection" plain
           "%?"
           :if-new (file+head "${slug}.org" "#+title: ${title}\n#+created: %U\n\n %i")
           :named t
           :unnarrowed t)))
  (org-roam-setup)
  (with-eval-after-load 'org-roam
    (define-key minibuffer-local-completion-map (kbd "SPC") 'self-insert-command)))

(use-package password-store
  )

(use-package gptel
  :after (password-store)
  :hook (gptel-mode . visual-line-mode)
  :bind (("C-c g s" . gptel-send)
         ("C-c g c" . gptel-menu)
         ("C-c g a" . gptel-add)
         ("C-c g /" . gptel-abort)
         ("C-c g t" . gptel-org-set-topic)
         ("C-c g RET" . gptel))
  :config
  (setq gptel-default-mode 'org-mode)
  (add-hook 'gptel-post-stream-hook 'gptel-auto-scroll)
  (add-hook 'gptel-post-response-functions 'gptel-end-of-response)
  (setq-default gptel-backend (gptel-make-openai "Qwen"
                                :key (password-store-get "web/services/qwen/key")
                                :stream t
                                :protocol "http"
                                :endpoint "/v1/chat/completions"
                                :host (password-store-get "web/services/qwen/host")
                                :models '(Qwen/Qwen2.5-72B-Instruct))
                gptel-model   'Qwen/Qwen2.5-72B-Instruct))

;; call those in the end to disable mouse zoom
(global-unset-key (kbd "C-<wheel-down>"))
(global-unset-key (kbd "C-<wheel-up>"))
(global-unset-key (kbd "C-<mouse-5>"))
(global-unset-key (kbd "C-<mouse-4>"))
