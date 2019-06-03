<%@ WebHandler Language="VB" Class="docSubirDocumento_UploadDocumento" %>
Imports System.IO
Imports System.Web
Imports System.Web.Services
Imports System.Data.SqlClient
Imports System
Imports System.Web.SessionState
Imports Solex.Base.DataAccess
Imports Solex.Base.Comun
Imports Solex.Base.Comun.Utilities
Imports System.Data

Public Class docSubirDocumento_UploadDocumento : Implements System.Web.IHttpHandler, IReadOnlySessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        Const IdAplicacion_Documento As Integer = 296
        Const IdAplicacion_Log As Integer = 297

        Dim myBoSetDocumento, log As BOSET
        Dim myBoSetTarea As BOSET
        Dim myBosession As BOSession
        Dim stjson As String = String.Empty
        Dim archivo As System.Web.HttpPostedFile
        Dim corr As String = String.Empty
        Dim arMimeTypes As String()
        Dim stError As String = String.Empty
        Dim stMimeTypes As String = String.Empty
        Dim stpath As String = String.Empty
        Dim stpathDoc As String = String.Empty
        Dim nombreArchivo As String = String.Empty
        Dim nombreArchivoF As String = String.Empty
        Dim nombreArchivoAnterior As String = String.Empty
        Dim extension() As String
        Dim mimetype As String = String.Empty
        Dim stNombre As String = String.Empty
        Dim stNombreFormat As String = String.Empty
        Dim stfilename As String = String.Empty
        Dim stfilenametmp As String = String.Empty
        Dim stfilenameResp As String = String.Empty
        Dim stfilenameAnt As String = String.Empty
        Dim Oculto As String = String.Empty

        'Parametros necesarios obtenidos desde el cliente.
        Dim nombreTabla As String = String.Empty
        Dim idTabla As Integer = 0
        Dim nombreCampo As String = String.Empty
        Dim tipoMaterial As String = String.Empty
        Dim idEvaluacion As Integer = 0
        Dim idDocumento As Integer = 0
        Dim idDocumento_actual As Integer = 0

        Dim stSql As String = String.Empty
        Dim ano As String = String.Empty
        Dim rut As String = String.Empty
        Dim Peso As Integer = 0
        Dim PesoActual As Integer = 0
        Dim sPesoMaximo As Integer = 0
        Dim existe As Boolean = False
        Dim maximo As Boolean = False
        Dim fecha As Date
        Dim tipoOperacion As String

        Dim idfile As New Guid
        idfile = Guid.NewGuid

        myBosession = CType(context.Session("MySession"), BOSession)

        If CType(context.Session(IdAplicacion_Documento & "_Boset"), BOSET) Is Nothing Then
            context.Session(IdAplicacion_Documento & "_Boset") = CType(context.Session("MySession"), BOSession).GetBoset(IdAplicacion_Documento)
        End If

        myBoSetDocumento = CType(context.Session(IdAplicacion_Documento & "_Boset"), BOSET)

        If CType(context.Session(IdAplicacion_Log & "_Boset"), BOSET) Is Nothing Then
            context.Session(IdAplicacion_Log & "_Boset") = CType(context.Session("MySession"), BOSession).GetBoset(IdAplicacion_Log)
        End If

        log = CType(context.Session(IdAplicacion_Log & "_Boset"), BOSET)

        Try
            stjson = "{""d"":{""__error"":""""""}}"

            myBoSetTarea = CType(context.Session(context.Request("IdAplicacion").ToString & "_Boset"), BOSET)

            stMimeTypes = context.Request("Mimetypes").ToString
            arMimeTypes = stMimeTypes.Split(",")

            nombreTabla = myBoSetTarea.CleanSqlInyection(context.Request("NombreTabla").ToString)
            idTabla = context.Request("IdTabla").ToString
            nombreCampo = context.Request("NombreCampo").ToString
            tipoMaterial = myBoSetTarea.CleanSqlInyection(context.Request("TipoMaterial").ToString)
            idEvaluacion = context.Request("idEvaluacion").ToString
            idDocumento = context.Request("idDocumento").ToString

            If Not myBoSetTarea Is Nothing AndAlso idTabla = myBoSetTarea.GetString("ID_" & nombreTabla) Then
                Peso = CDec(context.Request.Files(0).ContentLength / 1024)
                stpath = ConfigurationManager.AppSettings("PathDocumento")
                sPesoMaximo = CDec(ConfigurationManager.AppSettings("PesoMaximoDocumento"))

                If context.Request.Files.Count > 0 Then
                    archivo = context.Request.Files(0)
                    mimetype = archivo.ContentType
                    stfilename = Path.Combine(stpath, archivo.FileName)

                    stNombre = ReplaceCharFreak(archivo.FileName)

                    extension = Split(stNombre, ".")
                    If extension.Length > 1 Then
                        stNombreFormat = Mid(Mid(stNombre, 1, stNombre.Length - CType(extension(extension.Length - 1), String).Length - 1), 1, 36)
                        If Not ((extension(extension.Length - 1).ToLower() = "tmp" Or (stNombre.StartsWith("~")))) Then

                            If arMimeTypes.Contains(mimetype) AndAlso extension(extension.Length - 1).ToLower() <> "rtf" Then '11/05/2018 LC - Se agrega nueva excepción y no se deja agregar archivos con extensión RTF. 

                                myBoSetDocumento.Reset()
                                myBoSetDocumento.SearchFilter = "NOMBRE_TABLA = '" & nombreTabla & "'"
                                myBoSetDocumento.SearchFilter = "ID_TABLA = " & idTabla
                                myBoSetDocumento.SearchFilter = "TIPO_MATERIAL = '" & tipoMaterial & "'"
                                myBoSetDocumento.FillBoset()

                                fecha = myBoSetDocumento.GetDBDate

                                'RBORLONE 08-04-2016 Verifica que no hayan mas de 5 documentos siempre que este subiendo un nuevo documento.
                                If idDocumento = 0 Then
                                    If myBoSetDocumento.RowCount >= 5 Then
                                        maximo = True
                                    End If
                                End If

                                If Not maximo Then
                                    'RBORLONE 08-04-2016 Verifica que el documento exista.

                                    If myBoSetDocumento.RowCount > 0 Then
                                        For index = 0 To myBoSetDocumento.RowCount - 1
                                            If idDocumento = 0 And myBoSetDocumento.GetString("NOMBRE_DOCUMENTO_REAL").ToLower = stNombre.ToLower Then
                                                existe = True
                                                Exit For
                                            ElseIf myBoSetDocumento.GetString("NOMBRE_DOCUMENTO_REAL").ToLower = stNombre.ToLower And myBoSetDocumento.GetInteger("ID_DOCUMENTO") <> idDocumento Then
                                                existe = True
                                                Exit For
                                            End If
                                            myBoSetDocumento.NextRow()
                                        Next
                                    End If
                                    If Not existe Then
                                        If Peso > 0 Then

                                            'SPALMA 21-07-2016  subir archivo en carpeta temporal
                                            stfilenametmp = stpath & "temporal\" & idEvaluacion.ToString & "_" & idfile.ToString & "." & extension(extension.Length - 1)
                                            archivo.SaveAs(stfilenametmp)

                                            '**********************************************************
                                            If File.Exists(stfilenametmp) Then

                                                ano = context.Session("AnoPeriodo")
                                                rut = context.Session("RUT_DOCENTE")

                                                myBoSetDocumento.BeginTransaction()

                                                'INSERTA
                                                If idDocumento = 0 Then

                                                    tipoOperacion = "SUBE"

                                                    'Guardamos la información en PD_DOCUMENTO
                                                    stSql = "INSERT INTO PD_DOCUMENTO (NOMBRE_TABLA,ID_TABLA,NOMBRE_CAMPO,ID_EVALUACION,NOMBRE_DOCUMENTO_REAL,TIPO_MATERIAL,PESO,ID_USR_ACTUALIZACION,FECHA_ACTUALIZACION)  VALUES ("
                                                    stSql &= "'" & nombreTabla & "'"
                                                    stSql &= "," & idTabla.ToString
                                                    stSql &= ",'" & nombreCampo & "'"
                                                    stSql &= "," & idEvaluacion.ToString
                                                    stSql &= ",'" & stNombre.Trim & "'"
                                                    stSql &= ",'" & tipoMaterial & "'"
                                                    stSql &= "," & Peso.ToString
                                                    stSql &= "," & myBosession.UserID.ToString
                                                    stSql &= ", CONVERT(datetime, '" & Format(fecha, "yyyy-MM-dd HH:mm:ss") & "',121)"
                                                    stSql &= ")"

                                                    myBoSetDocumento.ExecuteNonQuery(stSql)

                                                    idDocumento_actual = myBoSetDocumento.ExecuteScalar("select SCOPE_IDENTITY()")

                                                    nombreArchivo = ano & "_" & rut & "_" & nombreTabla & tipoMaterial & "_" & idDocumento_actual.ToString & "." & extension(extension.Length - 1)
                                                    nombreArchivo = ReplaceCharFreak(nombreArchivo)
                                                    nombreArchivoF = stNombreFormat & "." & extension(extension.Length - 1)

                                                    'Actualizar documento recien insertado
                                                    stSql = "UPDATE PD_DOCUMENTO SET "
                                                    stSql &= "NOMBRE_DOCUMENTO_SERVIDOR = '" & nombreArchivo & "'"
                                                    stSql &= ",NOMBRE_DOCUMENTO_REAL_FORMATEADO = '" & nombreArchivoF & "'"
                                                    stSql &= " WHERE ID_DOCUMENTO = " & idDocumento_actual.ToString

                                                    myBoSetDocumento.ExecuteNonQuery(stSql)


                                                    'REEMPLAZA
                                                ElseIf idDocumento > 0 Then

                                                    tipoOperacion = "REEMPLAZA"
                                                    idDocumento_actual = idDocumento

                                                    'SPALMA 25-04-2016 Se obtiene el valor del archivo anterior que sera reemplazado
                                                    nombreArchivoAnterior = myBoSetDocumento.ExecuteScalar("SELECT NOMBRE_DOCUMENTO_SERVIDOR FROM PD_DOCUMENTO WHERE ID_DOCUMENTO = " & idDocumento_actual.ToString)

                                                    nombreArchivo = ano & "_" & rut & "_" & nombreTabla & tipoMaterial & "_" & idDocumento_actual.ToString & "." & extension(extension.Length - 1)
                                                    nombreArchivo = ReplaceCharFreak(nombreArchivo)
                                                    nombreArchivoF = stNombreFormat & "." & extension(extension.Length - 1)

                                                    'Actualiza documento
                                                    stSql = "UPDATE PD_DOCUMENTO SET "
                                                    stSql &= "NOMBRE_DOCUMENTO_REAL = '" & stNombre & "'"
                                                    stSql &= ",NOMBRE_DOCUMENTO_SERVIDOR = '" & nombreArchivo & "'"
                                                    stSql &= ",NOMBRE_DOCUMENTO_REAL_FORMATEADO = '" & nombreArchivoF & "'"
                                                    stSql &= ",PESO = " & Peso.ToString
                                                    stSql &= ",ID_USR_ACTUALIZACION = " & myBosession.UserID.ToString
                                                    stSql &= ",FECHA_ACTUALIZACION = CONVERT(datetime, '" & Format(fecha, "yyyy-MM-dd HH:mm:ss") & "',121)"
                                                    stSql &= " WHERE ID_DOCUMENTO = " & idDocumento_actual.ToString

                                                    myBoSetDocumento.ExecuteNonQuery(stSql)
                                                Else

                                                    stError = "No es posible guardar el documento."

                                                    Throw New Exception(stError)
                                                End If

                                                'Insertar el log de documento                              
                                                stSql = "INSERT INTO PD_DOCUMENTO_LOG (ID_DOCUMENTO,NOMBRE_TABLA,ID_TABLA,NOMBRE_CAMPO,ID_EVALUACION,NOMBRE_DOCUMENTO_REAL,NOMBRE_DOCUMENTO_REAL_FORMATEADO,NOMBRE_DOCUMENTO_SERVIDOR,TIPO_MATERIAL,PESO,OPERACION,ID_USR_ACTUALIZACION,FECHA_ACTUALIZACION) "
                                                stSql &= " select ID_DOCUMENTO,NOMBRE_TABLA,ID_TABLA,NOMBRE_CAMPO,ID_EVALUACION,NOMBRE_DOCUMENTO_REAL,NOMBRE_DOCUMENTO_REAL_FORMATEADO,NOMBRE_DOCUMENTO_SERVIDOR,TIPO_MATERIAL,PESO"
                                                stSql &= ",'" & tipoOperacion & "'"
                                                stSql &= "," & myBosession.UserID.ToString
                                                stSql &= ", CONVERT(datetime, '" & Format(fecha, "yyyy-MM-dd HH:mm:ss") & "',121)"
                                                stSql &= " FROM PD_DOCUMENTO WHERE ID_DOCUMENTO = " & idDocumento_actual.ToString

                                                myBoSetDocumento.ExecuteNonQuery(stSql)

                                                'RBORLONE 18-04-2016 Se agrega ejecucion de procedimiento almacenado que actualiza el estado de avance, para este caso segun la tabla.
                                                Dim boParams() As BoParameter = New BoParameter(0) {}
                                                boParams(0) = New BoParameter("@ID_EVALUACION", BoType.Int, 32, idEvaluacion)
                                                myBoSetDocumento.ExecuteSp("PD_ACT_ESTADO_AVANCE_" & nombreTabla, boParams)

                                                'Guardar archivos adjuntos e eliminar los anteriores
                                                stpathDoc = stpath & ano & "\" & idEvaluacion & "\"

                                                If Not Directory.Exists(stpathDoc) Then
                                                    Directory.CreateDirectory(stpathDoc)
                                                End If

                                                ''SPALMA 25-04-2016 Se elimina archivo anterior si al reemplazar cambia de extension 
                                                'If idDocumento > 0 And nombreArchivo <> nombreArchivoAnterior Then
                                                '    File.Delete(stpath + nombreArchivoAnterior)
                                                'End If
                                                
                                                'CMC 15-05-2019 Se mueve archivo anterior a carpeta temporal como respardo hasta terminar la transacción 
                                                If idDocumento > 0 Then
                                                    stfilenameAnt = stpathDoc & nombreArchivoAnterior
                                                    stfilenameResp = stpath & "temporal\" & nombreArchivoAnterior
                                                    If File.Exists(stfilenameResp) Then
                                                        File.Delete(stfilenameResp)
                                                    End If
                                                    'Mover de carpeta del docente a carpeta temporal
                                                    File.Move(stfilenameAnt, stfilenameResp)
                                                End If

                                                'SPALMA  21-07-2016  Mover archivo temporal a carpeta definitiva del docente
                                                stfilename = stpathDoc + nombreArchivo.Trim
                                                If File.Exists(stfilename) Then
                                                    File.Delete(stfilename)
                                                End If
                                                File.Move(stfilenametmp, stfilename)

                                                myBoSetDocumento.CommitTransaction()

                                                'CMC 15-05-2019 eliminar archivo de respaldo de la carpeta temporal
                                                If stfilenameResp <> "" Then
                                                    If File.Exists(stfilenameResp) Then
                                                        File.Delete(stfilenameResp)
                                                    End If
                                                End If
                                                                                                
                                                stjson = "{""d"":{""__error"":"""","

                                                If idDocumento = 0 Then
                                                    stjson += """__nombre"":" + Serialize("Se guardó el archivo correctamente.", Newtonsoft.Json.StringEscapeHandling.EscapeHtml) + "}}"
                                                Else
                                                    stjson += """__nombre"":" + Serialize("Archivo reemplazado exitosamente.", Newtonsoft.Json.StringEscapeHandling.EscapeHtml) + "}}"
                                                End If
                                            Else
                                                cLog.WriteMessage(idEvaluacion.ToString & "-" & nombreTabla & "-" & "No se pudo subir el archivo , intente nuevamente.")
                                                stjson = "{""d"":{""__error"":" + Serialize("No se pudo subir el archivo , intente nuevamente.", Newtonsoft.Json.StringEscapeHandling.EscapeHtml) + ","
                                                stjson += """__nombre"":""""}}"

                                            End If

                                        Else
                                            stjson = "{""d"":{""__error"":" + Serialize("El archivo que intenta adjuntar no tiene información.", Newtonsoft.Json.StringEscapeHandling.EscapeHtml) + ","
                                            stjson += """__nombre"":""""}}"
                                        End If
                                    Else
                                        cLog.WriteMessage(idEvaluacion.ToString & "-" & nombreTabla & "-" & "El archivo que intenta subir tiene el mismo nombre que un archivo subido anteriormente.")
                                        stjson = "{""d"":{""__error"":" + Serialize("El archivo que intenta subir tiene el mismo nombre que un archivo subido anteriormente.", Newtonsoft.Json.StringEscapeHandling.EscapeHtml) + ","
                                        stjson += """__nombre"":""""}}"
                                    End If
                                Else
                                    If tipoMaterial = "PAUA" Then
                                        stjson = "{""d"":{""__error"":" + Serialize("Usted puede adjuntar un máximo de 5 archivos como lista, escala o rúbrica.", Newtonsoft.Json.StringEscapeHandling.EscapeHtml) + ","
                                        stjson += """__nombre"":""""}}"
                                    ElseIf tipoMaterial = "PAUB" Then
                                        stjson = "{""d"":{""__error"":" + Serialize("Usted puede adjuntar un máximo de 5 archivos como pauta de corrección.", Newtonsoft.Json.StringEscapeHandling.EscapeHtml) + ","
                                        stjson += """__nombre"":""""}}"
                                    ElseIf tipoMaterial = "GPE" Then
                                        stjson = "{""d"":{""__error"":" + Serialize("Usted puede adjuntar un máximo de 5 archivos como guía o prueba.", Newtonsoft.Json.StringEscapeHandling.EscapeHtml) + ","
                                        stjson += """__nombre"":""""}}"
                                    ElseIf tipoMaterial = "ADJ" Then
                                        stjson = "{""d"":{""__error"":" + Serialize("Usted puede adjuntar un máximo de 5 archivos.", Newtonsoft.Json.StringEscapeHandling.EscapeHtml) + ","
                                        stjson += """__nombre"":""""}}"
                                    Else
                                        stjson = "{""d"":{""__error"":" + Serialize("Usted puede adjuntar un máximo de 5 archivos como recursos de aprendizaje.", Newtonsoft.Json.StringEscapeHandling.EscapeHtml) + ","
                                        stjson += """__nombre"":""""}}"
                                    End If
                                End If
                            Else
                                cLog.WriteMessage(idEvaluacion.ToString & "-" & nombreTabla & "-" & "El tipo de archivo que intenta subir es distinto a los tipos especificados en el Manual del Portafolio.")
                                stjson = "{""d"":{""__error"":" + Serialize("El tipo de archivo que intenta subir es distinto a los tipos especificados en el Manual del Portafolio.", Newtonsoft.Json.StringEscapeHandling.EscapeHtml) + ","
                                stjson += """__nombre"":""""}}"
                            End If
                        Else
                            cLog.WriteMessage(idEvaluacion.ToString & "-" & nombreTabla & "-" & "El archivo no se puede adjuntar. Cierre el archivo y vuelva a cargarlo.")
                            stjson = "{""d"":{""__error"":" + Serialize("El archivo no se puede adjuntar. Cierre el archivo y vuelva a cargarlo.", Newtonsoft.Json.StringEscapeHandling.EscapeHtml) + ","
                            stjson += """__nombre"":""""}}"
                        End If
                    Else
                        cLog.WriteMessage(idEvaluacion.ToString & "-" & nombreTabla & "-" & "El archivo que intenta subir no tiene extensión. Revise su archivo y vuelva a cargarlo.")
                        stjson = "{""d"":{""__error"":" + Serialize("El archivo que intenta subir no tiene extensión. Revise su archivo y vuelva a cargarlo.", Newtonsoft.Json.StringEscapeHandling.EscapeHtml) + ","
                        stjson += """__nombre"":""""}}"
                    End If
                Else
                    cLog.WriteMessage(idEvaluacion.ToString & "-" & nombreTabla & "-" & "No se recibio el archivo enviado.")
                    stjson = "{""d"":{""__error"":" + Serialize("No se recibio el archivo enviado.", Newtonsoft.Json.StringEscapeHandling.EscapeHtml) + ","
                    stjson += """__nombre"":""""}}"
                End If

            Else
                cLog.WriteMessage(idEvaluacion.ToString & "-" & nombreTabla & "-" & "Esta sesión expiró. Existe una sesión activa en otra pestaña.")
                stjson = "{""d"":{""__error"":" + Serialize("Esta sesión expiró. Existe una sesión activa en otra pestaña.", Newtonsoft.Json.StringEscapeHandling.EscapeHtml) + ","
                stjson += """__nombre"":""""}}"
            End If

        Catch ex As Exception
            cLog.WriteMessage(idfile.ToString & " - " & ex.Message & " - " & nombreTabla & "-" & idEvaluacion.ToString & " - " & stfilenametmp)
            stError = "Error: " + ex.Message
            If ex.Message.IndexOf("interbloqueo") > 0 Then
                stjson = "{""d"":{""__error"":" + Serialize("Ha Ocurrido un Error. Intente otra véz", Newtonsoft.Json.StringEscapeHandling.EscapeHtml) + "}}"
            Else
                stjson = "{""d"":{""__error"":" + Serialize(stError, Newtonsoft.Json.StringEscapeHandling.EscapeHtml) + "}}"
            End If
            'stjson = "{""d"":{""__error"":" + Serialize(stError, Newtonsoft.Json.StringEscapeHandling.EscapeHtml) + "}}"

            If myBoSetDocumento.BOSession.IsOnTransaction Then
                myBoSetDocumento.RollbackTransaction()
            End If
            
            'CMC 15-05-2019 Si existe archivo que subio recien
            If stfilename <> "" Then
                If File.Exists(stfilename) Then
                    File.Delete(stfilename)
                End If
            End If
            
            'CMC 15-05-2019 Si existe respaldo mover a carpeta del docente
            If stfilenameResp <> "" Then
                If File.Exists(stfilenameResp) Then
                    File.Move(stfilenameResp, stfilenameAnt)
                End If
            End If
        Finally

            'cLog.WriteMessage(idfile.ToString & " - " & stjson & " - " & idEvaluacion.ToString)

            stMimeTypes = Nothing
            arMimeTypes = Nothing
            archivo = Nothing
            mimetype = Nothing
            stfilename = Nothing
            stfilenametmp = Nothing
            stNombre = Nothing
            stNombreFormat = Nothing
            extension = Nothing
            stError = Nothing
            stpath = Nothing
            nombreArchivo = Nothing
            idEvaluacion = Nothing
            idDocumento = Nothing
            corr = Nothing
            stSql = Nothing
            ano = Nothing
            rut = Nothing
            Peso = Nothing
            PesoActual = Nothing
            sPesoMaximo = Nothing



            If Not myBoSetDocumento Is Nothing Then
                myBoSetDocumento.Dispose()
                myBoSetDocumento = Nothing
            End If
        End Try

        context.Response.ContentType = "application/json"
        context.Response.Write(stjson)
    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class


