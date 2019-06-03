<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Tarea5.aspx.vb" Inherits="PlataformaDocente.Tarea5" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" >

<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="google" content="notranslate" />
    <title></title>
    <script src="../../Scripts/Framework/__jsCommon/jsCommon.js" type="text/javascript"></script>
    <script type="text/javascript">
        var baseUrl = '<%= ResolveUrl("~/") %>';
        var op = "";
        var pt = 0;

        $.fn.ready(function () {
            $('#divDetalle').height($(window).height() - 210);

            //Deshabilitar arrastre de imagenes
            $(".guardar").on('dragstart', function (e) { e.preventDefault(); });
            $(".adjunto").on('dragstart', function (e) { e.preventDefault(); });

            $('#rec_T5_TC_GENERAL').maxlength({ max: 500, feedbackTarget: '#tf_T5_TC_GENERAL', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T5_TC_MOTIVACION').maxlength({ max: 2200, feedbackTarget: '#tf_T5_TC_MOTIVACION', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T5_TC_EXPERIENCIA').maxlength({ max: 5400, feedbackTarget: '#tf_T5_TC_EXPERIENCIA', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            //$('#rec_T5_TC_DESCRIPCION').maxlength({ max: 5400, feedbackTarget: '#tf_T5_TC_DESCRIPCION', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T5_TC_BALANCE').maxlength({ max: 5400, feedbackTarget: '#tf_T5_TC_BALANCE', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });


            $("#confirm-dialog").dialog({
                modal: true,
                autoOpen: false,
                height: "auto",
                width: 400
            });


            $("#desempeno").button().click(function (event) {
                event.preventDefault();
                MostrarDesempeno(810, 530);
            });

            cargar_tabla("ADJ", "T5_TC_TABLA");//SPALMA 14-05-2018
            cambioOpciones();
            check();//SPALMA 11-05-2018 Metodo para los checks de RadioButtons

            $('input[name*="rec_"]').bind('change paste keyup keydown keypress', function (e) {
                var keyCode = e.keyCode || e.which;
                if ($("#acceso").val() != "V") {
                    if (keyCode != 9) {
                        boInputChanged = true;
                        return;
                    }
                }
            });

            $('select[name*="rec_"]').bind('change paste keyup keydown keypress', function (e) {
                var keyCode = e.keyCode || e.which;
                if ($("#acceso").val() != "V") {
                    if (keyCode != 9) {
                        boInputChanged = true;
                        return;
                    }
                }
            });

            $('textarea[name*="rec_"]').bind('change paste keyup keydown keypress', function (e) {
                var keyCode = e.keyCode || e.which;
                if ($("#acceso").val() != "V") {
                    if (keyCode != 9) {
                        boInputChanged = true;
                        return;
                    }
                }
            });

            //En el caso del acceso ser V solo se podra ver el formulario.
            if ($("#acceso").val() == "V") {
                $('.guardar').hide();
                $("input[name$='op_T5_M3_OPCION']").attr('disabled', true);
                $('#rec_T5_TC_GENERAL').prop('readonly', true);
                $('#rec_T5_TC_MOTIVACION').prop('readonly', true);
                $('#rec_T5_TC_EXPERIENCIA').prop('readonly', true);
                //$('#rec_T5_TC_DESCRIPCION').prop('readonly', true);
                $('#rec_T5_TC_BALANCE').prop('readonly', true);
                $('.adjuntos').hide();
            }

            if ($("#ErrorMessage").val() != "") {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html($("#ErrorMessage").val());
                $("#alert-message").dialog("open");
            }
        });

        function SubirADJ() {
            $('#rec_ID_DOCUMENTO').val('0');
            upload_Documento("ADJ", function () {
                cargar_tabla("ADJ", "T5_TC_TABLA");
            });
            $("#uploadTitulo").html("<p><span>Seleccione un archivo.</span></p>")
            $("#dialog-uploadDocumento").dialog("option", "title", "Subir archivos");
            $('#dialog-uploadDocumento').dialog('open');
        }

        //Guardar la Tarea 5
        function Guardar() {
            if (boInputChanged == true) {
                if ($('input[name=op_T5_M3_OPCION]:checked', '#frmRegistry').val() == "Opcion2" && hayDatos() == true) {
                    $("#confirm-dialog").dialog("option", "title", "Hay cambios");
                    $("#confirm-dialog-content").html("<center>Al guardar esta opción se eliminará lo que haya ingresado”, ¿Desea continuar?</center>");
                    $("#confirm-dialog").dialog("option", "buttons", {
                        "Sí": function () {
                                SaveDataViaAjax()
                                LimpiaAdjuntos();
                                $(this).dialog("close");
                                limpiaDatos();
                        },
                        "No": function () {
                            $(this).dialog("close");
                            if (hayDatos() == true) {
                                pt = 0;
                                //$("#rec_T5_M3_OPCION1").click();
                            }
                        }
                    });
                    $("#confirm-dialog").dialog("open");
                }
                else {
                    SaveDataViaAjax();
                }
            }

            else {
                $("#info-message").dialog("option", "title", "Guardar registro");
                $("#info-message-content").html("No hay cambios pendientes de guardar.");
                $("#info-message").dialog("open");
            }
        }
        //SPALMA 09-06-2016 Funcion para saber si existen datos en los respaldos de ambas opciones y enviar advertencia segun sea el caso
        function hayDatos() {
            if ( $("#rec_T5_TC_GENERAL").val() != "" ||  $("#rec_T5_TC_MOTIVACION").val() != "" ||  $("#rec_T5_TC_EXPERIENCIA").val() != "" ||  $("#rec_T5_TC_BALANCE").val() != "" || $('#ID_ADJ0').val() != undefined) {
                return true;
            }
            else {
                return false;
            }
        }

        function SaveDataViaAjax() {
            methodURL = baseUrl + "Aplicaciones/Ficha/Tarea5.aspx/SaveData";
            var arForm = $("#frmRegistry").serializeArray();
            $("#save").button("option", "disabled", true);

            $("#iconUpdates").html("<img src='../../Imagenes/ajax-loader_small.gif' />");
            $("#Vidrio").show();

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: methodURL,
                data: JSON.stringify({ "mode": $('#boRegistryMode').val(), formVars: arForm }),
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
                            $('#MyRowstamp').val(Record["d"]["ROWSTAMP"]);
                            $("#iCurrentRow").val(Record["d"]["__rowindex"]);

                            boInputChanged = false;

                            if ($("#boRegistryMode").val() == 'new') {
                                //RBORLONE 05-04-2016 Cuando se esta insertando un registro le asignamos un nuevo ID_T5.
                                $("#rec_ID_TABLA").val(Record["d"]["__ID_T5"]);
                                $("#boRegistryMode").val("update");
                            }
                            else {
                                $("#info-message").dialog("option", "title", "Aviso");
                                $("#info-message-content").html("Su tarea ha sido guardada con éxito.");
                                $("#info-message").dialog("open");
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
                $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo guardar datos en el servidor: " + msg);
                $("#alert-message").dialog("open");
            }
                },
                complete: function () {
                    $("#iconUpdates").html("");
                    $("#save").button("option", "disabled", false);
                    $("#Vidrio").hide();
                }

            });
}

