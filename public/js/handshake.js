function handshake()
{
  var loc = document.location;
  //get the correct port
  var port = loc.port == "" ? (loc.protocol == "https:" ? 443 : 80) : loc.port;
  var host = loc.hostname;
  var protocol = loc.protocol;

  if (etherpadServerConfig != undefined && etherpadServerConfig != null) {
      port = etherpadServerConfig['port'];
      host = etherpadServerConfig['host'];
      protocol = etherpadServerConfig['protocol'] + ":";
  }

  //create the url
  var url = protocol + "//" + host + ":" + port + "/";
  //find out in which subfolder we are
  var resource = loc.pathname.substr(1, loc.pathname.indexOf("/p/")) + "socket.io";
  //connect
  socket = io.connect(url, {
    resource: resource
  });

  socket.once('connect', function()
  {
    var padId = document.location.pathname.substring(document.location.pathname.lastIndexOf("/") + 1);
    padId = unescape(padId); // unescape neccesary due to Safari and Opera interpretation of spaces

    document.title = document.title + " | " + padId;

    var token = readCookie("token");
    if (token == null)
    {
      token = randomString();
      createCookie("token", token, 60);
    }
    
    var sessionID = readCookie("sessionID");
    var password = readCookie("password");

    var msg = {
      "component": "pad",
      "type": "CLIENT_READY",
      "padId": padId,
      "sessionID": sessionID,
      "password": password,
      "token": token,
      "protocolVersion": 2
    };
    socket.json.send(msg);
  });

  var receivedClientVars = false;
  var initalized = false;

  socket.on('message', function(obj)
  {
    //the access was not granted, give the user a message
    if(!receivedClientVars && obj.accessStatus)
    {
      if(obj.accessStatus == "deny")
      {
        $("#editorloadingbox").html("<b>You do not have permission to access this pad</b>");
      }
      else if(obj.accessStatus == "needPassword")
      {
        $("#editorloadingbox").html("<b>You need a password to access this pad</b><br>" +
                                    "<input id='passwordinput' type='password' name='password'>"+
                                    "<button type='button' onclick='savePassword()'>ok</button>");
      }
      else if(obj.accessStatus == "wrongPassword")
      {
        $("#editorloadingbox").html("<b>You're password was wrong</b><br>" +
                                    "<input id='passwordinput' type='password' name='password'>"+
                                    "<button type='button' onclick='savePassword()'>ok</button>");
      }
    }
    
    //if we haven't recieved the clientVars yet, then this message should it be
    else if (!receivedClientVars)
    {
      //log the message
      if (window.console) console.log(obj);

      receivedClientVars = true;

      //set some client vars
      clientVars = obj;
      clientVars.userAgent = "Anonymous";
      clientVars.collab_client_vars.clientAgent = "Anonymous";

      //initalize the pad
      pad.init();
      initalized = true;

      // If the LineNumbersDisabled value is set to true then we need to hide the Line Numbers
      if (LineNumbersDisabled == true)
      {
        pad.changeViewOption('showLineNumbers', false);
      }
      // If the Monospacefont value is set to true then change it to monospace.
      if (useMonospaceFontGlobal == true)
      {
        pad.changeViewOption('useMonospaceFont', true);
      }
      // if the globalUserName value is set we need to tell the server and the client about the new authorname
      if (globalUserName !== false)
      {
        pad.notifyChangeName(globalUserName); // Notifies the server
        $('#myusernameedit').attr({"value":globalUserName}); // Updates the current users UI
      }
    }
    //This handles every Message after the clientVars
    else
    {
      //this message advices the client to disconnect
      if (obj.disconnect)
      {
        padconnectionstatus.disconnected(obj.disconnect);
        socket.disconnect();
        return;
      }
      else
      {
        pad.collabClient.handleMessageFromServer(obj);
      }
    }
  });

  // Bind the colorpicker
  var fb = $('#colorpicker').farbtastic({ callback: '#mycolorpickerpreview', width: 220});
}