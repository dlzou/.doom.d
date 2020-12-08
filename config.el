;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Daniel Zou"
      user-mail-address "zoudl2000@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-vibrant)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; Basic setup
(exec-path-from-shell-initialize)
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(lsp-treemacs-sync-mode)


;; Editor
(setq-default word-wrap t)
(setq-default fill-column 100)
(blink-cursor-mode)

(global-whitespace-mode)
(setq whitespace-style
      '(face tabs tab-mark))


;; Custom keybindings
(defun split-window-vert-goto ()
  (interactive)
  (split-window-vertically)
  (other-window 1))

(defun split-window-hor-goto ()
  (interactive)
  (split-window-horizontally)
  (other-window 1))

(defun scroll-down-half ()
  (interactive)
  (scroll-down (/ (window-body-height) 2)))

(defun scroll-up-half ()
  (interactive)
  (scroll-up (/ (window-body-height) 2)))

(map! "C-x 2" #'split-window-vert-goto
      "C-x 3" #'split-window-hor-goto
      "M-p" #'scroll-down-half
      "M-n" #'scroll-up-half)
(map! :map Info-mode-map
      "M-n" nil
      "M-c" #'clone-buffer)

(map! "C-z"   #'undo-fu-only-undo
      "C-S-z" #'undo-fu-only-redo)
(map! :map undo-fu-mode-map
      [remap undo] nil)

(map! :map dired-mode-map
      "f" #'find-file)

(map! "M-0"       #'treemacs-select-window
      "C-x t t"   #'treemacs
      "C-x t b"   #'treemacs-bookmark
      "C-x t f"   #'treemacs-find-file
      "C-x t C-f" #'treemacs-find-tag)

(map! :map vterm-mode-map "C-c C-x" #'vterm-send-C-x)

(windmove-default-keybindings 'control)


;; Visual elements
(setq doom-font (font-spec :family "Iosevka" :size 17))
(setq doom-variable-pitch-font (font-spec :family "Noto Sans CJK SC" :size 13))
(setq doom-themes-treemacs-theme "doom-colors")


;; Org
(require 'org-alert)
(setq org-agenda-files '("~/org/agenda/"))
(setq alert-default-style 'libnotify)
(org-alert-enable)
(setq org-agenda-custom-commands
      '(("c" "Custom agenda view"
         ((tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'done))
                 (org-agenda-overriding-header "High priority items:")))
          (agenda "" ((org-agenda-start-day "0d")
                      (org-agenda-span 1)
                      (org-agenda-overriding-header "Today's agenda:")))
          (agenda "" ((org-agenda-start-day "+1d")
                      (org-agenda-span 7)))
          (tags "DEADLINE<\"<today>\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'done))
                 (org-agenda-overriding-header "Overdue items:")))
          (alltodo "" ((org-agenda-todo-ignore-with-date t)
                       (org-agenda-overriding-header "Undated items:")))))))


;; Projectile
(setq projectile-enable-caching nil)
(setq projectile-indexing-method 'alien)


;; Anaconda
(setq conda-anaconda-home (expand-file-name "~/anaconda3/"))
(setq conda-env-home-directory (expand-file-name "~/anaconda3/"))


;; Mode hooks
(defun coding-hook ()
  (setq indent-tabs-mode nil)
  (setq tab-width 4)
  (setq lsp-enable-indentation nil)
  (display-fill-column-indicator-mode)
  (setq whitespace-style
        '(face tabs tab-mark trailing)))

(defun coding-narrow-hook ()
  (coding-hook)
  (setq tab-width 2))

(defun hide-whitespace-hook ()
  (setq whitespace-style nil))

(add-hook 'ibuffer-mode-hook #'hide-whitespace-hook)
(add-hook 'ibuffer-mode-hook
          (lambda () (ibuffer-auto-mode)))

(add-hook 'vterm-mode-hook #'hide-whitespace-hook)

(add-hook 'c-mode-common-hook #'coding-hook)
(add-hook 'c-mode-common-hook
          (lambda ()
            (setq ccls-enable-skipped-ranges nil)
            (c-set-style "stroustrup")
            (setq indent-region-function #'c-indent-region)))

(add-hook 'python-mode-hook #'coding-hook)
(add-hook 'python-mode-hook
          (lambda ()
            (hack-dir-local-variables)
            (when (assoc 'conda-project-env-path file-local-variables-alist)
                (conda-env-activate-for-buffer))
            (setq indent-region-function #'python-indent-region)))

(add-hook 'emacs-lisp-mode-hook #'coding-narrow-hook)

(add-hook 'json-mode-hook #'coding-narrow-hook)
