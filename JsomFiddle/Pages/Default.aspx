<!DOCTYPE html>
<%@ Page language="C#" Inherits="Microsoft.SharePoint.WebPartPages.WebPartPage, Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>

<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
    <title>JSOM Fiddle</title>
    <link href="../Content/themes/base/jquery-ui.css" rel="stylesheet" />
    <link href="../Content/listbox.css" rel="stylesheet" />
    <link href="../Content/layout.css" rel="stylesheet" />
    <link href="../Content/themes/flick/jquery.ui.theme.css" rel="stylesheet" />
    <link href="../Scripts/jquery.toast/jquery.toast.min.css" rel="stylesheet" />
    <!--[if lt IE 10]>
	    <link rel="stylesheet" type="text/css" href="../content/IE9.css" />
    <![endif]-->

    <script type="text/javascript" src="../Scripts/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="/_layouts/15/MicrosoftAjax.js"></script>
    <script type="text/javascript" src="/_layouts/15/1033/strings.js"></script>
    <script type="text/javascript" src="/_layouts/15/init.js"></script>
    <script type="text/javascript" src="/_layouts/15/core.js"></script>
    <script type="text/javascript" src="/_layouts/15/sp.runtime.js"></script>
    <script type="text/javascript" src="/_layouts/15/SP.search.js"></script>
    <script type="text/javascript" src="/_layouts/15/sp.ui.dialog.js"></script>
    <script type="text/javascript" src="/_layouts/15/sp.js"></script>

    <script src="../Scripts/jquery-ui-1.10.4.min.js"></script>
    <script src="../Scripts/jquery.format.js"></script>
    <!-- Add your JavaScript to the following file -->
    <script type="text/javascript" src="../Scripts/App/App.min.js"></script>
    <script src="../scripts/src/ace.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/jquery-ui-1.10.4.min.js"></script>
    <script src="../Scripts/listbox.js"></script>
    <script src="../Scripts/jquery.toast/jquery.toast.min.js"></script>
    <script src="../Scripts/layout.js"></script>
    <script src="../Scripts/jquery.easytabs.min.js"></script>

<style type="text/css" media="screen">
    #jsEditor, #htmlEditor { 
        width:100%;
        height:100%;
        position:relative;
        top:0;
    }

</style>

