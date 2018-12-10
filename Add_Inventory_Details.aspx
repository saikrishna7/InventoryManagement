<%@ Page Language="C#" AutoEventWireup="True" CodeBehind="Add_Inventory_Details.aspx.cs" Inherits="Inventory_DB.WebForm1" %>
<%@ Import Namespace="System.DirectoryServices" %>

<%--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">--%>

<%--<html xmlns="http://www.w3.org/1999/xhtml">--%>
<%--<head runat="server">
    <title></title>
</head>--%>--%>
<%--<body>
    <form id="form1" runat="server">
    <div id = "login-form">

        <asp:label runat="server" id = "lblUserName" >USERNAME</asp:label><br />
        <asp:TextBox runat ="server" id = "txtUserName" ></asp:TextBox><br /><br />
        <asp:label runat="server" id = "lblPassword" >PASSWORD</asp:label><br />
        <asp:TextBox runat ="server" id = "txtPassword" TextMode="Password"></asp:TextBox><br /><br />
        <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ErrorMessage="Please enter your password" ControlToValidate="txtPassword" CssClass="error" ForeColor="" ValidationGroup="Submit"></asp:RequiredFieldValidator>
         <br />
        <asp:Button runat = "server" id = "btnLogin" Text="LOGIN" onclick = "Login_Click" />

        <asp:Label runat = "server" id = "errorLabel" ></asp:Label>

    </div> 
    </form>


