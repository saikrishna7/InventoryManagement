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

            String convertToStr(object o)
            {
                return convertToStr(o, false);
            }
            
            String convertToStr(object o, bool is_date) {
                if (is_date && o != null && o.ToString().Length > 0) return o.ToString().Substring(0, o.ToString().IndexOf(" "));
                if (o == null) return "";
                else return o.ToString();
            }
            
            
            
            protected void Page_Load(object sender, EventArgs e) {
                Context.Session.Add("Request URI", "Update.aspx?id="+Request.QueryString["id"]);
                var logged_in = Context.Session["DomainUser"];
                if (!(logged_in != null && (bool)logged_in == true)) Response.Redirect("Login.aspx");
                if (Request.RequestType == "POST") {
                    var formData = Request.Form;
                    var procedure = new inventory.DatabaseStoredProcedure("[dbo].[sp_Inventory_UpdateRecord]");
                    foreach (var key in formData.AllKeys) {
                        if (!key.Contains("inventory")) continue;
                        if (!assert(formData[key]) && key != "inventoryRoomLetter" &&  key != "inventoryNote") {
                            String[] PeopleCategories = { " ", "Faculty", "Staff", "Departments", "GA/RA/TA", "PhD", "Other" };
                            var query = from String str in PeopleCategories.AsQueryable() where str == formData["inventoryCategory"] select str;
                            if (query.Count() > 0) {
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
                }
                inventoryInventoryId.Value = Request.QueryString["id"];
        
                var record_data_query = new inventory.DatabaseStoredProcedure("dbo.sp_Inventory_GetRecord");
                record_data_query.SetParameter("@ID", Convert.ToInt32(Request.QueryString["id"]).ToString());
                var record_data = record_data_query.ExecuteReader().Rows[0];//only want the first row
                
                var location = convertToStr(record_data["Location"]);
                var room = "";
                var letter = "";
                var bldg = "";
                if (location == "") //not legacy entry
                {
                    room = convertToStr(record_data["Room"]);                    
                    letter = convertToStr(record_data["Letter"]);
                    bldg = convertToStr(record_data["Building"]);
                } else //legacy
                {
                    room = location;
                }
                
                inventorySerialNumber.Value = convertToStr(record_data["SerialNumber"]);
                inventoryType.Value         = convertToStr(record_data["Type"]);
                inventoryMake.Value         = convertToStr(record_data["Make"]);
                inventoryModel.Value        = convertToStr(record_data["Model"]);
                inventoryCategory.Value     = convertToStr(record_data["Category"]);
                inventoryUser.Value         = convertToStr(record_data["User"]);
                inventoryUserPawprint.Value = convertToStr(record_data["UserPawprint"]);
                inventoryDepartment.Value   = convertToStr(record_data["Department"]);
                inventoryRoom.Value         = room;
                inventoryRoomLetter.Value   = letter;
                inventoryBuilding.Value     = bldg;
                inventoryOwnedBy.Value      = convertToStr(record_data["OwnedBy"]);
                inventoryNote.Value         = convertToStr(record_data["Note"]);
                inventoryPurchaseDate.Value = convertToStr(record_data["PurchaseDate"],true);
                inventoryAuxComputerDate.Value = convertToStr(record_data["AuxComputerDate"],true);
                
                frmDepartments.Value = GetJsonArray("sp_Get_Departments", "Department_Name");
                frmTypes.Value = GetJsonArray("sp_Inventory_GetTypes", "Type");
                frmMakes.Value = GetJsonArray("sp_Inventory_GetMakes", "Manuf");
                frmModels.Value = GetJsonArray("sp_Inventory_GetModels", "Model");
                frmCategories.Value = GetJsonArray("sp_Inventory_GetCategories", "Category_Name");
                frmUsers.Value = TechServices.TSWebservices.GetAllFacStaffPhdUsers();
            }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            var letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
            var autopopulates = [
                { id: "#inventoryType", sourceId: "#frmTypes" },
                { id: "#inventoryModel", sourceId: "#frmModels" },
                { id: "#inventoryMake", sourceId: "#frmMakes" },
                { id: "#inventoryOwnedBy", sourceId: "#frmDepartments" },
                { id: "#inventoryCategory", sourceId: "#frmCategories" },
                { id: "#inventoryDepartment", sourceId: "#frmDepartments" }
            ]

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

            $('.date').datepicker();

            function validate() {
                var requireds = $('.required');
                $('.required:not(.ui-autocomplete-input)').removeClass('invalid');
                requireds.each(function (i, e) {
                    if ($(e).val() == '') $(e).addClass('invalid');
                });
            }

            $("#Save").click(function (e) {
                //e.preventDefault()
                validate();
                console.log($('.invalid').length);
                if ($('.invalid').length > 0 ) return false;
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
        #content #delete {
            margin-bottom: 10px;
        }
       #content .invalid {
            border-color: #A10000 ;
        }
    </style>
</head>

<body id="page">
    <a href="Summary.aspx">
        <div id="header">
            <div id="app-title">
                Inventory Management
            </div>
        </div>
    </a>
    <div id="content">
        <form id="mainForm" runat="server" autocomplete="off">
         <%--<input type="submit" id="delete" formaction="Delete.aspx" formmethod="post" value ="Delete!"/>--%>
        
            <h2>Add Item</h2>
            <div>
                <input type="hidden" id="frmDepartments" runat="server"/>
                <input type="hidden" id="frmTypes" runat="server" />
                <input type="hidden" id="frmMakes" runat="server" />
                <input type="hidden" id="frmModels" runat="server" />
                <input type="hidden" id="frmCategories" runat="server" />
                <input type="hidden" id="frmUsers" runat="server" />
                <asp:Label runat="server" ID="lblAddedMessage"></asp:Label>
                <asp:Label runat="server" ID="lblSerialNum" > Serial Number </asp:Label>
                <input type="hidden" name ="inventoryInventoryId" id="inventoryInventoryId" runat="server"/>
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
                <asp:Label runat="server" ID="lblPurchaseDate"> Purchase Date </asp:Label>
                <input runat="server" id="inventoryPurchaseDate" name="inventoryPurchaseDate" class="date required" type="text"  />
                <asp:Label runat="server" ID="lblAuxComputerDate"> Aux Computer</asp:Label>
                <input runat="server" id="inventoryAuxComputerDate" name="inventoryAuxComputerDate" class="date required" type="text" />
                <input type="submit" id="Save" value="Update" />
            </div>
        </form>
    </div>
    <div id="footer">&copy; Copyright <%= DateTime.Now.Year %> Curators of the University of Missouri</div>



</body>
</html>
