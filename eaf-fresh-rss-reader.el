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
