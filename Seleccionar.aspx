<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Seleccionar.aspx.vb" Inherits="PlataformaDocente.Seleccionar" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" >

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="head" runat="server">
    <title>Sistema de Evaluación del Desempeño Profesional Docente</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />

    <script src="Scripts/jQuery/jquery.min.js" type="text/javascript"></script>
    <script src="Scripts/jQuery/jquery-ui.custom.min.js" type="text/javascript"></script>
    <script src="Scripts/jQuery/plugins/Rut/jquery.Rut.min.js" type="text/javascript"></script>
    <script src="Scripts/Framework/__jsCommon/jsCommon.js" type="text/javascript"></script>
    <link href="Scripts/jQuery/themes/00current/jquery-ui.css" rel="stylesheet" />
    <link href="StyleFrameworkSolex.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">

        var pass = "";
        $.fn.ready(function () {

            $(document).ajaxError(function (event, jqxhr, settings, exception) {
                if (jqxhr.status == 419) {
                    window.location.href = '<%= ResolveUrl("~/") %>' + exception;
                } else {
                    $("#alert-message").dialog("option", "title", "Error");
                    $("#alert-message-content").html("Error ajax call no controlado: " + jqxhr.status + ": " + exception);
                    $("#alert-message").dialog("open");
                }
            });

            $('.soloCarRut').keydown(function (e) {

                if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 189, 109, 190, 75]) !== -1 ||
                    (e.keyCode == 65 && (e.ctrlKey === true || e.metaKey === true)) ||
                    (e.keyCode >= 35 && e.keyCode <= 40) || (e.ctrlKey && e.keyCode == 86)) {
                    return;
                }
                if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                    e.preventDefault();
                }
            });

            $('#txtRut').Rut({
                on_error: function () {
                    $("#rut_valido").val("N");
                },
                on_success: function () {
                    $("#rut_valido").val("S");
                },
            });

            $('input[type=text]').addClass('text ui-widget-content ui-corner-all');

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

            if ($('#MensajeError').val() != '') {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html($('#MensajeError').val());
                $("#alert-message").dialog("open");
            }

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

            $('input').keypress(function (event) {
                if (event.which == 13) {
                    event.preventDefault();
                }
            });

            $('.btnIngresar')
                .button()
                .click(function (event) {
                    event.preventDefault();

                    if ($('#txtRut').val() != "" && $('#rut_valido').val() == "S") {

                        arrForm = '{rut: "' + $('#txtRut').val() + '"}';
                        methodURL = "Seleccionar.aspx/SeleccionarDocente";
                        //var arrForm = '{pass: "' + $('#password').val().toLowerCase() + '",mail: "' + $('#email').val().toLowerCase() + '"}'
                        $.ajax({
                            cache: false,
                            async: false,
                            type: "POST",
                            dataType: "json",
                            contentType: "application/json; charset=utf-8",
                            url: methodURL,
                            data: arrForm,

                            success: function (response) {
                                var Record = jQuery.parseJSON(response.d);
                                if (Record["d"]["__error"] != '') {
                                    $("#alert-message").dialog("option", "title", "Error");
                                    $("#alert-message-content").html(Record["d"]["__error"]);
                                    $("#alert-message").dialog("open");
                                } else {
                                    $(location).attr('href', 'Portada/Home.aspx')
                                }
                            },
                            error: function (xhr, err) {
                                $("#alert-message").dialog("option", "title", "Error");
                                $("#alert-message-content").html(err);
                                $("#alert-message").dialog("open");
                            }
                        });
                    } else {
                        $("#alert-message").dialog("option", "title", "Error");
                        $("#alert-message-content").html("Rut invalido.");
                        $("#alert-message").dialog("open");
                    }


                });
        });

    function funcVerificaRut(obRut, obDigito) {
        var strRut = obRut.value
        var strDig = obDigito.value
        if (strRut != "") {
            if (parseInt(strRut) == 0)
                return false;
            intSuma = 0;
            intMultiplo = 2;
            strDigVerf = "";
            for (i = (strRut.length - 1) ; i >= 0; i--) {
                if (strRut.charAt(i) != '0' && strRut.charAt(i) != '1'
                    && strRut.charAt(i) != '2' && strRut.charAt(i) != '3'
                    && strRut.charAt(i) != '4' && strRut.charAt(i) != '5'
                    && strRut.charAt(i) != '6' && strRut.charAt(i) != '7'
                    && strRut.charAt(i) != '8' && strRut.charAt(i) != '9'
                    ) {
                    return false;
                }
                intSuma = intSuma + (strRut.charAt(i) * intMultiplo);
                if (intMultiplo == 7)
                    intMultiplo = 2;
                else
                    intMultiplo++;
            }
            intResto = (intSuma % 11);
            if (intResto == 1)
                strDigVerf = 'k';
            else if (intResto == 0)
                strDigVerf = '0';
            else {
                strDigVerf = (11 - intResto);
                strDigVerf = strDigVerf.toString();
            }

            if (strDig.toUpperCase() != strDigVerf.toUpperCase()) {
                return false;
            }
        }
        return true;
    }

    function isValidDate(s) {
        var bits = s.split('/');
        var d = new Date(bits[2] + '/' + bits[1] + '/' + bits[0]);
        return !!(d && (d.getMonth() + 1) == bits[1] && d.getDate() == Number(bits[0]));
    }

    function ValidarPermitidosTelefono(e) {
        var keynum = window.event ? window.event.keyCode : e.which;
        if ((keynum == 8) || (keynum == 46) || (keynum == 45) || (keynum == 32) || (keynum == 40) || (keynum == 41)) //Números, guión, espacio y paréntesis
            return true;

        return /\d/.test(String.fromCharCode(keynum));
    }

    function SoloNumeros(e) {
        var keynum = window.event ? window.event.keyCode : e.which;
        if ((keynum == 8) || (keynum == 46))
            return true;

        return /\d/.test(String.fromCharCode(keynum));
    }

    function SoloTexto(e) {
        var tecla = (document.all) ? e.keyCode : e.which;
        if (tecla == 8) return true;
        patron = /[A-Za-zñÑÁ-Úá-ú\Ç s]/;
        te = String.fromCharCode(tecla);
        return patron.test(te);
    }
    </script>
