;; Org
(setq org-agenda-files '("~/org/agenda/"))
(advice-add 'org-agenda-redo :before #'org-save-all-org-buffers)
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


;; LaTeX
(setq +latex-viewers '(pdf-tools))


;; Mode hooks
(defun coding-hook ()
  (setq indent-tabs-mode nil)
  (setq tab-width 4)
  (setq lsp-enable-indentation nil)
  (setq lsp-ui-doc-enable nil)
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
            (hack-local-variables)
            (when (assoc 'conda-project-env-path file-local-variables-alist)
                (conda-env-activate-for-buffer))
            (setq indent-region-function #'python-indent-region)))

(add-hook 'rustic-mode-hook #'coding-hook)

(add-hook 'emacs-lisp-mode-hook #'coding-narrow-hook)

(add-hook 'json-mode-hook #'coding-narrow-hook)
