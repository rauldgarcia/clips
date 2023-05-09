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

(defrule casosospechoso-1a
    ?paciente <- (paciente (nombre ?nombre)
                           (enfermedadrespiratoria ?enfermedadrespiratoria&:(member$ ?enfermedadrespiratoria ?*enfermedadesrespiratorias*))
                           (viaje ?viaje&:(member$ ?viaje ?*paisescontagiolocal*))
                           (dias ?dias&:(< ?dias 14))
                           (diagnostico nil))
    =>
    (modify ?paciente (diagnostico casosospechoso))
    (printout t ?nombre " es caso sospechoso." crlf))

(defrule casosospechoso-1b
    ?paciente <- (paciente (nombre ?nombre)
                           (enfermedadrespiratoria ?enfermedadrespiratoria&:(member$ ?enfermedadrespiratoria ?*enfermedadesrespiratorias*))
                           (contacto ?contacto&:(member$ ?contacto ?*contactos*))
                           (dias ?dias&:(< ?dias 14))
                           (diagnostico nil))
    =>
    (modify ?paciente (diagnostico casosospechoso))
    (printout t ?nombre " es caso sospechoso." crlf))
    

(defrule casoconfirmado
    (paciente (nombre ?nombre))
    (paciente (diagnostico confirmado))
    =>
    (printout t ?nombre " es caso confirmado." crlf))