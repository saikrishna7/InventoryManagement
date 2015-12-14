<%@ Page Language="C#" %>
<%@ Import Namespace="System.DirectoryServices" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Assembly Src="DatabaseStoredProcedure.cs" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<!doctype HTML>
<script runat="server">

   public int differenceitemid = 0;
   public string[] myarrayDepartment;
   public string myarray_jsonDepartment;
   public string[] myarrayCategory;
   public string myarray_jsonCategory;
   public string[] myarrayType;
   public string myarray_jsonType;
   public string[] myarrayOwnedBy;
   public string myarray_jsonOwnedBy;


    protected void Page_Load(object sender, EventArgs e)
    {
        String Connstr = "SERVER=sql2005.iats.missouri.edu;Integrated Security = True;DATABASE=MU_BUS_TechServices_1;";
        System.Data.SqlClient.SqlConnection conn = new System.Data.SqlClient.SqlConnection(Connstr);

        conn.Open();
        
        //Comment: use the serial number from the previous page where you display data from temp table
        
        string serialnum = Request.QueryString["id"];
        
        System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand();
        cmd.Connection = conn;
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.CommandText = "[dbo].[sp_Inventory_GetRecordTemp]";
        cmd.Parameters.AddWithValue("@SerialNum", serialnum);

        System.Data.SqlClient.SqlDataReader reader = cmd.ExecuteReader();
        if(reader.HasRows == true)
        {

        System.Data.DataTable dt = new System.Data.DataTable();
        dt.Load(reader);

        string serialNumberTemp = dt.Rows[0]["SerialNumber"].ToString();
        string makeTemp = dt.Rows[0]["Make"].ToString();
        string modelTemp = dt.Rows[0]["Model"].ToString();
        string computerNameTemp = dt.Rows[0]["ComputerName"].ToString();
        string typeTemp = dt.Rows[0]["Type"].ToString();
        string categoryTemp = dt.Rows[0]["Category"].ToString();
        string userTemp = dt.Rows[0]["User"].ToString();
        string userPawprintTemp = dt.Rows[0]["UserPawprint"].ToString();
        string departmentTemp = dt.Rows[0]["Department"].ToString();
        string roomTemp = dt.Rows[0]["Room"].ToString();
        string letterTemp = dt.Rows[0]["Letter"].ToString();  
        string buildingTemp = dt.Rows[0]["Building"].ToString();
        string noteTemp = dt.Rows[0]["Note"].ToString();     
        string ownedByTemp = dt.Rows[0]["OwnedBy"].ToString();
        string purchaseDateTemp = dt.Rows[0]["PurchaseDate"].ToString();
        string auxComputerDateTemp = dt.Rows[0]["AuxComputerDate"].ToString();
            

        txtSerialNumberTemp.Value = serialNumberTemp;
        txtMakeTemp.Value = makeTemp;
        txtModelTemp.Value = modelTemp;
        txtComputerNameTemp.Value = computerNameTemp;
        txtTypeTemp.Value = typeTemp;
        txtCategoryTemp.Value = categoryTemp;
        txtUserTemp.Value = userTemp;
        txtUserPawprintTemp.Value = userPawprintTemp;
        txtDepartmentTemp.Value = departmentTemp;
        txtLocationTemp.Value = roomTemp;
        txtLetterTemp.Value = letterTemp;
        txtBuildingTemp.Value = buildingTemp;
        txtNoteTemp.Value = noteTemp;
        txtOwnedByTemp.Value = ownedByTemp;
        txtPurchaseDateTemp.Value = purchaseDateTemp;
        txtAuxComputerDateTemp.Value = auxComputerDateTemp; 
        
        reader.Close();
        }
        
    //Comment: Use the serial number from the inventoryValidation page to get data from the InventoryDB

        System.Data.SqlClient.SqlCommand command1 = new System.Data.SqlClient.SqlCommand();
        command1.Connection = conn;
        command1.CommandType = System.Data.CommandType.StoredProcedure;
        command1.CommandText = "[dbo].[sp_Inventory_GetRecordInventoryDB]";
        command1.Parameters.AddWithValue("@SerialNum", serialnum);
        reader.Close();
        System.Data.SqlClient.SqlDataReader reader2 = command1.ExecuteReader();

        if (reader2.HasRows == true)
        {
            System.Data.DataTable dt1 = new System.Data.DataTable();
            dt1.Load(reader2);

            string serialNumberDB = dt1.Rows[0]["SerialNumber"].ToString();
            string makeDB = dt1.Rows[0]["Make"].ToString();
            string modelDB = dt1.Rows[0]["Model"].ToString();
            string computerNameDB = dt1.Rows[0]["ComputerName"].ToString();
            string typeDB = dt1.Rows[0]["Type"].ToString();
            string userDB = dt1.Rows[0]["User"].ToString();
            string userPawprintDB = dt1.Rows[0]["UserPawprint"].ToString();
            string categoryDB = dt1.Rows[0]["Category"].ToString();
            string departmentDB = dt1.Rows[0]["Department"].ToString();
            string buildingDB = dt1.Rows[0]["Building"].ToString();
            string ownedByDB = dt1.Rows[0]["OwnedBy"].ToString();
            string purchaseDateDB = dt1.Rows[0]["PurchaseDate"].ToString();
            string auxComputerDB = dt1.Rows[0]["AuxComputerDate"].ToString();
            string roomDB = dt1.Rows[0]["Room"].ToString();
            string letterDB = dt1.Rows[0]["Letter"].ToString();
            string noteDB = dt1.Rows[0]["Note"].ToString();

            txtSerialNumberDB.Value = serialNumberDB;
            //txtSerialNumberDB.ReadOnly = true;
            txtMakeDB.Value = makeDB;
            txtModelDB.Value = modelDB;
            txtComputerNameDB.Value = computerNameDB;
            txtTypeDB.Value = typeDB;
            txtUserDB.Value = userDB;
            txtUserPawprintDB.Value = userPawprintDB;
            txtCategoryDB.Value = categoryDB;
            txtDepartmentDB.Value = departmentDB;
            txtLocationDB.Value = roomDB;
            txtLetterDB.Value = letterDB;
            txtBuildingDB.Value = buildingDB;
            txtNoteDB.Value = noteDB;
            txtOwnedByDB.Value = ownedByDB;
            txtPurchaseDateDB.Value = purchaseDateDB;
            txtAuxComputerDateDB.Value = auxComputerDB;

            if (txtMakeTemp.Value != txtMakeDB.Value)
            {
               
            }
            
            //auto complete department

           

            System.Data.SqlClient.SqlCommand cmd4 = new System.Data.SqlClient.SqlCommand();
            cmd4.Connection = conn;
            cmd4.CommandType = System.Data.CommandType.StoredProcedure;
            cmd4.CommandText = "[dbo].[sp_Inventory_GetDepartmentNames]";

            System.Data.SqlClient.SqlDataReader reader4 = cmd4.ExecuteReader();

            if (reader4.HasRows == true)
            {
                System.Data.DataTable dt4 = new System.Data.DataTable();
                dt4.Load(reader4);
                myarrayDepartment = new String[dt4.Rows.Count];
                for (int i = 0; i < dt4.Rows.Count; i++)
                {
                    myarrayDepartment[i] = dt4.Rows[i]["Dept"].ToString();
                    //myarray[i] = reader["Dept"].ToString();
                }


            }


            var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            myarray_jsonDepartment = serializer.Serialize(myarrayDepartment);


            reader4.Close();
            
            //auto complete category

            System.Data.SqlClient.SqlCommand cmd5 = new System.Data.SqlClient.SqlCommand();
            cmd5.Connection = conn;
            cmd5.CommandType = System.Data.CommandType.StoredProcedure;
            cmd5.CommandText = "[dbo].[sp_Inventory_GetCategory]";

            System.Data.SqlClient.SqlDataReader reader5 = cmd5.ExecuteReader();

            if (reader5.HasRows == true)
            {
                System.Data.DataTable dt5 = new System.Data.DataTable();
                dt5.Load(reader5);
                myarrayCategory = new String[dt5.Rows.Count];
                for (int j = 0; j < dt5.Rows.Count; j++)
                {
                    myarrayCategory[j] = dt5.Rows[j]["Category_Name"].ToString();
                    //myarray[i] = reader["Dept"].ToString();
                }


            }


            serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            myarray_jsonCategory= serializer.Serialize(myarrayCategory);


            reader5.Close();
            
            //autocomplete for type


            System.Data.SqlClient.SqlCommand cmd6 = new System.Data.SqlClient.SqlCommand();
            cmd6.Connection = conn;
            cmd6.CommandType = System.Data.CommandType.StoredProcedure;
            cmd6.CommandText = "[dbo].[sp_Inventory_GetInventoryType]";

            System.Data.SqlClient.SqlDataReader reader6 = cmd6.ExecuteReader();

            if (reader6.HasRows == true)
            {
                System.Data.DataTable dt6 = new System.Data.DataTable();
                dt6.Load(reader6);
                myarrayType = new String[dt6.Rows.Count];
                for (int j = 0; j < dt6.Rows.Count; j++)
                {
                    myarrayType[j] = dt6.Rows[j]["Type"].ToString();
                    //myarray[i] = reader["Dept"].ToString();
                }


            }


            serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            myarray_jsonType = serializer.Serialize(myarrayType);


            reader6.Close();
            
            //autpcomplete for ownedby

            System.Data.SqlClient.SqlCommand cmd7 = new System.Data.SqlClient.SqlCommand();
            cmd7.Connection = conn;
            cmd7.CommandType = System.Data.CommandType.StoredProcedure;
            cmd7.CommandText = "[dbo].[sp_Inventory_GetInventoryOwnedBy]";

            System.Data.SqlClient.SqlDataReader reader7 = cmd7.ExecuteReader();

            if (reader7.HasRows == true)
            {
                System.Data.DataTable dt7 = new System.Data.DataTable();
                dt7.Load(reader7);
                myarrayOwnedBy = new String[dt7.Rows.Count];
                for (int j = 0; j < dt7.Rows.Count; j++)
                {
                    myarrayOwnedBy[j] = dt7.Rows[j]["Dept"].ToString();
                    //myarray[i] = reader["Dept"].ToString();
                }


            }


            serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            myarray_jsonOwnedBy = serializer.Serialize(myarrayOwnedBy);


            reader7.Close();
            
            //code from add.aspx

            //frmDepartments.Value = GetJsonArray("sp_Get_Departments", "Department_Name");
            //txtTypeDB.Value = GetJsonArray("sp_Inventory_GetTypes", "Type");
            //txtCategoryDB.Value = GetJsonArray("sp_Inventory_GetCategories", "Category_Name");
            //frmUsers.Value = TechServices.TSWebservices.GetAllFacStaffPhdUsers();

            //frmDepartments.Value = GetJsonArray("sp_Get_Departments", "Department_Name");
           
           String WarningColor = "#fff39d";
             
            if (txtMakeTemp.Value != txtMakeDB.Value)
            {
                trowMake.Style.Add("background-color", WarningColor);
            }
            if (txtModelTemp.Value != txtModelDB.Value)
            {
                trowModel.Style.Add("background-color", WarningColor);
            }
            if (txtComputerNameTemp.Value != txtComputerNameDB.Value)
            {
                trowComputerName.Style.Add("background-color", WarningColor);
            }
        }
    }

    protected void btnConfirm_Click(object sender, EventArgs e)
    {

        string serialNumberUpdate = Request.Form["txtSerialNumberDB"];
        string makeUpdate = Request.Form["txtMakeDB"];
        string modelUpdate = Request.Form["txtModelDB"];
        string computerNameUpdate = Request.Form["txtComputerNameDB"];
        string typeUpdate = Request.Form["txtTypeDB"];
        string userUpdate = Request.Form["txtUserDB"];
        string userPawprintUpdate = Request.Form["txtUserPawprintDB"];
        string categoryUpdate = Request.Form["txtCategoryDB"];
        string departmentUpdate = Request.Form["txtDepartmentDB"];
        string roomUpdate = Request.Form["txtLocationDB"];
        string letterUpdate = Request.Form["txtLetterDB"];
        string buildingUpdate = Request.Form["txtBuildingDB"];
        string noteUpdate = Request.Form["txtNoteDB"];
        string ownedByUpdate = Request.Form["txtOwnedByDB"];
        string purchaseDateUpdate = Request.Form["txtPurchaseDateDB"];
        string auxComputerUpdate = Request.Form["txtAuxComputerDB"];
            
        String Connstr = "SERVER=sql2005.iats.missouri.edu;Integrated Security = True;DATABASE=MU_BUS_TechServices_1;";
        System.Data.SqlClient.SqlConnection conn = new System.Data.SqlClient.SqlConnection(Connstr);

        conn.Open();
        System.Data.SqlClient.SqlCommand cmd1 = new System.Data.SqlClient.SqlCommand();
        cmd1.Connection = conn;
        cmd1.CommandType = System.Data.CommandType.StoredProcedure;

        cmd1.CommandText = "[dbo].[sp_Inventory_UpdateInventoryDB]";
        cmd1.Parameters.AddWithValue("@SerialNumber", serialNumberUpdate);
        cmd1.Parameters.AddWithValue("@Make", makeUpdate);
        cmd1.Parameters.AddWithValue("@Model", modelUpdate);
        cmd1.Parameters.AddWithValue("@ComputerName", computerNameUpdate);
        cmd1.Parameters.AddWithValue("@Type", typeUpdate);
        cmd1.Parameters.AddWithValue("@User", userUpdate);
        cmd1.Parameters.AddWithValue("@UserPawprint", userPawprintUpdate);
        cmd1.Parameters.AddWithValue("@Category", categoryUpdate);
        cmd1.Parameters.AddWithValue("@Department", departmentUpdate);
        cmd1.Parameters.AddWithValue("@Room", roomUpdate);
        cmd1.Parameters.AddWithValue("@Letter", letterUpdate);
        cmd1.Parameters.AddWithValue("@Building", buildingUpdate);
        cmd1.Parameters.AddWithValue("@Note", noteUpdate);
        cmd1.Parameters.AddWithValue("@OwnedBy", ownedByUpdate);
        cmd1.Parameters.AddWithValue("@PurchaseDate", purchaseDateUpdate);
        cmd1.Parameters.AddWithValue("@AuxComputerDate", auxComputerUpdate);
        cmd1.ExecuteScalar();
        
        

        
        System.Data.SqlClient.SqlCommand cmd2 = new System.Data.SqlClient.SqlCommand();
        cmd2.Connection = conn;
        cmd2.CommandType = System.Data.CommandType.StoredProcedure;
        cmd2.CommandText = "[dbo].[sp_Inventory_DeleteRecordTemp]";
        cmd2.Parameters.AddWithValue("@SerialNumber", serialNumberUpdate);

        cmd2.ExecuteScalar();

        Response.Redirect("InventoryValidation.aspx");
        
    }

