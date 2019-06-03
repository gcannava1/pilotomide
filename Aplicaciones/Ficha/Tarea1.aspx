<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Tarea1.aspx.vb" Inherits="PlataformaDocente.Tarea1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" >

<html xmlns="http://www.w3.org/1999/xhtml" lang ="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="google" content="notranslate" />
    <title></title>
    <script src="../../Scripts/Framework/__jsCommon/jsCommon.js" type="text/javascript"></script>
    <script type="text/javascript">
        var baseUrl = '<%= ResolveUrl("~/") %>';

        $.fn.ready(function () {

            $('#divDetalle').height($(window).height() - 190);
            $('#divDetalleTP').height($(window).height() - 190);

            //Deshabilitar arrastre de imagenes
            $(".guardar").on('dragstart', function (e) { e.preventDefault(); });

            $('#rec_T1_OBJ_CURR_TXT').maxlength({ max: 2000, feedbackTarget: '#tf_T1_OBJ_CURR_TXT', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            for (var i = 1; i <= 3; i++) {
                $('#rec_T1_' + i + '_OBJETIVOS').maxlength({ max: 500, feedbackTarget: '#tf_T1_' + i + '_OBJETIVOS', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            }
            for (var i = 1; i <= 3; i++) {
                $('#rec_T1_' + i + '_DESCRIPCION').maxlength({ max: 3600, feedbackTarget: '#tf_T1_' + i + '_DESCRIPCION', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            }

            $('#rec_T1_TP_MODULO').maxlength({ max: 200, feedbackTarget: '#tf_T1_TP_MODULO', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T1_TP_OBJ_APRE_TXT').maxlength({ max: 2000, feedbackTarget: '#tf_T1_TP_OBJ_APRE', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T1_TP_CRITE_ACTIV_TXT').maxlength({ max: 1000, feedbackTarget: '#tf_T1_TP_CRITE_ACTIV', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T1_TP_APRE_ESP_TXT').maxlength({ max: 1000, feedbackTarget: '#tf_T1_TP_APRE_ESP', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            for (var i = 1; i <= 3; i++) {
                $('#rec_T1_TP_' + i + '_OBJETIVOS').maxlength({ max: 500, feedbackTarget: '#tf_T1_TP_' + i + '_OBJETIVOS', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            }
            for (var i = 1; i <= 3; i++) {
                $('#rec_T1_TP_' + i + '_DESCRIPCION').maxlength({ max: 3600, feedbackTarget: '#tf_T1_TP_' + i + '_DESCRIPCION', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            }

            //$("#dialog-info-desempeno").dialog({
            //    height: $("#DesEspHeight").val(),
            //    width: $("#DesEspWidth").val()
            //});

            $("#desempeno").button().click(function (event) {
                event.preventDefault();
                MostrarDesempeno(790, 325);
            });

            if ($("#Cod_Subsector").val() == "EAEMCN") {
                $("#tb_T1_ASIGNATURA").show();
            }

            //si es TP mostramos formulario de TP, sino mostramos formulario no TP.
            if ($("#Cod_Nivel").val() == "EMTP") {
                $("#divDetalleTP").show();
                $("#divDetalle").hide();
            } else {
                $("#divDetalleTP").hide();
                $("#divDetalle").show();
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
                //NO TP
                $('#rec_T1_CURSO').prop('readonly', true);
                $("#rec_T1_ASIGNATURA_EAEMCN").attr('disabled', true);
                $("#rec_T1_OBJ_CURR_TXT").prop('readonly', true);
                for (var i = 1; i <= 3; i++) {
                    $('#rec_T1_' + i + '_OBJETIVOS').prop('readonly', true);
                }
                for (var i = 1; i <= 3; i++) {
                    $('#rec_T1_' + i + '_DESCRIPCION').prop('readonly', true);
                }
                for (var i = 1; i <= 3; i++) {
                    $('#rec_T1_' + i + '_FECHA').prop('readonly', true);
                }
                for (var i = 1; i <= 3; i++) {
                    $('#rec_T1_' + i + '_DURACION').prop('readonly', true);
                }
                //TP
                $('#rec_T1_TP_CURSO').prop('readonly', true);
                $('#rec_T1_TP_MODULO').prop('readonly', true);
                $("#rec_T1_TP_OBJ_APRE_TXT").prop('readonly', true);
                $("#rec_T1_TP_CRITE_ACTIV_TXT").prop('readonly', true);
                $("#rec_T1_TP_APRE_ESP_TXT").prop('readonly', true);
                for (var i = 1; i <= 3; i++) {
                    $('#rec_T1_TP_' + i + '_OBJETIVOS').prop('readonly', true);
                }
                for (var i = 1; i <= 3; i++) {
                    $('#rec_T1_TP_' + i + '_DESCRIPCION').prop('readonly', true);
                }
                for (var i = 1; i <= 3; i++) {
                    $('#rec_T1_TP_' + i + '_FECHA').prop('readonly', true);
                }
                for (var i = 1; i <= 3; i++) {
                    $('#rec_T1_TP_' + i + '_DURACION').prop('readonly', true);
                }
            }
            if ($("#ErrorMessage").val() != "") {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html($("#ErrorMessage").val());
                $("#alert-message").dialog("open");
            }
        });

        //Guardar la Tarea 1
        function Guardar() {
            if (boInputChanged == true) {
                SaveDataViaAjax();
            } else {
                $("#info-message").dialog("option", "title", "Guardar registro");
                $("#info-message-content").html("No hay cambios pendientes de guardar.");
                $("#info-message").dialog("open");
            }
        }

        function SaveDataViaAjax() {
            methodURL = baseUrl + "Aplicaciones/Ficha/Tarea1.aspx/SaveData";
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
                                //RBORLONE 05-04-2016 Cuando se esta insertando un registro le asignamos un nuevo ID_T%.
                                $("#rec_ID_TABLA").val(Record["d"]["__ID_T1"]);
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
                    <td align="center" class="pdTitulo1">PLANIFICACIÓN
                    </td>
                    <td align="right" style="width: 20%;">
                        <img alt="Guardar" src="../../Imagenes/Images/guardar-off.jpg" onmouseover="this.src='../../Imagenes/Images/guardar-on.jpg'"
                            onmouseout="this.src='../../Imagenes/Images/guardar-off.jpg'" onclick="Guardar()" class="guardar" style="cursor:pointer" id="guardar1" runat="server"/></td>
                    <td style="width: 15px;"></td>
                </tr>
                <tr>
                    <td align="center" class="pdSubTitulo1" colspan="3"><b>Revise las instrucciones de su Manual Portafolio para desarrollar esta tarea</b>
                    </td>
                </tr>
            </table>
            <div id="divDetalle" style="width: 750px; height: 100px; border: 0px; overflow-y: auto;" runat="server">

                <%--======================= FRAMEWORK rec fields declaration =======================--%>
                <fieldset class="pdFondoT1">
                    <table id="tb_T1_ASIGNATURA" class="ui-widget" style="width: 100%; display: none;" border="0" runat="server">
                        <tr>
                            <td runat="server" style="width: 30%;" class="ui-widget">
                                <label><b><u>DEBE</u> indicar la especialidad</b></label>
                            </td>
                            <td style="width: 100%;">
                                <asp:DropDownList ID="rec_T1_ASIGNATURA_EAEMCN" runat="server" Width="20%" CssClass="ui-widget-content ui-corner-all">
                                    <asp:ListItem>Seleccione</asp:ListItem>
                                    <asp:ListItem>Biología</asp:ListItem>
                                    <asp:ListItem>Química</asp:ListItem>
                                    <asp:ListItem>Física</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" style="width: 100%;" border="0">
                        <tr>
                            <td>
                                <label>
                                    <b>a. Curso y letra:</b></label>
                            </td>
                            <td>
                                <input type="text" id="rec_T1_CURSO" runat="server" class="ui-widget-content ui-corner-all" maxlength="80" style="width: 580px;" value="" />
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>b. Objetivo Curricular en el que se basa la unidad:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T1_OBJ_CURR_TXT"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T1_OBJ_CURR_TXT" name="rec_T1_OBJ_CURR_TXT_" runat="server" class="ui-widget-content ui-corner-all" rows="10" cols="100" maxlength="2000" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                        <tr>
                            <td class="TituloPreg">
                                <label><b>c. Tablas de descripción de tres clases de la unidad:</b></label>
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" border="0">
                        <tr>
                            <td>
                                <label><b>Fecha:</b></label>
                            </td>
                            <td>
                                <input type="text" id="rec_T1_1_FECHA" runat="server" name="rec_T1_1_FECHA" style="width: 245px;" maxlength="30" class="ui-widget-content ui-corner-all" value="" />
                            </td>
                            <td>
                                <label><b>Duración de la clase:</b></label>
                            </td>
                            <td>
                                <input type="text" id="rec_T1_1_DURACION" runat="server" name="rec_T1_1_DURACION" style="width: 245px;" maxlength="30" class="ui-widget-content ui-corner-all" value="" />
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                        <tr>
                            <td>
                                <label>
                                    <b>Objetivo(s) trabajado(s) en la clase:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T1_1_OBJETIVOS"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T1_1_OBJETIVOS" name="rec_T1_1_OBJETIVOS" runat="server" class="ui-widget-content ui-corner-all" rows="5" cols="100" maxlength="500" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label><b>Descripción de la clase:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T1_1_DESCRIPCION"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T1_1_DESCRIPCION" name="rec_T1_1_DESCRIPCION" runat="server" class="ui-widget-content ui-corner-all" rows="36" cols="100" maxlength="3600" style="width: 100%; overflow-y: auto"></textarea><br />
                                <br />
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" border="0">
                        <tr>
                            <td>
                                <label><b>Fecha:</b></label>
                            </td>
                            <td>
                                <input type="text" id="rec_T1_2_FECHA" runat="server" name="rec_T1_2_FECHA" style="width: 245px;" maxlength="30" class="ui-widget-content ui-corner-all" value="" />
                            </td>
                            <td>
                                <label style="display: inline;"><b>Duración de la clase:</b></label>
                            </td>
                            <td>
                                <input type="text" id="rec_T1_2_DURACION" runat="server" name="rec_T1_2_DURACION" style="width: 245px;" maxlength="30" class="ui-widget-content ui-corner-all" />
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                        <tr>
                            <td>
                                <label><b>Objetivo(s) trabajado(s) en la clase:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T1_2_OBJETIVOS"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T1_2_OBJETIVOS" name="rec_T1_2_OBJETIVOS" runat="server" class="ui-widget-content ui-corner-all" rows="5" cols="100" maxlength="500" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label><b>Descripción de la clase:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T1_2_DESCRIPCION"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T1_2_DESCRIPCION" name="rec_T1_2_DESCRIPCION" runat="server" class="ui-widget-content ui-corner-all" rows="36" cols="100" maxlength="3600" style="width: 100%; overflow-y: auto"></textarea><br />
                                <br />
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" border="0">
                        <tr>
                            <td>
                                <label><b>Fecha:</b></label>
                            </td>
                            <td>
                                <input type="text" id="rec_T1_3_FECHA" runat="server" name="rec_T1_3_FECHA" style="width: 245px;" maxlength="30" class="ui-widget-content ui-corner-all" value="" />
                            </td>
                            <td>
                                <label><b>Duración de la clase:</b></label>
                            </td>
                            <td>
                                <input type="text" id="rec_T1_3_DURACION" runat="server" name="rec_T1_3_DURACION" style="width: 245px;" maxlength="30" class="ui-widget-content ui-corner-all" value="" />
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                        <tr>
                            <td>
                                <label><b>Objetivo(s) trabajado(s) en la clase:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T1_3_OBJETIVOS"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T1_3_OBJETIVOS" name="rec_T1_3_OBJETIVOS" runat="server" class="ui-widget-content ui-corner-all" rows="5" cols="100" maxlength="500" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label><b>Descripción de la clase:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T1_3_DESCRIPCION"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T1_3_DESCRIPCION" name="rec_T1_3_DESCRIPCION" runat="server" class="ui-widget-content ui-corner-all" rows="36" cols="100" maxlength="3600" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                    </table>
                </fieldset>
                <table style="width: 100%;" border="0">
                    <tr>
                        <td align="right">
                            <img alt="Guardar" src="../../Imagenes/Images/guardar-off.jpg" onmouseover="this.src='../../Imagenes/Images/guardar-on.jpg'"
                                onmouseout="this.src='../../Imagenes/Images/guardar-off.jpg'" onclick="Guardar()" class="guardar" style="cursor:pointer"/></td>
                    </tr>
                </table>
                <%--======================= Fin FRAMEWORK rec fields declaration ======================= --%>
            </div>
            <div id="divDetalleTP" style="width: 750px; height: 100px; border: 0px; overflow-y: auto;" runat="server">

                <%--======================= FRAMEWORK rec fields declaration =======================--%>
                <fieldset class="pdFondoT1">
                    <table class="ui-widget" style="width: 100%;" border="0">
                        <tr>
                            <td>
                                <label>
                                    <b>a. Curso y letra:</b></label>
                            </td>
                            <td>
                                <input type="text" id="rec_T1_TP_CURSO" runat="server" class="ui-widget-content ui-corner-all" maxlength="80" style="width: 580px;" value="" />
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" style="width: 100%;" border="0">
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>b. Módulo de la especialidad al que pertenecen las actividades:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T1_TP_MODULO"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <input type="text" id="rec_T1_TP_MODULO" runat="server" class="ui-widget-content ui-corner-all" maxlength="200" style="width: 700px;" value="" />
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>c. Objetivo de aprendizaje con el que se relacionan las actividades:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T1_TP_OBJ_APRE"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T1_TP_OBJ_APRE_TXT" name="rec_T1_TP_OBJ_APRE_TXT" runat="server" class="ui-widget-content ui-corner-all" rows="10" cols="100" maxlength="2000" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>d. Aprendizaje esperado:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T1_TP_APRE_ESP"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T1_TP_APRE_ESP_TXT" name="rec_T1_TP_APRE_ESP_TXT" runat="server" class="ui-widget-content ui-corner-all" rows="10" cols="100" maxlength="1000" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>e. Criterio(s) de evaluación:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T1_TP_CRITE_ACTIV"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T1_TP_CRITE_ACTIV_TXT" name="rec_T1_TP_CRITE_ACTIV_TXT" runat="server" class="ui-widget-content ui-corner-all" rows="10" cols="100" maxlength="1000" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                        <tr>
                            <td class="TituloPreg">
                                <label><b>f. Tablas de descripción de actividades:</b></label>
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" border="0">
                        <tr>
                            <td>
                                <label><b>Fecha:</b></label>
                            </td>
                            <td>
                                <input type="text" id="rec_T1_TP_1_FECHA" runat="server" name="rec_T1_TP_1_FECHA" style="width: 245px;" maxlength="30" class="ui-widget-content ui-corner-all" value="" />
                            </td>
                            <td align="right">
                                <label><b>Duración de la actividad:</b></label>
                            </td>
                            <td>
                                <input type="text" id="rec_T1_TP_1_DURACION" runat="server" name="rec_T1_TP_1_DURACION" style="width: 245px;" maxlength="30" class="ui-widget-content ui-corner-all" value="" />
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                        <tr>
                            <td>
                                <label>
                                    <b>Objetivo(s) que se propuso lograr con la actividad:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T1_TP_1_OBJETIVOS"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T1_TP_1_OBJETIVOS" name="rec_T1_TP_1_OBJETIVOS" runat="server" class="ui-widget-content ui-corner-all" rows="5" cols="100" maxlength="500" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label><b>Descripción de la actividad:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T1_TP_1_DESCRIPCION"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T1_TP_1_DESCRIPCION" name="rec_T1_TP_1_DESCRIPCION" runat="server" class="ui-widget-content ui-corner-all" rows="36" cols="100" maxlength="3600" style="width: 100%; overflow-y: auto"></textarea><br />
                                <br />
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" border="0">
                        <tr>
                            <td>
                                <label><b>Fecha:</b></label>
                            </td>
                            <td>
                                <input type="text" id="rec_T1_TP_2_FECHA" runat="server" name="rec_T1_TP_2_FECHA" style="width: 245px;" maxlength="30" class="ui-widget-content ui-corner-all" value="" />
                            </td>
                            <td align="right">
                                <label style="display: inline;"><b>Duración de la actividad:</b></label>
                            </td>
                            <td>
                                <input type="text" id="rec_T1_TP_2_DURACION" runat="server" name="rec_T1_TP_2_DURACION" style="width: 245px;" maxlength="30" class="ui-widget-content ui-corner-all" />
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                        <tr>
                            <td>
                                <label><b>Objetivo(s) que se propuso lograr con la actividad:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T1_TP_2_OBJETIVOS"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T1_TP_2_OBJETIVOS" name="rec_T1_TP_2_OBJETIVOS" runat="server" class="ui-widget-content ui-corner-all" rows="5" cols="100" maxlength="500" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label><b>Descripción de la actividad:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T1_TP_2_DESCRIPCION"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T1_TP_2_DESCRIPCION" name="rec_T1_TP_2_DESCRIPCION" runat="server" class="ui-widget-content ui-corner-all" rows="36" cols="100" maxlength="3600" style="width: 100%; overflow-y: auto"></textarea><br />
                                <br />
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" border="0">
                        <tr>
                            <td>
                                <label><b>Fecha:</b></label>
                            </td>
                            <td>
                                <input type="text" id="rec_T1_TP_3_FECHA" runat="server" name="rec_T1_TP_3_FECHA" style="width: 245px;" maxlength="30" class="ui-widget-content ui-corner-all" value="" />
                            </td>
                            <td align="right">
                                <label><b>Duración de la actividad:</b></label>
                            </td>
                            <td>
                                <input type="text" id="rec_T1_TP_3_DURACION" runat="server" name="rec_T1_TP_3_DURACION" style="width: 245px;" maxlength="30" class="ui-widget-content ui-corner-all" value="" />
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                        <tr>
                            <td>
                                <label><b>Objetivo(s) que se propuso lograr con la actividad:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T1_TP_3_OBJETIVOS"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T1_TP_3_OBJETIVOS" name="rec_T1_TP_3_OBJETIVOS" runat="server" class="ui-widget-content ui-corner-all" rows="5" cols="100" maxlength="500" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label><b>Descripción de la actividad:</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T1_TP_3_DESCRIPCION"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T1_TP_3_DESCRIPCION" name="rec_T1_TP_3_DESCRIPCION" runat="server" class="ui-widget-content ui-corner-all" rows="36" cols="100" maxlength="3600" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                    </table>
                </fieldset>
                <table style="width: 100%;" border="0">
                    <tr>
                        <td align="right">
                            <img alt="Guardar" src="../../Imagenes/Images/guardar-off.jpg" onmouseover="this.src='../../Imagenes/Images/guardar-on.jpg'"
                                onmouseout="this.src='../../Imagenes/Images/guardar-off.jpg'" onclick="Guardar()" class="guardar" style="cursor:pointer" id="guardar2" runat="server"/></td>
                    </tr>
                </table>
                <%--======================= Fin FRAMEWORK rec fields declaration ======================= --%>
            </div>
        </div>
        <input type="hidden" id="rec_ID_PERIODO" runat="server" />
        <input type="hidden" id="rec_RUT_DOCENTE" runat="server" />
        <input type="hidden" id="rec_ID_EVALUACION" runat="server" />
        <input type="hidden" id="boRegistryMode" runat="server" value="new" />
        <input type="hidden" id="ErrorMessage" runat="server" value="" />
        <input type="hidden" id="MyRowstamp" name="MyRowstamp" runat="server" />
        <span id="msgSaved"></span>
    </form>

    <input type="hidden" id="DesEsp" name="DesEsp" value="" runat="server" />
    <input type="hidden" id="DesEspWidth" name="DesEspWidth" value="800" runat="server" />
    <input type="hidden" id="DesEspHeight" name="DesEspHeight" value="800" runat="server" />
    <input type="hidden" id="rec_NOMBRE_TABLA" name="rec_NOMBRE_TABLA" value="T1" runat="server" />
    <input type="hidden" id="rec_ID_TABLA" name="rec_ID_TABLA" value="" runat="server" />
    <input type="hidden" id="acceso" name="acceso" value="V" runat="server" />
    <input type="hidden" id="Cod_Subsector" name="Cod_Subsector" runat="server" />
    <input type="hidden" id="Cod_Nivel" name="Cod_Nivel" runat="server" />
</body>
</html>
