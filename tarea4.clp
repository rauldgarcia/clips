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
    (slot status)
    (slot niveldeteccion))

(defrule casosospechoso-1a
    ?paciente <- (paciente (nombre ?nombre)
                           (enfermedadrespiratoria ?enfermedadrespiratoria&:(member$ ?enfermedadrespiratoria ?*enfermedadesrespiratorias*))
                           (viaje ?viaje&:(member$ ?viaje ?*paisescontagiolocal*))
                           (dias ?dias&:(< ?dias 15))
                           (diagnostico nil))
    =>
    (modify ?paciente (diagnostico casosospechoso))
    (printout t ?nombre " es caso sospechoso. Propocionarle mazcarilla n95." crlf))

(defrule casosospechoso-1b
    ?paciente <- (paciente (nombre ?nombre)
                           (enfermedadrespiratoria ?enfermedadrespiratoria&:(member$ ?enfermedadrespiratoria ?*enfermedadesrespiratorias*))
                           (contacto ?contacto&:(member$ ?contacto ?*contactos*))
                           (dias ?dias&:(< ?dias 15))
                           (diagnostico nil))
    =>
    (modify ?paciente (diagnostico casosospechoso))
    (printout t ?nombre " es caso sospechoso. Propocionarle mazcarilla n95." crlf))
    
(defrule casoconfirmado
    ?paciente <- (paciente (nombre ?nombre)
                           (diagnostico casoconfirmado))
    =>
    (printout t ?nombre " es caso confirmado. Propocionarle mazcarilla n95." crlf))

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

(defrule casointubado
    ?paciente <- (paciente (nombre ?nombre)
                           (diagnostico casosospechoso)
                           (status intubado))
    =>
    (printout t "Hacer prueba de covid con lavado bronquioalveolar a " ?nombre "." crlf))

(defrule casofallecido
    ?paciente <- (paciente (nombre ?nombre)
                           (diagnostico casosospechoso)
                           (status fallecido))
    =>
    (printout t "Hacer prueba de covid con biopsia pulmonar a " ?nombre "." crlf))

(defrule casonormal
    ?paciente <- (paciente (nombre ?nombre)
                           (diagnostico casosospechoso)
                           (status nil))
    =>
    (printout t "Hacer prueba de covid con exudado nasofaríngeo y faríngeo a " ?nombre "." crlf))

(defrule deteccionivelprimero
    ?paciente <- (paciente (nombre ?nombre)
                           (diagnostico casosospechoso)
                           (niveldeteccion primero))
    =>
    (printout t "Coordinar caso de " ?nombre "con jurisdiccion sanitaria." crlf))

(defrule deteccionivelsegundo
    ?paciente <- (paciente (nombre ?nombre)
                           (diagnostico casosospechoso)
                           (niveldeteccion segundo))
    =>
    (printout t "Coordinar caso de " ?nombre "con epidemiologo." crlf))

(defrule deteccioniveltercero
    ?paciente <- (paciente (nombre ?nombre)
                           (diagnostico casosospechoso)
                           (niveldeteccion tercero))
    =>
    (printout t "Coordinar caso de " ?nombre " con epidemiologo." crlf))

(deffacts prueba
    (paciente (nombre pancho) 
              (enfermedadrespiratoria leve) 
              (contacto casoconfirmado) 
              (dias 10)
              (status intubado))
    (paciente (nombre maria)
              (diagnostico casoconfirmado))
    (paciente (nombre eugenio)
              (diagnostico casosospechoso)
              (status fallecido))
    (paciente (nombre meriyein)
              (enfermedadrespiratoria aguda)
              (viaje china)
              (dias 13)
              (niveldeteccion segundo)))
