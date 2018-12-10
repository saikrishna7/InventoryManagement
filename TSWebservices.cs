using System;
using System.IO;
using System.Net;
using System.Web.Script.Serialization;

namespace TechServices
{
    public class TSWebservices
    {
        string[] arr;
        public static string GetAllFacStaffPhdUsers()
        {
            var url = "https://apps.business.missouri.edu/services/ldap/get_fac_staff_phd_users.php?API_KEY=V2hkLZ00Lju6483lfHX1hcypC587tX7B";
            WebRequest get_req = WebRequest.Create(url);
            Stream res_stream;
            res_stream = get_req.GetResponse().GetResponseStream();
            StreamReader res = new StreamReader(res_stream);
            string cur_line = "";
            
            string body = "";
            int i = 0;
            while (cur_line != null)
            {
                i++;
                cur_line = res.ReadLine();
                body += cur_line;
            }
            return body;
        }
    }
}