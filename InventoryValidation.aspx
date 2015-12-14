<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System" %>
<%@ Assembly Src="DatabaseStoredProcedure.cs" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Web.UI" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="Microsoft.VisualBasic.FileIO" %>
<%@ Import Namespace="System.Windows.Forms" %>


<!DOCTYPE html>
<script runat="server">
    protected void btnUploadFile_Click(object sender, EventArgs e)
        
    {
        if (FileUploadInventoryLog.HasFile)
            try
            {
                string path = @"C:\Uploads";
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }
                FileUploadInventoryLog.SaveAs("C:\\Uploads\\" +
                     FileUploadInventoryLog.FileName);
                lblUploadFile.Text = FileUploadInventoryLog.PostedFile.FileName; 
                     //+ "<br>" +
                     //FileUploadInventoryLog.PostedFile.ContentLength + " kb<br>" +
                     //"Content type: " +
                     //FileUploadInventoryLog.PostedFile.ContentType;
                
            }
            catch (Exception ex)
            {
                lblUploadFile.Text = "ERROR: " + ex.Message.ToString();
            }
        else
        {
            lblUploadFile.Text = "You have not specified a file.";
        }
    }


protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                lblInformationTable.Visible = true;

                GenerateTableHeader(TableHeaders, ref informationTable);
                GenerateTableRowsFromSp1("[dbo].[sp_TempTable_GetRecords_New]", ref informationTable);

                lblTableWithMismatchRecords.Visible = true;
                GenerateTableHeader(TableHeaders, ref TableWithMismatchRecords);
                GenerateTableRowsFromSp("[dbo].[sp_TempTable_GetRecords_Mismatch]", ref TableWithMismatchRecords);
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {


        }

        protected void Button2_Click(object sender, EventArgs e)
        {

        }

        String[] TableHeaders = {
                                      "SerialNumber"
                                      ,"Make"
                                      ,"Model"
                                      ,"ComputerName"
                                      ,"RecordStatus"
                                      };

        String[] DataTableHeaders = {
                                      "SerialNumber"
                                      ,"Make"
                                      ,"Model"
                                      ,"ComputerName"
                                      ,"RecordStatus"
                                    };

        bool check_is_header(String str)
        {
            foreach (var i in DataTableHeaders)
            {
                if (i == str) return true;
            }
            return false;
        }



        void GenerateTableHeader(String[] headers, ref System.Web.UI.HtmlControls.HtmlTable table)
        {
            var headerRow = new System.Web.UI.HtmlControls.HtmlTableRow();
            foreach (var str in headers)
            {
                var header = new System.Web.UI.HtmlControls.HtmlTableCell("th");
                header.InnerText = str;
                headerRow.Cells.Add(header);
            }
            table.Rows.Add(headerRow);
        }

        void GenerateTableRowsFromSp(String procedure, ref System.Web.UI.HtmlControls.HtmlTable table)
        {
            String Connstr = "SERVER=sql2005.iats.missouri.edu;Integrated Security = True;DATABASE=MU_BUS_TechServices_1;";
            System.Data.SqlClient.SqlConnection conn = new System.Data.SqlClient.SqlConnection(Connstr);
            conn.Open();
            System.Data.SqlClient.SqlCommand cmd2 = new System.Data.SqlClient.SqlCommand();
            cmd2.Connection = conn;
            cmd2.CommandType = System.Data.CommandType.StoredProcedure;
            cmd2.CommandText = procedure;
            System.Data.SqlClient.SqlDataReader query = cmd2.ExecuteReader();

            if (query.HasRows == true)
            {
                System.Data.DataTable dt = new System.Data.DataTable();
                dt.Load(query);

                for (var i = 0; i < dt.Rows.Count; i++)
                {

                    var row = dt.Rows[i];
                    var htmlRow = new System.Web.UI.HtmlControls.HtmlTableRow();
                    htmlRow.ID = i.ToString();
                    htmlRow.Attributes.Add("class", "data-row");
                    foreach (var col in dt.Columns)
                    {
                        var field = col.ToString();
                        if (!check_is_header(field)) continue;
                        var tableCell = new System.Web.UI.HtmlControls.HtmlTableCell("td");
                        var content = row[field].ToString();
                        //if (dt.Columns.IndexOf(field) > row.ItemArray.Count() - 6 && content.Length > 0) content = content.Substring(0, content.IndexOf(" "));


                        var innerHtml = "<a href='Edit_Record.aspx?id=" + row.ItemArray[1] + "' target='_blank'><div>" + content + "</div></a>";

                        tableCell.InnerHtml = innerHtml;
                        htmlRow.Cells.Add(tableCell);
                    }
                    table.Rows.Add(htmlRow);
                }
            }

        }

        void GenerateTableRowsFromSp1(String procedure, ref System.Web.UI.HtmlControls.HtmlTable table)
        {
            String Connstr = "SERVER=sql2005.iats.missouri.edu;Integrated Security = True;DATABASE=MU_BUS_TechServices_1;";
            System.Data.SqlClient.SqlConnection conn = new System.Data.SqlClient.SqlConnection(Connstr);
            conn.Open();
            System.Data.SqlClient.SqlCommand cmd2 = new System.Data.SqlClient.SqlCommand();
            cmd2.Connection = conn;
            cmd2.CommandType = System.Data.CommandType.StoredProcedure;
            cmd2.CommandText = procedure;
            System.Data.SqlClient.SqlDataReader query = cmd2.ExecuteReader();

            if (query.HasRows == true)
            {
                System.Data.DataTable dt = new System.Data.DataTable();
                dt.Load(query);

                for (var i = 0; i < dt.Rows.Count; i++)
                {

                    var row = dt.Rows[i];
                    var htmlRow = new System.Web.UI.HtmlControls.HtmlTableRow();
                    htmlRow.ID = i.ToString();
                    htmlRow.Attributes.Add("class", "data-row");
                    foreach (var col in dt.Columns)
                    {
                        var field = col.ToString();
                        if (!check_is_header(field)) continue;
                        var tableCell = new System.Web.UI.HtmlControls.HtmlTableCell("td");
                        var content = row[field].ToString();
                        //if (dt.Columns.IndexOf(field) > row.ItemArray.Count() - 6 && content.Length > 0) content = content.Substring(0, content.IndexOf(" "));


                        var innerHtml = "<a href='AddFromLog.aspx?id=" + row.ItemArray[1] + "' target='_blank'><div>" + content + "</div></a>";

                        tableCell.InnerHtml = innerHtml;
                        htmlRow.Cells.Add(tableCell);
                    }
                    table.Rows.Add(htmlRow);
                }
            }
        }


        protected void btnRun_Click(object sender, EventArgs e)
        {
            try
            {
                

                using (TextFieldParser parser = new TextFieldParser("C:\\Uploads\\" + lblUploadFile.Text))
                //string file = "C:\\Uploads\\" + FileUploadInventoryLog.PostedFile.FileName;
                //MessageBox.Show("C:\\Uploads\\" + lblUploadFile.Text);
                //using (TextFieldParser parser = new TextFieldParser(file)
                {

                    //Delete data from the temp table when a new csv file is loaded
                    String Connstr = "SERVER=sql2005.iats.missouri.edu;Integrated Security = True;DATABASE=MU_BUS_TechServices_1;";
                    System.Data.SqlClient.SqlConnection conn = new System.Data.SqlClient.SqlConnection(Connstr);
                    conn.Open();
                    System.Data.SqlClient.SqlCommand cmd2 = new System.Data.SqlClient.SqlCommand();
                    cmd2.Connection = conn;
                    cmd2.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd2.CommandText = "[dbo].[sp_Inventory_DeleteTempTableData]";
                    cmd2.ExecuteScalar();

                    //read the log csv file
                    parser.Delimiters = new string[] { "," };
                    while (true)
                    {
                        string[] parts = parser.ReadFields();
                        if (parts == null)
                        {
                            break;
                        }
                        //System.Diagnostics.Debug.WriteLine("{0},{1}", parts[0], parts[1], parts[2]); break;

                        if (parts[0] != "SerialNumber")
                        {

                            //storing every column value from the csv to a variable to use later for comparison

                            string serialnum = parts[0];
                            string make = parts[1];
                            string model = parts[2];
                            string ComputerName = parts[3];
                            string type = parts[4];
                            string category = parts[5];
                            string user = parts[6];
                            string userPawprint = parts[7];
                            string department = parts[8];
                            string room = parts[9];
                            string roomLetter = parts[10];
                            string building = parts[11];
                            string note = parts[12];
                            string ownedBy = parts[13];
                            string purchaseDate = parts[14];
                            string auxComputerDate = parts[15];


                            //compare the records with the original Inventory database
                            System.Data.SqlClient.SqlCommand command = new System.Data.SqlClient.SqlCommand();
                            command.Connection = conn;
                            command.CommandType = System.Data.CommandType.StoredProcedure;
                            command.Parameters.AddWithValue("@SerialNum", serialnum);
                            command.CommandText = "[dbo].[sp_Inventory_GetInventoryData]";

                            System.Data.SqlClient.SqlDataReader reader1 = command.ExecuteReader();
                            if (reader1.HasRows == true)
                            {


                                System.Data.DataTable dt = new System.Data.DataTable();
                                dt.Load(reader1);
                                int flag = 0;

                                //comapre each column of the record in the csv with the columns of the record from the database. if different, insert that into the temp table
                                for (int j = 0; j < 4; j++)
                                {
                                    string valuefromdb = dt.Rows[0][j].ToString();
                                    string valuefromreader = parts[j].ToString();
                                    if (valuefromdb != valuefromreader)
                                    {
                                        //MessageBox.Show("difference of value for testid" + testid.ToString());
                                        flag = 1;
                                        string recordstatus = "Mismatch found";
                                        System.Data.SqlClient.SqlCommand cmd1 = new System.Data.SqlClient.SqlCommand();
                                        cmd1.Connection = conn;
                                        cmd1.CommandType = System.Data.CommandType.StoredProcedure;
                                        cmd1.CommandText = "[dbo].[sp_Inventory_AddTempTable]";
                                        cmd1.Parameters.AddWithValue("@SerialNumber", serialnum);
                                        cmd1.Parameters.AddWithValue("@Make", make);
                                        cmd1.Parameters.AddWithValue("@Model", model);
                                        cmd1.Parameters.AddWithValue("@ComputerName", ComputerName);
                                        cmd1.Parameters.AddWithValue("@RecordStatus", recordstatus);
                                        cmd1.Parameters.AddWithValue("@Type", type);
                                        cmd1.Parameters.AddWithValue("@Category", category);
                                        cmd1.Parameters.AddWithValue("@User", user);
                                        cmd1.Parameters.AddWithValue("@UserPawprint", userPawprint);
                                        cmd1.Parameters.AddWithValue("@Department", department);
                                        cmd1.Parameters.AddWithValue("@Room", room);
                                        cmd1.Parameters.AddWithValue("@Letter", roomLetter);
                                        cmd1.Parameters.AddWithValue("@Building", building);
                                        cmd1.Parameters.AddWithValue("@Note", note);
                                        cmd1.Parameters.AddWithValue("@OwnedBy", ownedBy);
                                        cmd1.Parameters.AddWithValue("@PurchaseDate", purchaseDate);
                                        cmd1.Parameters.AddWithValue("@AuxComputerDate", auxComputerDate);
                                        cmd1.ExecuteScalar();
                                        break;
                                    }

                                }

                                //update LastVerified to the current date to indicate that the record was verified on that date
                                if (flag == 0)
                                {
                                    System.Data.SqlClient.SqlCommand com3 = new System.Data.SqlClient.SqlCommand();
                                    com3.Connection = conn;
                                    com3.CommandType = System.Data.CommandType.Text;

                                    com3.CommandText = "update [MU_BUS_Techservices_1].[dbo].[ComputerInventory] set LastVerified = SYSDATETIME() where SerialNumber = '" + serialnum + "'";
                                    com3.ExecuteScalar();
                                }


                                //reader1.Close();   
                            }

                                //if the record has no entry in the original database, move it to the temp table
                            else
                            {
                                reader1.Close();
                                //MessageBox.Show("There is no row with the id " + testid.ToString());
                                string recstatus = "New Record";
                                System.Data.SqlClient.SqlCommand cmd1 = new System.Data.SqlClient.SqlCommand();
                                cmd1.Connection = conn;
                                cmd1.CommandType = System.Data.CommandType.StoredProcedure;

                                cmd1.CommandText = "[dbo].[sp_Inventory_AddTempTable]";
                                cmd1.Parameters.AddWithValue("@SerialNumber", serialnum);
                                cmd1.Parameters.AddWithValue("@Make", make);
                                cmd1.Parameters.AddWithValue("@Model", model);
                                cmd1.Parameters.AddWithValue("@ComputerName", ComputerName);
                                cmd1.Parameters.AddWithValue("@RecordStatus", recstatus);
                                cmd1.ExecuteScalar();


                            }
                        }
                    }
                    //Response.Redirect("Summary_TestData.aspx");

                    lblInformationTable.Visible = true;

                    GenerateTableHeader(TableHeaders, ref informationTable);
                    GenerateTableRowsFromSp1("[dbo].[sp_TempTable_GetRecords_New]", ref informationTable);

                    lblTableWithMismatchRecords.Visible = true;
                    GenerateTableHeader(TableHeaders, ref TableWithMismatchRecords);
                    GenerateTableRowsFromSp("[dbo].[sp_TempTable_GetRecords_Mismatch]", ref TableWithMismatchRecords);
                }
            }
            catch (AggregateException ae)
            {
                Response.Write("Please upload the latest file");
            }


        }
   
    
    