</head>
<body onload="fnCommon_nobackbutton()">
    <form id="formPrincipal" runat="server">
        <table align="center" cellpadding="0" cellspacing="0" style="background: url('Imagenes/images/Encabezado_fondo.png') repeat-x" border="0">
            <tr>
                <td style="height: 135px;" valign="top">
                    <table cellpadding="0" cellspacing="0" style="padding-top: 0.1em;" border="0">
                        <tr>
                            <td style="width: 137px;"></td>
                            <td align="right">
                                <img src="Imagenes/Images/LogoGob.jpg" alt="" /></td>
                            <td style="width: 63px;"></td>
                            <td align="center" style="width: 672px;">
                                <img src="Imagenes/Images/encabezado.png" alt="" />
                            </td>
                            <td>
                                <img src="Imagenes/Images/LogoDM.png" alt="" />
                            </td>
                            <td style="width: 137px;"></td>
                        </tr>
                        <tr>
                            <td colspan="5"></td>
                            <td>
                                <img alt="cerrar" src="Imagenes/Images/cerrar_sesion_OFF.png" onmouseover="this.src='Imagenes/Images/cerrar_sesion_ON.png'"
                                    onmouseout="this.src='Imagenes/Images/cerrar_sesion_OFF.png'" onclick="top.document.location='inicio.aspx?cerrar=1'" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>

        <div style="padding-top: 2px">
            <br />
            <table class="ui-widget ui-widget-content ui-corner-all" align="center" border="0" style="width: 400px">
                <tr>
                    <td align="center" style="height: 40px;">
                        <label>
                            <b>Usted no es un docente.<br />Ingrese el rut del docente con el cual desea trabajar.</b></label>
                    </td>
                </tr>
                <tr>
                    <td align="center">
                        <table border="0">
                            <tr>
                                <td>
                                    <input type="text" id="txtRut" placeholder="RUT" style="text-align: center; width: 15   em;" name="txtRut" runat="server" maxlength="20" tabindex="1" class="soloCarRut" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="center">
                        <button id="btnIngresar" class="btnIngresar" runat="server">
                            Ingresar</button>

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
        <input type="hidden" id="pas" name="pas" runat="server" />
        <input type="hidden" id="primeraVez" name="primeraVez" runat="server" />
        <input type="hidden" id="rut_valido" name="rut_valido" runat="server" />
    </form>

</body>
</html>
