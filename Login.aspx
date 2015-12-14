<%@ Page Language="C#" %>

<%@ Import Namespace="System.DirectoryServices" %>

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

    <script runat="server">
            protected void Login_Click(object sender, EventArgs e)
            {
                LoginUser(txtUserName.Text, txtPassword.Text);
            }
            protected void Page_Load(object sender, EventArgs e)
            {
                var logged_in = Context.Session["DomainUser"];
                if (logged_in != null && (bool)logged_in == true) {
                    if (Context.Session["Request URL"] != null)
                    {
                        Response.Redirect(Context.Session["Request URL"].ToString());
                    }
                    else
                    {
                        Response.Redirect("Summary.aspx");
                    }
                }
                
            }
            
            public int LoginUser(string username, string password)
            {
                string ldapServer = "GC://col.missouri.edu";
                string[] userDomains = null;
                string userDomain = "umc-users|tigers";

                if (userDomain != String.Empty || userDomain.Trim() != "")
                {
                    userDomains = userDomain.Split(new Char[] { '|', ';', ':' });
                    for (int i = 0; i < userDomains.Length; i++)
                    {
                        userDomains[i] = userDomains[i].ToLower().Trim();
                    }
                }
                HttpContext Context = HttpContext.Current;
                int retVal = -1;
                Context.Session.Add("DomainUser", false);
                if (ldapServer != String.Empty && userDomains != null)
                {
                    string filterAttribute = String.Empty;
                    string domainAndUsername = String.Empty;

                    string[] domains = userDomains;
                    int i = 0;
                    while (i <= domains.Length - 1 && retVal != 0)
                    {
                        try
                        {
                            domainAndUsername = domains[i] + "\\" + username;

                    
                            DirectoryEntry entry = new DirectoryEntry(ldapServer, domainAndUsername, password);
                            using (entry)
                            {
                                try
                                {
                                    // force an authentication
                                    object obj = entry.NativeObject;
                                    Context.Session.Add("DomainUser", true);
                                    retVal = 0;
                                    Response.Redirect("Summary.aspx");
                                    errorLabel.Text = "Loading"; //ex.ToString();
                                }
                                catch (Exception ex)
                                {
                                    errorLabel.Text = "An error occurred while trying to login, please try again.<br><br>"; //ex.ToString();
                                    retVal = 2;
                                }
                                finally
                                {
                                    entry.Close();
                                }
                            }
                        }
                        catch (Exception ex)
                        {
                            retVal = 2;
                            errorLabel.Text = "We were unable to log you in, please try again.<br><br>"; // + ex.ToString();
                        }
                        i++;
                    }
                }
                return retVal;
            }
    </script>
</head>
<body id="page">
    <div id="header">
        <div id="app-title">
            Inventory Management
            <span></span>
        </div>
    </div>
    <div id="content">
        <form id="form1" runat="server">
            <div id="login-form">

                <asp:Label runat="server" ID="lblUserName">USERNAME</asp:Label><br />
                <asp:TextBox runat="server" ID="txtUserName"></asp:TextBox><br />
                <br />
                <asp:Label runat="server" ID="lblPassword">PASSWORD</asp:Label><br />
                <asp:TextBox runat="server" ID="txtPassword" TextMode="Password"></asp:TextBox><br />
                <br />
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ErrorMessage="Please enter your password" ControlToValidate="txtPassword" CssClass="error" ForeColor="" ValidationGroup="Submit"></asp:RequiredFieldValidator>
                <br />
                <asp:Button runat="server" ID="btnLogin" Text="LOGIN" OnClick="Login_Click" />

                <asp:Label runat="server" ID="errorLabel"></asp:Label>

            </div>
        </form>
    </div>
    <div id="footer">&copy; Copyright <%= DateTime.Now.Year %> Curators of the University of Missouri</div>
</body>
</html>
