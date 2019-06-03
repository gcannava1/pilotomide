<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Ayuda.aspx.vb" Inherits="PlataformaDocente.Ayuda" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" >

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="head" runat="server">
    <title>Sistema de Evaluación del Desempeño Profesional Docente</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <link href="Scripts/jQuery/themes/00current/jquery-ui.css" rel="stylesheet" />
    <link href="StyleFrameworkSolex.css" rel="stylesheet" type="text/css" />

    <script src="Scripts/jQuery/jquery.min.js" type="text/javascript"></script>
    <script src="Scripts/jQuery/jquery-ui.custom.min.js" type="text/javascript"></script>
    <script src="Scripts/jQuery/plugins/FileDownload/jQuery.download.js" type="text/javascript"></script>
    <script src="Scripts/Framework/__jsCommon/jsCommon.js" type="text/javascript"></script>

    <script type="text/javascript">

        $(document).ready(function () {

            fnCommon_analytics();

            $("#alert-message").dialog({
                modal: true,
                autoOpen: false,
                height: "auto",
                width: 400,
                buttons: {
                    Ok: function () {
                        $(this).dialog("close");
                    }
                }
            });

            $("#info-message").dialog({
                modal: true,
                autoOpen: false,
                height: "auto",
                width: 400,
                buttons: {
                    Ok: function () {
                        $(this).dialog("close");
                        $(location).attr('href', 'Portada/Home.aspx')
                    }
                }
            });

            $("#confirm-dialog").dialog({
                modal: true,
                autoOpen: false,
                height: "auto",
                width: 400
            });

            $("#action-dialog").dialog({
                modal: true,
                autoOpen: false,
                resizable: false
            });

            $(".blockArrastre").on('dragstart', function (e) { e.preventDefault(); });

            $(document).ajaxStart(function () {
                $('body').addClass('busy');
            });

            $(document).ajaxComplete(function () {
                $('body').removeClass('busy');
            });

            $(document).ajaxError(function (event, jqxhr, settings, exception) {
                if (jqxhr.status == 419) {
                    window.location.href = '<%= ResolveUrl("~/") %>' + exception;
                } else {
                    $("#alert-message").dialog("option", "title", "Error");
                    $("#alert-message-content").html("Error ajax call no controlado: " + jqxhr.status + ": " + exception);
                    $("#alert-message").dialog("open");
                }
            });

        });

        function CargarAcordeon(idBanner,index) {
            
            ga('send', 'event', 'PregFrecuentes', 'click','aplicacion '+ $("#aplicacion" + index).val());//idbanner,nombremenu,etc
            var methodURL = 'Ayuda.aspx/CargarAcordeon';
            var parameters = '{idBanner: ' + idBanner + '}'; //,index: ' + index + '
            $.ajax(
                {
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: methodURL,
                    data: parameters,
                    dataType: "json",
                    async: false,
                    success: function (response) {
                        try {
                            var Record = jQuery.parseJSON(response.d);
                            if (Record["d"]["__error"] != "") {
                                $("#alert-message").dialog("option", "title", "Error");
                                $("#alert-message-content").html("Error: " + Record["d"]["__error"]);
                                $("#alert-message").dialog("open");
                            }
                            else {
                                $("#det_ayuda").html(Record["d"]["__PregFrecuente"]);
                                $("#divDetalleAyuda").accordion({heightStyle: 'content'});
                            }
                        }
                        catch (e) {
                            $("#alert-message").dialog("option", "title", "Error");
                            $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo parsear datos Json desde el servidor: " + e.toString());
                            $("#alert-message").dialog("open");
                        }
                    },
                    error: function (xhr, status, msg) {
                        if (xhr.status == 419) {
                            window.location.href = '<%= ResolveUrl("~/") %>' + msg;
                    } else {
                        $("#alert-message").dialog("option", "title", "Error");
                        $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo marcar fila seleccionada en el servidor: " + msg);
                        $("#alert-message").dialog("open");
                    }
                }
            });
        }

        function DescargarArchivo(nombre_servidor) {
            //<a href='JavaScript:DescargarArchivo("QME_T5_2016.png")'>archivo</a>
            var keypath = 'pathArchivo'
            var methodURL = 'Portada/Home.aspx/DescargarArchivo';
            var parameters = '{keypath:"' + keypath + '", nombre_servidor:"' + nombre_servidor + '"}';

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: methodURL,
                data: parameters,
                dataType: "json",
                async: false,
                success: function (response) {
                    try {
                        var Record = jQuery.parseJSON(response.d);
                        if (Record["d"]["__error"] != "") {
                            $("#alert-message").dialog("option", "title", "Error");
                            $("#alert-message-content").html("Error: " + Record["d"]["__error"]);
                            $("#alert-message").dialog("open");
                        } else {
                            parameters = 'Path=' + keypath;
                            parameters += '&NombreCliente=' + nombre_servidor;
                            parameters += '&NombreServidor=' + nombre_servidor;
                            parameters += '&r=' + Math.random();
                            $.download('FileDownload.aspx', parameters);
                        }
                    }
                    catch (e) {
                        $("#alert-message").dialog("option", "title", "Error");
                        $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo parsear datos Json desde el servidor: " + e.toString());
                        $("#alert-message").dialog("open");
                    }
                },
                error: function (xhr, status, msg) {
                    if (xhr.status == 419) {
                        window.location.href = '<%= ResolveUrl("~/") %>' + msg;
                    } else {
                        $("#alert-message").dialog("option", "title", "Error");
                        $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo obtener datos desde el servidor: " + msg);
                        $("#alert-message").dialog("open");
                    }
                }
            });
        }


    </script>
