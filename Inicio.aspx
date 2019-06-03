<%@ Page Language="VB" AutoEventWireup="false" Inherits="PlataformaDocente.Inicio" CodeBehind="Inicio.aspx.vb" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <link rel="SHORTCUT ICON" href="~/Imagenes/favicon.ico" type="image/x-icon" />
    <link rel="ICON" href="~/Imagenes/favicon.ico" type="image/ico" />
    <title>Plataforma Docente</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="google" content="notranslate" />
    <script src="Scripts/jQuery/jquery.min.js" type="text/javascript"></script>
    <script type="text/javascript">

        var baseUrl = '<%= ResolveUrl("~/") %>';

        $(window).load(function () {
            if ($('#id_perfil').val() == 8) {
                if ($('#primeraVez').val() == 1) {
                    if ($('#modo').val() == "Normal") {
                    window.location.replace(baseUrl + 'DocentePrimeraVez.aspx');
                    }
                    else {
                        window.location.replace(baseUrl + 'DocentePrimeraVezP.aspx');
                    }

                } else {
                    if ($('#modo').val() == "Normal") {
                    window.location.replace(baseUrl + 'Portada/Home.aspx');
                    }
                    else {
                        window.location.replace(baseUrl + 'Portada/HomeP.aspx');
                    }
                }
            }
            else {
                window.location.replace(baseUrl + 'Seleccionar.aspx');
            }

        });

    </script>
</head>
<body>
    <form id="frmInicio" runat="server">
        <div>
            <input type="hidden" id="modo" name="modo" runat="server" />
            <input type="hidden" id="id_perfil" name="id_perfil" runat="server" />
            <input type="hidden" id="primeraVez" name="primeraVez" runat="server" />

        </div>

    </form>
</body>
</html>
