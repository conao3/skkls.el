;;; skkls.el --- Client for skkls  -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Naoya Yamashita

;; Author: Naoya Yamashita <conao3@gmail.com>
;; Keywords: convenience
;; Package-Requires: ((emacs "29.1"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Client for skkls

;;; Code:

(require 'cl-lib)

(defun skkls--handle-actions (actions)
  (dolist (action (cl-coerce actions 'list))
    (let ((command (plist-get action :command))
          (arguments (plist-get action :arguments)))
      (cond
       ((string= command "insert")
        (insert (aref arguments 0)))))))

(defun skkls-self-insert (arg)
  "SKKLS version of `self-insert-command'."
  (interactive "p")
  (let ((key last-command-event)
        (server (car (gethash (eglot--current-project)
                              eglot--servers-by-project))))
    (when (< 0 arg)
      (dotimes (i arg)
        (skkls--handle-actions
         (eglot-execute server `(:command "inputKey" :arguments [,(char-to-string key)])))))))

(define-minor-mode skkls-mode
  "Yet another ddskk."
  :lighter " Skkls"
  :require 'skkls
  :group 'skkls
  :keymap (mapcar (lambda (i) (cons (char-to-string i) #'skkls-self-insert))
                  (number-sequence 33 126)))

(provide 'skkls)

;;; skkls.el ends here

