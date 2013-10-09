<%@ page session="true" %>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page import ="org.apache.commons.httpclient.*" %>
<%@ page import ="org.apache.commons.httpclient.methods.PostMethod" %>
<%@ page import ="org.apache.commons.httpclient.protocol.Protocol" %>
<%@ page import ="socketfactory.SimpleSSLSocketFactory" %>
<%@ page import="com.radishsystems.choiceview.webapi.*" %>
<%!
@SuppressWarnings("deprecation")
%>
<%
            /* do not want jsp content cached */
            response.setHeader("Cache-Control", "no-store");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "1");

            /* set the content type */
            response.setContentType("text/ecmascript; charset=UTF-8");
            
            /*
            * Dump out request parameters just to see what they are
            * since this is a sample application.
            */
            Enumeration hnames = request.getHeaderNames();
            while (hnames.hasMoreElements()) {
            	String name = (String) hnames.nextElement();
            	String value = request.getHeader(name);
            	System.out.println("header :" + name + "  as -> " + value);
            }

            Enumeration names = request.getParameterNames();
            while (names.hasMoreElements()) {
            	String name = (String) names.nextElement();
            	String value = request.getParameter(name);
            	System.out.println("Parameter :" + name + "  value -> " + value);
            }
            System.out.println("Query String :" + request.getQueryString());
            
            /*
             * passed in ANI
             */
            String dialogname = "''";
            String returnVal = "'OKAY'";
            String networkQuality = "''";
            
            String callerId = request.getParameter("callerID");
            String callId = request.getParameter("in_connectionid");
            String sessionURL = request.getParameter("myURL");//return URL for control messages
            String sessionID = request.getParameter("sessionID"); //ccxml session id
            
            String keystoreLocation = request.getParameter("keystoreLocation");
            String keystorePassword= request.getParameter("keystorePassword");
            
            String cvHost= request.getParameter("cvHost");
            String cvHostUser= request.getParameter("cvHostUser");
            String cvHostPassword= request.getParameter("cvHostPassword");
            
            String localIP = request.getServerName();
            
            String localURL = request.getRequestURL().toString();
            URL url = new URL (localURL);
            
            if (localURL.startsWith("https://") == true || sessionURL.startsWith("https://") == true) {
            	/* !!!!!  You must alter this for your environment. !!!!! */
            	URL	keystoreUrl = new URL(keystoreLocation);
            	
            	Protocol.registerProtocol("https", new Protocol("https", new SimpleSSLSocketFactory(keystoreUrl, keystorePassword), url.getPort()));
            }

            HttpClient client = new HttpClient();
            client.getHttpConnectionManager().getParams().setConnectionTimeout(30000);
                 
            //Add the CCXML session id to the URL for control messages to be sent
            //sessionURL = sessionURL + "?sessionid=" + sessionID;
            System.out.println(new java.util.Date() + " sessionURL: " + sessionURL);
            
            int cvSessionID = 0;
            ChoiceViewSession CVS = null;

    		try {
    			CVS = new ChoiceViewSession(cvHost, cvHostUser, cvHostPassword);
    			
    			System.out.println(new java.util.Date() + " ChoiceViewSession object created ");
    			System.out.format(" callerId is %s, callId is %s\n", callerId, callId);
    			System.out.println(" ChoiceViewSession controlmessage URL: " + sessionURL);
   
    			//if(CVS.startSession(callerId, callId, sessionURL, sessionURL, "CCXML")){
    			if(CVS.startSession(callerId, callId)){
    				
    				System.out.println(new java.util.Date() + " Choice View session started");
    				
    				cvSessionID = CVS.getSessionId();
    				System.out.format("Choice View sessionID %d\n", cvSessionID);
    				System.out.println("Choice View hashCode: " + CVS.hashCode()); 
    				
    				networkQuality = CVS.getNetworkQuality();
    				
    				System.out.println("Choice View Session status: " + CVS.getStatus()); 
    				
    				com.radish.choiceview.ChoiceViewServlet.addSession(Integer.toString(cvSessionID), CVS, sessionURL, sessionID);
    				
    				//send the main menu html to the mobile device
    				CVS.sendUrl("http://cvnet.radishsystems.com/choiceview/ivr/openmethods_main_menu.html");
    				
    				//get the hash to store the CVS session
    				HashMap map = (HashMap)application.getAttribute("CVSHash");
    				if(map == null){
    					//the hash hasn't been created yet, so create the new hash and add it to the 
    					//application session
    					map = new HashMap<String, ChoiceViewSession>();	
    				}
   					map.put(callId, CVS);
    				application.setAttribute("CVSHash", map); 
    				
    				
    				//this is for debugging purposes
    				Map<String, String> properties = CVS.getProperties();
    				if(properties == null) {
    					System.err.println("Cannot get session properties!");
    				} else {
    					System.out.println("Session Properties:");
    					System.out.println("Session Properties size:" + properties.size());
    					for(Entry<String, String> property : properties.entrySet()) {
    						System.out.println("\t" + property.getKey() + ": " + property.getValue());
    					}
    					System.out.println();
    				}
    				
    			}else{
    				
    				System.out.println("Choice View session not Started. Choice View Session status: " + CVS.getStatus()); 
    				
    				//Return the disconnect page if we couldn't create a session
    				if("disconnected".equalsIgnoreCase(CVS.getStatus())){
    					returnVal = "'DISCONNECTED'";
    				}
    			}
    			   		
    		} catch (Exception e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		}
            
           
%>
result = <%=returnVal%>; 
dialogname=<%=dialogname%>;
cvSessionID=<%=cvSessionID%>;
networkQuality=<%=networkQuality%>
<%
//request.getSession().invalidate();
%>