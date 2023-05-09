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
    (slot id)
    (slot enfermedadrespiratoria)
    (slot contacto)
    (slot viaje)
    (slot dias)
    (slot diagnostico)
    (slot estatus))

(defrule casosospechoso-1a
    ?paciente <- (paciente (nombre ?nombre)
                           (enfermedadrespiratoria ?enfermedadrespiratoria&:(member$ ?enfermedadrespiratoria ?*enfermedadesrespiratorias*))
                           (viaje ?viaje&:(member$ ?viaje ?*paisescontagiolocal*))
                           (dias ?dias&:(< ?dias 15))
                           (diagnostico nil))
    =>
    (modify ?paciente (diagnostico casosospechoso))
    (printout t ?nombre " es caso sospechoso." crlf))

(defrule casosospechoso-1b
    ?paciente <- (paciente (nombre ?nombre)
                           (enfermedadrespiratoria ?enfermedadrespiratoria&:(member$ ?enfermedadrespiratoria ?*enfermedadesrespiratorias*))
                           (contacto ?contacto&:(member$ ?contacto ?*contactos*))
                           (dias ?dias&:(< ?dias 15))
                           (diagnostico nil))
    =>
    (modify ?paciente (diagnostico casosospechoso))
    (printout t ?nombre " es caso sospechoso." crlf))
    
(defrule casoconfirmado
    ?paciente <- (paciente (nombre ?nombre)
                           (diagnostico casoconfirmado))
    =>
    (printout t ?nombre " es caso confirmado." crlf))

(defrule identificacioncasosospechoso
    ?paciente <- (paciente (nombre ?nombre)
                           (diagnostico casosospechoso))
    =>
    (printout t "Hay que aislar a " ?nombre " en cubiculo ventilado y mantener la puerta cerrada." crlf))

(defrule identificacioncasoconfirmado
    ?paciente <- (paciente (nombre ?nombre)
                           (diagnostico casoconfirmado))
    =>
    (printout t "Hay que aislar a " ?nombre " en cubiculo ventilado y mantener la puerta cerrada." crlf))

(deffacts prueba
    (paciente (nombre pancho) 
              (enfermedadrespiratoria leve) 
              (contacto casoconfirmado) 
              (dias 10)))

(deffacts prueba2
    (paciente (nombre maria) 
              (diagnostico casoconfirmado)))