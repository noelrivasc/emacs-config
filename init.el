;; --- Package setup: tell Emacs where to download packages ---
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Make sure use-package is available
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Keep M-x customize's auto-writes out of this file, in their own file.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

;; Cheatsheet: list every keybinding set via use-package's `:bind` below.
;; Auto-generated from the config itself, so it can't go stale.
(global-set-key (kbd "C-c c h") #'describe-personal-keybindings)

;; Motion plugin - jump by typing chars
(use-package avy
  :ensure t                          ;; auto-download avy if missing
  :bind (("C-c l" . avy-goto-char-timer)
         ("C-c k" . avy-goto-char-2)))

;; --- Ctrl-P equivalent: fuzzy-find files in the current project ---
;; project.el (file search + project-root detection) ships with Emacs
;; itself, already bound to `C-x p f`. These two packages just make its
;; matching/UI fuzzy instead of exact-prefix.
(use-package vertico                 ;; minimal vertical completion UI
  :ensure t
  :init
  (vertico-mode 1))

(use-package orderless                ;; lets you type words out of order,
  :ensure t                           ;; like ctrlp/fzf-style fuzzy matching
  :custom
  (completion-styles '(orderless basic))
  (orderless-matching-styles '(orderless-flex))  ;; scattered-letter matching,
                                                  ;; e.g. "srcljmawea" -> src/cljs/.../weather_...
  (completion-category-overrides
   '((file (styles basic partial-completion))         ;; C-x C-f: normal per-directory TAB
     (project-file (styles orderless partial-completion))))) ;; C-x p f: fuzzy, ctrlp-style

;; --- Surround equivalent: add/change/delete wrapping pairs ---
;; Not evil-surround (that needs full evil-mode, which you don't have) -
;; embrace is a standalone package scoped to just this one feature.
;; C-c s opens a menu: a = add, c = change, d = delete, then pick the pair.
(use-package embrace
  :ensure t
  :bind ("C-c s" . embrace-commander))

;; --- Select inside/around parens, quotes, etc. (like vim's ci"/di() ---
;; Not identical: instead of one command per text-object, this grows the
;; selection outward one semantic unit at a time (word -> string contents
;; -> string incl. quotes -> enclosing sexp -> ...). Press C-c e repeatedly
;; to keep growing; C-- C-c e shrinks back in.
(use-package expand-region
  :ensure t
  :bind ("C-c e" . er/expand-region))

;; --- rnu + jump-to-line: built into Emacs, no package needed ---
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
;; Jump to line is already bound: M-g g (or M-g M-g)

;; --- NERDTree equivalent: sidebar file tree ---
(use-package treemacs
  :ensure t
  :bind ("C-x t t" . treemacs))

;; --- Git porcelain: Magit ---
(use-package magit
  :ensure t
  :bind ("C-c g" . magit-status))

;; --- Clojure support ---
(use-package clojure-mode             ;; teaches Emacs Clojure's syntax
  :ensure t)

(use-package cider                    ;; REPL + evaluation, like conjure
  :ensure t)                          ;; entry point: M-x cider-jack-in

;; Load nicer theme
(use-package solarized-theme
  :ensure t
  :init
  (load-theme 'solarized-dark t))

(when (display-graphic-p)
  (setq ns-command-modifier 'meta
        ns-option-modifier  'none))

;; Become Evil
(use-package evil
  :ensure t
  :init
  (setq evil-disable-insert-state-bindings t) ; insert state = plain Emacs
  :config
  (evil-mode 1)
  (evil-set-initial-state 'treemacs-mode 'emacs)) ; treemacs = plain Emacs, no evil
