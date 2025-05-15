<!-- %@ page language="java" pageEncoding="UTF-8"% -->

<%@page import="com.thingworx.security.authentication.AuthenticationUtilities"%>
<%@ page import="java.io.IOException,
    java.net.URLEncoder,
    java.util.Arrays,
    java.util.List,
    javax.servlet.ServletException,
    javax.servlet.http.HttpServlet,
    javax.servlet.http.HttpServletRequest,
    javax.servlet.http.HttpServletResponse,
    org.json.JSONObject,
    org.owasp.esapi.ESAPI,
    org.slf4j.Logger,
    com.thingworx.common.RESTAPIConstants,
    com.thingworx.common.SharedConstants,
    com.thingworx.common.exceptions.InvalidRequestException,
    com.thingworx.common.utils.JSONUtilities,
    com.thingworx.common.utils.StringUtilities,
    com.thingworx.logging.LogUtilities,
    com.thingworx.metadata.collections.PropertyDefinitionCollection,
    com.thingworx.security.organizations.DefaultOrganizations,
    com.thingworx.security.organizations.Organization,
    com.thingworx.security.utils.ESAPIUtilities,
    com.thingworx.system.ThingWorxServer,
    com.thingworx.system.managers.ExtensionPackageManager,
    com.thingworx.system.managers.OrganizationManager,
    com.thingworx.system.managers.StyleDefinitionManager,
    com.thingworx.system.managers.ThingShapeManager,
    com.thingworx.webservices.BaseService,
    com.thingworx.webservices.context.HttpExecutionContext,
    com.thingworx.webservices.context.HttpExecutionContext.RequestType,
    com.thingworx.webservices.serialization.html.HTMLWriter"%>