</script>


<html class="no-js" lang="en">
<head id="apps-business-missouri-edu" data-template-set="html5-reset">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	    <meta charset="utf-8" />
	    <meta name="title" content="Inventory" />
	    <meta name="description" content="Inventory" />
	    <meta name="Copyright" content="Copyright 2013 Curators of the University of Missouri. All Rights Reserved." />
	    <meta name="DC.title" content="Inventory" />
	    <title>Inventory Management App</title>
    <link rel="stylesheet" type="text/css" href="//apps.business.missouri.edu/css/base-1.1.css" />
        <script type="text/javascript" src="//code.jquery.com/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="//code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
    <link rel="stylesheet" type="text/css" href="//code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css">

    <script type="text/javascript" src="//code.jquery.com/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="//code.jquery.com/ui/1.10.3/jquery-ui.js"></script>


<%-- compare and correct the values from LHS to RHS --%>    
    
    <script type="text/javascript">
        $(document).ready(function () {
            $("#btnCorrectMake").click(function () {
                $("#txtMakeDB").val($("#txtMakeTemp").val());
            });
        })

    </script>

     <script type="text/javascript">
         $(document).ready(function () {
             $("#btnCorrectModel").click(function () {
                 $("#txtModelDB").val($("#txtModelTemp").val());
             });
         })

    </script>

    <script type="text/javascript">
        $(document).ready(function () {
            $("#btnCorrectComputerName").click(function () {
                $("#txtComputerNameDB").val($("#txtComputerNameTemp").val());
            });
        })

    </script>

      <script type="text/javascript">
          $(document).ready(function () {
              $("#btnCorrectType").click(function () {
                  $("#txtTypeDB").val($("#txtTypeTemp").val());
              });
          })

    </script>

    <script type="text/javascript">
            $(document).ready(function () {
                $("#btnCorrectCategory").click(function () {
                    $("#txtCategoryDB").val($("#txtCategoryTemp").val());
                });
            })

    </script>

     <script type="text/javascript">
         $(document).ready(function () {
             $("#btnCorrectUser").click(function () {
                 $("#txtUserDB").val($("#txtUserTemp").val());
                 $("#txtUserPawprintDB").val($("#txtUserPawprintTemp").val());
             });
         })

    </script>

    <script type="text/javascript">
            $(document).ready(function () {
                $("#btnCorrectDepartment").click(function () {
                    $("#txtDepartmentDB").val($("#txtDepartmentTemp").val());
                   
                });
            })

    </script>
    <script type="text/javascript">
            $(document).ready(function () {
                $("#btnCorrectLocation").click(function () {
                    $("#txtLocationDB").val($("#txtLocaitonTemp").val());
                   
                });
            })

    </script>
    <script type="text/javascript">
          $(document).ready(function () {
              $("#btnCorrectBuilding").click(function () {
                  $("#txtBuildingDB").val($("#txtBuildingTemp").val());
                   
              });
          })

    </script>

       <script type="text/javascript">
           $(document).ready(function () {
               $("#btnCorrectOwnedBy").click(function () {
                   $("#txtOwnedByDB").val($("#txtOwnedByTemp").val());
                   
               });
           })

    </script>

     <script type="text/javascript">
             $(document).ready(function () {
                 $("#btnCorrectPurchaseDate").click(function () {
                     $("#txtPurchaseDateByDB").val($("#txtPurchaseDateTemp").val());
                   
                 });
             })

    </script>

    
     <script type="text/javascript">
         $(document).ready(function () {
             $("#btnCorrectAuxComputerDate").click(function () {
                 $("#txtAuxComputerDateByDB").val($("#txtAuxComputerDateTemp").val());
                   
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

            $("#txtDepartmentDB").autocomplete({
                delay: 5, //how long it takes to display the list
                source: <%= myarray_jsonDepartment %>,
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

             $("#txtCategoryDB").autocomplete({
                 delay: 5, //how long it takes to display the list
                 source: <%= myarray_jsonCategory %>,
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

                 $("#txtTypeDB").autocomplete({
                     delay: 5, //how long it takes to display the list
                     source: <%= myarray_jsonType %>,
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

            $("#txtOwnedByDB").autocomplete({
                delay: 5, //how long it takes to display the list
                source: <%= myarray_jsonOwnedBy %>,
                     minLength: 0, //begin suggesting completions when the field is empty
                     autoFocus: true//automatically populate the box with the current suggestion
                 });

             })
                </script>
    <script type="text/javascript"> 
        $(function() {
            $( "#txtPurchaseDateDB" ).datepicker();
        });
    </script>
     <script type="text/javascript"> 
          $(function() {
              $( "#txtAuxComputerDateDB" ).datepicker();
          });
    </script>
<%--    <script runat ="server">
    JavaScriptSerializer serializer = new JavaScriptSerializer();
    String GetJsonArray(String Command, String Field) {
                DataTable data = new Inventory_DB.DatabaseStoredProcedure(Command).ExecuteReader();
                String[] arrayToLoad = new String[data.Rows.Count];
                for (int i = 0; i < data.Rows.Count; i++) {
                    arrayToLoad[i] = data.Rows[i][Field].ToString();
                }
                return serializer.Serialize(arrayToLoad);
                }

     </script>--%>
<%--<script runat="server">
    JavaScriptSerializer serializer = new JavaScriptSerializer();


            String GetJsonArray(String Command, String Field) {
                DataTable data = new Inventory_DB.DatabaseStoredProcedure(Command).ExecuteReader();
                String[] arrayToLoad = new String[data.Rows.Count];
                for (int i = 0; i < data.Rows.Count; i++) {
                    arrayToLoad[i] = data.Rows[i][Field].ToString();
                }
                return serializer.Serialize(arrayToLoad);
            }
            
            bool assert(string value) {
                if (value != null && value != "") return true;
                return false;
            }

            void error() {
                Response.Redirect("Error.aspx",true);
            }
            
           


 </script>    
 --%>
 



    <style type="text/css">
        .auto-style1 {
            height: 43px;
        }
        .auto-style5 {
            height: 20px;
            width: 110px;
        }
    </style>


</head>
<body>
    <a href="Summary.aspx"><div id="header">
        <div id="app-title">
            Inventory Management
        </div>
    </div></a>

   <form runat="server">
        <input type="hidden" id="frmDepartments" runat="server"/>
        <input type="hidden" id="frmTypes" runat="server" />
        <input type="hidden" id="frmCategories" runat="server" />
        <input type="hidden" id="frmUsers" runat="server" />

            <div id="content" style ="width:100%">
               

                <table runat="server" id= "tblRecordMatching" name="tblRecordMatching" style="width:100%;border: 1px grey">
                   <tr>
                        <th>Temp Table</th>
                        <th></th> 
                        <th>Database</th>
                   </tr>
                    <tr id ="trowSerialNumber" name="trowSerialNumber">
                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblSerialNumberTemp" style ="width:50%" > Serial Number </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtSerialNumberTemp" name="txterialNumber" type="text" style ="width:80%">
                            </div>
                        </td>
                      
                        <td style ="width:20%">
                            <%--<input type="button" id ="btnCorrectSerialNumber" style="width:50%" value="Correct" OnClick="btnCorrectSerialNumber_Click" />--%>
                        </td>
                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblSerialNumberDB" style="width:50%" > Serial Number </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtSerialNumberDB" name="txtSerialNumberDB" type="text"  style ="width:80%" disabled="disabled">
                            </div>
                        </td>
                    </tr>
                    <tr id ="trowMake" name ="trowMake" >
                        <td style ="width:40%;" >
                            <div>
                                <asp:Label runat="server" ID="lblMakeTemp" style ="width:50%" > Make </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtMakeTemp" name="txtMakeTemp" type="text" style ="width:80%">
                            </div>
                        </td>
                      
                        <td style ="width:20%">
                            <input type ="button" id ="btnCorrectMake" style="width:50%" Value="Correct -- >"  />
                        </td>
                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblMakeDB" style="width:50%" > Make </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtMakeDB" name="txtMakeDB" type="text"  style ="width:80%" required>
                            </div>
                        </td>
                    </tr>
                    <tr id="trowModel" name ="trowModel" >
                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblModel" style ="width:50%" > Model </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtModelTemp" name="txtModelTemp" type="text" style ="width:80%">
                            </div>
                        </td>
                      
                        <td style ="width:20%">
                            <input type="button" id ="btnCorrectModel" style="width:50%" value="Correct -- >" />
                        </td>
                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblModelDB" style="width:50%" > Model </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtModelDB" name="txtModelDB" type="text"  style ="width:80%" required>
                            </div>
                        </td>
                    </tr>
                    <tr id="trowComputerName">
                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblComputerNameTemp" style ="width:50%" > Computer Name </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtComputerNameTemp" name="txtComputerNameTemp" type="text" style ="width:80%">
                            </div>
                        </td>
                      
                        <td style ="width:20%">
                            <input type="button" id ="btnCorrectComputerName" runat="server" style="width:50%" value="Correct -- >" OnClick="btnCorrectComputerName_Click" />
                        </td>
                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblComputerNameDB" style="width:50%" > Computer Name </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtComputerNameDB" name="txtComputerNameDB" type="text"  style ="width:80%" required>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblTypeTemp" style="width:50%" > Type </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtTypeTemp" name="txtTypeTemp" type="text"  style ="width:80%" >
                            </div>
                        </td>
                      
                        <td style ="width:20%">    
                            <input type="button" id ="btnCorrectType" runat="server" style="width:50%" value="Correct" />
                        </td>  
                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblTypeDB" style="width:50%" > Type </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtTypeDB" name="txtTypeDB" type="text"  style ="width:80%" required>
                            </div>
                        </td>
                    </tr>
                     <tr>
                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblCategoryTemp" style="width:50%" > Category </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtCategoryTemp" name="txtCategoryTemp" type="text"  style ="width:80%" >
                            </div>
                        </td>
                      
                        <td style ="width:20%">
                            <input type="button" id ="btnCorrectCategory" runat="server" style="width:50%" value="Correct" />
                        </td>

                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblCategoryDB" style="width:50%" > Category </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtCategoryDB" name="txtCategoryDB" type="text"  style ="width:80%" required>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblUserTemp" style="width:50%" > User </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtUserTemp" name="txtUserTemp" type="text" style="width: 80%">
                                <input runat="server" id="txtUserPawprintTemp" name="txtUserPawprintTemp" type="text"  style ="width:80%" >
                            </div>
                        </td>
                      
                        <td style ="width:20%">
                            <input type="button" id ="btnCorrectUser" runat="server" style="width:50%" value="Correct" />
                        </td>
                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblUserDB" style="width:50%" > User </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtUserDB" name="txtUserDB" type="text" style="width: 80%">
                                <input runat="server" id="txtUserPawprintDB" name="txtUserPawprintDB" type="text"  style ="width:80%" >
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblDepartmentTemp" style="width:50%" > Department </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtDepartmentTemp" name="txtDepartmentTemp" type="text" style="width: 80%">
                            </div>
                        </td>
                      
                        <td style ="width:20%">
                            <input type="button" id ="btnCorrectDepartment" runat="server" style="width:50%" value="Correct" />
                        </td>
                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblDepartmentDB" style="width:50%" > Department </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtDepartmentDB" name="txtDepartmentDB" type="text" style="width: 80%" required>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblLocationTemp" style="width:50%" > Room </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtLocationTemp" name="txtLocationTemp" type="text" style="width: 80%">
                            </div>
                             <div>
                                <asp:Label runat="server" ID="lblLetterTemp" style="width:50%" >Letter</asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtLetterTemp" name="txtLetterTemp" type="text" style="width: 80%">
                            </div>
                        </td>
                      
                        <td style ="width:20%">
                            <input type="button" id ="btnCorrectLocation" runat="server" style="width:50%" value="Correct" />
                        </td>
                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblLocationDB" style="width:50%" > Room </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtLocationDB" name="txtLocationDB" type="text" placeholder="Ex: 308" style="width: 80%" required>
                            </div>
                            <div>
                                <asp:Label runat="server" ID="lblLetterDB" style="width:50%" >Letter</asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtLetterDB" name="txtLetterDB" type="text" placeholder="A-Z" style="width: 80%">
                            </div>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblBuildingTemp" style="width:50%" > Building </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtBuildingTemp" name="txtBuildingTemp" type="text" style="width: 80%">
                            </div>
                            <div>
                                <asp:Label runat="server" ID="lblNoteTemp" style="width:50%" > Note </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtNoteTemp" name="txtNoteTemp" type="text" style="width: 80%">
                            </div>
                        </td>
                      
                        <td style ="width:20%">
                            <input type="button" id ="btnCorrectBuilding" runat="server" style="width:50%" value="Correct" />
                        </td>

                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblBuildingDB" style="width:50%" > Building </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtBuildingDB" name="txtBuildingDB" value="Cornell Hall" type="text" style="width: 80%" required>
                            </div>

                            <div>
                                <asp:Label runat="server" ID="lblNoteDB" style="width:50%" > Note </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtNoteDB" name="txtNoteTemp" type="text" style="width: 80%">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblOwnedByTemp" style="width:50%" > Owned By </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtOwnedByTemp" name="txtOwnedByTemp" type="text" style="width: 80%">
                            </div>
                        </td>
                      
                        <td style ="width:20%">
                            <input type="button" id ="btnCorrectOwnedBy" runat="server" style="width:50%" value="Correct" />   
                        </td>
                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblOwnedByDB" style="width:50%" > Owned By </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtOwnedByDB" name="txtOwnedByDB" type="text" style="width: 80%" required>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblPurchaseDateTemp" style="width:50%" > Purchase Date </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtPurchaseDateTemp" name="txtPurchaseDateTemp" type="text" style="width: 80%">
                            </div>
                        </td>
                      
                        <td style ="width:20%">
                            <input type="button" id ="btnCorrectPurchaseDate" runat="server" style="width:50%" value="Correct" />
                            <%--<input type="image" id ="testimage" runat="server" style="width:50%" src="Pictures\download.jpg" />--%>
                        </td>   
                            
                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblPurchaseDateDB" style="width:50%" > Purchase Date </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtPurchaseDateDB" name="txtPurchaseDateDB" type="text" style="width: 80%" required>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblAuxComputerDateTemp" style="width:50%" > Aux Computer </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtAuxComputerDateTemp" name="txtAuxComputerDateTemp" type="text" style="width: 80%">
                            </div>
                        </td>
                      
                        <td style ="width:20%">
                           <input type="button" id ="btnCorrectAuxComputerDate" runat="server" style="width:50%" value="Correct" />
                        </td> 
                        <td style ="width:40%">
                            <div>
                                <asp:Label runat="server" ID="lblAuxComputerDateDB" style="width:50%" > Aux Computer </asp:Label>
                            </div>
                            <div>
                                <input runat="server" id="txtAuxComputerDateDB" name="txtAuxComputerDateDB" type="text" style="width: 80%">
                            </div>
                        </td>
                    </tr>
             
             

                </table>
                 



               <div style="float:right">
                    <asp:button runat="server" id="btnConfirm" text="Confirm" OnClick="btnConfirm_Click"/>
               </div>
          </div>
                 <asp:Label runat="server" ID="lblMessage1" >  </asp:Label>   
           

    </form>
    
</body>
</html>

