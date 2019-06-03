<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DocentePrimeraVezP.aspx.vb" Inherits="PlataformaDocente.DocentePrimeraVezP" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" >

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="head" runat="server">
    <title>Sistema de Evaluación del Desempeño Profesional Docente</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <link href="Scripts/jQuery/themes/00current/jquery-ui.css" rel="stylesheet" />
    <link href="Scripts/jQuery/plugins/qtip2/jquery.qtip.min.css" rel="stylesheet" />
    <script src="Scripts/jQuery/jquery.min.js" type="text/javascript"></script>
    <script src="Scripts/jQuery/jquery-ui.custom.min.js" type="text/javascript"></script>
    <script src="Scripts/jQuery/plugins/qtip2/jquery.qtip.min.js" type="text/javascript"></script>
    <script src="Scripts/jQuery/plugins/Passwordstrength/passwordstrength.js" type="text/javascript"></script>
    <script src="Scripts/jQuery/plugins/Validations/jquery.validate.min.js" type="text/javascript"></script>
    <script src="Scripts/jQuery/plugins/Validations/jquery.validate.additional-methods.js" type="text/javascript"></script>
    <link href="StyleFrameworkSolex.css?v=1" rel="stylesheet" type="text/css" />
    <script src="Scripts/Framework/__jsCommon/jsCommon.js" type="text/javascript"></script>
    <script src="Scripts/jQuery/FuncionesAgregadas.js" type="text/javascript"></script>
    <script src="Scripts/jQuery/plugins/ui.datepicker-es.js" type="text/javascript"></script>
    <script type="text/javascript">
        var baseUrl = '<%= ResolveUrl("~/") %>';
        var pass = "";
        var boInputChanged = false;
        var PassChanged = false;

        $(document).ready(function () {
            //CargaFechaNacimiento();
            $('input[type=text]').addClass('text ui-widget-content ui-corner-all');
            $('input[type=password]').addClass('text ui-widget-content ui-corner-all');
            $('select').addClass('text ui-widget-content ui-corner-all');
            $('textarea').addClass('text ui-widget-content ui-corner-all');
            $("#alert-message").dialog({
                modal: true,
                autoOpen: false,
                height: "auto",
                width: 450,
                buttons: {
                    Ok: function () {
                        $(this).dialog("close");
                    }
                }
            });

            $('input[type=text]').bind('change', function () {
                boInputChanged = true;
            });

            $('input[type=password]').bind('change', function () {
                //boInputChanged = true;
                PassChanged = true;
            });

            $(".blockArrastre").on('dragstart', function (e) { e.preventDefault(); });

            $('select').bind('change', function () {
                boInputChanged = true;
            });

            $(".hide").show();

            $('#password').pstrength({
                'displayMinChar': false,
                'minChar': 4,
                'minCharText': 'Ingrese mínimo %d caracteres',
                'verdicts': ['Débil', 'Normal', 'Mediano', 'Alto', 'Muy alto']
            });
           
            $("#info-Val").hide();

            Noprimeravez();
            mostrar_msjeImportante();
            $("#info-message").dialog({
                modal: true,
                autoOpen: false,
                height: "auto",
                width: 450,
                buttons: {
                    Ok: function () {
                        $(this).dialog("close");
                        $(location).attr('href', 'Portada/HomeP.aspx')
                    }
                }
            });
           
            ////Control de refresco de pagina
            //window.addEventListener('beforeunload', function (event) {
            //    if (boInputChanged == true) {
            //        event.returnValue = "Hay cambios que no se han guardado. Presione Cancelar para volver y guardar los cambios.";
            //    };
            //});

            //dialogo de validacion

            $("#confirm-dialog").dialog({
                modal: true,
                autoOpen: false,
                height: "auto",
                width: 450
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

            $('.solo-letrasnumeros').on('keypress', function (key) {
                //LCF 20181115 SOLO LETRAS Y NUMEROS - ACTUALIZADO EL 20181210
                if (!((key.charCode >= 48 && key.charCode <= 57) || //#
                    (key.charCode >= 65 && key.charCode <= 90)  ||  //A-Z
                    (key.charCode >= 97 && key.charCode <= 122) ||  //a-z
                    (key.charCode == 209) ||                        //Ñ
                    (key.charCode == 241))) {                       //ñ
                    return false;
                }
            });

            $('.SoloLetraNumero').keypress(function (event) {
                if (event.which == 32) {
                    event.preventDefault();
                }
                if (event.which == 34) {
                    event.preventDefault();
                }
                else if (event.which == 35) {
                    event.preventDefault();
                }
                else if (event.which == 38) {
                    event.preventDefault();
                }
                else if (event.which == 39) {
                    event.preventDefault();
                }

            });

            $('#continuar')
               .button()
            .click(function () {
                $(".hide").show();
                $("#info-Val").hide();
            });

            $('.btnGrabar')
                .button()
                .click(function (event) {
                    event.preventDefault();
                    if (validar_evaluacion() == true) {
                        var arForm = $("#formPrincipal").serializeArray();
                        var methodURL = ""
                        //valida contraseña
                        if (PassChanged == true) {
                            if ($('#password').val() == '') {
                                $('#password').focus();
                                $("#alert-message").dialog("option", "title", "Error");
                                if ($('#primeraVez').val() == 1) {
                                    $("#alert-message-content").html("Debe ingresar una nueva contraseña.");
                                }
                                else {
                                    $("#alert-message-content").html("Debe ingresar una contraseña.");
                                }
                                $("#alert-message").dialog("open");
                                return false;
                            } else {
                                if ($('#password').val().length < 4) {
                                    $('#password').focus();
                                    $("#alert-message").dialog("option", "title", "Error");
                                    $("#alert-message-content").html("La contraseña debe tener al menos 4 caracteres.");
                                    $("#alert-message").dialog("open");
                                    return false;
                                }
                            }

                            if ($('#password_reingresado').val() == '') {
                                $('#password_reingresado').focus();
                                $("#alert-message").dialog("option", "title", "Error");
                                if ($('#primeraVez').val() == 1) {
                                    $("#alert-message-content").html("Debe reingresar la nueva contraseña.");
                                }
                                else {
                                    $("#alert-message-content").html("Debe reingresar la contraseña.");
                                }
                                $("#alert-message").dialog("open");
                                return false;
                            } else {
                                if ($('#password').val() != $('#password_reingresado').val()) {
                                    $('#password_reingresado').focus();
                                    $("#alert-message").dialog("option", "title", "Error");
                                    $("#alert-message-content").html("Las contraseñas son distintas.");
                                    $("#alert-message").dialog("open");
                                    return false;
                                }
                            }
                        }
                        
                        // validar email
                        if ($('#email').val() == '') {
                            $('#email').focus();
                            $("#alert-message").dialog("option", "title", "Error");
                            $("#alert-message-content").html("Debe ingresar una cuenta de correo electrónico.");
                            $("#alert-message").dialog("open");
                            return false;
                        } else {
                            if (validarEmail($('#email')) == false) {
                                $('#email').focus();
                                $("#alert-message").dialog("option", "title", "Error");
                                $("#alert-message-content").html("La dirección de correo es errónea.");
                                $("#alert-message").dialog("open");
                                return false;
                            }
                        }

                        // validar email
                        if ($('#email_reingresado').val() == '') {
                            $('#email_reingresado').focus();
                            $("#alert-message").dialog("option", "title", "Error");
                            $("#alert-message-content").html("Debe de reingresar la cuenta de correo electrónico.");
                            $("#alert-message").dialog("open");
                            return false;
                        } else {
                            if ($('#email').val().toLowerCase() != $('#email_reingresado').val().toLowerCase()) {
                                $('#email_reingresado').focus();
                                $("#alert-message").dialog("option", "title", "Error");
                                $("#alert-message-content").html("Las direcciones de correo son distintas.");
                                $("#alert-message").dialog("open");
                                return false;
                            }
                        }

                        // validar direccion
                        if ($('#direccion').val() == '') {
                            $('#direccion').focus();
                            $("#alert-message").dialog("option", "title", "Error");
                            $("#alert-message-content").html("Debe ingresar una Dirección.");
                            $("#alert-message").dialog("open");
                            return false;
                        }
                        //Validacion de numero de telefono cuando esta escrito algo(ValidarPermitidosTelefono($('#numContac').val()),SoloNumeros($('#numContac').val())??

                        methodURL = "DocentePrimeraVezP.aspx/SaveData";
                        //var arrForm = '{pass: "' + $('#password').val().toLowerCase() + '",mail: "' + $('#email').val().toLowerCase() + '"}'
                        $.ajax({
                            cache: false,
                            async: false,
                            type: "POST",
                            dataType: "json",
                            contentType: "application/json; charset=utf-8",
                            url: methodURL,
                            data: JSON.stringify({ formVars: arForm }),

                            success: function (response) {
                                var Record = jQuery.parseJSON(response.d);
                                if (Record["d"]["__error"] != '') {
                                    $("#alert-message").dialog("option", "title", "Error");
                                    $("#alert-message-content").html(Record["d"]["__error"]);
                                    $("#alert-message").dialog("open");
                                } else {
                                    $("#info-message").dialog("option", "title", "Información");
                                    $("#info-message-content").html("Información actualizada correctamente");
                                    $("#info-message").dialog("open");
                                }
                            },
                            error: function (xhr, err) {
                                $("#alert-message").dialog("option", "title", "Error");
                                $("#alert-message-content").html(err);
                                $("#alert-message").dialog("open");
                            }
                        });
                    }
                    else {
                        $("#alert-message").dialog("option", "title", "Error");
                        $("#alert-message-content").html("Error: Esta sesión expiró. Existe una sesión activa en otra pestaña.");
                        $("#alert-message").dialog("open");
                    }
                });
        });
    //revisar otra opcion
    function Noprimeravez() {
        if ($("#primeraVez").val() == "0") {
            $('#lblReContraseña').text("(*) Reingrese contraseña");
            $('#lblContraseña').text("(*) Ingrese contraseña");

            //se quita password anterior
            //$(':password').val($('#pas').val());

            //SPALMA 13-06-2016 focus a los inputs de password para cambio solamente
            $(':password').focus(function (event) {
                event.preventDefault();
                this.select();

            });
        } else {
            $(".hide").hide();
            $("#info-Val").show();
        }
    }

    function validarEmail(valor) {
        var text = valor[0].value.trim();
        //if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(text)) { //SPALMA 05-08-2016 La expresión regular para comprobar la validez dirección de email no está actualizada ya que ahora hay extensiones domainname con 6 caracteres como .museum , para ello se reemplaza por la siguiente forma.

        if (/^([\w-\.]+@([\w-]+\.)+[\w-]{2,6})?$/.test(text)) {
            return (true)
        }
        else
            return (false);
    }

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

    function Portada() {
        
        if (validar_evaluacion() == true) {
            Verificar_Cambios(function () {
                window.location.replace(baseUrl + "portada/homeP.aspx");
            }, function () { /*TODO: AGREGAR CODIGO SI SE CANCELA Y SE DESEA EJECUTAR UN EVENTO */ })
            }
            else {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html("Error: Esta sesión expiró. Existe una sesión activa en otra pestaña.");
                $("#alert-message").dialog("open");
            }
    }

    function CerrarSesion() {
        Verificar_Cambios(function () {
            top.document.location = 'Inicio.aspx?cerrar=1';
        }, function () { /*TODO: AGREGAR CODIGO SI SE CANCELA Y SE DESEA EJECUTAR UN EVENTO */ })
    }

    function validar_evaluacion() {
        var methodURL = baseUrl + 'Aplicaciones/Ficha/Fichas.aspx/validar_evaluacion';
        var parameters = '{idEvaluacion: "' + $('#idEvaluacion').val() + '"}';
        var estado = false

        $.ajax({
            cache: false
                , async: false
                , type: "POST"
                , dataType: "json"
                , contentType: "application/json; charset=utf-8"
                , url: methodURL
                , data: parameters
                , success: function (response) {
                    var Record = jQuery.parseJSON(response.d);
                    if (Record["d"]["__Estado"] == 'S') {
                        estado = true;
                    }
                }
        });

        return estado;
    }

    function Verificar_Cambios(success, cancel) {
        if (boInputChanged == true) {
            if (!jQuery("#confirm-dialog").dialog('isOpen')) {

                $("#confirm-dialog").dialog("option", "title", "Advertencia");
                $("#confirm-dialog-content").html("<center><b>Hay cambios que no se han guardado. </br>Presione Volver para guardar los cambios.</b></center>");
                $("#confirm-dialog").dialog("option", "buttons", {
                    "Volver para guardar": function () {
                        if (cancel)
                            cancel();
                        $(this).dialog("close");
                    },
                    "Abandonar sin guardar": function () {
                        boInputChanged = false;
                        if (success)
                            success();
                        $(this).dialog("close");
                    },
                });
                $("#confirm-dialog").dialog("open");
            }
        }
        else {
            success();
        }
    }

    function mostrar_msjeImportante() {
        var methodURL = baseUrl + "DocentePrimeraVezP.aspx/MsjeImportante";
        $.ajax(
            {
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: methodURL,
                //data: parameters,
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
                                $("#alert-message-content").html("No hay información para ver.");
                                $("#alert-message").dialog("open");
                            }
                            else {
                                $('#info-Val').empty();
                                $("#info-Val").html(Record["d"]["__body"]);
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

    </script>
</head>
<body onload="fnCommon_nobackbutton()">
    <form id="formPrincipal" runat="server">
        <table align="center" cellpadding="0" cellspacing="0" style="background: url('Imagenes/imagesP/Encabezado_fondo.png') repeat-x" border="0">
            <tr>
                <td style="height: 135px;" valign="top">
                    <table cellpadding="0" cellspacing="0" style="padding-top: 0.1em;" border="0">
                        <tr>
                            <td style="width: 137px;height: 90px;"></td>
                            <td align="right" style="width: 100px;">
                                </td>
                            <td style="width: 63px;"></td>
                            <td align="center" valign="top" style="width: 672px;">
                                <img src="Imagenes/imagesP/encabezado.png" alt="" class="blockArrastre" />
                            </td>
                            <td style="width: 163px;">
                            </td>
                            <td style="width: 137px;"></td>
                        </tr>
                        <tr>
                            <td align="right">
                                <img id="imgPortada" runat="server" alt="cerrar" src="Imagenes/imagesP/btn_portada_OFF.png" onmouseover="this.src='Imagenes/imagesP/btn_portada_ON.png'"
                                    onmouseout="this.src='Imagenes/imagesP/btn_portada_OFF.png'" onclick="Portada()" class="blockArrastre" /></td>
                            <td colspan="2"></td>
                            <td></td>
                            <td colspan="2">
                                <table align="center">
                                    <tr>
                                        <td>
                                            <img alt="cerrar" src="Imagenes/imagesP/cerrar_sesion_OFF.png" onmouseover="this.src='Imagenes/imagesP/cerrar_sesion_ON.png'"
                                                onmouseout="this.src='Imagenes/imagesP/cerrar_sesion_OFF.png'" onclick="CerrarSesion()" class="blockArrastre" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>

        <div style="padding-top: 2px">
            <table class="ui-widget ui-widget-content ui-corner-all" cellspacing="1" align="center" border="0">
                <tr>
                    <td colspan="2">
                        <div style="height: 20px; padding-left: 2px; padding-top: 2px;" id="rec_toolbar" class="ui-widget ui-widget-header ui-corner-all">Mis datos personales</div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table cellpadding="1" cellspacing="1" border="0" style="width: 100%;">
                            <tr>
                                <td>
                                    <label>Nombre Docente</label>
                                </td>
                                <td style="width: 500px;">
                                    <input type="text" id="nombre" runat="server" name="docente" style="width: 500px;"
                                        maxlength="50" readonly="readonly" disabled="disabled" />
                                </td>
                                <td>
                                    <label>RUT Docente</label>
                                </td>
                                <td>
                                    <input type="text" id="rut" runat="server" name="rut" style="width: 70px;" maxlength="10"
                                        readonly="readonly" disabled="disabled" />
                                    -
                                                <input type="text" id="dv" runat="server" name="dv" style="width: 15px;" maxlength="1"
                                                    readonly="readonly" disabled="disabled" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>Ud. está inscrito/a por </label>
                                </td>
                                <td colspan="3">
                                    <input type="text" id="nivel" runat="server" name="nivel" style="width: 500px; background-color: #FCD5B5" maxlength="50"
                                        readonly="readonly" disabled="disabled" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>Establecimiento</label>
                                </td>
                                <td>
                                    <input type="text" id="NomEstablecimiento" runat="server" name="NomEstablecimiento" style="width: 500px;" maxlength="50"
                                        readonly="readonly" disabled="disabled" />
                                </td>
                                <td>
                                    <label>RBD</label>
                                </td>
                                <td>
                                    <input type="text" id="rbdEstablecimiento" runat="server" name="rbdEstablecimiento" style="width: 70px;" maxlength="10"
                                        readonly="readonly" disabled="disabled" />
                                </td>
                            </tr>
<%--                            <tr id="sostenedor" class="PSAD">
                                 <td>
                                    <label>Nombre Sostenedor</label>
                                </td>
                                <td style="width: 500px;">
                                    <input type="text" id="nomsost" runat="server" name="nomsost" style="width: 500px;"
                                        maxlength="50" readonly="readonly" disabled="disabled" />
                                </td>
                            </tr>
                            <tr id="encargado" class="PSAD">
                                 <td>
                                    <label>Nombre Encargado</label>
                                </td>
                                <td style="width: 500px;">
                                    <input type="text" id="nomenc" runat="server" name="nomenc" style="width: 500px;"
                                        maxlength="50" readonly="readonly" disabled="disabled" />
                                </td>
                            </tr>
                            <tr id="coordinadorcom" class="MUN">
                                 <td>
                                    <label>Nombre Coordinador Comunal</label>
                                </td>
                                <td style="width: 500px;">
                                    <input type="text" id="nomcc" runat="server" name="nomcc" style="width: 500px;"
                                        maxlength="50" readonly="readonly" disabled="disabled" />
                                </td>
                            </tr>
                            <tr id="encargadocom" class="MUN">
                                 <td>
                                    <label>Nombre Encargado Comuna</label>
                                </td>
                                <td style="width: 500px;">
                                    <input type="text" id="nomenccc" runat="server" name="nomenccc" style="width: 500px;"
                                        maxlength="50" readonly="readonly" disabled="disabled" />
                                </td>
                            </tr>--%>
                            <tr>
                                <td>
                                    <label>Dependencia</label>
                                </td>
                                <td>
                                    <input type="text" id="dependencia" runat="server" name="dependencia" style="width: 190px;" maxlength="10"
                                        readonly="readonly" disabled="disabled" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr class="hide" style="display: none">
                    <td colspan="2">
                        <div style="height: 20px; padding-left: 2px; padding-top: 2px;" id="rec_toolbar2" class="ui-widget ui-widget-header ui-corner-all">Complete la siguiente información:</div>
                    </td>
                </tr>
                <tr class="hide" style="display: none">
                    <td>
                        <table width="100%" border="0">
                            <tr>
                                <td style="width: 220px">
                                    <label id="lblContraseña">(*) Ingrese una nueva contraseña</label>
                                </td>
                                <td width="400px" >
                                    <input onpaste="return true" type="password" id="password" class="solo-letrasnumeros" runat="server"
                                        maxlength="15" style="width: 150px;" name="password" /> 
                                </td>
                                  <td style="color: gray; font-size: 11px">(Puede combinar números, letras,
                                    <br />
                                    mayúsculas y minúsculas)</td>
                            </tr>
                            <tr>
                                <td>
                                    <label id="lblReContraseña">(*) Reingrese la nueva contraseña</label>
                                </td>
                                <td>
                                    <input onpaste="return false" type="password" id="password_reingresado" class="solo-letrasnumeros" runat="server"
                                        maxlength="15" style="width: 150px;" name="password_reingresado" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>(*) Ingrese Correo Electrónico</label>
                                </td>
                                <td >
                                    <input type="text" id="email" class="SoloLetraNumero" onpaste="return false" runat="server" maxlength="100"
                                        style="width: 320px" name="email" />
                                </td>
                                <td style="color: gray; font-size: 11px" valign="top" rowspan="2">(A este correo se le enviará<br /> información relevante sobre el <br />proceso de Evaluación)</td>
                            </tr>
                            <tr>
                                <td>
                                    <label>(*) Reingrese Correo Electrónico</label>
                                </td>
                                <td>
                                    <input type="text" id="email_reingresado" class="SoloLetraNumero" onpaste="return false" runat="server" maxlength="100"
                                        style="width: 320px" name="email_reingresado" />
                                </td>
                            </tr>
                             <tr>
                                <td>
                                    <label>(*) Dirección<br /></label>
                                </td>
                                <td>
                                    <input type="text" id="direccion" runat="server" maxlength="100" style="width: 320px" name="direccion" />
                                </td>
                                <td style="color: gray; font-size: 11px">(Calle, número, depto.)</td>
                            </tr>
                             <tr>
                                <td>
                                    <label>(*) Comuna</label>
                                </td>
                                <td>
                                    <asp:DropDownList ID="Dd1_Comunas" runat="server" Width="200" CssClass="TextoCombo"></asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>Número de contacto 1</label>
                                </td>
                                <td>56-<input onpaste="return false" type="text" id="numContac" runat="server" maxlength="20"
                                    style="width: 300px" name="numContac" />

                                </td>
                                <td align="left" style="color: gray; font-size: 11px"><i><b><u>Ejemplo</u> </b>Celular: 991234567
                                    <br />
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Fijo: 221234567</i>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>Número de contacto 2</label>
                                </td>
                                <td>56-<input onpaste="return false" type="text" id="numContac2" runat="server" maxlength="20"
                                    style="width: 300px" name="numContac2" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>Sexo</label>
                                </td>
                                <td>
                                    <label style="display: inline;">Hombre</label>
                                    <input type="radio" id="rdbHombre" runat="server" name="sexo" style="width: 20px;" />
                                    <label style="display: inline">Mujer</label>
                                    <input type="radio" id="rdbMujer" runat="server" name="sexo" style="width: 20px;" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>Año de nacimiento</label>
                                </td>
                                <td style="padding-top: 5px">
                                    <select id="ANIO_NACIMIENTO" runat="server"></select>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    <label>(*) Información obligatoria</label>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr class="hide" style="display: none">
                    <td align="right">
                        <button id="btnGrabarDown" class="btnGrabar" runat="server" style="width: auto">
                            Guardar mis datos</button>
                    </td>
                </tr>
            </table>
        </div>
        <div id="info-Val">
            <%--<table class="ui-widget ui-widget-content ui-corner-all" align="center" style="width: 810px; height: 350px; border-radius: 60px; background-color: #B9CDE5; border-collapse: collapse; border-width: 0px">
                <tr style="border-radius: 60px; background-color: #B9CDE5; height: 350px">
                    <td style="border-radius: 60px; background-color: #B9CDE5; padding-left: 110px; padding-right: 110px">
                        <p style="text-align: left; font-size: 1.2em" class="pdTituloBv">¡IMPORTANTE!</p>
                        <p style="text-align: justify; font-family: Calibri; font-size: 19px">
                            Revise que <b>todos sus datos estén correctos:</b> Nombre, RUT, inscripción y establecimiento.
                        </p>
                        <p style="text-align: justify; font-family: Calibri; font-size: 19px">
                            Considere que <b>debe</b> elaborar su Portafolio según los datos de inscripción señalados en el recuadro anterior.
                        </p>
                        <p style="text-align: justify; font-family: Calibri; font-size: 19px">
                            Ante cualquier duda sobre esta información, comuníquese con su<br />
                            Coordinador/a Comunal, quien es responsable de la inscripción según la
                                normativa vigente.
                        </p>
                    </td>
                </tr>
            </table>
            <table align="center" style="width: 810px; height: 4px; background-color: white; border-collapse: collapse; border-width: 0px">
                <tr>
                    <td align="right">
                        <input type="button" id="continuar" value="Continuar" style="width: 100px;" />
                    </td>
                </tr>
            </table>--%>
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
        <div id="confirm-dialog" class="ui-state-error" style="background: red; color: yellow; font-weight: bold;">
            <p id="confirm-dialog-content"></p>
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
        <input type="hidden" id="idEvaluacion" runat="server" />
        <input type="hidden" id="FechaNacDocente" runat="server" />
    </form>

</body>
</html>
