<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AvancePortafolio.aspx.vb" Inherits="PlataformaDocente.AvancePortafolio" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" >

<html xmlns="http://www.w3.org/1999/xhtml" lang ="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="google" content="notranslate" />
    <title>Avance Portafolio
    </title>
        <script src="../../Scripts/Framework/__jsCommon/jsCommon.js" type="text/javascript"></script>
   
    <!--MENSAJES DE ALERTA**********************************************************-->
    <script type="text/javascript">
        $.fn.ready(function () {

            fnCommon_analytics();

            $("#Mostrar_Avance")
                .button()
                .click(function (event) {
                    event.preventDefault();
                    mostrar_avance();
                });

            $("#Mostrar_Avance_PDF_PF")
              .button()
              .click(function (event) {
                  event.preventDefault();
                  descarga_avance_pdf_PF();
              });

            $(".Imprimir")
                .button()
                .click(function (event) {
                    event.preventDefault();
                    if (validar_evaluacion() == true) {
                        $("#tablaImprimir").print();
                    }
                    else {
                        $("#alert-message").dialog("option", "title", "Error");
                        $("#alert-message-content").html("Error: Esta sesión expiró. Existe una sesión activa en otra pestaña.");
                        $("#alert-message").dialog("open");
                    }
                });

            $(".Guardar")
                .button()
                .click(function (event) {
                    event.preventDefault();
                    guardar_avance();
                });

            $("#dialog_avance").dialog(
                {
                    modal: true,
                    autoOpen: false,
                    height: 800,
                    width: 900
                });
        });

        function guardar_avance() {
            if (validar_evaluacion() == true) {
                var methodURL = 'AvancePortafolio.aspx/GuardarHTML';
                $.ajax(
                    {
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: methodURL,
                        dataType: "json",
                        async: false,
                        success: function (response) {
                            var Record = jQuery.parseJSON(response.d);
                            if (Record["d"]["__error"] != "") {
                                $("#alert-message").dialog("option", "title", "Error");
                                $("#alert-message-content").html("Error: " + Record["d"]["__error"]);
                                $("#alert-message").dialog("open");
                            }
                            else {
                                parameters = 'Path=pathDescargar';
                                parameters += '&NombreCliente=' + $("#Rut_Docente").val() + '_AvancePF.html';
                                parameters += '&NombreServidor=' + Record["d"]["__NombreServidor"];
                                parameters += '&r=' + Math.random();
                                $.download('../../FileDownload.aspx', parameters);
                            }
                        },
                        error: function (xhr, err) {
                            $("#alert-message").dialog("option", "title", "Error");
                            $("#alert-message-content").html("Hubo un error al momento de guardar el archivo.");
                            $("#alert-message").dialog("open");
                        }
                    });
            }
            else {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html("Error: Esta sesión expiró. Existe una sesión activa en otra pestaña.");
                $("#alert-message").dialog("open");
            }
        }

        function descarga_avance_pdf_PF() {
            if (validar_evaluacion() == true) {
                var methodURL = 'AvancePortafolio.aspx/descargaPDFPF';
                $("body").css("cursor", "progress");
                $.ajax(
                    {
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: methodURL,
                        dataType: "json",
                        async: true,
                        success: function (response) {
                            var Record = jQuery.parseJSON(response.d);
                            if (Record["d"]["__error"] != "") {
                                $("#alert-message").dialog("option", "title", "Error");
                                $("#alert-message-content").html("Error: " + Record["d"]["__error"]);
                                $("#alert-message").dialog("open");
                            }
                            else {
                                parameters = 'Path=pathDescargarPDFPF';
                                parameters += '&NombreCliente=' + Record["d"]["__NombreServidor"];
                                parameters += '&NombreServidor=' + Record["d"]["__NombreServidor"];
                                parameters += '&r=' + Math.random();
                                $.download('../../FileDownload.aspx', parameters);
                            }
                        },
                        error: function (xhr, err) {
                            $("#alert-message").dialog("option", "title", "Error");
                            $("#alert-message-content").html("Hubo un error al momento de guardar el archivo.");
                            $("#alert-message").dialog("open");
                        },
                        complete: function () {
                            $("body").css("cursor", "default");
                        }
                    });
            }
            else {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html("Error: Esta sesión expiró. Existe una sesión activa en otra pestaña.");
                $("#alert-message").dialog("open");
            }
        }
        function mostrar_avance() {
            if (validar_evaluacion() == true) {
                var methodURL = 'AvancePortafolio.aspx/Informe_AvancePF';
                $.ajax(
                    {
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: methodURL,
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
                                    if (Record["d"]["__body"] == "") {
                                        $("#alert-message").dialog("option", "title", "Información");
                                        $("#alert-message-content").html("No hay información para descargar.");
                                        $("#alert-message").dialog("open");
                                    }
                                    else {
                                        $('#body_avance').empty();
                                        $("#body_avance").html(Record["d"]["__body"]);
                                        $('#dialog_avance').dialog("open");
                                        $('#dialog_avance').animate({ scrollTop: 0 }, 0);
                                    }
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
                else {
                    $("#alert-message").dialog("option", "title", "Error");
                    $("#alert-message-content").html("Error: Esta sesión expiró. Existe una sesión activa en otra pestaña.");
                    $("#alert-message").dialog("open");
                }
            }
    </script>
</head>
<body onload="fnCommon_nobackbutton()">
    <form id="frmRegistry" runat="server">
        <!--TABLA QUE SE VISUALIZA AL MOMENTO DE CARGAR LA PÁGINA-->
        <div id="tablaImprimirAvance">
            <div>
                <table align="center" style="width: 50%;" border="0">
                    <tr>
                        <td colspan="2" align="center" class="pdTitulo1">AVANCE PORTAFOLIO</td>
                    </tr>
                    <tr>
                        <td align="left">
                            <input type="button" id="Mostrar_Avance_PDF_PF" value="Descargar mi Avance PDF" style="display:none" runat="server" onclick="ga('send', 'event', 'AvancePDF', 'click', 'DescargaAvancePFPDF');" />
                            </td>
                        <td align="right">
                            <input type="button" id="Mostrar_Avance" value="Descargar mi Avance" onclick="ga('send', 'event', 'Avance', 'click', 'DescargaAvancePF');" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style='font-family: segoe ui; font-size: 14px;'>
                            <p style="text-align: justify">
                                <b>IMPORTANTE: Este reporte es solo una <u>ayuda</u> para que pueda monitorear su trabajo, y NO
                            SUSTITUYE la revisión detallada que <u>solo usted</u> puede hacer para asegurarse de que ha
                            completado todo su Portafolio.</b><br />
                            </p>
                        </td>
                    </tr>
                </table>
            </div>
            <div id="TablaAvancePF" class="TablaAvancePF" runat="server" />
        </div>
        <!--TABLA QUE SE MUESTRA EN LA VENTANA EMERGENTE-->
        <div id="dialog_avance" title="Avance Portafolio" style="overflow: scroll" class="text_div">
            <table cellspacing="0" cellpadding="2" width="100%" border="0">
                <tr>
                    <td align="right">
                        <input runat="server" type="button" id="btnGuardar" name="btnGuardar" value="Guardar" class="Guardar" role="button" />
                        <input runat="server" type="button" id="btnImprimir" name="btnImprimir" value="Imprimir" class="Imprimir" role="button" aria-disabled="false" />
                    </td>
                </tr>
            </table>
            <table cellspacing="0" cellpadding="2" width="100%" style="font-family: Segoe UI; font-size: 13px" border="0" id="tablaImprimir">
                <tr>
                    <td id="body_avance"></td>
                </tr>
            </table>
            <table cellspacing="0" cellpadding="2" width="100%" border="0">
                <tr>
                    <td align="right">
                        <input runat="server" type="button" id="btnGuardar2" name="btnGuardar2" value="Guardar" class="Guardar" role="button" />
                        <input runat="server" type="button" id="btnImprimir2" name="btnImprimir2" value="Imprimir" class="Imprimir" role="button" aria-disabled="false" />
                    </td>
                </tr>
            </table>
        </div>
        <input type="hidden" id="Rut_Docente" runat="server" />
    </form>
</body>
</html>
