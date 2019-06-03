<%@ Page Language="vb" AutoEventWireup="false" Inherits="PlataformaDocente.AplicacionesError" CodeBehind="Error.aspx.vb" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head" runat="server">
    <title>Plataforma Docente</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <script src="../Scripts/jQuery/jquery.min.js" type="text/javascript"></script>
    <script src="../Scripts/jQuery/jquery-ui.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/jQuery/plugins/Rut/jquery.Rut.min.js" type="text/javascript"></script>
    <script src="../Scripts/Framework/__jsCommon/jsCommon.js?v=150720151107" type="text/javascript"></script>
    <link href="../Scripts/jQuery/themes/00current/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="StyleFrameworkSolex.css" rel="stylesheet" type="text/css" />
    <link rel="SHORTCUT ICON" href="../Imagenes/favicon.ico" type="image/x-icon" />
    <link rel="ICON" href="../Imagenes/favicon.ico" type="image/ico" />
    <script type="text/javascript">
        $.fn.ready(function () {
            $(".blockArrastre").on('dragstart', function (e) { e.preventDefault(); });
        });
    </script>
</head>
<body>
    <form id="frmError" name="frmError" method="post" runat="server">
        <div>
            <table align="center" cellpadding="0" cellspacing="0" style="padding-top: 0.1em;" border="0">
                <tr>
                    <td style="width: 100px;"></td>
                    <td  align="right">
                        <img src="../Imagenes/Images/LogoGob.jpg" alt="" class="blockArrastre" /></td>
                    <td style="width: 59px;"></td>
                    <td align="center" style="width: 677px;">
                        <img src="../Imagenes/Images/encabezado.png" alt="" class="blockArrastre" />
                    </td>
                    <td>
                        <img src="../Imagenes/Images/LogoDM.png" alt="" class="blockArrastre" />
                    </td>
                    <td style="width: 100px;"></td>

                </tr>
                <tr>
                    <td colspan="6" align="center" style="background: #f6f6f6;" class="pdTitulo1">
                        <table cellpadding="0" cellspacing="0"  style="width: 618px;padding-top:20px">
                            <tr>
                                <td style="background: url('../Imagenes/images/login_sup.png')  no-repeat;height: 30px;" title="Error">
                                </td>
                            </tr>
                            <tr>
                                <td style="background: url('../Imagenes/images/login_cen.png');height: 50px;">
                                     <center><h1>Se ha Producido un error</h1></center>
                                    <center><h4>Contactese con el administrador del sistema.</h4></center>
                                </td>
                            </tr>
                            <tr>
                                <td style="background: url('../Imagenes/images/login_inf.png')  no-repeat;height: 30px;"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
<%--                <tr>
                    <td colspan="6" align="center" style="background: #f6f6f6;" class="pdTitulo1">
                        <table cellpadding="0" cellspacing="0" style="width: 618px; background: url('../Imagenes/images/login_cen.png');" border="0">
                            <tr>
                                <td align="center">
                                    <table border="0" cellpadding="3" style="width: 300px;">
                                        <tr class="ui-widget">
                                            <td style="height: 50px;"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="6" align="center" style="background: #f6f6f6;" class="pdTitulo1">
                        <table cellpadding="0" cellspacing="0" style="width: 618px; background: url('../Imagenes/images/login_cen.png');" border="0">
                            <tr class="ui-widget">
                                <td>
                                    <table align="center" border="0" cellpadding="3">
                                        <tr>
                                            <td colspan="3">Los navegadores habilitados para ingresar a la plataforma son:
                                            </td>
                                        </tr>
                                    </table>

                                </td>
                            </tr>
                        </table>
                    </td>

                </tr>

                <tr>
                    <td colspan="6" align="center" style="background: #f6f6f6;" class="pdTitulo1">
                        <table cellpadding="0" cellspacing="0" style="width: 618px; height: 10px;" border="0">
                            <tr>
                                <td style="background: url('../Imagenes/images/login_inf.png');"></td>
                            </tr>
                        </table>
                    </td>
                </tr>--%>
            </table>
        </div>
        <div class="ui-widget">

            <table style="width: 100%; height: 100%; padding: 0em;" border="0">
                <tr>
                    <td colspan="3" align="right" valign="bottom" style="height: 4em; color: white;">
                        <label id="loginVersion" runat="server">
                        </label>
                    </td>
                </tr>
            </table>
        </div>
    </form>

    <input type="hidden" id="rut_valido" name="rut_valido" runat="server" />
</body>
</html>