<style type="text/css">
	p				{ margin:		1em 0; }

	/* use !important to override UI theme styles */
	.grey			{ background:	#999 !important; }
	.outline		{ /*border:		1px dashed #F00 !important;*/ }
	.add-padding	{ padding:		10px !important; }
	.no-padding		{ padding:		0 !important; }
	.add-scrollbar	{ overflow:		auto; }
	.no-scrollbar	{ overflow:		hidden; }
	.allow-overflow	{ overflow:		visible; }
	.full-height	{ height:		100%; }
	button			{ cursor:		pointer; }

    .myList{
        margin:0;
        padding:0;
        list-style:none;
    }

    .myList li{
        cursor:default;
        font-size:0.7em;
        padding-bottom:6px;
        padding-top:4px;
        
        width:100%;
    }
        .myList li:hover {
            background-color:silver;
        }

#tabs .tabs-spacer { float: left; height: 200px; }

  .tabs-bottom .ui-tabs-nav { clear: left; padding: 0 .2em .2em .2em; background-image:none; }

  .tabs-bottom .ui-tabs-nav li { top: auto; bottom: 0; margin: 0 .2em 1px 0; border-bottom: auto; margin-left:-4px; border-top: 0; margin-top: -3px;  }

  .tabs-bottom .ui-tabs-nav li.ui-tabs-active { margin-top: -3px; padding-top: 1px; }
  .tabs-bottom .ui-tabs-nav li a { font-size:10pt; padding-left:4px !important; padding-right:4px !important; padding-top:2px !important; padding-bottom:2px !important; }

  .tabs-bottom .ui-tabs-nav li.ui-tabs-active a { font-weight:bold !important; }
  .tabs-bottom .ui-tabs-nav li a { color:black !important; font-weight:normal; }

</style>

    <script type="text/javascript">
        'use strict';

        // Set the style of the client web part page to be consistent with the host web.
        //(function () {
        //    var hostUrl = '';
        //    if (document.URL.indexOf('?') != -1) {
        //        var params = document.URL.split('?')[1].split('&');
        //        for (var i = 0; i < params.length; i++) {
        //            var p = decodeURIComponent(params[i]);
        //            if (/^SPHostUrl=/i.test(p)) {
        //                hostUrl = p.split('=')[1];
        //                document.write('<link rel="stylesheet" href="' + hostUrl + '/_layouts/15/defaultcss.ashx" />');
        //                break;
        //            }
        //        }
        //    }
        //    if (hostUrl == '') {
        //        document.write('<link rel="stylesheet" href="/_layouts/15/1033/styles/themable/corev15.css" />');
        //    }
        //})();
    </script>

	<script type="text/javascript">
	    (function (c) { var a = c.layout; a.callbacks || (a.callbacks = {}); a.callbacks.resizePaneAccordions = function (a, b) { (b.jquery ? b : c(b.newPanel || b.panel)).find(".ui-accordion:visible").each(function () { var a = c(this); a.data("accordion") && a.accordion("resize"); a.data("ui-accordion") && a.accordion("refresh") }) } })(jQuery);
	    (function (c) { var a = c.layout; a.callbacks || (a.callbacks = {}); a.callbacks.resizeTabLayout = function (a, b) { (b.jquery ? b : c(b.newPanel || b.panel)).filter(":visible").find(".ui-layout-container:visible").andSelf().each(function () { var a = c(this).data("layout"); a && (a.options.resizeWithWindow = !1, a.resizeAll()) }) } })(jQuery);
	    function toggleLiveResizing() {
	        $.each($.layout.config.borderPanes, function (i, pane) {
	            var o = myLayout.options[pane];
	            o.livePaneResizing = !o.livePaneResizing;
	        });
	    };

	    function toggleStateManagement(skipAlert, mode) {
	        if (!$.layout.plugins.stateManagement) return;

	        var options = myLayout.options.stateManagement
            , enabled = options.enabled // current setting
	        ;
	        if ($.type(mode) === "boolean") {
	            if (enabled === mode) return; // already correct
	            enabled = options.enabled = mode
	        }
	        else
	            enabled = options.enabled = !enabled; // toggle option

	        if (!enabled) { // if disabling state management...
	            myLayout.deleteCookie(); // ...clear cookie so will NOT be found on next refresh
	            if (!skipAlert)
	                alert('This layout will reload as the options specify \nwhen the page is refreshed.');
	        }
	        else if (!skipAlert)
	            alert('This layout will save & restore its last state \nwhen the page is refreshed.');

	        // update text on button
	        var $Btn = $('#btnToggleState'), text = $Btn.html();
	        if (enabled)
	            $Btn.html(text.replace(/Enable/i, "Disable"));
	        else
	            $Btn.html(text.replace(/Disable/i, "Enable"));
	    };

	    // set EVERY 'state' here so will undo ALL layout changes
	    // used by the 'Reset State' button: myLayout.loadState( stateResetSettings )
	    var stateResetSettings = {
	        north__size: "auto"
        , north__initClosed: false
        , north__initHidden: false
        , south__size: "auto"
        , south__initClosed: false
        , south__initHidden: false
        , west__size: 300
        , west__initClosed: false
        , west__initHidden: false
	    };

	    var myLayout;

	    $(document).ready(function () {

	        // this layout could be created with NO OPTIONS - but showing some here just as a sample...
	        // myLayout = $('body').layout(); -- syntax with No Options

	        myLayout = $('body').layout({

	            //	reference only - these options are NOT required because 'true' is the default
	            closable: true	// pane can open & close
            , resizable: true	// when open, pane can be resized 
            , slidable: true	// when closed, pane can 'slide' open over other panes - closes on mouse-out
            , livePaneResizing: true
            , south__maskContents: true
            , south__closable: false
	            //	some resizing/toggling settings
            , north__size: 44	// OVERRIDE the pane-default of 'slidable=true'
            , north__slidable: false	// OVERRIDE the pane-default of 'slidable=true'
            , north__resizable: false	// OVERRIDE the pane-default of 'slidable=true'
            , north__togglerLength_closed: '100%'	// toggle-button is full-width of resizer-bar
            , north__spacing_closed: 20		// big resizer-bar when open (zero height)
            , south__resizable: true	// OVERRIDE the pane-default of 'resizable=true'
            , north__spacing_open: 0		// no resizer-bar when open (zero height)
            , north__spacing_closed: 20		// big resizer-bar when open (zero height)

	        //	some pane-size settings
            , west__minSize: 100
            , center__minWidth: 100
            , east__onresize: $.layout.callbacks.resizeTabLayout
	        //	some pane animation settings
            , west__animatePaneSizing: false
            , west__fxSpeed_size: "fast"	// 'fast' animation when resizing west-pane
            , west__fxSpeed_open: 1000	// 1-second animation when opening west-pane
            , west__fxSettings_open: { easing: "easeOutBounce" } // 'bounce' effect when opening
            , west__fxName_close: "none"	// NO animation when closing west-pane
	        //	enable showOverflow on west-pane so CSS popups will overlap north pane
            , west__showOverflowOnHover: true
	        //	enable state management
            , stateManagement__enabled: true // automatic cookie load & save enabled by default

            , showDebugMessages: true // log and/or display messages from debugging & testing code
	        , east: {
	            size: 250
		        , spacing_closed: 24		// wider space when closed
		        , togglerLength_closed: 24			// make toggler 'square' - 21x21
		        , togglerAlign_closed: "top"		// align to top of resizer
		        , togglerLength_open: 0 			// NONE - using custom togglers INSIDE east-pane
		        , togglerTip_open: "Close East Pane"
		        , togglerTip_closed: "Open East Pane"
		        , resizerTip_open: "Resize East Pane"
		        , slideTrigger_open: "mouseover"
		        , initClosed: false
	            //	override default effect, speed, and settings
		        , fxName: "drop"
		        , fxSpeed: "normal"
		        , fxSettings: { easing: "" } // nullify default easing
                , togglerContent_closed: "<div style='text-align:center;background-color:rgb(221, 221, 221);padding:2px'><img src='../content/buttons/arrowhead-left.png' class='eastOpenArrow' style='width:20;height:20'></img></div>"
	        }
                , center: {
                    onresize_end: function () {
                        var jsEditor = ace.edit("jsEditor");
                        jsEditor.resize();
                    }
                }
                , west: {
                    onresize_end: function () {
                        var editor = ace.edit("htmlEditor");
                        editor.resize();
                    }
                }
	        });

	        var eastSelector = "body > .ui-layout-east"; // outer-east pane
	        // CREATE SPANs for pin-buttons - using a generic class as identifiers
	        $("<div><img src='../content/buttons/pin.png' style='width:16px;height:16px;position:absolute;left:3px;margin:3px;'/></div><span>&nbsp;</span>").addClass("pin-button").prependTo(eastSelector);
	        // BIND events to pin-buttons to make them functional
	        myLayout.addPinBtn(eastSelector + " .pin-button", "east");
	        // CREATE SPANs for close-buttons - using unique IDs as identifiers
	        $("<span><img src='../content/buttons/close.png' style='width:16px;height:16px;position:absolute;right:5px;margin:3px'/></span>").attr("id", "east-closer").prependTo(eastSelector);
	        // BIND layout events to close-buttons to make them functional
	        myLayout.addCloseBtn("#east-closer", "east");

	        // if there is no state-cookie, then DISABLE state management initially
	        //
	        var cookieExists = !$.isEmptyObject(myLayout.readCookie());
	        //if (!cookieExists) toggleStateManagement(true, false);
	        //$("#toolbox").accordion({ heightStyle: "fill" });
	        myLayout.panes.east.tabs();
	        $(".tabs-bottom .ui-tabs-nav, .tabs-bottom .ui-tabs-nav > *")
              .removeClass("ui-corner-all ui-corner-top")
              .addClass("ui-corner-bottom");
	        // move the nav to the bottom
	        $(".tabs-bottom .ui-tabs-nav").appendTo(".tabs-bottom");
	        setTimeout(myLayout.resizeAll, 50);

	        //$(".ui-layout-toggler-east-closed").html("<img src='../content/buttons/arrowhead-left.png' style='width:20;height:20'></img>");

	    });

	</script>

</head>
<body>

<!-- manually attach allowOverflow method to pane -->
<div class="ui-layout-north no-padding">
    <a href="#" id="backToSiteButton" style="text-decoration:none" title="Return to host site">
        <img src='../content/buttons/arrowhead-left.png' style='width:32px;height:32px; padding:3px;'/>
    </a>
    &nbsp;&nbsp;&nbsp;
    <a href="#" id="executeButton" style="text-decoration:none" title="Run script">
        <img src='../content/buttons/media-play.png' style='width:32px;height:32px; padding:3px;'/>
    </a>
    <a href="#" id="saveButton" style="text-decoration:none" title="Save script">
        <img src='../content/buttons/save.png' style='width:32px;height:32px; padding:3px;'/>
    </a>
    <a href="#" id="exportButton" style="text-decoration:none" title="Export script">
        <img src='../content/buttons/data-export.png' style='width:32px;height:32px; padding:3px;'/>
    </a>
    <a href="#" id="importButton" style="text-decoration:none" title="Import scripts">
        <img src='../content/buttons/data-import.png' style='width:32px;height:32px; padding:3px;'/>
    </a>
    <a href="#" id="helpButton" style="text-decoration:none;position:absolute;right:2px" title="Help">
        <img src='../content/buttons/help.png' style='width:32px;height:32px; padding:3px;'/>
    </a>

    <h1 style="position:absolute;top:-19px;display:inline;margin-left:30px">JSOM Fiddle</h1>
</div>

<!-- allowOverflow auto-attached by option: west__showOverflowOnHover = true -->
<div class="ui-layout-west no-padding">
    <div id="htmlEditor">&lt;div id='title'&gt;HTML HERE&lt;/div&gt;</div>
</div>

<div class="ui-layout-south">
    <iframe id="results" src="tempscripts/results.html" style="width:100%;height:100%;border:none;"></iframe>
</div>

<div  class="ui-layout-east no-padding no-scrollbar tabs-bottom" id="tabs-bottom">
    <ul class="allow-overflow">
        <li><a href="#samplesTab">Samples</a></li>
        <li><a href="#savedTab">Saved</a></li>
    </ul>
	<div class="ui-layout-content ui-widget-content no-scrollbar" style="border-top: 0;">
    <div id="samplesTab" class="full-height no-padding add-scrollbar">
            <div id="samplesList"></div>
    </div>
    <div id="savedTab"  class="full-height no-padding add-scrollbar">
            <div id="savedList"></div>
    </div>
        </div>
</div>

<div class="ui-layout-center no-padding">
    <div id="jsEditor">  var ctx = SP.ClientContext.get_current();
  var web = ctx.get_web();
  ctx.load(web);
  ctx.executeQueryAsync(
    function (s, a) // Success
    {
      $('#title').text(web.get_title());
    },
    function (s, e) // Error
    {
      alert(e.get_message());
  });</div>
    <div style="background-color:black;position:absolute;right:0;top:0;border:1px solid silver;color:silver;margin-top:5px; margin-right:22px;padding:3px;display:none;font-size:0.75em" id="fiddleName"></div>
</div>

<div id="dialog-help" title="Help" style="display:none">
    <ul style="list-style: none; margin-left: -40px;">
        <li>Ctrl+S saves the script and Ctrl+R will execute the scrpt.</li><br />
        <li>To break into the debugger add a line to the code with a 'debugger;' statement. 
            Also ensure you have the developer tools open and the debugger attached.</li><br />
        <li>Additional samples can be imported from http://www.codexpoint.com/jsomsamples.txt. Samples can be loaded from any Url provided they were
            exported in the correct JSON format from the JSOM Fiddle App.
        </li>
    </ul>

    <input type="button" class="close-button" value="Close" />
</div>

<div id="dialog-noaccess" title="Permissions" style="display:none">

    <p>
        You do not have the correct permissions to use JSOM Fiddle. <br /><br />
    </p>

    <p>
        You will be re-directed back to the host site.
    </p>
    <input type="button" class="naclose-button" value="Close" />
</div>

<div id="dialog-save" title="Save script" style="display:none">

    <input type="text" id="saveTitle" style="width:100%;font-size:0.8em"/>
    <br /><br />

    <input type="button" class="save-button" value="Save"/>
    <input type="button" class="close-button" value="Close"/>
</div>

<div id="dialog-import" title="Import scripts" style="display:none">

    <label for="importUrl" style="font-size:0.8em">Enter url to the sample scripts</label>
    <input type="url" id="importUrl" style="width:100%;font-size:0.8em" value="http://www.codexpoint.com/jsomsamples.txt"/>
    <br /><br />
    <select id="importType" style="font-size:0.8em">
        <option value="0">Add to sample scripts</option>
        <option value="1">Add to saved scripts</option>
    </select>
    <br /><br />

    <input type="button" class="import-button" value="Import"/>
    <input type="button" class="close-button" value="Close"/>
</div>

<div id="dialog-ie8" title="Sorry" style="display:none">

    <p>
        Unfortunately JSOM Fiddle is not compatible with IE8 and below.<br /><br />
    </p>

    <p>
        You will be re-directed back to the host site.
    </p>
    <input type="button" class="naclose-button" value="Close" />
</div>

    <!--[if lt IE 9]>
        <script>
            $("#dialog-ie8").dialog({
                resizable: false,
                height: 250,
                width: 520,
                modal: true
            });
        </script>
    <![endif]-->

</body>


</html>
