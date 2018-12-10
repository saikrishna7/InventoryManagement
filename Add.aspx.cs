using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using System.Data;

namespace inventory
{
    public partial class Add : System.Web.UI.Page
    {

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

        public string users_json;

        JavaScriptSerializer serializer = new JavaScriptSerializer();


        String GetJsonArray(String Command, String Field)
        {
            DataTable data = new inventory.DatabaseStoredProcedure(Command).ExecuteReader();
            String[] arrayToLoad = new String[data.Rows.Count];
            for (int i = 0; i < data.Rows.Count; i++)
            {
                arrayToLoad[i] = data.Rows[i][Field].ToString();
            }
            return serializer.Serialize(arrayToLoad);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Context.Session.Add("Request URI", "Add.aspx");
            var logged_in = Context.Session["DomainUser"];

            if (!(logged_in != null && (bool)logged_in == true))
                Response.Redirect("Login.aspx");

            if (Request.RequestType == "POST")
            {
                var formData = Request.Form;
                var procedure = new inventory.DatabaseStoredProcedure("[dbo].[sp_Inventory_CreateRecord]");

                foreach (var key in formData.AllKeys)
                {
                    if (!key.Contains("inventory"))
                        continue;




                    procedure.SetParameter("@" + key.Replace("inventory", ""), formData[key]);
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

            //frmDepartments.Value = GetJsonArray("sp_Get_Departments", "Department_Name");
            //frmTypes.Value = GetJsonArray("sp_Inventory_GetTypes", "Type");
            //frmMakes.Value = GetJsonArray("sp_Inventory_GetMakes", "Manuf");
            //frmModels.Value = GetJsonArray("sp_Inventory_GetModels", "Model");
            //frmCategories.Value = GetJsonArray("sp_Inventory_GetCategories", "Category_Name");

            users_json = TechServices.TSWebservices.GetAllFacStaffPhdUsers(); //Uncommneted

        }
    }
}