</head>
<body onload="fnCommon_nobackbutton()">
    <form id="formPrincipal" runat="server">
        <div id="divEncabezado" style="width: 1280px; border: 0px; margin-top: 0px; margin-left: auto; margin-right: auto;" runat="server">
            <table align="center" cellpadding="0" cellspacing="0" style="background: url('Imagenes/images/Encabezado_fondo.png') repeat-x" border="0">
                <tr>
                    <td style="height: 135px;" valign="top">
                        <table cellpadding="0" cellspacing="0" style="padding-top: 0.1em;" border="0">
                            <tr>
                                <td style="width: 137px;"></td>
                                <td align="right">
                                    <img src="Imagenes/Images/LogoGob.jpg" alt="" class="blockArrastre" /></td>
                                <td style="width: 63px;"></td>
                                <td align="center" style="width: 672px;">
                                    <img src="Imagenes/Images/encabezado.png" alt="" class="blockArrastre" />
                                </td>
                                <td>
                                    <img src="Imagenes/Images/LogoDM.png" alt="" class="blockArrastre" />
                                </td>
                                <td style="width: 137px;"></td>
                            </tr>
                            <tr>
                                <td align="right">
                                    <img id="imgPortada" runat="server" alt="cerrar" src="Imagenes/Images/btn_portada_OFF.png" onmouseover="this.src='Imagenes/Images/btn_portada_ON.png'"
                                        onmouseout="this.src='Imagenes/Images/btn_portada_OFF.png'" onclick="top.document.location='portada/home.aspx'" class="blockArrastre" /></td>
                                <td colspan="2"></td>
                                <td></td>
                                <td colspan="2">
                                    <table align="center">
                                        <tr>
                                            <td>
                                                <img alt="cerrar" src="Imagenes/Images/cerrar_sesion_OFF.png" onmouseover="this.src='Imagenes/Images/cerrar_sesion_ON.png'"
                                                    onmouseout="this.src='Imagenes/Images/cerrar_sesion_OFF.png'" onclick="top.document.location='inicio.aspx?cerrar=1'" class="blockArrastre" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <div id="divAyuda" style="width: 1240px; border: 0px; margin-top: 0px; margin-left: auto; margin-right: auto;" runat="server">

            <table style="width: 100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td colspan="3" style="height:50px" class="pdAyudaTitulo">Ayuda</td>
                </tr>
                <tr>
                    <td style="width:2%"></td>
                    <td  valign="top" style="width: 30%">
                        <div id="divMenu" runat="server"></div>
                    </td>
                    <td valign="top" style="width: 68%">
                        <div id="det_ayuda"></div>
                    </td>
                </tr>
            </table>

        </div>



        <div id="alert-message" class="ui-state-error">
            <span class="ui-icon ui-icon-alert" style="margin: 0.9em 0.3em 0.2em 0.2em; float: left;"></span>
            <p id="alert-message-content">
            </p>
        </div>
        <div id="info-message" class="ui-state-highlight">
            <span class="ui-icon ui-icon-info" style="margin: 0.9em 0.3em 0.2em 0.2em; float: left;"></span>
            <p id="info-message-content">
            </p>
        </div>
        <div id="confirm-dialog">
            <span class="ui-icon ui-icon-alert" style="margin: 0.9em 0.3em 0.2em 0.2em; float: left;"></span>
            <p id="confirm-dialog-content">
            </p>
        </div>
        <div id="lookup-dialog">
            <p id="lookup-dialog-content">
            </p>
        </div>
        <div id="uploadfile-dialog">
            <p id="uploadfile-dialog-content">
            </p>
        </div>
        <div id="action-dialog">
        </div>
        <input type="hidden" name="MensajeError" id="MensajeError" runat="server" />
         <input type="hidden" id="dependencia" name="dependencia" runat="server" />
    </form>

</body>
</html>