<%
    // JSP implementation ConfirmCredentials-Purpose is to show a personalized credential form per organization
    Logger _logger = LogUtilities.getInstance().getApplicationLogger(BaseService.class);
    Logger _securityLogger = LogUtilities.getInstance().getSecurityLogger(BaseService.class);

    _logger.debug("Executing ConfirmCredentials.jsp");

    String ORGANIZATION_NAME = "OrganizationName";
    String backgroundColor1 = "#616161";
    String backgroundColor2 = "#fff";
    String foregroundColor1 = "#252525";
    String lineColor = "#ddd";
    String buttonBackgroundColor1 = "#ffffff";
    String buttonForegroundColor1 = "#252525";
    String buttonBackgroundColor2 = "#e6e6e6";
    String buttonLineColor = "#ddd";
    long lineThickness = 1;
    long buttonLineThickness = 1;

    HttpExecutionContext context = null;
    Organization myOrg = null;
    String orgName = "";
    String loginPrompt = "";


    try {
        context = new HttpExecutionContext(request,response);

        if(!ThingWorxServer.getInstance().isRunning()) {
            throw new InvalidRequestException("Thingworx Is Not Running",RESTAPIConstants.StatusCode.STATUS_SERVICE_UNAVAILABLE);
        }

        if(!context.getRequestType().equals(RequestType.HTML)) {
            throw new InvalidRequestException("This request only supports HTML output", RESTAPIConstants.StatusCode.STATUS_BAD_REQUEST);
        }

        if(_logger.isDebugEnabled()) {
            _logger.debug("Executing request [URI: {}]", ESAPIUtilities.cleanLoggedString(request.getRequestURI()));
        }

        orgName = context.getRequestContext().getCharacteristicName();

        if(StringUtilities.isNullOrEmpty(orgName)) {
            orgName = DefaultOrganizations.EVERYONE;
        }

        // TODO: look for a way to verify where the request came from

        if(_securityLogger.isWarnEnabled()) {
	        _securityLogger.warn("Reset Password clicked for [OrgName: {}]", ESAPIUtilities.cleanLoggedString(orgName));
        }

        OrganizationManager myMgr = OrganizationManager.getInstance();
        myOrg = myMgr.getEntityDirect(orgName);
        JSONObject jsonLoginStyle = null;
        JSONObject jsonLoginButtonStyle = null;

        if( myOrg != null) {
            loginPrompt = myOrg.getLoginPrompt();
            StyleDefinitionManager sdm = StyleDefinitionManager.getInstance();

            // Set style for login container
            try {
                // see if it's a named style
                jsonLoginStyle = sdm.getEntityDirect(myOrg.getLoginStyleName()).getJSONContent();
            } catch (NullPointerException npe) {
                try {
                    // try custom style if it starts with "{"
                    String customStyle = null;
                    String styleName = myOrg.getLoginStyleName();
                    if( styleName.length() > 0 && styleName.substring(0, 1).compareTo("{") == 0 ) {
                        customStyle = styleName;
                        jsonLoginStyle = JSONUtilities.readJSON(customStyle);
                    } else {
                        throw npe;
                    }
                } catch (NullPointerException npe2) {
                    try {
                        // try default style
                        jsonLoginStyle = sdm.getEntityDirect("DefaultLoginStyle").getJSONContent();
                    } catch (NullPointerException npe3) {
                        // use blank style
                        jsonLoginStyle = new JSONObject();
                    }
                }
            }

            // Set style for login button
            try {
                // see if it's a named style
                jsonLoginButtonStyle = sdm.getEntityDirect(myOrg.getLoginButtonStyleName()).getJSONContent();
            } catch (NullPointerException npe) {
                try {
                    // try custom style if it starts with "{""
                    String customStyle = null;
                    String styleName = myOrg.getLoginButtonStyleName();
                    if(styleName.length() > 0 && styleName.substring(0, 1).compareTo("{") == 0) {
                        customStyle = styleName;
                        jsonLoginButtonStyle = JSONUtilities.readJSON(customStyle);
                    } else {
                        throw npe;
                    }
                } catch (NullPointerException npe2) {
                    try {
                        // try default style
                        jsonLoginButtonStyle = sdm.getEntityDirect("DefaultLoginButtonStyle").getJSONContent();
                    } catch (NullPointerException npe3) {
                        // use blank style
                        jsonLoginButtonStyle = new JSONObject();
                    }
                }
            }

            // Set styles
            try {
                backgroundColor1 = ESAPIUtilities.customEncodeForCSS(jsonLoginStyle.getString("backgroundColor"));
            } catch( Exception e ) {}

            try {
                backgroundColor2 = ESAPIUtilities.customEncodeForCSS(jsonLoginStyle.getString("secondaryBackgroundColor"));
            } catch( Exception e ) {}

            try {
                foregroundColor1 = ESAPIUtilities.customEncodeForCSS(jsonLoginStyle.getString("foregroundColor"));
            } catch( Exception e ) {}

            try {
                lineColor = ESAPIUtilities.customEncodeForCSS(jsonLoginStyle.getString("lineColor"));
            } catch( Exception e ) {}

            try {
                lineThickness = jsonLoginStyle.getLong("lineThickness");
            } catch( Exception e ) {}

            try {
                buttonBackgroundColor1 = ESAPIUtilities.customEncodeForCSS(jsonLoginButtonStyle.getString("backgroundColor"));
            } catch( Exception e ) {}

            try {
                buttonForegroundColor1 = ESAPIUtilities.customEncodeForCSS(jsonLoginButtonStyle.getString("foregroundColor"));
            } catch( Exception e ) {}

            try {
                buttonBackgroundColor2 = ESAPIUtilities.customEncodeForCSS(jsonLoginButtonStyle.getString("secondaryBackgroundColor"));
            } catch( Exception e ) {}

            try {
                buttonLineColor = ESAPIUtilities.customEncodeForCSS(jsonLoginButtonStyle.getString("lineColor"));
            } catch( Exception e ) {}

            try {
                buttonLineThickness = jsonLoginButtonStyle.getLong("lineThickness");
            } catch( Exception e ) {}
        } else {
            throw new InvalidRequestException("The named organization " + orgName + " does not exist", RESTAPIConstants.StatusCode.STATUS_BAD_REQUEST);
        }
    } catch(InvalidRequestException ire) {
        try {
            LogUtilities.logExceptionDetails(this.getClass(), ire, context.toString(), true);
            _logger.error(context.toString() + ": " + ire.getMessage());

            response.setStatus(ire.getStatusCode().httpCode());
            if(context != null) {
                if(context.getWriter() != null) {
                    context.getWriter().write(RESTAPIConstants.StatusCode.STATUS_BAD_REQUEST.getStatusMessage());
                }
            }
        } catch(Exception ioe) {
            _logger.error("Error sending response: {}", ioe.toString(), context.toString());
        }
    } catch (Throwable exc) {
        try {
            LogUtilities.logExceptionDetails(this.getClass(), exc, context.toString(), true);
            _logger.error(context.toString() + ": " + exc.getMessage());

            response.setStatus(RESTAPIConstants.StatusCode.STATUS_INTERNAL_ERROR.httpCode());
            if(context != null) {
                if(context.getWriter() != null) {
                    context.getWriter().write(RESTAPIConstants.StatusCode.STATUS_INTERNAL_ERROR.getStatusMessage());
                }
            }
        } catch(Exception ioe) {
            _logger.error("Error sending response: {}", ioe.toString(), context.toString());
        }
    }
