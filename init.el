;;; package -- Configuring emacs for React editing
;;; Last update: 11/15/2016. By Will Kessler

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Set up melpa.
;; cf: http://melpa.org/#/getting-started
;;
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

(setq package-archive-priorities
      '(("melpa-stable" . 20)
        ("marmalade" . 20)
        ("gnu" . 10)
        ("melpa" . 0)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Preinstall all packages we need (if necessary).
;; cf: http://stackoverflow.com/questions/10092322/how-to-automatically-install-emacs-packages-by-specifying-a-list-of-package-name

;; First fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

;; Now list the packages you want
(setq package-list '(afternoon-theme
		     bash-completion
		     company
		     flx-ido
		     flycheck
		     markdown-mode
                     magit
		     projectile
                     react-snippets
		     readline-complete
		     sane-term
		     web-mode
		     yaml-mode
                     yasnippet
		     )
)

;; Install any missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Set up various global settings I like.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Use the command key for meta,
;;; cf http://superuser.com/questions/297259/set-emacs-meta-key-to-be-the-mac-key
(setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-option-modifier 'none)

;; Set up good indentation for 2017
(setq-default
 ;; js2-mode
 js2-basic-offset 2

 ;; json-mode
 js-indent-level 2

 ;; web-mode
 css-indent-offset 2
 web-mode-markup-indent-offset 2
 web-mode-css-indent-offset 2
 web-mode-code-indent-offset 2
 web-mode-attr-indent-offset 2
)

;; Make web-mode come up for certain file types: html, js, react jsx, json
;; cf: http://web-mode.org/
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '(".*\\.js[x]?\\'" . web-mode))
(add-to-list 'auto-mode-alist '(".*\\.json?\\'" . web-mode))

;; Set up flycheck with eslint.
;; cf: http://www.flycheck.org/en/latest/user/quickstart.html#enable-flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

;; Remove toolbar. If not in GUI mode, don't show menu bar either
(setq tool-bar-mode 0)
(menu-bar-mode -1)
(setq scroll-bar-mode -1)
(blink-cursor-mode 0)

;; set C-shift-n and C-shift-p to scroll up and down by one line
(fset 'scrollup "\C-u1\366")
(fset 'scrolldown "\C-u1\C-v")
(global-set-key [(control shift n)] 'scrolldown)
(global-set-key [(control shift p)] 'scrollup)

;; set M-g to goto-line
(global-set-key [(meta g)] 'goto-line)

;; Make M-s start/switch to shell
(global-set-key [(meta s)] 'shell)

;; Stop at the end of the file, don't add lines
(setq next-line-add-newlines nil)

;; Stop using tabs to indent,
;; cf: https://www.emacswiki.org/emacs/NoTabs
(setq-default indent-tabs-mode nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Set up afternoon-theme: https://github.com/jordonbiondo/ample-theme
;;

(load-theme 'afternoon t t)
;; choose one to enable
(enable-theme 'afternoon)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Set up ido
;;

(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t) ; fuzzy matching is a must have
;; Map ido to C-x b and C-x C-b
(global-set-key "b" (quote electric-buffer-list))
(global-set-key "" (quote ido-switch-buffer))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Set up sane-term, cf https://github.com/adamrt/sane-term
;;

  (require 'sane-term)
    (global-set-key (kbd "C-x t") 'sane-term)
    (global-set-key (kbd "C-x T") 'sane-term-create)

;; Optional convenience binding. This allows C-y to paste even when in term-char-mode (see below).
(add-hook 'term-mode-hook (lambda() (define-key term-raw-map (kbd "C-y") (lambda () (interactive) (term-line-mode) (yank) (term-char-mode)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Set up desktop save mode. NB: you *must* create an empty ~/.emacs.desktop file before start using emacs the first time if you want
;; desktop save mode to work correctly.

;; save a list of open files in ~/.emacs.desktop
;; save the desktop file automatically if it already exists
(setq desktop-save 'if-exists)
(desktop-save-mode 1)

;; Save a bunch of variables to the desktop file
;; for lists specify the len of the maximal saved data also
(setq desktop-globals-to-save
      (append '((extended-command-history . 30)
                (file-name-history        . 100)
                (grep-history             . 30)
                (compile-history          . 30)
                (minibuffer-history       . 50)
                (query-replace-history    . 60)
                (read-expression-history  . 60)
                (regexp-history           . 60)
                (regexp-search-ring       . 20)
                (search-ring              . 20)
                (shell-command-history    . 50)
                tags-file-name
                register-alist)))
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Set up markdown mode
;; cf: http://jblevins.org/projects/markdown-mode/

(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;;   "Major mode for editing GitHub Flavored Markdown files" t)
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Set up yaml mode

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
;; Make CR indent in yaml mode
(add-hook 'yaml-mode-hook
          '(lambda ()
             (define-key yamyesl-mode-map "\C-m" 'newline-and-indent)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Set up magit
;; cf: https://magit.vc/manual/magit/Getting-started.html#Getting-started
;;
(global-set-key (kbd "C-x g") 'magit-status)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Set up react yasnippets, cf https://github.com/johnmastro/react-snippets.el

(require 'react-snippets)
(add-hook 'after-init-hook #'yas-global-mode)
;; Turn off yas in ansi-term though as it gets in the way of autocomplete,
;; cf http://stackoverflow.com/questions/18278310/emacs-ansi-term-not-tab-completing
(add-hook 'term-mode-hook (lambda()
                (yas-minor-mode -1)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Set various autocomplete settings.

;; Make sure to turn on company's autocomplete,
;; cf http://company-mode.github.io/
(add-hook 'after-init-hook 'global-company-mode)

;; Turn on autocomplete in shell buffers,
;; cf https://github.com/monsanto/readline-complete.el/blob/master/readline-complete.el
(require 'readline-complete)

;; Try out bash completion
(require 'bash-completion)
(bash-completion-setup)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Include revbufs.el directly in the init file.
;; This way I only have to move around init.el when setting up emacs on a new system.
;; The original revbufs.el is here: http://www.neilvandyke.org/revbufs/revbufs.el
;;; revbufs.el -- reverts all out-of-date buffers safely

;; Author:   Neil Van Dyke <neil@neilvandyke.org>
;; Version:  1.2
;; X-URL:    http://www.neilvandyke.org/revbufs/
;; X-CVS:    $Id: revbufs.el,v 1.20 2007-03-02 05:45:46 neil Exp $ GMT

;; Copyright (C) 1997-1999,2002,2007 Neil W. Van Dyke.  This is free software;
;; you can redistribute it and/or modify it under the terms of the GNU General
;; Public License as published by the Free Software Foundation; either version
;; 2, or (at your option) any later version.  This is distributed in the hope
;; that it will be useful, but without any warranty; without even the implied
;; warranty of merchantability or fitness for a particular purpose.  See the
;; GNU General Public License for more details.  You should have received a
;; copy of the GNU General Public License along with Emacs; see the file
;; `COPYING'.  If not, write to the Free Software Foundation, Inc., 59 Temple
;; Place, Suite 330, Boston, MA 02111-1307, USA.")

;;; Commentary:

;; `revbufs' reverts Emacs buffers that are visiting files that have been
;; modified outside Emacs' control.  This is useful for files generated by a
;; compiler, or log files.  `revbufs' won't revert a buffer that has been
;; modified (what it calls "conflicts"), and will tell you if any files
;; disappeared out from under your buffers ("orphans").

;;; Change Log:

;; [Version 1.2, 2007-03-01, neil@neilvandyke.org] Added missing `provide'.

;; [Version 1.1, 15-Oct-2002] Updated email address, URL, comments.
;;
;; [Version 1.0, 04-Sep-1999] Initial release.

;;; Code:

(defun revbufs ()
  (interactive)
  (let ((conflicts  '())
        (orphans    '())
        (reverts    '())
        (report-buf (get-buffer-create "*revbufs*")))

    ;; Process the buffers.
    (mapcar (function
             (lambda (buf)
	       (let ((file-name (buffer-file-name buf)))
                 (cond
                  ;; If buf is the report buf, ignore it.
                  ((eq buf report-buf) nil)
                  ;; If buf is not a file buf, ignore it.
                  ((not file-name) nil)
                  ;; If buf file doesn't exist, buf is an orphan.
                  ((not (file-exists-p file-name))
                   (setq orphans (nconc orphans (list buf))))
                  ;; If file modified since buf visit, buf is either a conflict
                  ;; (if it's modified) or we should revert it.
                  ((not (verify-visited-file-modtime buf))
                   (if (buffer-modified-p buf)
                       (setq conflicts (nconc conflicts (list buf)))
                     (save-excursion
                       (set-buffer buf)
                       (revert-buffer t t))
                     (setq reverts (nconc reverts (list buf)))))))))
            (copy-sequence (buffer-list)))

    ;; Prepare the report buffer.
    (save-excursion
      (set-buffer report-buf)
      (setq buffer-read-only nil
            truncate-lines   t)
      (delete-region (point-min) (point-max))
      (insert (revbufs-format-list conflicts "CONFLICTS")
              (revbufs-format-list orphans   "ORPHANS")
              (revbufs-format-list reverts   "REVERTS"))
      (goto-char (point-min))
      (setq buffer-read-only t))
    (bury-buffer report-buf)

    ;; Print message in echo area.
    (if (or conflicts orphans)
        (progn
          (display-buffer report-buf)
          (message
	   (concat
	    (format "Reverted %s with"
		    (revbufs-quantity (length reverts) "buffer"))
	    (if conflicts
		(format " %s%s"
			(revbufs-quantity (length conflicts) "conflict")
			(if orphans " and" "")))
	    (if orphans
		(format " %s"
			(revbufs-quantity (length orphans) "orphan"))))))
      (if reverts
          (message "Reverted %s." (revbufs-quantity (length reverts) "buffer"))
        (message "No buffers need reverting.")))))

(defun revbufs-format-list (list label)
  (if list
      (concat label
              (format " (%s):\n" (length list))
              (mapconcat
               (function
                (lambda (buf)
                  (format "  %-20s %s\n"
                          (buffer-name buf)
                          (buffer-file-name buf))))
               list
               ""))
    ""))

(defun revbufs-quantity (num what)
  (format "%d %s%s" num what (if (= num 1) "" "s")))

(provide 'revbufs)

;; Map M-r to revbufs so I can use it easily.
(global-set-key [(meta r)] 'revbufs)

;; revbufs.el ends here
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Custom variables.

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (bash-completion ztree company readline-complete yaml-mode sane-term markdown-mode flycheck ample-theme flx-ido projectile web-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; End of init.el
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
