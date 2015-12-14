<%@ Page Language="C#" %>
<%@ Assembly Src="DatabaseStoredProcedure.cs" %>
<%@ Assembly Src="TSWebservices.cs" %>
<%@ Import Namespace="System.DirectoryServices" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<%@ Import Namespace="System.Data" %>

<!DOCTYPE html>

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

    <script runat="server">

            JavaScriptSerializer serializer = new JavaScriptSerializer();


            String GetJsonArray(String Command, String Field) {
                DataTable data = new inventory.DatabaseStoredProcedure(Command).ExecuteReader();
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

            public string[] myarrayDepartment;
            public string myarray_jsonDepartment;
            public string[] myarrayCategory;
            public string myarray_jsonCategory;
            public string[] myarrayType;
            public string myarray_jsonType;
            public string[] myarrayOwnedBy;
            public string myarray_jsonOwnedBy;
            public string[] myarrayMake;
            public string myarray_jsonMake;
            public string[] myarrayModel;
            public string myarray_jsonModel;
            




            protected void Page_Load(object sender, EventArgs e) {
                Context.Session.Add("Request URI", "Add.aspx");
                var logged_in = Context.Session["DomainUser"];
                if (!(logged_in != null && (bool)logged_in == true)) Response.Redirect("Login.aspx");
                
                if (Request.RequestType == "POST") {
                    var formData = Request.Form;
                    var procedure = new inventory.DatabaseStoredProcedure("[dbo].[sp_Inventory_CreateRecord]");
                    foreach (var key in formData.AllKeys) {
                        if (!key.Contains("inventory") ) continue;
                        if (!assert(formData[key]) && key != "inventoryRoomLetter" && key != "inventoryNote" && key != "inventoryAuxComputerDate")
                        {
                            String[] PeopleCategories = { " ", "Faculty", "Staff", "Departments", "GA/RA/TA", "PhD", "Other" };
                            var query = from String str in PeopleCategories.AsQueryable() where str == formData["inventoryCategory"] select str;
                            if (query.Count() > 0){
                                error();
                            }
                            else {
                                if (key == "inventoryUser" || key == "inventoryUserPawprint") continue;
                                else error();
                            }
                        }
                        procedure.SetParameter("@" + key.Replace("inventory",""), formData[key]);
                    }
                    var success = procedure.ExecuteReader();
                    Response.Redirect("summary.aspx");
                    
                }

                //auto complete department

                String Connstr = "SERVER=sql2005.iats.missouri.edu;Integrated Security = True;DATABASE=MU_BUS_TechServices_1;";
                System.Data.SqlClient.SqlConnection conn = new System.Data.SqlClient.SqlConnection(Connstr);

                conn.Open();



                System.Data.SqlClient.SqlCommand cmd4 = new System.Data.SqlClient.SqlCommand();
                cmd4.Connection = conn;
                cmd4.CommandType = System.Data.CommandType.StoredProcedure;
                cmd4.CommandText = "[dbo].[sp_Get_Departments]";

                System.Data.SqlClient.SqlDataReader reader4 = cmd4.ExecuteReader();

                if (reader4.HasRows == true)
                {
                    System.Data.DataTable dt4 = new System.Data.DataTable();
                    dt4.Load(reader4);
                    myarrayDepartment = new String[dt4.Rows.Count];
                    for (int i = 0; i < dt4.Rows.Count; i++)
                    {
                        myarrayDepartment[i] = dt4.Rows[i]["Department_Name"].ToString();
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
                myarray_jsonCategory = serializer.Serialize(myarrayCategory);


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


                //autpcomplete for make

                System.Data.SqlClient.SqlCommand cmd8 = new System.Data.SqlClient.SqlCommand();
                cmd8.Connection = conn;
                cmd8.CommandType = System.Data.CommandType.StoredProcedure;
                cmd8.CommandText = "[dbo].[sp_Inventory_GetInventoryMake]";

                System.Data.SqlClient.SqlDataReader reader8 = cmd8.ExecuteReader();

                if (reader8.HasRows == true)
                {
                    System.Data.DataTable dt8 = new System.Data.DataTable();
                    dt8.Load(reader8);
                    myarrayMake = new String[dt8.Rows.Count];
                    for (int j = 0; j < dt8.Rows.Count; j++)
                    {
                        myarrayMake[j] = dt8.Rows[j]["Manuf"].ToString();
                        //myarray[i] = reader["Dept"].ToString();
                    }


                }


                serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                myarray_jsonMake = serializer.Serialize(myarrayMake);


                reader8.Close();

                //autpcomplete for model

                System.Data.SqlClient.SqlCommand cmd9 = new System.Data.SqlClient.SqlCommand();
                cmd9.Connection = conn;
                cmd9.CommandType = System.Data.CommandType.StoredProcedure;
                cmd9.CommandText = "[dbo].[sp_Inventory_GetInventoryModel]";

                System.Data.SqlClient.SqlDataReader reader9 = cmd9.ExecuteReader();

                if (reader9.HasRows == true)
                {
                    System.Data.DataTable dt9 = new System.Data.DataTable();
                    dt9.Load(reader9);
                    myarrayModel = new String[dt9.Rows.Count];
                    for (int j = 0; j < dt9.Rows.Count; j++)
                    {
                        myarrayModel[j] = dt9.Rows[j]["Model"].ToString();
                        //myarray[i] = reader["Dept"].ToString();
                    }


                }


                serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                myarray_jsonModel = serializer.Serialize(myarrayModel);


                reader9.Close();
                
                frmDepartments.Value = GetJsonArray("sp_Get_Departments", "Department_Name");
                frmTypes.Value = GetJsonArray("sp_Inventory_GetTypes", "Type");
                frmMakes.Value = GetJsonArray("sp_Inventory_GetMakes", "Manuf");
                frmModels.Value = GetJsonArray("sp_Inventory_GetModels", "Model");
                frmCategories.Value = GetJsonArray("sp_Inventory_GetCategories", "Category_Name");
                //frmUsers.Value = TechServices.TSWebservices.GetAllFacStaffPhdUsers();
            }
    </script>
 
    <script type="text/javascript">
        //autocomplete department
        $(document).ready(function () {
            ///with jquery, there is a jquery function object represented by $
            //everything you pass to it becomes a jquery object with events and functions
            //to make things more convenient
            //here, I am using $(document).ready to wait until the document has loaded to execute my JS

            $(".date").datepicker();

            $("#inventoryDepartment").autocomplete({
                delay: 5, //how long it takes to display the list
                source: <%= myarray_jsonDepartment %>,
                minLength: 0, //begin suggesting completions when the field is empty
                autoFocus: true//automatically populate the box with the current suggestion
            });

        })
                </script>

    
  <script type="text/javascript">

      //autocomplete category
      $(document).ready(function () {
          ///with jquery, there is a jquery function object represented by $
          //everything you pass to it becomes a jquery object with events and functions
          //to make things more convenient
          //here, I am using $(document).ready to wait until the document has loaded to execute my JS

          $(".date").datepicker();

          $("#inventoryCategory").autocomplete({
              delay: 5, //how long it takes to display the list
              source: <%= myarray_jsonCategory %>,
                 minLength: 0, //begin suggesting completions when the field is empty
                 autoFocus: true//automatically populate the box with the current suggestion
             });

         })
                </script>

      <script type="text/javascript">

          //autocomplete type
          $(document).ready(function () {
              ///with jquery, there is a jquery function object represented by $
              //everything you pass to it becomes a jquery object with events and functions
              //to make things more convenient
              //here, I am using $(document).ready to wait until the document has loaded to execute my JS

              $(".date").datepicker();

              $("#inventoryType").autocomplete({
                  delay: 5, //how long it takes to display the list
                  source: <%= myarray_jsonType %>,
                     minLength: 0, //begin suggesting completions when the field is empty
                     autoFocus: true//automatically populate the box with the current suggestion
                 });

             })
    </script>

    <script type="text/javascript">

        //autocomplete ownedby
        $(document).ready(function () {
            ///with jquery, there is a jquery function object represented by $
            //everything you pass to it becomes a jquery object with events and functions
            //to make things more convenient
            //here, I am using $(document).ready to wait until the document has loaded to execute my JS

            $(".date").datepicker();

            $("#inventoryOwnedBy").autocomplete({
                delay: 5, //how long it takes to display the list
                source: <%= myarray_jsonOwnedBy %>,
                minLength: 0, //begin suggesting completions when the field is empty
                autoFocus: true//automatically populate the box with the current suggestion
            });

        })
                </script>

     <script type="text/javascript">

         //autocomplete make
         $(document).ready(function () {
             ///with jquery, there is a jquery function object represented by $
             //everything you pass to it becomes a jquery object with events and functions
             //to make things more convenient
             //here, I am using $(document).ready to wait until the document has loaded to execute my JS

             $(".date").datepicker();

             $("#inventoryMake").autocomplete({
                 delay: 5, //how long it takes to display the list
                 source: <%= myarray_jsonMake %>,
                minLength: 0, //begin suggesting completions when the field is empty
                autoFocus: true//automatically populate the box with the current suggestion
            });

        })
                </script>

      <script type="text/javascript">

          //autocomplete model
          $(document).ready(function () {
              ///with jquery, there is a jquery function object represented by $
              //everything you pass to it becomes a jquery object with events and functions
              //to make things more convenient
              //here, I am using $(document).ready to wait until the document has loaded to execute my JS

              $(".date").datepicker();

              $("#inventoryModel").autocomplete({
                  delay: 5, //how long it takes to display the list
                  source: <%= myarray_jsonModel %>,
                 minLength: 0, //begin suggesting completions when the field is empty
                 autoFocus: true//automatically populate the box with the current suggestion
             });

         })
                </script>

    <script type="text/javascript"> 
        $(function() {
            $( "#inventoryAuxComputerDate" ).datepicker();
        });
    </script>


    <script type="text/javascript">
        $(document).ready(function () {
        var letters = ["", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
            var autopopulates = [
                { id: "#inventoryType", sourceId: "#frmTypes" },
                { id: "#inventoryModel", sourceId: "#frmModels" },
                { id: "#inventoryMake", sourceId: "#frmMakes" },
                { id: "#inventoryOwnedBy", sourceId: "#frmDepartments" },
                { id: "#inventoryCategory", sourceId: "#frmCategories" },
                { id: "#inventoryDepartment", sourceId: "#frmDepartments" }
            ]

            $("#inventoryDepartment").autocomplete({
                delay: 5, //how long it takes to display the list
                source: <%= myarray_jsonDepartment %>,
                minLength: 0, //begin suggesting completions when the field is empty
                autoFocus: true//automatically populate the box with the current suggestion
            });

        })
           

            function autocompleteOptions(sourceId) {
                return {
                    delay: 10,
                    source: JSON.parse($(sourceId).val()),
                    minLength: 0,
                    autoFocus: true,
                    focus: function () { $(this).addClass('invalid'); },
                    select: function () { $(this).removeClass('invalid') }
                }
            }

            $('#inventoryRoomLetter').autocomplete({
                delay: 10,
                source: letters,
                minLength: 0,
                autoFocus: true
            }).bind('focus', function () { $(this).autocomplete("search"); });;

            var users = JSON.parse($('#frmUsers').val());
            var justUserNames = [];
            var inventoryUser = $('#inventoryUser');
            var inventoryUserPawprint = $('#inventoryUserPawprint');
            for (var i in users) {
                justUserNames.push(users[i].label);
            }

            function setPawprint(e) {
                var val = inventoryUser.val();
                $('#inventoryUserPawprint').val("");
                for (var i in users) {
                    if (users[i].label == val) {
                        $('#inventoryUserPawprint').val(users[i].value);
                        return;
                    }
                }
            }

            inventoryUser.autocomplete({
                delay: 10,
                source: justUserNames,
                minLength: 0,
                autoFocus: true
            }).keyup(setPawprint).change(setPawprint).focusout(setPawprint)

            var peopleCategories = [" "
                                    , "Faculty"
                                    , "Staff"
                                    , "Departments"
                                    , "GA/RA/TA"
                                    , "PhD"
                                    , "Other"]

            $('#inventoryCategory').change(function (e, n) { categoryCheckIsUserType($(this).val()) });
            $('#inventoryCategory').focusout(function (e, n) { categoryCheckIsUserType($(this).val()) });
            $('#inventoryCategory').keyup(function (e, n) { categoryCheckIsUserType($(this).val()) });
            function categoryCheckIsUserType(val) {
                if (peopleCategories.indexOf(val) > 0 || peopleCategories.indexOf(val) > 0) {
                    $("#inventoryUser").removeAttr('readonly');
                    $("#inventoryUser").autocomplete('enable');
                    $("#inventoryUser").attr('name', 'inventoryUser');
                    $("#inventoryUser").attr('dx-required', true);
                } else {
                    $("#inventoryUser").attr('readonly', true);
                    $("#inventoryUser").val('');
                    $("#inventoryUser").autocomplete('disable');
                    $("#inventoryUser").removeAttr('dx-required');
                }
            }

            for (var i in autopopulates) {
                var currentObj = autopopulates[i];
                var currentTextField = $(currentObj.id);
                currentTextField.autocomplete(autocompleteOptions(currentObj.sourceId));
            }
            //purchase date is in the format of Jul/24/2014
            $('#inventoryPurchaseDate').datepicker();
            //Aux date is in the format of 07/24/2014
            $('.date').datepicker();

            function validate() {
                var requireds = $('.required');
                $('.required:not(.ui-autocomplete-input)').removeClass('invalid');
                requireds.each(function (i, e) {
                    if ($(e).val() == '') {

                        $(e).addClass('invalid');
                        //if ($("#inventoryAuxComputerDate").val() == '' || )
                        //{

                        //    $("#inventoryAuxComputerDate").removeClass('invalid');
                        //}
                    }
                });

                if ($("#inventoryAuxComputerDate").val() == "" || $("#inventoryAuxComputerDate").val() == "1/1/1900 12:00:00 AM") {
                    $("#inventoryAuxComputerDate").removeClass('calendarclass');

                    $("#inventoryAuxComputerDate").removeClass("hasDatepicker");

                    $("#inventoryAuxComputerDate").unbind();
                    $("#inventoryAuxComputerDate").val('');
                }
            }

            $("#Save").click(function (e) {
                validate();
                if ($('.invalid').length > 0) return false;
            });
        });
    </script>
    <style type="text/css">
        input[name=inventoryUser] {
            width: 70%;
        }
        input[name=inventoryUserPawprint] {
            width: 26%;
            margin-right: 0px;
        }
        #content .invalid {
            border-color: #A10000 ;
        }
    </style>
</head>

<body id="page">
    <a href="Summary.aspx"><div id="header">
        <div id="app-title">
            Inventory Management
        </div>
    </div></a>
    <div id="content">
        <h2>Add Item</h2>
        <form id="mainForm" runat="server" autocomplete="off">
            <div>
                <input type="hidden" id="frmDepartments" runat="server"/>
                <input type="hidden" id="frmTypes" runat="server" />
                <input type="hidden" id="frmMakes" runat="server" />
                <input type="hidden" id="frmModels" runat="server" />
                <input type="hidden" id="frmCategories" runat="server" />
                <input type="hidden" id="frmUsers" runat="server" />
                <asp:Label runat="server" ID="lblAddedMessage"></asp:Label>
                <asp:Label runat="server" ID="lblSerialNum" > Serial Number </asp:Label>

                <input runat="server" id="inventorySerialNumber" name="inventorySerialNumber" type="text" class="required">


                <asp:Label runat="server" ID="lblType"> Type </asp:Label>
                <input runat="server" id="inventoryType" name="inventoryType" type="text" class="required"/>
                <asp:Label runat="server" ID="lblMake"> Make </asp:Label>
                <input runat="server" id="inventoryMake" name="inventoryMake" type="text" class="required" />
                <asp:Label runat="server" ID="lblModel">Model</asp:Label>
                <input runat="server" id="inventoryModel" name="inventoryModel" type="text"  class="required"/>
                <asp:Label runat="server" ID="lblCategory">Category </asp:Label>
                <input runat="server" id="inventoryCategory" name="inventoryCategory" type="text" class="required"/>
                <asp:Label runat="server" ID="lblUser"> User </asp:Label>
                <div>
                <input runat="server" type="text" id="inventoryUser" name="inventoryUser"  readonly />
                <input runat="server" type="text" id="inventoryUserPawprint" tabindex="-1" name="inventoryUser" readonly />
                    </div>
                <asp:Label runat="server" ID="lblDepartments"> Department </asp:Label>
                <input runat="server" id="inventoryDepartment" name="inventoryDepartment" type="text" class="required"/>
                <asp:Label runat="server" ID="lblLocation">Location</asp:Label>
                <asp:Label runat="server" ID="lblRoomNumber">Room No.</asp:Label>
                <input runat="server" id="inventoryRoom" name="inventoryRoom" type="text" placeholder="Ex: 308" class="required"/>
                <asp:Label runat="server" ID="lblAlphabet">Letter</asp:Label>
                <input runat="server" id="inventoryRoomLetter" name="inventoryRoomLetter" type="text" placeholder="A-Z" /> 
                <asp:Label runat="server" ID="lblBuilding">Building</asp:Label>
                <input runat="server" id="inventoryBuilding" name="inventoryBuilding" type="text" value="Cornell Hall" class="required"/>
                <asp:Label runat="server" ID="lblNote">Note</asp:Label>
                <input runat="server" id="inventoryNote" name="inventoryNote" type="text" style="width: 199px; height: 28px;"/>
                <div>
                <asp:Label runat="server" ID="lblOwnedBy">Owned By</asp:Label>
                <input runat="server" id="inventoryOwnedBy" name="inventoryOwnedBy" type="text"  class="required"/>
                    </div>
                <asp:Label runat="server" ID="lblPurchaseDate" > Purchase Date </asp:Label>
                <input runat="server" id="inventoryPurchaseDate" name="inventoryPurchaseDate" class="date required" type="text"  />
                <asp:Label runat="server" ID="lblAuxComputerDate"> Aux Computer</asp:Label>
                <input runat="server" id="inventoryAuxComputerDate" name="inventoryAuxComputerDate" type="text" />
                  <!--
                     this belongs in inventoryAuxComputerDate
                     they no longer need that to be a required field
                      didn't delete, just in case.
                       class="date required" -->
                <input type="submit" id="Save" />
            </div>
        </form>
    </div>
    <div id="footer">&copy; Copyright <%= DateTime.Now.Year %> Curators of the University of Missouri</div>

  

</body>
</html>


