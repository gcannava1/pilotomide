<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Tarea4.aspx.vb" Inherits="PlataformaDocente.Tarea4" %>

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

        $.fn.ready(function () {
            $('#divDetalle').height($(window).height() - 190)

            $('#divDetalleTP').height($(window).height() - 190)

            //Deshabilitar arrastre de imagenes
            $(".guardar").on('dragstart', function (e) { e.preventDefault(); });
            $(".adjunto").on('dragstart', function (e) { e.preventDefault(); });
            //Div no TP
            $('#rec_T4_OB_CURRICULAR').maxlength({ max: 2000, feedbackTarget: '#tf_T4_OB_CURRICULAR', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T4_OB_CLASE').maxlength({ max: 500, feedbackTarget: '#tf_T4_OB_CLASE', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T4_SITUACION').maxlength({ max: 600, feedbackTarget: '#tf_T4_SITUACION', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            //Div TP
            $('#rec_T4_TP_MODULO').maxlength({ max: 200, feedbackTarget: '#tf_T4_TP_MODULO', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T4_TP_OB_CURRICULAR').maxlength({ max: 2000, feedbackTarget: '#tf_T4_TP_OB_CURRICULAR', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T4_TP_APREN_ESP_TXT').maxlength({ max: 1000, feedbackTarget: '#tf_T4_TP_APREN_ESP_TXT', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T4_TP_CRITE_CLASE').maxlength({ max: 500, feedbackTarget: '#tf_T4_TP_CRITE_CLASE', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T4_TP_OB_CLASE').maxlength({ max: 500, feedbackTarget: '#tf_T4_TP_OB_CLASE', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T4_TP_CONTEX_CLASE').maxlength({ max: 2000, feedbackTarget: '#tf_T4_TP_CONTEX_CLASE', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T4_TP_SITUACION').maxlength({ max: 600, feedbackTarget: '#tf_T4_TP_SITUACION', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });

            //Si es TP (Técnico Profesional).
            if ($("#Cod_Nivel").val() == "EMTP") {
                $("#divDetalleTP").show();
                $("#divDetalle").hide();
                $("#tituloTarea").html("GRABACIÓN DE UN SEGMENTO DE CLASE");

                cargar_tabla("RRA", "TablaRecursosTP");
            } else {
                $("#divDetalleTP").hide();
                $("#divDetalle").show();
                $("#tituloTarea").html("CLASE GRABADA");
                cargar_tabla("RRA", "TablaRecursos");
            }

            $("#desempeno").button().click(function (event) {
                event.preventDefault();
                MostrarDesempeno(650, 680);
            });

            if ($("#Cod_Subsector").val() == "EAEMCN") {
                $("#tb_T4_ASIGNATURA").show();
            }

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
            
            fnCommon_fnEnterTab();

            //En el caso del acceso ser V solo se podra ver el formulario.
            if ($("#acceso").val() == "V") {
                $('.guardar').hide();
                $("#rec_T4_ASIGNATURA_EAEMCN").attr('disabled', true);
                $("#rec_T4_CURSO").prop('readonly', true);
                $("#rec_T4_CANTIDAD").prop('readonly', true);
                $("#rec_T4_OB_CURRICULAR").prop('readonly', true);
                $("#rec_T4_OB_CLASE").prop('readonly', true);
                $("#rec_T4_SITUACION").prop('readonly', true);
                //TP
                $("#rec_T4_TP_CURSO").prop('readonly', true);
                $("#rec_T4_TP_CANTIDAD").prop('readonly', true);
                $("#rec_T4_TP_MODULO").prop('readonly', true);
                $("#rec_T4_TP_OB_CURRICULAR").prop('readonly', true);
                $("#rec_T4_TP_APREN_ESP_TXT").prop('readonly', true);
                $("#rec_T4_TP_CRITE_CLASE").prop('readonly', true);
                $("#rec_T4_TP_OB_CLASE").prop('readonly', true);
                $("#rec_T4_TP_CONTEX_CLASE").prop('readonly', true);
                $("#rec_T4_TP_SITUACION").prop('readonly', true);

                $('.adjuntos').hide();
            }

            if ($("#ErrorMessage").val() != "") {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html($("#ErrorMessage").val());
                $("#alert-message").dialog("open");
            }
        });

        function SubirRRA() {
            $('#rec_ID_DOCUMENTO').val('0');
            upload_Documento("RRA", function () {
                if ($("#Cod_Nivel").val() == "EMTP") { cargar_tabla("RRA", "TablaRecursosTP"); }
                else { cargar_tabla("RRA", "TablaRecursos"); }
            });
            $("#uploadTitulo").html("<p><span>Seleccione el archivo del recurso de aprendizaje.</span></p>")
            $("#dialog-uploadDocumento").dialog("option", "title", "Subir recurso de aprendizaje");
            $('#dialog-uploadDocumento').dialog('open');
        }


        //Guardar la Tarea 4
        function Guardar() {
            if (boInputChanged == true) {
                SaveDataViaAjax();
            } else {
                $("#info-message").dialog("option", "title", "Guardar registro");
                $("#info-message-content").html("No hay cambios pendientes de guardar.");
                $("#info-message").dialog("open");
            }
        }

        $('.solo-numero').bind('paste', function (e) {
            var selector = '#' + $(this).context.id;
            setTimeout(function (e, event) {
                $(selector).val($(selector).val().replace(/[^0-9]/g, ''));
            }, 10);
        });

        $('.solo-numero').keydown(function (e) {
            if ($.inArray(e.keyCode, [46, 8, 9, 27, 13]) !== -1 ||
                (e.keyCode == 65 && (e.ctrlKey === true || e.metaKey === true)) ||
                (e.keyCode >= 35 && e.keyCode <= 40) || (e.ctrlKey && e.keyCode == 86)) {
                return;
            }
            if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                e.preventDefault();
            }
        });

        function SaveDataViaAjax() {
            methodURL = baseUrl + "Aplicaciones/Ficha/Tarea4.aspx/SaveData";
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
                                //RBORLONE 05-04-2016 Cuando se esta insertando un registro le asignamos un nuevo ID_T4.
                                $("#rec_ID_TABLA").val(Record["d"]["__ID_T4"]);
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

//Metodo para cargar la tabla con los archivos.
function cargar_tabla(tipomaterial, tabla) {
    if ($('#rec_NOMBRE_TABLA').val() != "" && $('#rec_ID_TABLA').val() != "") {
        var methodURL = baseUrl + "Aplicaciones/Ficha/Tarea4.aspx/cargarTabla";
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
                    <td align="left" style="width: 25%;">
                        <button id="desempeno" runat="server">
                            Qué me evaluarán...</button></td>
                    <td align="center" class="pdTitulo1" id="tituloTarea"></td>
                    <td align="right" style="width: 15%;">
                        <img alt="Guardar" src="../../Imagenes/Images/guardar-off.jpg" onmouseover="this.src='../../Imagenes/Images/guardar-on.jpg'"
                            onmouseout="this.src='../../Imagenes/Images/guardar-off.jpg'" onclick="Guardar()" class="guardar" style="cursor:pointer" id="guardar1" runat="server"/>
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
                <fieldset class="pdFondoT4">
                    <table id="tb_T4_ASIGNATURA" class="ui-widget" style="width: 100%; display: none;" border="0" runat="server">
                        <tr>
                            <td runat="server" style="width: 30%;" class="ui-widget">
                                <label><b><u>DEBE</u> indicar la especialidad</b></label>
                            </td>
                            <td style="width: 100%;">
                                <asp:DropDownList ID="rec_T4_ASIGNATURA_EAEMCN" runat="server" Width="20%" CssClass="ui-widget-content ui-corner-all">
                                    <asp:ListItem>Seleccione</asp:ListItem>
                                    <asp:ListItem>Biología</asp:ListItem>
                                    <asp:ListItem>Química</asp:ListItem>
                                    <asp:ListItem>Física</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget">
                        <tr>
                            <td>
                                <label>
                                    <b>a. Curso y letra:</b></label>
                            </td>
                            <td>
                                <input type="text" id="rec_T4_CURSO" name="rec_T4_CURSO" runat="server" class="ui-widget-content ui-corner-all" maxlength="80" style="width: 580px;" />
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget">
                        <tr>
                            <td>
                                <label>
                                    <b>b. Cantidad de estudiantes presentes en la clase: </b></label>
                            </td>
                            <td>
                                <input type="text" id="rec_T4_CANTIDAD" name="rec_T4_CANTIDAD" runat="server" class="ui-widget-content ui-corner-all solo-numero" maxlength="2" style="width: 20px;" />
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>c. Objetivo Curricular:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T4_OB_CURRICULAR"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T4_OB_CURRICULAR" name="rec_T4_OB_CURRICULAR" runat="server" class="ui-widget-content ui-corner-all" rows="10" cols="100" maxlength="2000" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>d. Objetivo(s) trabajado(s) en la clase:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T4_OB_CLASE"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T4_OB_CLASE" name="rec_T4_OB_CLASE" runat="server" class="ui-widget-content ui-corner-all" rows="5" cols="100" maxlength="500" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>e. Si durante su clase ocurrió alguna situación que interfirió en el desarrollo de esta, por favor, menciónela.</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T4_SITUACION"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T4_SITUACION" name="rec_T4_SITUACION" runat="server" class="ui-widget-content ui-corner-all" rows="6" cols="100" maxlength="600" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>

                    </table>
                    <table>
                        <tr>
                            <td valign="top" class="adjuntos">
                                <img alt="SubirRRA" src="../../Imagenes/Images/T4_RRA_OFF.png" onmouseover="this.src='../../Imagenes/Images/T4_RRA_ON.png'"
                                    onmouseout="this.src='../../Imagenes/Images/T4_RRA_OFF.png'" onclick="SubirRRA()" class="adjunto" style="cursor:pointer"/>
                            </td>
                            <td valign="top">
                                <div id="TablaRecursos" runat="server">
                                </div>
                            </td>
                        </tr>
                    </table>
                </fieldset>
                <table style="width: 100%;" border="0">
                    <tr>
                        <td align="right">
                            <img alt="Guardar" src="../../Imagenes/Images/guardar-off.jpg" onmouseover="this.src='../../Imagenes/Images/guardar-on.jpg'"
                                onmouseout="this.src='../../Imagenes/Images/guardar-off.jpg'" onclick="Guardar()" class="guardar" style="cursor:pointer"/>
                        </td>
                    </tr>
                </table>

                <%--======================= Fin FRAMEWORK rec fields declaration =======================--%>
            </div>
            <div id="divDetalleTP" style="width: 750px; height: 100px; border: 0px; overflow-y: auto;" runat="server">

                <%--======================= FRAMEWORK rec fields declaration =======================--%>
                <fieldset class="pdFondoT4">
                    <table class="ui-widget">
                        <tr>
                            <td>
                                <label>
                                    <b>a. Curso y letra:</b></label>
                            </td>
                            <td>
                                <input type="text" id="rec_T4_TP_CURSO" name="rec_T4_TP_CURSO" runat="server" class="ui-widget-content ui-corner-all" maxlength="80" style="width: 580px;" />
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget">
                        <tr>
                            <td>
                                <label>
                                    <b>b. Cantidad de estudiantes presentes en la grabación: </b>
                                </label>
                            </td>
                            <td>
                                <input type="text" id="rec_T4_TP_CANTIDAD" name="rec_T4_TP_CANTIDAD" runat="server" class="ui-widget-content ui-corner-all solo-numero" maxlength="2" style="width: 20px;" />
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>c. Módulo de la especialidad al que pertenece el segmento:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T4_TP_MODULO"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T4_TP_MODULO" name="rec_T4_TP_MODULO" runat="server" class="ui-widget-content ui-corner-all" rows="2" cols="100" maxlength="200" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>d. Objetivo de aprendizaje con el que se relaciona el segmento: </b>
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T4_TP_OB_CURRICULAR"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T4_TP_OB_CURRICULAR" name="rec_T4_TP_OB_CURRICULAR" runat="server" class="ui-widget-content ui-corner-all" rows="10" cols="100" maxlength="2000" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>e. Aprendizaje esperado:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T4_TP_APREN_ESP_TXT"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T4_TP_APREN_ESP_TXT" name="rec_T4_TP_APREN_ESP_TXT" runat="server" class="ui-widget-content ui-corner-all" rows="10" cols="100" maxlength="1000" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>f. Criterio(s) de evaluación relacionados con el segmento:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T4_TP_CRITE_CLASE"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T4_TP_CRITE_CLASE" name="rec_T4_TP_CRITE_CLASE" runat="server" class="ui-widget-content ui-corner-all" rows="5" cols="100" maxlength="500" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>g. Objetivo(s) que se propuso lograr en el segmento grabado:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T4_TP_OB_CLASE"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T4_TP_OB_CLASE" name="rec_T4_TP_OB_CLASE" runat="server" class="ui-widget-content ui-corner-all" rows="5" cols="100" maxlength="500" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>h. ¿Qué trabajó antes y después de su grabación?</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T4_TP_CONTEX_CLASE"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T4_TP_CONTEX_CLASE" name="rec_T4_TP_CONTEX_CLASE" runat="server" class="ui-widget-content ui-corner-all" rows="10" cols="100" maxlength="2000" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>i. Si durante el segmento ocurrió alguna situación que interfirió en el desarrollo de este, por favor, &nbsp;&nbsp;&nbsp;&nbsp;menciónela.</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T4_TP_SITUACION"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T4_TP_SITUACION" name="rec_T4_TP_SITUACION" runat="server" class="ui-widget-content ui-corner-all" rows="6" cols="100" maxlength="600" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>

                    </table>
                    <table>
                        <tr>
                            <td valign="top" class="adjuntos">
                                <img alt="SubirRRA" src="../../Imagenes/Images/T4_RRA_OFF.png" onmouseover="this.src='../../Imagenes/Images/T4_RRA_ON.png'"
                                    onmouseout="this.src='../../Imagenes/Images/T4_RRA_OFF.png'" onclick="SubirRRA()" class="adjunto" style="cursor:pointer"/>
                            </td>
                            <td valign="top">
                                <div id="TablaRecursosTP" runat="server">
                                </div>
                            </td>
                        </tr>
                    </table>
                </fieldset>
                <table style="width: 100%;" border="0">
                    <tr>
                        <td align="right">
                            <img alt="Guardar" src="../../Imagenes/Images/guardar-off.jpg" onmouseover="this.src='../../Imagenes/Images/guardar-on.jpg'"
                                onmouseout="this.src='../../Imagenes/Images/guardar-off.jpg'" onclick="Guardar()" class="guardar" style="cursor:pointer" id="guardar2" runat="server"/>
                        </td>
                    </tr>
                </table>

                <%--======================= Fin FRAMEWORK rec fields declaration =======================--%>
            </div>
        </div>
        <input type="hidden" id="rec_ID_PERIODO" runat="server" />
        <input type="hidden" id="rec_RUT_DOCENTE" runat="server" />
        <input type="hidden" id="rec_ID_EVALUACION" runat="server" />
        <input type="hidden" id="boRegistryMode" runat="server" value="new" />
        <input type="hidden" id="ErrorMessage" runat="server" value="" />
        <input type="hidden" id="MyRowstamp" name="MyRowstamp" runat="server" />
        <input type="hidden" id="Cod_Nivel" runat="server" />
    </form>
    <span id="msgSaved"></span>
    <%--RBORLONE 05-04-2016 Para la subida del archivo--%>
    <input type="hidden" id="rec_NOMBRE_TABLA" name="rec_NOMBRE_TABLA" value="T4" runat="server" />
    <input type="hidden" id="rec_ID_TABLA" name="rec_ID_TABLA" value="" runat="server" />
    <input type="hidden" id="rec_NOMBRE_CAMPO" name="rec_NOMBRE_CAMPO" value="" runat="server" />
    <input type="hidden" id="rec_ID_DOCUMENTO" name="rec_ID_DOCUMENTO" value="0" runat="server" />
    <input type="hidden" id="DesEsp" name="DesEsp" value="" runat="server" />
    <input type="hidden" id="DesEspWidth" name="DesEspWidth" value="800" runat="server" />
    <input type="hidden" id="DesEspHeight" name="DesEspHeight" value="800" runat="server" />
    <input type="hidden" id="Cod_Subsector" name="Cod_Subsector" runat="server" />
    <input type="hidden" id="acceso" name="acceso" value="V" runat="server" />
    <input type="hidden" id="Id_Aplicacion" name="Id_Aplicacion" value="294" runat="server" />
</body>
</html>
