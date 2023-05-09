(defrule regla-01
    (sala humeda)
    (cocina seca)
    =>
    (assert (fuga_en baño)))

(defrule regla-02
    (sala humeda)
    (baño seco)
    =>
    (assert (problema_en cocina)))

(defrule regla-03a
    (ventana cerrada)
    =>
    (assert (agua_del_exterior no)))

(defrule regla-03b
    (lluvia no)
    =>
    (assert (agua_del_exterior no)))

(defrule regla-04
    (problema_en cocina)
    (agua_del_exterior no)
    =>
    (assert (fuga_en cocina))
    (printout t "La fuga está en la cocina." crlf))

(deffacts fugas
    (sala humeda)
    (baño seco)
    (ventana cerrada))