<%@ Application Language="VB" %>
<%@ Import Namespace="System.Web.Compilation" %>
<%@ Import Namespace="Solex.Base.Comun" %>

<script RunAt="server">

    Sub Application_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Código que se ejecuta al iniciarse la aplicación
        ' Se desencadena cuando se inicia la aplicación
        
        BuildManager.GetReferencedAssemblies()
        
        Dim AppSettings As System.Configuration.AppSettingsReader = New System.Configuration.AppSettingsReader()
        Application.Add("hostname", AppSettings.GetValue("hostname", GetType(System.String)))
        Application.Add("logpath", AppSettings.GetValue("logpath", GetType(System.String)))
        Application.Add("logfile", AppSettings.GetValue("logfile", GetType(System.String)))
        cLog.LogPath = System.Web.HttpContext.Current.Application("logpath")
        cLog.LogFile = System.Web.HttpContext.Current.Application("logfile")

        cLog.WriteMessage("Application->Application Start")

        'Application.Add("PopUpAlerta", Utilities.PopUpAlerta(Application("hostname")))
    End Sub

    Sub Application_AuthenticateRequest(ByVal sender As Object, ByVal e As EventArgs)

        ' Se desencadena al intentar autenticar el uso
        Dim strPath, strURL, strRedirect As String
        'Dim i As Int16
        'Dim lista As String()
        strPath = Request.Path.ToLower

        If ConfigurationManager.AppSettings("SSL") = "S" Then
            strURL = Request.Url.ToString
            If Not (strURL.IndexOf("https") >= 0) Then
                strURL = strURL.Replace("http", "https")
                Response.Redirect(strURL)
            End If
        End If

        'lista = strPath.Split("/")
        'strRedirect = "inicio.htm"
        'If lista.Length > 3 Then
        '    For i = 1 To (lista.Length - 3)
        '        strRedirect = "../" + strRedirect
        '    Next
        'End If

        strRedirect = "~/inicio.htm"


        'If strPath.IndexOf(".asmx") > 0 Or strPath.IndexOf(".svc") > 0 Then
        If strPath.IndexOf(".svc") > 0 Then


        Else
            If Not (HttpContext.Current.User Is Nothing) Then
                Dim stUser As String = HttpContext.Current.User.Identity.Name

                If Not HttpContext.Current.User.Identity.IsAuthenticated Then
                    If Request.Headers("X-Requested-With") = "XMLHttpRequest" Then 'AGS 29-07-2013 para el caso de request AJAX, devuelve string al script cliente, que a su vez sale al inicio y login.
                        'http://en.wikipedia.org/wiki/List_of_HTTP_status_codes
                        '419 Authentication Timeout (not in RFC 2616) Not a part of the HTTP standard, 419 Authentication Timeout denotes that previously valid authentication has expired. It is used as an alternative to 401 Unauthorized in order to differentiate from otherwise authenticated clients being denied access to specific server resources.
                        Response.StatusCode = 419
                        Response.StatusDescription = "inicio.htm"
                    Else
                        Response.Redirect(strRedirect)
                    End If
                End If
            Else
                'AGS 25-07-2013 Aquí entramos si la cookie está vacía. Entonces, si el path del request NO contiene el string "inicio.aspx" o 
                '"login.aspx" quiere decir que el usuario está tratando de entrar sin autentificación, por lo tanto lo botamos al login.
                'El problema es que si el centro de inicio se llama "centroinicio.aspx" y contiene el string "inicio.aspx".
                'Conclusión, ninguna página del sistema debe contener el string "inicio.aspx" o "login.aspx" en su nombre, a excepción de las centrales.
                If strPath.IndexOf("inicio.aspx") < 0 And strPath.IndexOf("login.aspx") < 0 And strPath.IndexOf("loginp.aspx") < 0 And strPath.IndexOf("cambiarcontrasena.aspx") < 0 Then
                    If Request.Headers("X-Requested-With") = "XMLHttpRequest" Then 'AGS 29-07-2013 para el caso de request AJAX, devuelve string al script cliente, que a su vez sale al inicio y login

                        'http://en.wikipedia.org/wiki/List_of_HTTP_status_codes
                        '419 Authentication Timeout (not in RFC 2616) Not a part of the HTTP standard, 419 Authentication Timeout denotes that previously valid authentication has expired. It is used as an alternative to 401 Unauthorized in order to differentiate from otherwise authenticated clients being denied access to specific server resources.
                        Response.StatusCode = 419
                        Response.StatusDescription = "inicio.htm"

                    Else
                        Response.Redirect(strRedirect)
                    End If
                Else
                    If Request.Params.Item(0).IndexOf("cerrar") >= 0 Then
                        Response.Redirect(strRedirect)
                    End If
                End If

            End If
        End If
    End Sub

    Protected Sub Application_PreRequestHandlerExecute(ByVal sender As [Object], ByVal e As EventArgs)
        If TypeOf (Context.Handler) Is IRequiresSessionState Or TypeOf (Context.Handler) Is IReadOnlySessionState Then
            If Not (Session("user") Is Nothing) Then  ' e.g.  this is after an initial(logon)
                Dim sKey As String = CStr(Session("user"))
                ' Accessing the Cache Item extends the Sliding Expiration automatically()
                Dim sUser As String = CStr(HttpContext.Current.Cache(sKey))
            End If
        End If
    End Sub 'Application_PreRequestHandlerExecute

    Sub Application_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Código que se ejecuta durante el cierre de aplicaciones
        cLog.WriteMessage("Application->Application End")
    End Sub

    Sub Application_Error(ByVal sender As Object, ByVal e As EventArgs)
        ' Código que se ejecuta al producirse un error no controlado
    End Sub

    Sub Session_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Código que se ejecuta cuando se inicia una nueva sesión
    End Sub

    Sub Application_EndRequest(ByVal sender As Object, ByVal e As EventArgs)
        ' Se desencadena al principio de cada solicitud
        Dim stripper = New ServerIdentityStripper()
        stripper.Execute(HttpContext.Current)
    End Sub
    
    Sub Session_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Código que se ejecuta cuando finaliza una sesión. 
        ' Nota: El evento Session_End se desencadena sólo con el modo sessionstate
        ' se establece como InProc en el archivo Web.config. Si el modo de sesión se establece como StateServer 
        ' o SQLServer, el evento no se genera.

        'WT, RS24671, 31-03-2017 Cargar Log de conexión
        Try
            If ConfigurationManager.AppSettings("log_conexion") = "S" Then
                Clases.DesconectarUsuario(Session.SessionID, ConfigurationManager.AppSettings("hostname"))
            End If

        Catch ex As Exception

        End Try
    End Sub

</script>
