;;;; skctl.lisp — a Sheeternetes client in Common Lisp (our Lisp SDK / kubectl).
;;;; Talks to the Apps Script apiserver over HTTP. Homoiconic orchestration.
;;;;
;;;; Deps (Quicklisp): dexador (HTTP), yason (JSON).
;;;;   WEBAPP_URL=... TOKEN=... sbcl --script skctl.lisp get pods
;;;;   ... skctl.lisp scale hello 3
;;;;   ... skctl.lisp apply manifest.json
(eval-when (:load-toplevel :execute)
  (handler-case (ql:quickload '(:dexador :yason) :silent t)
    (error () (format *error-output* "This client needs Quicklisp with :dexador and :yason.~%"))))

(defpackage :sheeternetes
  (:use :cl)
  (:export :api-get :api-post :get-resource :scale :del :apply-file :main))
(in-package :sheeternetes)

(defparameter *url*   (uiop:getenv "WEBAPP_URL"))
(defparameter *token* (or (uiop:getenv "TOKEN") "CHANGE_ME_super_secret"))

(defun need-url ()
  (unless *url* (error "set WEBAPP_URL to the Apps Script /exec URL")))

(defun api-get (kind)
  "GET a resource kind (pods|nodes|deployments|events); returns parsed JSON."
  (need-url)
  (yason:parse (dex:get (format nil "~a?token=~a&kind=~a" *url* *token* kind))))

(defun ->json (ht)
  (with-output-to-string (s) (yason:encode ht s)))

(defun api-post (alist)
  "POST a control action. ALIST becomes the JSON body."
  (need-url)
  (let ((ht (make-hash-table :test 'equal)))
    (loop for (k . v) in alist do (setf (gethash k ht) v))
    (setf (gethash "token" ht) *token*)
    (yason:parse
     (dex:post *url* :headers '(("content-type" . "application/json"))
                     :content (->json ht)))))

(defun get-resource (kind)
  "Print a resource kind as a simple table."
  (let* ((data (api-get kind))
         (items (gethash "items" data)))
    (dolist (it items)
      (format t "~{~a~^	~}~%"
              (mapcar (lambda (k) (or (gethash k it) "-"))
                      (case (intern (string-upcase kind) :keyword)
                        (:pods '("name" "deployment" "node" "phase"))
                        (:nodes '("name" "ip" "cpu_total" "status"))
                        (:deployments '("name" "image" "replicas"))
                        (t '("ts" "kind" "object" "message"))))))))

(defun scale (name replicas)
  (api-post `(("action" . "scale") ("name" . ,name) ("replicas" . ,replicas))))

(defun del (name)
  (api-post `(("action" . "delete") ("name" . ,name))))

(defun apply-file (path)
  "Apply a manifest file: {\"deployments\":[...]} -> action:apply."
  (let* ((spec (with-open-file (in path) (yason:parse in)))
         (deployments (gethash "deployments" spec)))
    (api-post `(("action" . "apply") ("deployments" . ,deployments)))))

(defun main ()
  (let* ((args (uiop:command-line-arguments))
         (cmd (first args)))
    (cond
      ((string= cmd "get")   (get-resource (or (second args) "pods")))
      ((string= cmd "scale") (format t "~a~%" (scale (second args) (parse-integer (third args)))))
      ((string= cmd "delete")(format t "~a~%" (del (second args))))
      ((string= cmd "apply") (format t "~a~%" (apply-file (second args))))
      (t (format t "usage: skctl.lisp get pods|nodes|deployments|events | scale <name> <n> | delete <name> | apply <file>~%")))))

(eval-when (:execute)
  (when (uiop:command-line-arguments) (main)))