%>

<html>
<head>
    <title data-i18n="tw.login.labels.title-confirmation"></title>
    <meta content="text/html" http-equiv="Content-Type">
    <meta content="no-cache, no-store" http-equiv="cache-control">
    <meta content="-1" http-equiv="expires">
    <meta content="no-cache, no-store" http-equiv="pragma">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <script type="text/javascript" src="/Thingworx/Common/jquery/jquery-3.5.1.min.js"></script>

    <!-- i18next libs -->
    <script type="text/javascript" src="/Thingworx/Common/i18n/i18next.min.js"></script>
    <script type="text/javascript" src="/Thingworx/Common/i18n/i18nextXHRBackend.min.js"></script>
    <script type="text/javascript" src="/Thingworx/Common/i18n/i18next-jquery.min.js"></script>

    <script type="text/javascript" src="/Thingworx/login/LoginLocalization.js"></script>

    <style>
        body {
            font-family: Arial, Tahoma, Sans-Serif;
            font-size: 12px;
            height: 100%;
            /* Added Part */
            background-image: url('/Thingworx/FileRepositories/HKMC-RMS_PublicFileRepository/LoginBackground.png');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            color: <%=foregroundColor1%>;      /*default form login style foreground color   */
            overflow: hidden !important;
        }
        h1.orgName {
            font-size: 18px;
            font-weight: bold;
            margin: 14px 0px 0px 0px;
        }
        p.errorText {
            font-size: 12px;
            margin-top: 10px;
            background: #FF9494;
            color: black;
            font-weight: bold;
        }
        .login-container {
            background: <%=backgroundColor2%>; /*default form login style background color 2 */
            margin: 10px auto;
            width: 350px;
            padding: 15px;
            border: <%=lineThickness%>px solid <%=lineColor%>; /* default form login style line thickness, line type, & line color */
            border-radius: 6px;
            box-shadow: 1px 1px 8px rgba(0,0,0,0.1);
            top: 50%;
            position: relative;
            transform: translate(0, -50%);
        }
        .orgImage-container {
            text-align: center;
            min-height: 100px;
            display: table;
            width: 100%;
            margin-bottom: 15px;
        }
        .orgImage-container .vert-center {
            display: table-cell;
            vertical-align: middle;
        }
        .orgImage {
            max-width: 350px;
            max-height: 230px;
            height: auto;
        }
        .org-info {
            border-bottom: <%=lineThickness%> px solid <%=lineColor%>; /* default form login style line color & line thickness*/
            margin-left: -15px;
            margin-right: -15px;
            padding: 0px 15px;
            text-align: center;
            font-size: 20px;
            font-weight: bold;
        }
        .login-form, .reset-form {
            text-align: center;
        }
        .login-form, .reset-form {
            margin-bottom: 0;
        }
        .text-field {
            width: 100%;
            height: 32px;
            border: <%=lineThickness%>px solid <%=lineColor%>; /* default form login style line color & line thickness*/
            border-radius: 4px;
            margin: 10px 0px 0px 0px;
            padding: 4px 6px;
        }
        .login-buttons {
            padding: 4px 12px;
            font-size: 16px;
            border-radius: 6px;
            border: <%=buttonLineThickness%>px solid <%=buttonLineColor%>; /*defaultFormButtonStyle: lineColor, defaultFormButtonStyle: lineThickness */
            background-image: -moz-linear-gradient(top, <%=buttonBackgroundColor1%>, <%=buttonBackgroundColor2%>); /*defaultFormButtonStyle: backgroundColor1,defaultFormButtonStyle: backgroundColor2 */
            background-image: -webkit-gradient(linear, 0 0, 0 100%, from(<%=buttonBackgroundColor1%>), to(<%=buttonBackgroundColor2%>)); /*defaultFormButtonStyle: backgroundColor1,defaultFormButtonStyle: backgroundColor2  */
            background-image: -webkit-linear-gradient(top, <%=buttonBackgroundColor1%>, <%=buttonBackgroundColor2%>); /*defaultFormButtonStyle: backgroundColor1,defaultFormButtonStyle: backgroundColor2  */
            background-image: -o-linear-gradient(top, <%=buttonBackgroundColor1%>, <%=buttonBackgroundColor2%>); /*defaultFormButtonStyle: backgroundColor1,defaultFormButtonStyle: backgroundColor2  */
            background-image: linear-gradient(to bottom, <%=buttonBackgroundColor1%>, <%=buttonBackgroundColor2%>); /*defaultFormButtonStyle: backgroundColor1,defaultFormButtonStyle: backgroundColor2  */
            margin: 10px;
            color: <%=buttonForegroundColor1%>; /*defaultFormButtonStyle: foregroundColor  */
        }
    </style>

    <link type="text/css" rel="stylesheet" href="/Thingworx/Runtime/css/mashup-runtime.css" />
