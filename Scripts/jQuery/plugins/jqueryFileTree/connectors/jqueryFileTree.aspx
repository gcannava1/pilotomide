<%@ Page Language="C#" AutoEventWireup="true" %>

<%
    //
    // jQuery File Tree ASP.NET Connector
    //
    // Version 1.0
    //
    // Copyright (c)2008 Andrew Sweeny
    // asweeny@fit.edu
    // 24 March 2008
    // Modified for SOLEX Framework by Allan Gubbins S.
    // October 11 2013

    string dir = "";
    //string ServerPath = "";
    string ruta = "";
    if (Request.Form["dir"] == null || Request.Form["dir"].Length <= 0)
    {
        dir = "/";
    }
    else
    {

        //ServerPath = HttpContext.Current.Request.ApplicationPath;
        dir = Server.UrlDecode(Request.Form["dir"]);
        dir = dir.Replace('/', '\\');
        ruta = AppDomain.CurrentDomain.BaseDirectory.ToString() + dir;
    }

    System.IO.DirectoryInfo di = new System.IO.DirectoryInfo(ruta);
    Response.Write("<ul class=\"jqueryFileTree\" style=\"display: none;\">\n");
    foreach (System.IO.DirectoryInfo di_child in di.GetDirectories())
        Response.Write("\t<li class=\"directory collapsed\"><a href=\"#\" rel=\"" + dir + di_child.Name + "/\">" + di_child.Name + "</a></li>\n");
        string[] extensions;
        string st_ext = Request.Form["ext"];
        extensions = st_ext.Split(',');
        
            System.IO.FileInfo[] files = di.EnumerateFiles()
             .Where(f => extensions.Contains(f.Extension.ToLower()))
             .ToArray();
             
    foreach (System.IO.FileInfo fi in files)
    {
        string ext = "";
        if (fi.Extension.Length > 1)
            ext = fi.Extension.Substring(1).ToLower();

        Response.Write("\t<li class=\"file ext_" + ext + "\"><a href=\"#\" rel=\"" + dir + fi.Name + "\">" + fi.Name + "</a></li>\n");
    }
    Response.Write("</ul>");
%>