function cambioOpciones() {
    $("input[name$='op_T5_M3_OPCION']").change(function () {
        boInputChanged = true;
        op = $(this).val();
        if (pt == 1 && hayDatos() == true && op =="Opcion2") {
            advertencia(op);
        }
        pt = 1;
        if ($(this).val() == 'Opcion2') {
            $('textarea[name*="rec_"]').css('background', '#585858');
            $('textarea[name*="rec_"]').css('border', '#585858 solid 1px');
            $('textarea[name*="rec_"]').prop('readonly', true);
            $('.iconos').hide();
            $('.enc_iconos').hide();
            $('.adjuntos').hide();
        } else if ($(this).val() == 'Opcion1') {
            $('textarea[name*="rec_"]').css('background', '#EFF1F2');
            $('textarea[name*="rec_"]').css('border', '#EFF1F2 solid 1px');
            $('textarea[name*="rec_"]').prop('readonly', false);
            $('.iconos').show();
            $('.enc_iconos').show();
            $('.adjuntos').show();
        }
        else {
            $('textarea[name*="rec_"]').css('background', '#585858');
            $('textarea[name*="rec_"]').css('border', '#585858 solid 1px');
            $('textarea[name*="rec_"]').prop('readonly', true);
            $('.iconos').hide();
            $('.enc_iconos').hide();
            $('.adjuntos').hide();
        }

    });
}
function advertencia(opcion) {
    $("#confirm-dialog").dialog("option", "title", "Advertencia");
        $("#confirm-dialog-content").html("<center>Al marcar esta opción, se ELIMINARÁ lo que haya ingresado ¿Desea continuar?</center>");
    $("#confirm-dialog").dialog("option", "buttons", {
        "Sí": function () {
            $('textarea[name*="rec_"]').css('background', '#585858');
            $('textarea[name*="rec_"]').css('border', '#585858 solid 1px');
            $('textarea[name*="rec_"]').prop('readonly', true);
            $('.iconos').hide();
            $('.enc_iconos').hide();
            $('.adjuntos').hide();
            $(this).dialog("close");
        },
        "No": function () {

            $('textarea[name*="rec_"]').css('background', '#EFF1F2');
            $('textarea[name*="rec_"]').css('border', '#EFF1F2 solid 1px');
            $('textarea[name*="rec_"]').prop('readonly', false);
            $('.iconos').show();
            $('.enc_iconos').show();
            $('.adjuntos').show();
            if (hayDatos() == true) {
                $("#rec_T5_M3_OPCION1").click();
            }
            $(this).dialog("close");
        }
    });
    $("#confirm-dialog").dialog("open");
}

