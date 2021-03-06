(let ((minver "23.3"))
  (when (version<= emacs-version "23.1")
    (error "Your Emacs is too old -- this config requires v%s or higher" minver)))
(when (version<= emacs-version "24")
  (message "Your Emacs is old, and some functionality in this config will be disabled. Please upgrade if possible."))

;; Tell emacs where is your personal elisp lib dir
(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/" user-emacs-directory))
(add-to-list 'load-path "~/.emacs.d/lisp/")


(require 'init-benchmarking) ;; Measure startup time

(defconst *spell-check-support-enabled* nil) ;; Enable with t if you prefer
(defconst *is-a-mac* (eq system-type 'darwin))


;;----------------------------------------------------------------------------
;; Bootstrap config
;;----------------------------------------------------------------------------
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
;;(require 'init-compat)
(require 'init-utils)
(require 'init-site-lisp) ;; Must come before elpa, as it may provide package.el
;;Calls (package-initialize)
(require 'init-elpa)      ;; Machinery for installing required packages
(require 'init-exec-path) ;; Set up $PATH


(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'load-path "~/.emacs.d/elisp/")
(add-to-list 'load-path "/.emacs.d/emacs-eclim/")

(require 'use-package)
(package-initialize)
(diary)


(add-to-list 'auto-mode-alist '("\\.cql\\'" . sql-mode))
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\|todo\\)$" . org-mode))


(setenv "DICTIONARY" "en_GB")

(require 'auto-complete)
(auto-complete-mode)

;; yasnippet for templating
(require 'yasnippet)
(yas-global-mode 1)

;;OSX modifiers
(setq mac-option-key-is-meta nil)
(setq mac-command-key-is-meta t)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

;;JDEE for java development and debugging
;;(add-to-list 'load-path "~/.emacs.d/jdee-2.4.1/lisp")
;;(load "jde")
(setq multi-term-program "/bin/zsh")

;; (add-to-list 'load-path "~/.emacs.d/orgmode-mediawiki")
;; (require 'ox-mediawiki)



;; auto-complete at startup
(require 'auto-complete)
(global-auto-complete-mode t)


(add-to-list 'load-path "./helm")
(require 'helm-config)
;;(helm-mode 1)
(add-to-list 'load-path "./emacs-async")



(require 'init-ido)
;; use ffap for guessing files
(setq ido-use-filename-at-point 'guess)
(setq ido-create-new-buffer 'always)
(setq ido-ignore-extensions t)
(require 'org-mode)
(add-to-list 'org-modules 'org-habit)
(require 'org-habit)


(require 'smooth-scrolling)

;; no backups
(setq make-backup-files nil)

;;text increase
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; (setq echo-keystrokes 0.1
;;       use-dialog-box nil
;;       visible-bell t)
(show-paren-mode t)
(setq column-number-mode t)
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))


;; pair brackets
(require 'autopair)

;; spell
(setq flyspell-issue-welcome-flag nil)
(if (eq system-type 'darwin)
    (setq-default ispell-program-name "/usr/local/bin/aspell")
  (setq-default ispell-program-name "/usr/bin/aspell"))
(setq-default ispell-list-command "list")

;; Markdown mode
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mdown$" . markdown-mode))
(add-hook 'markdown-mode-hook
          (lambda ()
            (visual-line-mode t)
            (writegood-mode t)
            (flyspell-mode t)))
(setq markdown-command "pandoc --smart -f markdown -t html")

;; Lose UI
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
 

(setq path-to-ctags "~/tags") ;; <- your ctags path here
(defun create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (shell-command
   (format "ctags -f %s -e -R %s" path-to-ctags (directory-file-name dir-name)))
  )
;;go to previous
(bind-key "C-x p" 'pop-to-mark-command)
(setq set-mark-command-repeat-pop t)
(use-package smartscan
  :init
   (global-smartscan-mode t))

(require 'recentf)

;; get rid of `find-file-read-only' and replace it with something
;; more useful.
(global-set-key (kbd "C-x C-r") 'ido-recentf-open)

;; enable recent files mode.
(recentf-mode t)

; 50 files ought to be enough.
(setq recentf-max-saved-items 50)

(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))

(setq inhibit-splash-screen t
      initial-scratch-message nil
      initial-major-mode 'org-mode)

(defalias 'yes-or-no-p 'y-or-n-p)



(add-hook 'emacs-startup-hook 'toggle-frame-maximized)
(autoload 'typing-of-emacs "typing" "The Typing Of Emacs, a game." t)

(desktop-save-mode 1)
(setq desktop-restore-eager 10)
(put 'narrow-to-region 'disabled nil)

(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
;; you can select the key you prefer to
;; (define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
(global-set-key (kbd "C-c SPC") 'ace-jump-mode)



;; 
;; enable a more powerful jump back function from ace jump mode
;;
(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

;; When org-mode starts it (org-mode-map) overrides the ace-jump-mode.
(add-hook 'org-mode-hook
          (lambda ()
            (local-set-key (kbd "\C-c SPC") 'ace-jump-mode)))
(projectile-global-mode)

;;(require 'dirtree)
(require 'ox-mediawiki)

(global-set-key (kbd "M-c") 'other-window) ;

;; easy keys for split windows
(global-set-key (kbd "M-1") 'delete-other-windows) ; 【Alt+3】 unsplit all
(global-set-key (kbd "M-2") 'split-window-below)
(global-set-key (kbd "M-3") 'split-window-right)
(put 'scroll-left 'disabled nil)

(require 'deft)
;;(setq deft-directory "~/Dropbox/org")
(setq deft-extensions '("org" "org_archive"))
(setq deft-default-extension "org")
(setq deft-text-mode 'org-mode)
(setq deft-use-filename-as-title t)
;;(setq deft-use-filter-string-for-filename t)
(setq deft-auto-save-interval 0)
;;key to launch deft
(global-set-key (kbd "C-c d") 'deft)
;; set F7 to list recently opened file
(global-set-key (kbd "<f7>") 'recentf-open-files)

(require 'undo-tree)
(global-undo-tree-mode 1)

;;http://ergoemacs.org/emacs/emacs_copy_cut_current_line.html
(require 'copy-paste)
(global-set-key (kbd "<f2>") 'xah-cut-line-or-region) ; cut
(global-set-key (kbd "<f3>") 'xah-copy-line-or-region) ; copy
;;ediff window plain
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(add-to-list 'load-path "~/.emacs.d/swiper/")
(require 'ivy)
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq ivy-height 10)
(setq ivy-count-format "(%d/%d) ")

(setq fiplr-ignored-globs '((directories (".git" ".svn"))
                            (files ("*.jpg" "*.png" "*.zip" "*~" "*.class" "*.jar"))))
(setq fiplr-root-markers '(".git" ".svn"))
(global-set-key (kbd "C-x f") 'fiplr-find-file)


(require 'move-lines)
(move-lines-binding)

(global-set-key (kbd "C-x g") 'magit-status)


(global-set-key (kbd "C-x C-b") 'ibuffer)
    (autoload 'ibuffer "ibuffer" "List buffers." t)
(setq ibuffer-expert t)
(setq ibuffer-show-empty-filter-groups nil)

  (add-hook 'ibuffer-hook
    (lambda ()
      (ibuffer-vc-set-filter-groups-by-vc-root)
      (unless (eq ibuffer-sorting-mode 'alphabetic)
        (ibuffer-do-sort-by-alphabetic))))


;;prevent splitting windows by default
(setq split-height-threshold nil
      split-width-threshold nil)