</body>
</html>
--%>
<html class="no-js" lang="en">
	<head id="apps-business-missouri-edu" data-template-set="html5-reset">
    
	    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	    <meta charset="utf-8" />
	    <meta name="title" content="Inventory" />
	    <meta name="description" content="Inventory" />
	    <meta name="Copyright" content="Copyright 2013 Curators of the University of Missouri. All Rights Reserved." />
	    <meta name="DC.title" content="Inventory" />
	    <title>Inventory Management App</title>
        <%--<link rel="shortcut icon" href="./resources/images/favicon.ico" />--%>
       

	    <link rel="stylesheet" type="text/css" href="Styles/base.css" />
        <script type="text/javascript" src="http://code.jquery.com/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>

        <link rel="stylesheet" type="text/css" href="//code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css">

        <script runat="server">
            public string[] myarray = new string[40];
            public string myarray_json;
            private static string Connectionstring = System.Configuration.ConfigurationManager.ConnectionStrings["TCOBInventoryDBEntities"].ConnectionString;

            protected void Page_Load(object sender, EventArgs e)
            {

                //myarray[0] = "faculty";
                //myarray[1] = "student";


                //String Connstr = "SERVER=sql2005.iats.missouri.edu;Integrated Security = True;DATABASE=MU_BUS_TechServices_1;";
                System.Data.SqlClient.SqlConnection conn = new System.Data.SqlClient.SqlConnection(Connectionstring);
                conn.Open();

                System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand();
                cmd.Connection = conn;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.CommandText = "Get_DepartmentNames";

                System.Data.SqlClient.SqlDataReader reader = cmd.ExecuteReader();

                if (reader.HasRows == true)
                {
                    int i = 0;
                    while (reader.Read())
                    {

                        myarray[i] = reader["Dept"].ToString();
                        i++;
                    }


                }


                var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                myarray_json = serializer.Serialize(myarray);

            }


    </script>

            <script type="text/javascript">
                $(document).ready(function () {
                    ///with jquery, there is a jquery function object represented by $
                    //everything you pass to it becomes a jquery object with events and functions
                    //to make things more convenient
                    //here, I am using $(document).ready to wait until the document has loaded to execute my JS

                    $(".date").datepicker();

                    $("#department").autocomplete({
                        delay: 5, //how long it takes to display the list
                        source: <%= myarray_json %>,
                        minLength: 0, //begin suggesting completions when the field is empty
                        autoFocus: true//automatically populate the box with the current suggestion
                    });

                })
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            ///with jquery, there is a jquery function object represented by $
            //everything you pass to it becomes a jquery object with events and functions
            //to make things more convenient
            //here, I am using $(document).ready to wait until the document has loaded to execute my JS

            $(".date").datepicker();

            $("#type").autocomplete({
                delay: 5, //how long it takes to display the list
                source: [//an array of departments
        	"Camera"
            , "Copier"
            , "Desktop"
            , "Fax"
            , "Laptop"
            , "Monitor"
            , "PDA"
            , "Printer"
            , "Scanner"
            , "Wireless Microphone"
            , "Projector"
            , "Tablet"
            , "Wireless Audio Receiver"
            , "Document Camera"
            , "Apple TV"
            , "iMac"
            , "Cell Phone"
            , "Conference Phone"
        	],
                minLength: 0, //begin suggesting completions when the field is empty
                autoFocus: true//automatically populate the box with the current suggestion
            });

        })
    </script>

    <script type="text/javascript">
        $(document).ready(function () {
            ///with jquery, there is a jquery function object represented by $
            //everything you pass to it becomes a jquery object with events and functions
            //to make things more convenient
            //here, I am using $(document).ready to wait until the document has loaded to execute my JS

//            $(".date").datepicker();

            $("#make").autocomplete({
                delay: 5, //how long it takes to display the list
                source: [//an array of departments
        	"3M"
            , "Apple"
            , "Brother"
            , "Canon"
            , "Dell"
            , "Gateway"
            , "Homemade"
            , "HP"
            , "IBM"
            , "Nikon"
            , "Palm"
            , "Panasonic"
            , "Dell Inc."
            , "Sony"
            , "Xtag"
            , "Sympodium"
            , "Entuitive Touch"
            , "Microtech"
            , "Epson"
            , "Flip Ultra HD"
            , "Samsung"
            , "Motorola"
            , "Mipro"
            , "Lenovo"
            , "Flip"
            , "Ken-a-Vision"
            , "InFocus"
            , "Polycom"
            , "Microsoft"
        	],
                minLength: 0, //begin suggesting completions when the field is empty
                autoFocus: true//automatically populate the box with the current suggestion
            });

        })
    </script>

        <script type="text/javascript">
            $(document).ready(function () {
                ///with jquery, there is a jquery function object represented by $
                //everything you pass to it becomes a jquery object with events and functions
                //to make things more convenient
                //here, I am using $(document).ready to wait until the document has loaded to execute my JS

                $(".date").datepicker();

                $("#status").autocomplete({
                    delay: 5, //how long it takes to display the list
                    source: [//an array of departments
        	"Faculty"
            , "Staff"
            , "Department"
            , "GA/RA/TA"   
            , "PhD"
            , "Other"
           
        	],
                    minLength: 0, //begin suggesting completions when the field is empty
                    autoFocus: true//automatically populate the box with the current suggestion
                });

            })
    </script>

     <script type="text/javascript">
         $(document).ready(function () {
             ///with jquery, there is a jquery function object represented by $
             //everything you pass to it becomes a jquery object with events and functions
             //to make things more convenient
             //here, I am using $(document).ready to wait until the document has loaded to execute my JS

             $(".date").datepicker();

             $("#ownedby").autocomplete({
                 delay: 5, //how long it takes to display the list
                 source: [//an array of departments
        	"Acct"
            , "Advising"
            , "AERI"
            , "BCS"
            , "Dean"
            , "Desktop Enhancement"
            , "Development"
            , "execMBA"
            , "Finance"
            , "Fiscal"
            , "FRI"
            , "Grad Dean"
            , "GSO"
            , "ISS"
            , "ITF"
            , "Management"
            , "Marketing"
            , "MTI"
            , "PDP"
            , "Ponder"
            , "Study Abroad"
            , "TS"
            , "UG Dean"
        	],
                 minLength: 0, //begin suggesting completions when the field is empty
                 autoFocus: true//automatically populate the box with the current suggestion
             });

         })
    </script>

        <script type="text/javascript">
            $(document).ready(function () {
                ///with jquery, there is a jquery function object represented by $
                //everything you pass to it becomes a jquery object with events and functions
                //to make things more convenient
                //here, I am using $(document).ready to wait until the document has loaded to execute my JS

                $(".date").datepicker();

                $("#alphabet").autocomplete({
                    delay: 5, //how long it takes to display the list
                    source: [//an array of departments
               "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
                    ],
                    minLength: 0, //begin suggesting completions when the field is empty
                    autoFocus: true//automatically populate the box with the current suggestion
                });

            })
    </script>

        <script type="text/javascript">
            $(document).ready(function () {
                ///with jquery, there is a jquery function object represented by $
                //everything you pass to it becomes a jquery object with events and functions
                //to make things more convenient
                //here, I am using $(document).ready to wait until the document has loaded to execute my JS

                $(".date").datepicker();

                $("#building").autocomplete({
                    delay: 5, //how long it takes to display the list
                    source: [//an array of departments
                        "Cornell Hall","New Building"
                    ],
                    minLength: 0, //begin suggesting completions when the field is empty
                    autoFocus: true//automatically populate the box with the current suggestion
                });

            })
    </script>

	</head>
	<body id="page">
		<div id="header"><img src="http://apps.business.missouri.edu/ts/inventory/img/header.png" alt="Tech Tips - Technology Services - MU Trulaske College of Business" /></div>
            <div id="app-title">
            Inventory Management
            <span></span>
            </div>
      
        <div id="content">
            <form id="form2" runat="server">
                <div id = "login-form">

                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

                 <asp:Label runat="server" id = "lblSearch"> Search </asp:Label>
                 <input type ="text" style="width: 210px;height: 28px;" />

                 <br /><br />
                 
                 <asp:Label runat="server" id = "lblSerialNum"> Serial Number </asp:Label>
                 &nbsp;<asp:TextBox runat="server" id = "txtSerialNum" Height="27px" Width="634px"></asp:TextBox> <br /><br />
                 
                 <asp:Label runat="server" id="lblType" > Type </asp:Label>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                 <input id="type" type="text" style="width: 634px;height: 28px;" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                 <br /><br />
                 
            
                 <asp:Label runat = "server" id = "lblMake" > Make </asp:Label>
                 
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                <input id="make" type="text" style="width: 634px;height: 28px;"/><br /><br />

                <asp:Label runat ="server" id = "lblModel" >Model</asp:Label>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="text" style="width: 634px;height: 28px;" /> <br /><br />

                <asp:Label runat = "server" id = "lblUser" > User </asp:Label>
                   
                

                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                   
                <input type ="text" style="width: 634px;height: 28px;" />
                <br />
                <asp:label runat ="server" id = "lblStatus" >
                    <br />
                    Status </asp:label>
               

                &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <input id="status" type="text" style="width: 634px;height: 28px;" /><br /><br />

                 <asp:label runat ="server" id = "lblDepartment" > Department </asp:label>
                 

                    &nbsp;&nbsp;&nbsp;&nbsp;
                   <input id="department" type = "text" style="width: 634px;height: 28px;" />

                <asp:Label runat = "server" id ="lblLocation" ><br />
                    <br />
                    Location</asp:Label>
             

                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Label runat = "server" id ="lblRoomNumber" >Room No.</asp:Label>
                <input id="roomNumber" type ="text" style="width: 45px; height: 28px;" />&nbsp;&nbsp;
                    <asp:Label runat = "server" id ="lblAlphabet" >Letter</asp:Label> 
                    <input id="alphabet" type ="text" style="width: 30px; height: 28px;" />&nbsp;&nbsp; 
                    <asp:Label runat = "server" id ="lblBuilding" >Building</asp:Label>
                    <input id="building" type ="text" style="width: 101px; height: 28px;" />&nbsp;&nbsp;
                    <asp:Label runat = "server" id ="lblNote" >Note</asp:Label>
                     <input type ="text" style="width: 199px; height: 28px;" /><br /><br />
                
                 <asp:Label runat = "server" id ="lblOwnedBy" >Owned By</asp:Label>


                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                 <input id = "ownedby" type ="text" style="width: 634px;height: 28px; " /> <br /><br />


                <asp:label runat ="server" id = "lblPurchaseDate" > Purchase Date </asp:label>
                <input id="PurchaseDate" class = "date" type = "text" style="width: 634px;height: 28px;" />

                <br /><br />

                <asp:Label runat ="server" id="lblAuxComputerDate" > Aux Computer</asp:Label>
                    &nbsp;<input id="auxPurchaseDate" class ="date" type ="text" style="width: 634px;height: 28px;" />

                <br /><br />
                    <br />
                    <asp:Button ID="btnSubmit" runat="server" Height="28px" Text="Submit" 
                        Width="150px" />

                </div> 
            </form>
        </div>
        <div id="footer">&copy; Copyright 2013 Curators of the University of Missouri</div>
    </body>
</html>&nbsp;