function check() {
    var RDB_VAL_SELECT = '';
    var RDB_CHECK = $("input[name$='op_T5_M3_OPCION']");
    for (var i = 0; i < RDB_CHECK.length; i++) {
        if (RDB_CHECK[i].checked == true) {
            boInputChanged == true;
            RDB_VAL_SELECT = RDB_CHECK[i].value;
        }
        if (RDB_VAL_SELECT == 'Opcion2') {
            $('textarea[name*="rec_"]').css('background', '#585858');
            $('textarea[name*="rec_"]').css('border', '#585858 solid 1px');
            $('textarea[name*="rec_"]').prop('readonly', true);
            $('.iconos').hide();
            $('.enc_iconos').hide();
            $('.adjuntos').hide();
        } else if (RDB_VAL_SELECT == 'Opcion1') {
            $('textarea[name*="rec_"]').css('background', '#EFF1F2');
            $('textarea[name*="rec_"]').css('border', '#EFF1F2 solid 1px');
            $('textarea[name*="rec_"]').prop('readonly', false);
            $('.iconos').show();
            $('.enc_iconos').show();
            $('.adjuntos').show();
        } else {
            $('textarea[name*="rec_"]').css('background', '#585858');
            $('textarea[name*="rec_"]').css('border', '#585858 solid 1px');
            $('textarea[name*="rec_"]').prop('readonly', true);
            $('.iconos').hide();
            $('.enc_iconos').hide();
            $('.adjuntos').hide();
        }
    }
}

function LimpiaAdjuntos() {
    for (var i = 0; i < 5; i++) {
        if ($('#ID_ADJ' + i).val() != undefined) {
            eliminar_documentoTipos($('#ID_ADJ' + i).val());
        }
    }
    cargar_tabla("ADJ", "T5_TC_TABLA");
}