</script>



<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
       <style>
        #page {
            width: 1200px;
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
    
<link rel="stylesheet" type="text/css" href="//apps.business.missouri.edu/css/base-1.1.css" />
<link rel="stylesheet" type="text/css" href="//code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css">

</head>
<body>

    <a href="Summary.aspx"><div id="header">
        <div id="app-title">
            Inventory Management
        </div>
    </div></a>

       
       <div id="content">
               <form id="form1" runat="server">
        <div>
        <asp:FileUpload ID="FileUploadInventoryLog" runat="server" /><br />
        <br />
        <asp:Button ID="btnUploadFile" runat="server" OnClick="btnUploadFile_Click" 
         Text="Upload File" /><br />
        <br />
        <asp:Label ID="lblUploadFile" runat="server"></asp:Label></div>

        <br />
        <div>
            <asp:Button ID="btnRun" runat ="server" OnClick="btnRun_Click" Text ="Process Inventory"/>
        </div>
        <br />
        <br />
        <div>
             <asp:Label runat="server" ID="lblInformationTable" Visible="False" > New Records </asp:Label>
        </div>

        <table id="informationTable" runat="server"  >
                
        </table>
        <br />
        <br />
        <div>
             <asp:Label runat="server" ID="lblTableWithMismatchRecords" Visible="False" > Mismatched Records </asp:Label>
        </div>
        <table id="TableWithMismatchRecords" runat="server" >
                
        </table>
    </form>
       </div>

</body>
</html>

