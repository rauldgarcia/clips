(defglobal ?*paisescontagiolocal* =
    (create$ china hongkong coreadelsur japon italia iran singapur))

(defglobal ?*enfermedadesrespiratorias* =
    (create$ aguda leve grave))

(defglobal ?*contactos* =
    (create$ casoconfirmado bajoinvestigacion))

(defrule paissincontagio
    (pais ?pais&:(not (member$ ?pais ?*paisescontagiolocal*)))
    =>
    (assert (pais-status asalvo))
    (printout t ?pais " Es seguro." crlf))

(defrule paisconcontagio
    (pais ?pais&:(member$ ?pais ?*paisescontagiolocal*))
    =>
    (assert (pais-status noasalvo))
    (printout t ?pais " No es seguro." crlf))

(deftemplate paciente
    (slot nombre)
    (slot enfermedadrespiratoria)
    (slot contacto)
    (slot viaje)
    (slot dias)
    (slot diagnostico))

(defrule casosospechoso
    (paciente (nombre ?nombre))
    (paciente (enfermedadrespiratoria ?enfermedadrespiratoria&:(member$ ?enfermedadrespiratoria ?*enfermedadesrespiratorias*)))
    (or (paciente (viaje ?viaje&:(member$ ?viaje ?*paisescontagiolocal*))) (paciente (contacto ?contacto&:(member$ ?contacto ?*contactos*))))
    (paciente (dias ?dias&:(< ?dias 14)))
    =>
    (printout t ?nombre " es caso sospechoso." crlf))

(defrule casoconfirmado
    (paciente (nombre ?nombre))
    (paciente (diagnostico confirmado))
    =>
    (printout t ?nombre " es caso confirmado." crlf))