function limpiaDatos() {

    $("#rec_T5_TC_GENERAL").val("")
    $("#rec_T5_TC_MOTIVACION").val("")
    $("#rec_T5_TC_EXPERIENCIA").val("")
    $("#rec_T5_TC_BALANCE").val("")
    $('#rec_T5_TC_GENERAL').maxlength('option', { feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
    $('#rec_T5_TC_MOTIVACION').maxlength('option', { feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
    $('#rec_T5_TC_EXPERIENCIA').maxlength('option', { feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
    $('#rec_T5_TC_BALANCE').maxlength('option', { feedbackText: 'Máximo {m} caracteres. {r} disponibles' });

}


//SPALMA 09-06-2016 Funcion ajax llamada por las 2 anteriores para eliminacion de archivos en opcion no elegida
function eliminar_documentoTipos(idDocumento, tipomaterial, success) {
    var methodURL = baseUrl + 'Aplicaciones/Ficha/Fichas.aspx/EliminarDocumento';
    var parameters = '{idDocumento: "' + idDocumento + '",idTabla: "' + $('#rec_ID_TABLA').val() + '",Tabla: "T5",idApliccion: "' + $('#Id_Aplicacion').val() + '"}';

    $.ajax({
        cache: false,
        async: false,
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        url: methodURL,
        data: parameters,
        success: function (response) {
        },
        error: function (xhr, err) {
            $("#alert-message").dialog("option", "title", "Error");
            $("#alert-message-content").html(err);
            $("#alert-message").dialog("open");
        }
    });
}

//Metodo para cargar la tabla con los archivos.
function cargar_tabla(tipomaterial, tabla) {
    if ($('#rec_NOMBRE_TABLA').val() != "" && $('#rec_ID_TABLA').val() != "") {
        var methodURL = baseUrl + "Aplicaciones/Ficha/Tarea5.aspx/cargarTabla";
        var parameters = '{ nombreTabla:"' + $('#rec_NOMBRE_TABLA').val() + '", idTabla:"' + $('#rec_ID_TABLA').val() + '", tipoMaterial:"' + tipomaterial + '" }';
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
                    }
                    else {
                        $("#" + tabla).empty();
                        $("#" + tabla).html(Record["d"]["__body"]);
                        $(".adjunto").on('dragstart', function (e) { e.preventDefault(); });
                        $('#iconos').show();
                        $('#enc_iconos').show();
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
}

    </script>
</head>
<body onload="fnCommon_nobackbutton()">
    <form id="frmRegistry" runat="server">
        <div style="width: 750px; border: 0px; margin-top: 0px; margin-left: auto; margin-right: auto;">
            <table style="width: 100%;" border="0">
                <tr>
                    <td align="left" style="width: 30%;">
                        <button id="desempeno" runat="server">
                            Qué me evaluarán...</button></td>
                    <td align="center" class="pdTitulo1">TRABAJO COLABORATIVO PARA EL APRENDIZAJE DOCENTE
                    </td>
                    <td align="right" style="width: 20%;">
                        <img alt="Guardar" src="../../Imagenes/Images/guardar-off.jpg" onmouseover="this.src='../../Imagenes/Images/guardar-on.jpg'"
                            onmouseout="this.src='../../Imagenes/Images/guardar-off.jpg'" onclick="Guardar()" class="guardar" style="cursor: pointer" id="guardar1" runat="server" />
                    </td>
                    <td style="width: 15px;"></td>
                </tr>
                <tr>
                    <td align="center" class="pdSubTitulo1" colspan="3"><b>Revise las instrucciones de su Manual Portafolio para desarrollar esta tarea</b>
                    </td>
                </tr>
            </table>
            <div id="divDetalle" style="width: 750px; height: 100px; border: 0px; overflow-y: auto;" runat="server">
                <%--======================= FRAMEWORK rec fields declaration =======================--%>
                <fieldset class="pdFondoT5">
                    <table style="width: 100%;">
                        <tr>
                            <td>
                                <table class="ui-widget ui-widget-content ui-corner-all" style="width: 100%;" id="T5_TABLA_OPCION" runat="server">
                                    <tr>
                                        <td valign="top">
                                            <input type="radio" id="rec_T5_M3_OPCION1" runat="server" name="op_T5_M3_OPCION" value="Opcion1" />
                                        </td>
                                        <td style="width: auto">
                                            <label style="display: inline;">
                                                <b>SÍ presentaré Módulo 3. </b>
                                                <br />
                                                Recuerde: el puntaje obtenido en este módulo se considerará solo en caso que beneficie su puntaje de Portafolio</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top">
                                            <input type="radio" id="rec_T5_M3_OPCION2" runat="server" name="op_T5_M3_OPCION" value="Opcion2" />
                                        </td>
                                        <td style="width: auto">
                                            <label style="display: inline;">
                                                <b>NO presentaré Módulo 3. </b>
                                                <br />
                                                Al marcar esta opción usted indica que no presentará evidencia para Módulo 3 con lo cual su puntaje en el Portafolio se calculará en base a Módulo 1 y Módulo 2.</label>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td align="center" colspan="2">
                                <label style="font-style: italic;">Usted podrá cambiar su elección hasta el día 18 de octubre.</label>
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" style="width: 100%;" border="0">
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>INFORMACIÓN GENERAL:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T5_TC_GENERAL"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T5_TC_GENERAL" name="rec_T5_TC_GENERAL" runat="server" class="ui-widget-content ui-corner-all" rows="5" cols="100" maxlength="500" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td class="TituloPregG">
                                <label>
                                    <b>A. Describiendo la experiencia de trabajo colaborativo </b>
                                </label>
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>A.1 Describa la<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip" style="display: inline" /></label></b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T5_TC_MOTIVACION"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T5_TC_MOTIVACION" name="rec_T5_TC_MOTIVACION" runat="server" class="ui-widget-content ui-corner-all" rows="22" cols="100" maxlength="2200" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>A.2 Describa el<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip" style="display: inline" /></label></b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T5_TC_EXPERIENCIA"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T5_TC_EXPERIENCIA" name="rec_T5_TC_EXPERIENCIA" runat="server" class="ui-widget-content ui-corner-all" rows="22" cols="100" maxlength="5400" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                    </table>
                    <table>
                        <tr>
                            <td valign="top" class="adjuntos">
                                <img alt="SubirADJ" src="../../Imagenes/Images/T5_TC_BOTON_OFF.png" onmouseover="this.src='../../Imagenes/Images/T5_TC_BOTON_ON.png'" onmouseout="this.src='../../Imagenes/Images/T5_TC_BOTON_OFF.png'" onclick="SubirADJ()" class="adjunto" style="cursor: pointer" />
                            </td>
                            <td valign="top" class="adjuntos">
                                <div id="T5_TC_TABLA" runat="server">
                                </div>
                                <br />
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" style="width: 100%;" border="0">
                        <tr>
                            <td class="TituloPregG">
                                <label>
                                    <b>B. Reflexionando a partir de la experiencia de trabajo colaborativo </b>
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td class="TituloPreg" align="justify" style="padding-left: 25px">
                                <label>
                                    <b>IMPORTANTE:</b> Esta pregunta debe ser respondida en forma <b><u>individual</u></b>, pues se espera recoger la riqueza y singularidad de su reflexión. 
                                </label>
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>¿Qué balance hace de<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...?
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip" style="display: inline" /></label></b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T5_TC_BALANCE"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T5_TC_BALANCE" name="rec_T5_TC_BALANCE" runat="server" class="ui-widget-content ui-corner-all" rows="33" cols="100" maxlength="5400" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                    </table>
                </fieldset>
                <table style="width: 100%;" border="0">
                    <tr>
                        <td align="right">
                            <img alt="Guardar" src="../../Imagenes/Images/guardar-off.jpg" onmouseover="this.src='../../Imagenes/Images/guardar-on.jpg'"
                                onmouseout="this.src='../../Imagenes/Images/guardar-off.jpg'" onclick="Guardar()" class="guardar" style="cursor: pointer" id="guardar2" runat="server" />
                        </td>
                    </tr>
                </table>

                <%--======================= Fin FRAMEWORK rec fields declaration =======================--%>
                <input type="hidden" id="rec_ID_PERIODO" runat="server" />
                <input type="hidden" id="rec_RUT_DOCENTE" runat="server" />
                <input type="hidden" id="rec_ID_EVALUACION" runat="server" />
                <input type="hidden" id="boRegistryMode" runat="server" value="new" />
                <input type="hidden" id="ErrorMessage" runat="server" value="" />
                <input type="hidden" id="MyRowstamp" name="MyRowstamp" runat="server" />

                <span id="msgSaved"></span>
            </div>
        </div>
    </form>

    <%--Para la subida del archivo--%>
    <input type="hidden" id="rec_NOMBRE_TABLA" name="rec_NOMBRE_TABLA" value="T5" runat="server" />
    <input type="hidden" id="ID_T5" name="ID_T5" value="" runat="server" />
    <input type="hidden" id="rec_ID_TABLA" name="rec_ID_TABLA" value="" runat="server" />
    <input type="hidden" id="rec_NOMBRE_CAMPO" name="rec_NOMBRE_CAMPO" value="" runat="server" />
    <input type="hidden" id="rec_ID_DOCUMENTO" name="rec_ID_DOCUMENTO" value="0" runat="server" />
    <input type="hidden" id="DesEsp" name="DesEsp" value="" runat="server" />
    <input type="hidden" id="DesEspWidth" name="DesEspWidth" value="800" runat="server" />
    <input type="hidden" id="DesEspHeight" name="DesEspHeight" value="800" runat="server" />
    <input type="hidden" id="Cod_Subsector" name="Cod_Subsector" runat="server" />
    <input type="hidden" id="acceso" name="acceso" value="V" runat="server" />
    <input type="hidden" id="Id_Aplicacion" name="Id_Aplicacion" value="295" runat="server" />
    <input type="hidden" id="Cod_Nivel" name="Cod_Nivel" runat="server" />
</body>
</html>
