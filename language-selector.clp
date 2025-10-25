;;; BACKEND LANGUAGE SELECTOR EXPERT SYSTEM

(deftemplate question
    (slot id)
    (slot text)
    (slot type)
    (multislot options)
)

(deftemplate answer
    (slot question-id)
    (slot value)
)

(deftemplate recommendation
    (slot language)
    (slot score)
    (slot reason)
)

(deffacts languages
    (language JavaScript-Nodejs)
    (language Python)
    (language Java)
    (language Go)
    (language Rust)
    (language PHP)
    (language C-Sharp)
)

(deffacts questions
    (question (id project-type) 
        (text "What type of project are you building?")
        (type single)
        (options Web-API Microservices Real-time Data-Science Desktop Mobile-Backend)
    )
    
    (question (id experience-level)
        (text "What is your programming experience level?")
        (type single)
        (options Beginner Intermediate Advanced)
    )
    
    (question (id performance-needs)
        (text "What are your performance requirements?")
        (type single)
        (options Low Medium High Critical)
    )
    
    (question (id team-size)
        (text "What is your team size?")
        (type single)
        (options Solo Small-team Medium-team Large-team)
    )
    
    (question (id development-speed)
        (text "How important is development speed?")
        (type single)
        (options Not-important Somewhat-important Very-important Critical)
    )
)

;; Add initial fact to start the system
(deffacts startup
    (start-system)
)

;;; RECOMMENDATION RULES
(defrule recommend-python-beginner
    (answer (question-id experience-level) (value Beginner))
    (answer (question-id project-type) (value Data-Science))
    =>
    (assert (recommendation (language Python) (score 90) 
        (reason "Great for beginners and excellent for Data Science projects")))
)

(defrule recommend-nodejs-realtime
    (answer (question-id project-type) (value Real-time))
    =>
    (assert (recommendation (language JavaScript-Nodejs) (score 85)
        (reason "Perfect for real-time applications with event-driven architecture")))
)

(defrule recommend-go-microservices
    (answer (question-id project-type) (value Microservices))
    (answer (question-id performance-needs) (value High|Critical))
    =>
    (assert (recommendation (language Go) (score 88)
        (reason "Excellent for microservices with built-in concurrency support")))
)

(defrule recommend-java-enterprise
    (answer (question-id team-size) (value Large-team))
    (answer (question-id performance-needs) (value High|Critical))
    =>
    (assert (recommendation (language Java) (score 82)
        (reason "Ideal for large teams and enterprise applications")))
)

(defrule recommend-rust-critical
    (answer (question-id performance-needs) (value Critical))
    (answer (question-id experience-level) (value Advanced))
    =>
    (assert (recommendation (language Rust) (score 95)
        (reason "Unmatched performance and memory safety for critical systems")))
)

(defrule recommend-php-web
    (answer (question-id project-type) (value Web-API))
    (answer (question-id experience-level) (value Beginner))
    =>
    (assert (recommendation (language PHP) (score 75)
        (reason "Quick development for web APIs and easy for beginners")))
)

(defrule recommend-python-fast-dev
    (answer (question-id development-speed) (value Very-important|Critical))
    (answer (question-id experience-level) (value Beginner|Intermediate))
    =>
    (assert (recommendation (language Python) (score 80)
        (reason "Fast development cycle and easy to learn")))
)

(defrule recommend-csharp-enterprise
    (answer (question-id project-type) (value Web-API|Desktop))
    (answer (question-id team-size) (value Medium-team|Large-team))
    =>
    (assert (recommendation (language C-Sharp) (score 83)
        (reason "Excellent for enterprise applications with strong tooling")))
)

;;; QUESTION ASKING RULES
(defrule ask-project-type
    (start-system)
    (not (answer (question-id project-type)))
    =>
    (printout t crlf "What type of project are you building?" crlf)
    (printout t "Options: Web-API, Microservices, Real-time, Data-Science, Desktop, Mobile-Backend" crlf)
    (printout t "Your answer: ")
    (bind ?answer (read))
    (assert (answer (question-id project-type) (value ?answer)))
)

(defrule ask-experience-level
    (answer (question-id project-type))
    (not (answer (question-id experience-level)))
    =>
    (printout t crlf "What is your programming experience level?" crlf)
    (printout t "Options: Beginner, Intermediate, Advanced" crlf)
    (printout t "Your answer: ")
    (bind ?answer (read))
    (assert (answer (question-id experience-level) (value ?answer)))
)

(defrule ask-performance-needs
    (answer (question-id experience-level))
    (not (answer (question-id performance-needs)))
    =>
    (printout t crlf "What are your performance requirements?" crlf)
    (printout t "Options: Low, Medium, High, Critical" crlf)
    (printout t "Your answer: ")
    (bind ?answer (read))
    (assert (answer (question-id performance-needs) (value ?answer)))
)

(defrule ask-team-size
    (answer (question-id performance-needs))
    (not (answer (question-id team-size)))
    =>
    (printout t crlf "What is your team size?" crlf)
    (printout t "Options: Solo, Small-team, Medium-team, Large-team" crlf)
    (printout t "Your answer: ")
    (bind ?answer (read))
    (assert (answer (question-id team-size) (value ?answer)))
)

(defrule ask-development-speed
    (answer (question-id team-size))
    (not (answer (question-id development-speed)))
    =>
    (printout t crlf "How important is development speed?" crlf)
    (printout t "Options: Not-important, Somewhat-important, Very-important, Critical" crlf)
    (printout t "Your answer: ")
    (bind ?answer (read))
    (assert (answer (question-id development-speed) (value ?answer)))
)

;;; OUTPUT RULES
(defrule show-recommendations
    (declare (salience -10))
    (answer (question-id development-speed))
    =>
    (printout t crlf "**********************************" crlf)
    (printout t " RECOMMENDATION RESULTS" crlf)
    (printout t "**********************************" crlf)
)

(defrule display-recommendation
    (declare (salience -20))
    ?rec <- (recommendation (language ?lang) (score ?score) (reason ?reason))
    =>
    (printout t crlf "Language: " ?lang crlf)
    (printout t "Score: " ?score "/100" crlf)
    (printout t "Reason: " ?reason crlf)
    (printout t "----------------------------------" crlf)
    (retract ?rec)
)

(defrule no-recommendation
    (declare (salience -30))
    (answer (question-id development-speed))
    (not (recommendation))
    =>
    (printout t crlf "No specific recommendation matched your criteria." crlf)
    (printout t "Default Recommendation: Python" crlf)
    (printout t "Reason: Python is versatile and good for general purpose development." crlf)
    (printout t "**********************************" crlf)
)

(defrule end-recommendations
    (declare (salience -40))
    =>
    (printout t crlf "Thank you for using the Backend Language Selector!" crlf)
    (printout t "**********************************" crlf)
)

;;; MAIN FUNCTION
(deffunction main ()
    (printout t crlf)
    (printout t "**********************************" crlf)
    (printout t " Backend Language Selector v1.0 " crlf)
    (printout t "**********************************" crlf)
    (printout t "Please answer the following questions:" crlf)
    (reset)
    (run)
)