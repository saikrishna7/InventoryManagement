<%@ Page Language="C#" %>
<%@ Import Namespace="System.DirectoryServices" %>
<%@ Import Namespace="System.Data" %>
<%--<%@ Assembly Src="DatabaseStoredProcedure.cs" %>--%>
<!doctype HTML>
<html class="no-js" lang="en">
<head id="apps-business-missouri-edu" data-template-set="html5-reset">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	    <meta charset="utf-8" />
	    <meta name="title" content="Inventory" />
	    <meta name="description" content="Inventory" />
	    <meta name="Copyright" content="Copyright 2015 Curators of the University of Missouri. All Rights Reserved." />
	    <meta name="DC.title" content="Inventory" />
	    <title>Inventory Management App</title>
    <link rel="stylesheet" type="text/css" href="//apps.business.missouri.edu/css/base-1.1.css" />
        <script type="text/javascript" src="//code.jquery.com/jquery-1.10.2.min.js"></script>TCOBInventoryDBEntities        <script type="text/javascript" src="//code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
    <link rel="stylesheet" type="text/css" href="//code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css">
        <script type="text/javascript">
            $(document).ready(function () {

                document.title = "Inventory - Summary"
                $('html').ajaxStart(function () {
                    $(this).css({ 'cursor': 'wait' })
                }).ajaxStop(function () {
                    $(this).css({ 'cursor': 'default' })
                });
                var data = {};
                var Index = {};
                var strMirror = {};
                function buildSearchIndex() {
                    $('.data-row').each(function (index, element) {
                        Index[element.id] = element;
                        strMirror[element.id] = ' ';
                        for (var child in element.children) {
                            if (element.children[child].innerHTML) strMirror[element.id] += element.children[child].innerHTML + ' ';
                        }
                        strMirror[element.id].toLowerCase();
                    });
                }
                function search(searchFor) {
                    var quoted = searchFor.match(/"(.|\s)*?"/g);
                    if (searchFor) searchFor = searchFor.replace(/"(.|\s)*?"/g, '');
                    var searchKeys = searchFor.split(' ');
                    searchKeys = (searchKeys == '' ? quoted : searchKeys.concat(quoted));
                    if (searchKeys) searchKeys = searchKeys.map(function (el) { return (el ? el.replace(/"/g, '') : '') });
                    console.log(searchKeys, searchFor, quoted);
                    for (var element in Index) {
                        var match = true;
                        for (var i in searchKeys) {
                            if (strMirror[element].toLowerCase().indexOf(searchKeys[i].toLowerCase()) < 0) match = false;
                        }
                        if (match) {
                            Index[element].hidden = false;
                        } else {
                            Index[element].hidden = true;
                        }
                    }

                }
                function searchCallback(e) {
                    $('body').addClass('wait');
                    search($('#txtSearch').val());
                    $('body').removeClass('wait');
                    e.preventDefault();
                }

                buildSearchIndex();
                $('#txtSearch').keypress(function (e) { if (e.which == 13) searchCallback(e); });
            });
        </script>
        <script runat="server">

            String[] TableHeaders = {
                                      "Serial"
                                      ,"Type"
                                      ,"Make"
                                      ,"Model"
                                      ,"User"
                                      ,"Pawprint"
                                      ,"Category"
                                      ,"Dept"
                                      ,"Location"
                                      ,"Owner"
                                      ,"Purchased"
                                      ,"AuxDate"};
            String[] DataTableHeaders = {
                                      "SerialNumber"
                                      ,"Type"
                                      ,"Make"
                                      ,"Model"
                                      ,"UserPawprint"
                                      ,"User"
                                      ,"Category"
                                      ,"Department"
                                      ,"Room"
                                      ,"OwnedBy"
                                      ,"PurchaseDate"
                                      ,"AuxComputerDate"};

            void GenerateTableHeader(String[] headers, ref HtmlTable table)
            {
                var headerRow = new HtmlTableRow();
                foreach (var str in headers) {
                    var header = new HtmlTableCell("th");
                    header.InnerText = str;
                    headerRow.Cells.Add(header);
                }
                table.Rows.Add(headerRow);
            }

            bool check_is_header(String str)
            {
                foreach (var i in DataTableHeaders) {
                    if (i == str) return true;
                }
                return false;
            }

            void GenerateTableRowsFromSp(String procedure, ref HtmlTable table)
            {
                var storedProcedure = new inventory.DatabaseStoredProcedure(procedure);
                var query = storedProcedure.ExecuteReader();

                for (var i = 0; i<query.Rows.Count; i++)
                {

                    var row = query.Rows[i];
                    var htmlRow = new HtmlTableRow();
                    htmlRow.ID = i.ToString();
                    htmlRow.Attributes.Add("class", "data-row");
                    foreach (var col in query.Columns )
                    {

                        var field = col.ToString();
                        if (!check_is_header(field)) continue;
                        var tableCell = new HtmlTableCell("td");
                        var content = row[field].ToString();
                        // TODO: BUG - from previous version
                        //if (query.Columns.IndexOf(field) > row.ItemArray.Count() - 6 && content.Length > 0) content = content.Substring(0, content.IndexOf(" ")) ;
                        var innerHtml = "<a href='update.aspx?id="+row.ItemArray[0]+"'><div>" + content  + "</div></a>";
                        tableCell.InnerHtml = innerHtml;
                        htmlRow.Cells.Add(tableCell);
                    }
                    table.Rows.Add(htmlRow);
                }
            }
            public void Page_Load(object sender, EventArgs e)
            {
                Context.Session.Add("Request URI", "Summary.aspx");
                //var logged_in = Context.Session["DomainUser"];
                //if (!(logged_in != null && (bool)logged_in == true)) Response.Redirect("Login.aspx");

                GenerateTableHeader(TableHeaders, ref informationTable);
                GenerateTableRowsFromSp("[dbo].[sp_Inventory_GetRecords]", ref informationTable);
            }
        </script>
    <style>
        #page {
            width: 1500px;
        }
        #content {
            font-size: 90%;
        }
        #content table {
            table-layout:fixed;
            padding: 6px;
        }
        #content td {
            padding: 0px;
            
        }
        #content td div {
            width: 100%;
            height: 60px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .data-row:nth-child(2n+1) {
            background-color: rgb(250,250,250);
        }
        #content tbody tr:hover {
            background: #d3d3d3;
        }
        #content td a {
            text-decoration: none;
        }
        #content td a:link {
            color: #000;
        }
        #add button {
            margin-bottom: 10px;
        }

    </style>
  
</head>



<body id ="page">
    <div id="header">
        <div id="app-title">
        Inventory Management
    </div>
    </div>
   
    <div id="content" style = "width:1500px">
       
        <div>
        <a href="Add.aspx" id="add"><button>New Inventory</button></a>
        <a href="InventoryValidation.aspx" id="btnInventoryValidation"><button>Inventory Validation</button></a>
        <input type="text" runat="server" id="txtSearch" Width="110px" placeholder="Search">
     
       </div>
        <table id="informationTable" runat="server">
                
        </table>
    </div>
        
</body>
</html>
