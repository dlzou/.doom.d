(defun split-window-vert-goto ()
  (interactive)
  (split-window-vertically)
  (other-window 1))

(defun split-window-hor-goto ()
  (interactive)
  (split-window-horizontally)
  (other-window 1))

(defun backward-line-half ()
  (interactive)
  (forward-line (/ (window-body-height) -2)))

(defun forward-line-half ()
  (interactive)
  (forward-line (/ (window-body-height) 2)))

(map! "C-x 2" #'split-window-vert-goto
      "C-x 3" #'split-window-hor-goto
      "M-p" #'backward-line-half
      "M-n" #'forward-line-half)
(map! :map Info-mode-map
      "M-n" nil
      "M-c" #'clone-buffer)

(map! "C-z"   #'undo-fu-only-undo
      "C-S-z" #'undo-fu-only-redo)
(map! :map undo-fu-mode-map
      [remap undo] nil)

(map! :map dired-mode-map
      "f" #'find-file)

(map! :map org-mode-map
      "C-c k" #'org-cut-special)

(map! "M-0"       #'treemacs-select-window
      "C-x t t"   #'treemacs
      "C-x t b"   #'treemacs-bookmark
      "C-x t f"   #'treemacs-find-file
      "C-x t C-f" #'treemacs-find-tag)

(map! :map vterm-mode-map "C-c C-x" #'vterm-send-C-x)

(windmove-default-keybindings 'control)
