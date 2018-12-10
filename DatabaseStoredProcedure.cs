using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

namespace inventory
{
    public class DatabaseStoredProcedure
    {

        public string ProcedureName { get; set; }
        private Dictionary<string, string> Parameters;

        //private static string Connectionstring = "server=;Integrated Security = True;DATABASE=InventoryDB;";
                                                    //"SERVER=sql2005.iats.missouri.edu;Integrated Security = True;DATABASE=MU_BUS_TechServices_1;";

        private static string Connectionstring = System.Configuration.ConfigurationManager.ConnectionStrings["TCOBInventoryDBEntities"].ConnectionString;
        private static SqlConnection Connection = null;
        private SqlCommand Command;

        public DatabaseStoredProcedure(string procedureName)
        {
            Initialize(procedureName);
        }

        public DatabaseStoredProcedure()
        {
            Initialize();
        }

        public void SetParameter(string paramName, string value)
        {
            Command.Parameters.AddWithValue(paramName, value);
        }

        public DataTable ExecuteReader()
        {
            DataTable Data = new DataTable();
            Data.Load(Command.ExecuteReader());
            return Data;
        }

        public int ExecuteNonReader()
        {
            return Command.ExecuteNonQuery();
        }

        private void Initialize(string procName)
        {
            Initialize();
            Command.CommandText = procName;
        }

        private void Initialize()
        {
            if (Connection == null)
            {
                Connection = new SqlConnection(Connectionstring);
                Connection.Open();
            }
            Command = new SqlCommand();
            Command.Connection = Connection;
            Command.CommandType = CommandType.StoredProcedure;
            Parameters = new Dictionary<string, string>();
        }
    }
}