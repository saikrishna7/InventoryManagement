<%@ Page Language="C#" %>

<%@ Import Namespace="System.DirectoryServices" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Net" %>
<%--<%@ Assembly Src="TSWebservices.cs" %>--%>
<%--<%@ Assembly Src="DatabaseStoredProcedure.cs" %>--%>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<!doctype HTML>
<script runat="server">


            public string[] myarrayDepartment;
            public string myarray_jsonDepartment;
            public string[] myarrayCategory;
            public string myarray_jsonCategory;
            public string[] myarrayType;
            public string myarray_jsonType;
            public string[] myarrayOwnedBy;
            public string myarray_jsonOwnedBy;

            public string users_json;
            private static string Connectionstring = System.Configuration.ConfigurationManager.ConnectionStrings["TCOBInventoryDBEntities"].ConnectionString;


            protected void page_load(object sender, EventArgs e)
            {

            //string connstr = "server=sql2005.iats.missouri.edu;integrated security = true;database=mu_bus_techservices_1;";
            System.Data.SqlClient.SqlConnection conn = new System.Data.SqlClient.SqlConnection(Connectionstring);

            conn.Open();
        
        //comment: use the serial number from the previous page where you display data from temp table
        
        string serialnum = Request.QueryString["id"];

            System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand();
            cmd.Connection = conn;
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.CommandText = "[dbo].[sp_inventory_getrecordtemp]";
        cmd.Parameters.AddWithValue("@serialnum", serialnum);

        System.Data.SqlClient.SqlDataReader reader = cmd.ExecuteReader();
       
        if(reader.HasRows == true)
        {

                System.Data.DataTable dt = new System.Data.DataTable();
            dt.Load(reader);

                string serialnumbertemp = dt.Rows[0]["serialnumber"].ToString();
            string maketemp = dt.Rows[0]["make"].ToString();
            string modeltemp = dt.Rows[0]["model"].ToString();
            string computernametemp = dt.Rows[0]["computername"].ToString();
            string typetemp = dt.Rows[0]["type"].ToString();
            string categorytemp = dt.Rows[0]["category"].ToString();
            string usertemp = dt.Rows[0]["user"].ToString();
            string userpawprinttemp = dt.Rows[0]["userpawprint"].ToString();
            string departmenttemp = dt.Rows[0]["department"].ToString();
            string locationtemp = dt.Rows[0]["location"].ToString();
            string roomlettertemp = dt.Rows[0]["roomLetter"].ToString();
            string buildingtemp = dt.Rows[0]["building"].ToString();
            string notetemp = dt.Rows[0]["note"].ToString();
            string ownedbytemp = dt.Rows[0]["ownedby"].ToString();
            string purchasedatetemp = dt.Rows[0]["purchasedate"].ToString();
            string auxcomputerdatetemp = dt.Rows[0]["auxcomputerdate"].ToString();


            txtSerialNumberTemp.Value = serialnumbertemp;
                txtMakeTemp.Value = maketemp;
                txtModelTemp.Value = modeltemp;
                txtComputerNameTemp.Value = computernametemp;
                txtTypeTemp.Value = typetemp;
                txtCategoryTemp.Value = categorytemp;
                txtUserTemp.Value = usertemp;
                txtUserPawprintTemp.Value = userpawprinttemp;
                txtDepartmentTemp.Value = departmenttemp;
                txtLocationTemp.Value = locationtemp;
                txtLetterTemp.Value = roomlettertemp;
                txtBuildingTemp.Value = buildingtemp;
                txtNoteTemp.Value = notetemp;
                txtOwnedByTemp.Value = ownedbytemp;
                txtPurchaseDateTemp.Value = purchasedatetemp;
                txtAuxComputerDateTemp.Value = auxcomputerdatetemp; 
        
                reader.Close();
                }

        //comment: use the serial number from the inventoryvalidation page to get data from the inventorydb

        System.Data.SqlClient.SqlCommand command1 = new System.Data.SqlClient.SqlCommand();
        command1.Connection = conn;
        command1.CommandType = System.Data.CommandType.StoredProcedure;
        command1.CommandText = "[dbo].[sp_inventory_getrecordinventorydb]";
        command1.Parameters.AddWithValue("@serialnum", serialnum);
        reader.Close();

        System.Data.SqlClient.SqlDataReader reader2 = command1.ExecuteReader();

        if (reader2.HasRows == true)
        {
                System.Data.DataTable dt1 = new System.Data.DataTable();
        dt1.Load(reader2);

                string serialnumberdb = dt1.Rows[0]["serialnumber"].ToString();
        string makedb = dt1.Rows[0]["make"].ToString();
        string modeldb = dt1.Rows[0]["model"].ToString();
        string computernamedb = dt1.Rows[0]["computername"].ToString();
        string typedb = dt1.Rows[0]["type"].ToString();
        string userdb = dt1.Rows[0]["user"].ToString();
        string userpawprintdb = dt1.Rows[0]["userpawprint"].ToString();
        string categorydb = dt1.Rows[0]["category"].ToString();
        string departmentdb = dt1.Rows[0]["department"].ToString();
        string buildingdb = dt1.Rows[0]["building"].ToString();
        string ownedbydb = dt1.Rows[0]["ownedby"].ToString();
        string purchasedatedb = dt1.Rows[0]["purchasedate"].ToString();
        string auxcomputerdb = dt1.Rows[0]["auxcomputerdate"].ToString();
        string locationdb = dt1.Rows[0]["room"].ToString();
        string roomletterdb = dt1.Rows[0]["letter"].ToString();
        string notedb = dt1.Rows[0]["note"].ToString();

        txtSerialNumberDB.Value = serialnumberdb;
                txtMakeDB.Value = makedb;
                txtModelDB.Value = modeldb;
                txtComputerNameDB.Value = computernamedb;
                txtTypeDB.Value = typedb;
                txtUserDB.Value = userdb;
                txtUserPawprintDB.Value = userpawprintdb;
                txtCategoryDB.Value = categorydb;
                txtDepartmentDB.Value = departmentdb;
                txtLocationDB.Value = locationdb;
                txtLetterDB.Value = roomletterdb;
                txtBuildingDB.Value = buildingdb;
                txtNoteDB.Value = notedb;
                txtOwnedByDB.Value = ownedbydb;
                txtPurchaseDateDB.Value = purchasedatedb;
                txtAuxComputerDateDB.Value = auxcomputerdb;

                //auto complete department
    
                System.Data.SqlClient.SqlCommand cmd3 = new System.Data.SqlClient.SqlCommand();
        cmd3.Connection = conn;
                cmd3.CommandType = System.Data.CommandType.StoredProcedure;
                cmd3.CommandText = "[dbo].[sp_inventory_getdepartmentnames]";

                System.Data.SqlClient.SqlDataReader reader4 = cmd3.ExecuteReader();
            
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
                cmd5.CommandText = "[dbo].[sp_inventory_getcategory]";
                System.Data.SqlClient.SqlDataReader reader5 = cmd5.ExecuteReader();
            
                if(reader5.HasRows == true)
                {
                        System.Data.DataTable dt5 = new System.Data.DataTable();
    dt5.Load(reader5);
                        myarrayCategory = new String[dt5.Rows.Count];
                        for (int j = 0; j < dt5.Rows.Count; j++)
                        {
                            myarrayCategory[j] = dt5.Rows[j]["category_name"].ToString();
                            //myarray[i] = reader["category_name"].ToString();
                        }
                 }


                serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                myarray_jsonCategory = serializer.Serialize(myarrayCategory);

                reader5.Close();
            
                //autocomplete for type

                System.Data.SqlClient.SqlCommand cmd6 = new System.Data.SqlClient.SqlCommand();
    cmd6.Connection = conn;
                cmd6.CommandType = System.Data.CommandType.StoredProcedure;
                cmd6.CommandText = "[dbo].[sp_inventory_getinventorytype]";
                System.Data.SqlClient.SqlDataReader reader6 = cmd6.ExecuteReader();
            
                if (reader6.HasRows == true)
                {
                    System.Data.DataTable dt6 = new System.Data.DataTable();
    dt6.Load(reader6);
                    myarrayType = new string[dt6.Rows.Count];
                    for (int j = 0; j < dt6.Rows.Count; j++)
                    {
                        myarrayType[j] = dt6.Rows[j]["type"].ToString();
                        //myarray[i] = reader["type"].ToString();
                    }
                }


                serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                myarray_jsonType = serializer.Serialize(myarrayType);


                reader6.Close();
            
                //autpcomplete for ownedby

                System.Data.SqlClient.SqlCommand cmd7 = new System.Data.SqlClient.SqlCommand();
    cmd7.Connection = conn;
                cmd7.CommandType = System.Data.CommandType.StoredProcedure;
                cmd7.CommandText = "[dbo].[sp_inventory_getinventoryOwnedBy]";
                System.Data.SqlClient.SqlDataReader reader7 = cmd7.ExecuteReader();


                if (reader7.HasRows == true)
                {
                    System.Data.DataTable dt7 = new System.Data.DataTable();
    dt7.Load(reader7);
                    myarrayOwnedBy = new string[dt7.Rows.Count];
                    for (int j = 0; j < dt7.Rows.Count; j++)
                    {
                        myarrayOwnedBy[j] = dt7.Rows[j]["Dept"].ToString();
                        //myarray[i] = reader["Dept"].ToString();
                    }
                }


               serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
               myarray_jsonOwnedBy = serializer.Serialize(myarrayOwnedBy);

               reader7.Close();

           
               string warningcolor = "#fff39d";
             
                if (txtMakeTemp.Value != txtMakeDB.Value)
                {
                    trowMake.Style.Add("background-color", warningcolor);
                }

                if (txtModelTemp.Value != txtModelDB.Value)
                {
                    trowModel.Style.Add("background-color", warningcolor);
                }

                if (txtComputerNameTemp.Value != txtComputerNameDB.Value)
                {
                    trowComputerName.Style.Add("background-color", warningcolor);
                }

                users_json = TechServices.TSWebservices.GetAllFacStaffPhdUsers(); //uncommented
            }
        }

            

    protected void btnConfirm_Click(object sender, EventArgs e)
    {
        string serialNumberUpdate = Request.Form["txtSerialNumberDB"];
        string makeUpdate = Request.Form["txtMakeDB"];
        string modelUpdate = Request.Form["txtModelDB"];
        string computerNameUpdate = Request.Form["txtComputerNameDB"];
        string typeUpdate = Request.Form["txtTypeDB"];
        string categoryUpdate = Request.Form["txtCategoryDB"];
        string userUpdate = Request.Form["txtUserDB"];
        string userPawprintUpdate = Request.Form["txtUserPawprintDB"];
        string departmentUpdate = Request.Form["txtDepartmentDB"];
        string locationUpdate = Request.Form["txtLocationDB"];
        string roomLetterUpdate = Request.Form["txtLetterDB"];
        string buildingUpdate = Request.Form["txtBuildingDB"];
        string noteUpdate = Request.Form["txtNoteDB"];
        string ownedByUpdate = Request.Form["txtOwnedByDB"];
        string purchaseDateUpdate = Request.Form["txtPurchaseDateDB"];
        string auxComputerUpdate = Request.Form["txtAuxComputerDateDB"];

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
        cmd1.Parameters.AddWithValue("@Location", locationUpdate);
        cmd1.Parameters.AddWithValue("@Letter", roomLetterUpdate);
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

    //frmDepartments.Value = GetJsonArray("sp_Get_Departments", "Department_Name"); //Uncommneted
    //frmTypes.Value = GetJsonArray("sp_Inventory_GetTypes", "Type"); //Uncommneted
    //frmCategories.Value = GetJsonArray("sp_Inventory_GetCategories", "Category_Name"); //Uncommneted
    //frmUsers.Value = TechServices.TSWebservices.GetAllFacStaffPhdUsers(); //Uncommneted

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
                    $("#txtLocationDB").val($("#txtLocationTemp").val());
                    $("#txtLetterDB").val($("#txtLetterTemp").val()); //Added updating the value for letter
                   
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
                     $("#txtPurchaseDateDB").val($("#txtPurchaseDateTemp").val()); //updated txtPurchaseDateByDB to txtPurchaseDateDB
                   
                 });
             })

    </script>

    
     <script type="text/javascript">
         $(document).ready(function () {
             $("#btnCorrectAuxComputerDate").click(function () {
                 $("#txtAuxComputerDateDB").val($("#txtAuxComputerDateTemp").val()); //updated txtAuxComputerDateByDB to txtAuxComputerDateDB
                   
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
        $(document).ready(function () {
            $("#txtPurchaseDateDB").datepicker();
            $("#txtAuxComputerDateDB").datepicker();
            });
    </script>
     
    
    <script type="text/javascript">
        // TODO: make this work
        //autocomplete User
        $(document).ready(function () {
            ///with jquery, there is a jquery function object represented by $
            //everything you pass to it becomes a jquery object with events and functions
            //to make things more convenient
            //here, I am using $(document).ready to wait until the document has loaded to execute my JS

            //$(".date").datepicker();

            //obj = JSON.parse(users_json);
                
            var users=<%= users_json %>;
            var paws=new Array();

            $.each(users, function(i, ele){
                paws.push(ele.value);
            });

            $("#txtUserTemp").autocomplete({
                delay: 5, //how long it takes to display the list
                source: paws,
                 minLength: 0, //begin suggesting completions when the field is empty
                 autoFocus: true//automatically populate the box with the current suggestion
             });

            //$('#txtPurchaseDateTemp').datepicker();
            

            //$('#txtAuxComputerDateTemp').datepicker();
            

            $("#txtUserTemp").focusout(function () {
                var val = $("#txtUserTemp").val();
                var users = <%= users_json %>;
                for (var i in users) {
                     if (users[i].value == val) {                                           
                         $('#txtUserPawprintTemp').val(users[i].label);                  
                         $('#txtUserTemp').val(users[i].value);                           
                         return;
                     }
                 }
             });
         
         })
         


                </script>   
<%--<script runat="server">
    JavaScriptSerializer serializer = new JavaScriptSerializer();

    
    String GetJsonArray(String Command, String Field) 
        {
                DataTable data = new Inventory_DB.DatabaseStoredProcedure(Command).ExecuteReader();
                String[] arrayToLoad = new String[data.Rows.Count];
                for (int i = 0; i < data.Rows.Count; i++) 
                {
                    arrayToLoad[i] = data.Rows[i][Field].ToString();
                }
                return serializer.Serialize(arrayToLoad);
        }

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
                                <input runat="server" id="txtSerialNumberDB" name="txtSerialNumberDB" type="text"  style ="width:80%" readonly>
                            </div>
                            <%--test line--%>
                            <div>
                                <label runat="server" id="response" name="response" type="text"  style ="width:80%" visible="false" disabled="disabled" ></label>
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
                                <input runat="server" id="txtComputerNameDB" name="txtComputerNameDB" type="text"  style ="width:80%" required value="abc">
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
                                <input runat="server" id="txtUserTemp" name="txtUserTemp" type="text" style="width: 80%" placeholder="name">
                                <input runat="server" id="txtUserPawprintTemp" name="txtUserPawprintTemp" type="text"  style ="width:80%" placeholder="paw print">
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
                                <input runat="server" id="txtUserDB" name="txtUserDB" type="text" style="width: 80%" placeholder="name">
                                <input runat="server" id="txtUserPawprintDB" name="txtUserPawprintDB" type="text"  style ="width:80%" placeholder="paw print">
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