</head>
<body>
    <div class="login-container">
        <div class="tw-status-msg-box" style="display:none;">
            <div class="status-label" data-i18n="tw.login.labels.status-label"></div>
            <div class="close-sticky">
                <span class="close-sticky-btn" data-i18n="tw.login.buttons.dismiss"></span>
            </div>
            <div class="status-msg-container">
                <div class="status-msg">
                    <div id="status-msg-text"></div>
                </div>
            </div>
        </div>
        <div class="orgImage-container">
            <div class="vert-center">
<%
    // change this image with the image that comes from the org
    // if the image is not set, don't put the img element in
    int myint = 0;
    try {
        myint = myOrg.getLoginImage().length;
    } catch (Exception e) {
        myint = 0;
    }
    if (myint > 1) {
%>
                <img class="orgImage" src="/Thingworx/OrganizationLogoViewer/<%=URLEncoder.encode(orgName, RESTAPIConstants.UTF8_ENCODING)%>">
<%  }%>
            </div>
        </div>
        <div class="org-info">
            <p class="orgDescription" data-i18n="tw.login.labels.confirm-credentials-description"></p>
        </div>
        <div class="login-form">

            <%--changed to absolute path to fix customer issue--%>
            <form method="POST" action="/<%=RESTAPIConstants.WEBAPP_NAME%>/<%=RESTAPIConstants.ACTION_CONFIRM%>">
                <input id="thingworx-form-userid" class="text-field" type="TEXT" name="thingworx-form-userid" value="" data-i18n="[placeholder]tw.login.labels.user-id">
                <input id="thingworx-form-email" class="text-field" type="TEXT" name="thingworx-form-email" value="" data-i18n="[placeholder]tw.login.labels.email-address">
                <input class="login-buttons" type="button" name="Cancel" data-i18n="[value]tw.login.buttons.cancel" onclick="window.location.href = '/<%=RESTAPIConstants.WEBAPP_NAME%>/FormLogin/<%=URLEncoder.encode(orgName, RESTAPIConstants.UTF8_ENCODING)%>';">
                <input class="login-buttons" type="submit" name="Login" data-i18n="[value]tw.login.buttons.submit">
                <%@include file="ErrorMessage.jsp" %>
                <%@include file="FormCSRFCookie.jsp" %>
                <input type="hidden" name="<%=ESAPIUtilities.getEncoder().encodeForHTMLAttribute(RESTAPIConstants.PARAM_USE_SESSION)%>" value="true">
                <input type="hidden" name="OrganizationName" value="<%=ESAPIUtilities.getEncoder().encodeForHTMLAttribute(orgName)%>">
            </form>
        </div>
    </div>

    <script type="text/javascript">
        function hasPlaceholderSupport() {
            var input = document.createElement('input');
            return ('placeholder' in input);
        }
        if(!hasPlaceholderSupport()){
            var inputs = document.getElementsByTagName('input');
            for(var i=0,  count = inputs.length;i<count;i++){
                if(inputs[i].getAttribute('placeholder')){
                    inputs[i].style.cssText = "color:#939393;font-style:italic;";
                    inputs[i].value = inputs[i].getAttribute('placeholder');
                    inputs[i].onclick = function(){
                        if(this.value == this.getAttribute("placeholder")){
                            this.value = '';
                            this.style.cssText = "color:#000;font-style:normal;";
                        }
                    };
                    inputs[i].onblur = function(){
                        if(this.value == ''){
                            this.value = this.getAttribute("placeholder");
                            this.style.cssText = "color:#939393;font-style:italic;";
                        }
                    };
                }
            }
        }

        TW.LoginLocalization.init();
    </script>

</body>
</html>
