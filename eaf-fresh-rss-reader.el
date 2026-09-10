;; eaf-fresh-rss-reader.el
;;
;; Fresh RSS Reader module for EAF (Emacs Application Framework).
;;
;; This file registers the module with EAF and defines key bindings.
;; It is designed to be compatible with Doom Emacs module loading patterns.

;; --- Module registration ---
(add-to-list 'eaf-app-binding-alist '("fresh-rss-reader" . eaf-fresh-rss-reader-keybinding))
(add-to-list 'eaf-app-module-path-alist '("fresh-rss-reader" . eaf-fresh-rss-reader-module-path))

;; --- Module path ---
;; Path to the Python buffer module, relative to this Elisp file.
(let ((module-path (concat (file-name-directory (or load-file-name
                                                  (buffer-file-name)))
                           "buffer.py")))
  (defcustom eaf-fresh-rss-reader-module-path module-path
    "Path to the Fresh RSS Reader Python module."
    :type 'string))

;; --- Customizable options ---
(defcustom eaf-fresh-rss-reader-split-horizontally t
  "Split web page horizontally."
  :type 'boolean)

(defcustom eaf-fresh-rss-reader-refresh-time "600"
  "The default feed refresh time (seconds)."
  :type 'int)

(defcustom eaf-fresh-rss-reader-phone-agent-list nil
  "Some sites can't show content complete, this list contains user agents for those sites."
  :type 'list)

;; --- Key bindings ---
;; Designed to avoid conflicts with Doom Emacs Evil key bindings.
;; q is the primary return command (returns to feed/news list).
;; f opens the current article.
;; j/k navigate articles, n/p navigate feeds.
;; F toggles fullscreen, m marks read.
;; A/R add/remove feeds, g refreshes, i/o import/export OPML.

(defmacro eaf-fresh-rss-reader-keybinding (keymap)
  `(progn
     ;; Article navigation
     (define-key ,keymap (kbd "f") 'eaf-fresh-rss-reader-open-article)
     (define-key ,keymap (kbd "q") 'eaf-fresh-rss-reader-close-article)
     (define-key ,keymap (kbd "j") 'eaf-fresh-rss-reader-next-article)
     (define-key ,keymap (kbd "k") 'eaf-fresh-rss-reader-prev-article)
     ;; Feed navigation
     (define-key ,keymap (kbd "n") 'eaf-fresh-rss-reader-next-feed)
     (define-key ,keymap (kbd "p") 'eaf-fresh-rss-reader-prev-feed)
     ;; View toggle
     (define-key ,keymap (kbd "F") 'eaf-fresh-rss-reader-toggle-fullscreen)
     ;; Read marking
     (define-key ,keymap (kbd "m") 'eaf-fresh-rss-reader-mark-read)
     ;; Feed management
     (define-key ,keymap (kbd "A") 'eaf-fresh-rss-reader-add-feed)
     (define-key ,keymap (kbd "R") 'eaf-fresh-rss-reader-remove-feed)
     (define-key ,keymap (kbd "g") 'eaf-fresh-rss-reader-refresh-feed)
     ;; OPML import/export
     (define-key ,keymap (kbd "i") 'eaf-fresh-rss-reader-import-opml)
     (define-key ,keymap (kbd "o") 'eaf-fresh-rss-reader-export-opml)))

;; --- Elisp commands ---
;; These commands call the corresponding Python methods on the active buffer.
;; They are designed to work with Doom Emacs Evil mode by using
;; universal key bindings that are unlikely to conflict.

(defun eaf-fresh-rss-reader-open-article ()
  "Open the current article."
  (interactive)
  (eaf-call-py 'buffer.py 'open_article))

(defun eaf-fresh-rss-reader-close-article ()
  "Close the current article and return to the list view."
  (interactive)
  (eaf-call-py 'buffer.py 'close_article))

(defun eaf-fresh-rss-reader-next-article ()
  "Select the next article."
  (interactive)
  (eaf-call-py 'buffer.py 'select_feed 1))

(defun eaf-fresh-rss-reader-prev-article ()
  "Select the previous article."
  (interactive)
  (eaf-call-py 'buffer.py 'select_feed -1))

(defun eaf-fresh-rss-reader-next-feed ()
  "Select the next feed."
  (interactive)
  (eaf-call-py 'buffer.py 'select_feed 1))

(defun eaf-fresh-rss-reader-prev-feed ()
  "Select the previous feed."
  (interactive)
  (eaf-call-py 'buffer.py 'select_feed -1))

(defun eaf-fresh-rss-reader-toggle-fullscreen ()
  "Toggle fullscreen mode for the article view."
  (interactive)
  (eaf-call-py 'buffer.py 'toggle_fullscreen))

(defun eaf-fresh-rss-reader-mark-read ()
  "Mark the current article as read."
  (interactive)
  (eaf-call-py 'buffer.py 'mark_article_read))

(defun eaf-fresh-rss-reader-add-feed ()
  "Add a new feed."
  (interactive)
  (eaf-call-py 'buffer.py 'add_feed))

(defun eaf-fresh-rss-reader-remove-feed ()
  "Remove the current feed."
  (interactive)
  (eaf-call-py 'buffer.py 'remove_feed))

(defun eaf-fresh-rss-reader-refresh-feed ()
  "Refresh the current feed."
  (interactive)
  (eaf-call-py 'buffer.py 'refresh_feed))

(defun eaf-fresh-rss-reader-import-opml ()
  "Import feeds from an OPML file."
  (interactive)
  (eaf-call-py 'buffer.py 'import_opml))

(defun eaf-fresh-rss-reader-export-opml ()
  "Export feeds to an OPML file."
  (interactive)
  (eaf-call-py 'buffer.py 'export_opml))

;; --- Entry point ---
;; Open the Fresh RSS Reader application.
;; This function can be called from Doom Emacs config via:
;;   (eaf-open-fresh-rss-reader)
(defun eaf-open-fresh-rss-reader ()
  "Open EAF Fresh RSS Reader."
  (interactive)
  (let ((inhibit-message t))
    (eaf-open default-directory "fresh-rss-reader")))

;; --- Doom Emacs compatibility ---
;; This module can be loaded by Doom Emacs via:
;;   (use-package! eaf-fresh-rss-reader
;;     :load-path (concat doom-user-dir "path/to/fresh-rss-reader")
;;     :config
;;     (eaf-open-fresh-rss-reader))
;;
;; The key bindings are defined in a way that avoids conflicts with
;; Doom Emacs Evil mode by using the app-specific keymap.

(provide 'eaf-fresh-rss-reader)