var JsomFiddle;
(function (JsomFiddle) {
    var App = (function () {
        function App() {
            this.isDirty = false;
            this.template = "";
            this.executingToast = null;
            this.saveDlg = null;
        }
        App.prototype.init = function () {
            var me = this;
            var workerModule = ace.require("ace/worker/worker_client");
            workerModule.WorkerClient = workerModule.UIWorkerClient;

            $(window).bind('keydown', function (event) {
                if (event.ctrlKey || event.metaKey) {
                    switch (String.fromCharCode(event.which).toLowerCase()) {
                        case 's':
                            event.preventDefault();
                            me.saveFiddle({ data: me });
                            break;
                        case 'r':
                            event.preventDefault();
                            me.executeScript({ data: me });
                            break;
                    }
                }
            });

            //this.setupTempFile();
            this.setupHtmlEditor();
            this.setupJsEditor();
            this.initSamples();

            $('#results').load(function () {
                if (me.executingToast != null)
                    me.executingToast.hide();
            });

            $("#executeButton").click(me, me.executeScript);
            $("#saveButton").click(this, this.saveFiddle);
            $("#exportButton").click(this, this.exportScript);
            $("#importButton").click(this, this.importScript);
            $(".close-button").click(this, function (e) {
                $(this).parents(".ui-dialog-content").dialog('close');
            });
            $(".naclose-button").click(this, function (e) {
                window.location.href = decodeURIComponent(e.data.getQueryStringParameter('SPHostUrl'));
            });

            $("#backToSiteButton").click(this, function (e) {
                window.location.href = decodeURIComponent(e.data.getQueryStringParameter('SPHostUrl'));
            });

            $(".import-button").click(this, function (e) {
                var me = e.data;
                me.executingToast = $.toast("Importing scripts", { type: 'info', duration: 10000 });
                $.support.cors = true;
                var sampleUrl = $('#importUrl').val();

                // Using ProxyJsonP in my google account
                var gs = "https://script.google.com/macros/s/AKfycbxFZcqlPNgUIz97Q1FSX-5akze8X3Lx36iNqE_ltmBvfgWjH2c/exec?url=";
                sampleUrl = gs + encodeURIComponent(sampleUrl) + "&_callback=?";
                $.ajax({
                    url: sampleUrl,
                    crossDomain: true,
                    error: function (x, m, et) {
                        alert(m);
                    },
                    complete: function (e) {
                    },
                    success: function (data) {
                        var res = data;
                        var list = null;

                        var ctx = SP.ClientContext.get_current();

                        if ($('#importType').val() == 0)
                            list = ctx.get_web().get_lists().getByTitle("Samples");
                        else
                            list = ctx.get_web().get_lists().getByTitle("Saved");

                        for (var c = 0; c < res.length; c++) {
                            var sample = res[c];
                            var newOne = list.addItem(null);
                            newOne.set_item("Title", sample.Title);

                            newOne.set_item("JsomScript", sample.JsomScript);
                            newOne.set_item("JsomHtml", sample.JsomHtml);
                            newOne.update();
                        }

                        ctx.executeQueryAsync(function (o, a) {
                            me.initSaved();
                            me.initSamples();
                            if (me.executingToast != null)
                                me.executingToast.hide();
                            $.toast("Import has completed", { type: 'success' });
                        }, function (o, e) {
                            alert(e.get_message());
                        });
                    }
                });

                $(this).parents(".ui-dialog-content").dialog('close');
            });

            $("#helpButton").click(this, function (e) {
                $("#dialog-help").dialog('open');
            });

            $("#dialog-noaccess").dialog({
                resizable: false,
                height: 250,
                width: 520,
                autoOpen: false,
                modal: true
            });

            $("#dialog-help").dialog({
                resizable: false,
                height: 325,
                width: 560,
                autoOpen: false,
                modal: true
            });

            $("#dialog-import").dialog({
                resizable: true,
                height: 260,
                width: 450,
                autoOpen: false,
                modal: true
            });

            this.saveDlg = $("#dialog-save").dialog({
                resizable: true,
                height: 200,
                width: 300,
                autoOpen: false,
                modal: true
            });

            var frame = $("#results")[0];
            var url = document.URL;
            frame.contentWindow.location.href = "results.html" + url.substring(url.toLowerCase().indexOf("?"));

            var ctx = SP.ClientContext.get_current();
            this.user = ctx.get_web().get_currentUser();
            ctx.load(this.user);
            ctx.executeQueryAsync(function (o, a) {
            });
        };

        App.prototype.getQueryStringParameter = function (paramToRetrieve) {
            var params = document.URL.split("?")[1].split("&");
            var strParams = "";
            for (var i = 0; i < params.length; i = i + 1) {
                var singleParam = params[i].split("=");
                if (singleParam[0] == paramToRetrieve)
                    return singleParam[1];
            }
        };

        App.prototype.setupTempFile = function () {
            var me = this;
            var ctx = SP.ClientContext.get_current();
            var web = ctx.get_web();
            var webProperties = ctx.get_web().get_allProperties();
            ctx.load(web);

            ctx.executeQueryAsync(function (o, a) {
                var folder = web.getFolderByServerRelativeUrl(web.get_serverRelativeUrl() + "/pages/tempscripts");
                var folderItem = folder.get_listItemAllFields();
                ctx.load(folderItem);

                ctx.executeQueryAsync(function () {
                    var fileCreateInfo = new SP.FileCreationInformation();
                    $.get(web.get_serverRelativeUrl() + "/pages/tempscripts/results.html", function (data, status, xhr) {
                        var now = new Date();

                        fileCreateInfo.set_url(now.getTime() + ".html");
                        fileCreateInfo.set_content(new SP.Base64EncodedByteArray());
                        var fileContent = data;
                        me.template = data;

                        for (var i = 0; i < fileContent.length; i++) {
                            fileCreateInfo.get_content().append(fileContent.charCodeAt(i));
                        }

                        var newFile = folder.get_files().add(fileCreateInfo);

                        var init = webProperties.get_fieldValues()["FiddleInitDone"];
                        alert(init);
                        if (init != true) {
                            folderItem.breakRoleInheritance(true, true);
                        }

                        ctx.load(newFile);
                        ctx.executeQueryAsync(function (o, a) {
                            me.file = newFile;
                            $("#executeButton").click(me, me.executeScript);
                            //$("#results").attr("src", newFile.get_serverRelativeUrl());
                        }, function (o, e) {
                            $("#dialog-noaccess").dialog('open');
                        });
                    }); // Get
                }, function (o, e) {
                    alert(e.get_message());
                });
            });
        };

        App.prototype.exportScript = function (e) {
            var clientContext = SP.ClientContext.get_current();
            var oWebsite = clientContext.get_web();
            var oList = oWebsite.get_lists().getByTitle("Exports");

            var fileCreateInfo = new SP.FileCreationInformation();
            var now = new Date();

            fileCreateInfo.set_url(now.getTime() + ".txt");
            fileCreateInfo.set_content(new SP.Base64EncodedByteArray());

            var htmlEditor = ace.edit("htmlEditor");
            var jsEditor = ace.edit("jsEditor");

            //var fileContent = "<Row><Field Name='Title'>JSOM Fiddle Sample</Field><Field Name='JsomScript'><![CDATA[" + jsEditor.getValue() + "]]></Field><Field Name='JsomHtml'><![CDATA[" + htmlEditor.getValue() + "]]></Field></Row>";
            var json = { Title: "JSOM Fiddle Sample", JsomScript: jsEditor.getValue(), JsomHtml: htmlEditor.getValue() };

            var fileContent = JSON.stringify(json);

            for (var i = 0; i < fileContent.length; i++) {
                fileCreateInfo.get_content().append(fileContent.charCodeAt(i));
            }

            var newFile = oList.get_rootFolder().get_files().add(fileCreateInfo);

            clientContext.load(newFile);
            clientContext.executeQueryAsync(function (o, a) {
                window.open(newFile.get_serverRelativeUrl(), "_blank");
            }, function (o, e) {
                alert(e.get_message());
            });
        };

        App.prototype.importScript = function (e) {
            $("#dialog-import").dialog('open');
        };

        App.prototype.initSamples = function () {
            var ctx = SP.ClientContext.get_current();
            var q = new SP.CamlQuery();
            q.set_viewXml("<View><Query><Where><Gt><FieldRef Name='ID'/><Value Type='Counter'>0</Value></Gt></Where><OrderBy><FieldRef Name='Title'/></OrderBy></Query></View>");
            this.samples = ctx.get_web().get_lists().getByTitle("Samples").getItems(q);
            ctx.load(this.samples);
            var me = this;

            ctx.executeQueryAsync(function (o, a) {
                var select = "<ul id='samplesList' class='myList'>";

                for (var c = 0; c < me.samples.get_count(); c++) {
                    var item = me.samples.get_item(c);
                    select += "<li value='" + c + "'>" + item.get_item("Title") + "</li>";
                }

                select += "</ul>";

                $("#samplesList").replaceWith(select);

                //(<any>$("#samplesList")).listbox({ 'class':'samplesListbox', 'searchbar': true });
                $(document).on('click', '#samplesList li', function () {
                    var htmlEditor = ace.edit("htmlEditor");
                    var jsEditor = ace.edit("jsEditor");
                    if (me.isDirty == true) {
                        if (confirm("Changes will be lost. Do you wish to continue?") == false)
                            return;
                    }
                    var pos = parseInt($(this).attr("value"));
                    if (pos != -1) {
                        var item = me.samples.get_item(pos);

                        var html = item.get_item("JsomHtml");
                        var js = item.get_item("JsomScript");
                        try  {
                            jsEditor.setValue(js);
                            htmlEditor.setValue(html);
                            jsEditor.resize();
                            htmlEditor.resize();
                            jsEditor.selection.clearSelection();
                            htmlEditor.selection.clearSelection();
                            $("#samplesDialog").dialog("close");
                            $('#fiddleName').text('').hide();
                            me.currentFiddle = null;
                            me.notDirty();
                        } catch (e) {
                            alert(e.message);
                        }
                    }
                });
                me.initSaved();
            }, function (o, a) {
                alert(a.get_message());
            });
        };
        App.prototype.notDirty = function () {
            this.isDirty = false;
        };
        App.prototype.initSaved = function () {
            var ctx = SP.ClientContext.get_current();
            var saved = ctx.get_web().get_lists().getByTitle("Saved").getItems(SP.CamlQuery.createAllItemsQuery());
            ctx.load(saved);
            var me = this;

            ctx.executeQueryAsync(function (o, a) {
                var select = "<ul id='savedList' class='myList'>";

                for (var c = 0; c < saved.get_count(); c++) {
                    var item = saved.get_item(c);
                    select += "<li value='" + c + "'>" + item.get_item("Title") + "</li>";
                }

                me.saved = saved;

                select += "</ul>";

                $("#savedList").replaceWith(select);

                $(document).on('click', '#savedList li', function () {
                    var htmlEditor = ace.edit("htmlEditor");
                    var jsEditor = ace.edit("jsEditor");

                    if (me.isDirty == true) {
                        if (confirm("Changes will be lost. Do you wish to continue?") == false)
                            return;
                    }

                    var pos = parseInt($(this).attr("value"));
                    if (pos != -1) {
                        var item = me.saved.get_item(pos);

                        var html = item.get_item("JsomHtml");
                        var js = item.get_item("JsomScript");

                        jsEditor.setValue(js);
                        htmlEditor.setValue(html);
                        jsEditor.selection.clearSelection();
                        htmlEditor.selection.clearSelection();
                        jsEditor.resize();
                        htmlEditor.resize();
                        $('#fiddleName').text(item.get_item('Title')).show();
                        me.currentFiddle = item;
                        me.notDirty();
                    }
                });
            }, function (o, a) {
                alert(a.get_message());
            });
        };

        App.prototype.setupHtmlEditor = function () {
            var me = this;
            var htmlEditor = ace.edit("htmlEditor");
            htmlEditor.setTheme("ace/theme/chrome");
            htmlEditor.getSession().setMode("ace/mode/html");
            htmlEditor.resize();
            htmlEditor.getSession().on("change", function () {
                var txt = $("#fiddleName").text();
                me.isDirty = true;
                if (txt.indexOf("*") == -1) {
                    if (txt == "" || txt == null)
                        txt = "untitled";
                    $("#fiddleName").text(txt + "*").show();
                }
            });
        };

        App.prototype.setupJsEditor = function () {
            var me = this;
            var jsEditor = ace.edit("jsEditor");
            jsEditor.setTheme("ace/theme/twilight");
            jsEditor.getSession().setMode("ace/mode/javascript");
            jsEditor.resize();
            jsEditor.getSession().on("change", function () {
                var txt = $("#fiddleName").text();
                me.isDirty = true;
                if (txt.indexOf("*") == -1) {
                    if (txt == "" || txt == null)
                        txt = "untitled";
                    $("#fiddleName").text(txt + "*").show();
                }
            });
        };

        App.prototype.saveFiddle = function (e) {
            var me = e.data;

            if (me.currentFiddle == null) {
                //title = prompt("Enter the title");
                $('#dialog-save').dialog('open');
                $('.save-button').click(function (e) {
                    var btn = this;
                    me.doSave($("#saveTitle").val(), function (e) {
                        $('.save-button').unbind("click");
                        me.saveDlg.dialog('close');
                    });
                });
            } else
                me.doSave(me.currentFiddle.get_item("Title"), function (e) {
                    $(this).parents(".ui-dialog-content").dialog('close');
                });
        };

        App.prototype.doSave = function (title, onComplete) {
            try  {
                var me = this;

                if (title == null || title == "") {
                    alert("Please enter a valid title");
                    return;
                }

                var jsEditor = ace.edit("jsEditor");
                var htmlEditor = ace.edit("htmlEditor");

                if (title.indexOf("*") > -1)
                    title = title.substr(0, title.length - 1);

                var ctx = SP.ClientContext.get_current();
                var list = ctx.get_web().get_lists().getByTitle("Saved");
                var q = new SP.CamlQuery();
                q.set_viewXml("<View><Query><Where><Eq><FieldRef Name='Title'/><Value Type='Text'>" + title + "</Value></Eq></Where></Query></View>");
                var items = list.getItems(q);
                ctx.load(items);

                ctx.executeQueryAsync(function (o, a) {
                    if (me.currentFiddle == null && items.get_count() > 0) {
                        alert("An item named '" + title + "' already exists. Please choose a different name.");
                        return;
                    }
                    if (me.currentFiddle == null) {
                        me.currentFiddle = list.addItem(null);
                        me.currentFiddle.set_item("Title", title);
                    }

                    me.currentFiddle.set_item("JsomScript", jsEditor.getValue());
                    me.currentFiddle.set_item("JsomHtml", htmlEditor.getValue());
                    me.currentFiddle.set_item("JsomUser", me.user.get_id());
                    me.currentFiddle.update();
                    ctx.load(me.currentFiddle);

                    ctx.executeQueryAsync(function (o, a) {
                        $('#fiddleName').text(title).show();
                        me.isDirty = false;
                        onComplete(null);
                        $.toast("Fiddle " + title + "' has been saved", { type: 'success' });
                        me.initSaved();
                    }, function (o, e) {
                        alert(e.get_message());
                        onComplete(e);
                    });
                }, function (o, e) {
                    alert(e.get_message());
                    onComplete(e);
                });
            } catch (e) {
                alert(e);
            }
        };

        App.prototype.executeScript = function (e) {
            var me = e.data;

            //me.executingToast = (<any>$).toast("Running script", { type: 'info', duration: 10000 });
            var frame = $("#results")[0];
            var jsEditor = ace.edit("jsEditor");
            var htmlEditor = ace.edit("htmlEditor");

            frame.contentWindow.document.body.innerHTML = htmlEditor.getValue(); // + "<script>" + jsEditor.getValue() + "</script>";
            var script = frame.contentWindow.document.createElement("script");
            $(script).text(jsEditor.getValue());
            frame.contentWindow.document.body.appendChild(script);
        };
        return App;
    })();
    JsomFiddle.App = App;
    $(document).ready(function () {
        SP.SOD.executeFunc('sp.js', 'SP.ClientContext', function () {
            SP.SOD.executeFunc('sp.ui.dialog.js', 'SP.UI.ModelDialog', null);
        });

        var app;
        app = new JsomFiddle.App();
        app.init();
    });
})(JsomFiddle || (JsomFiddle = {}));
