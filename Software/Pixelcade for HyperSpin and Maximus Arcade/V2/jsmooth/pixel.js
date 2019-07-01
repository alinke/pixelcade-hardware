
function changeControls(mode)
{
    switch(mode)
    {
        case "animations":
        {
            hideElement("stillPanel");
            hideElement("scrollingTextPanel");
            hideElement("clockPanel");
            hideElement("arcadePanel");
            
            showElement("animationsPanel");
            
            break;
        }
        case "still":
        {
            hideElement("animationsPanel");
            hideElement("scrollingTextPanel");
            hideElement("clockPanel");
            hideElement("arcadePanel");   
            
            showElement("stillPanel");
            
            break;
        }
        case "clock":
        {
            hideElement("animationsPanel");
            hideElement("stillPanel");
            hideElement("scrollingTextPanel");
            hideElement("arcadePanel");
            
            showElement("clockPanel");
            
            break;
        }

        case "arcade":
        {
            hideElement("animationsPanel");
            hideElement("stillPanel");
            hideElement("scrollingTextPanel");
            hideElement("clockPanel");

            showElement("arcadePanel");

            break;
        }

        default:
        {
            // scrolling text
            hideElement("animationsPanel");
            hideElement("stillPanel");
            hideElement("clockPanel");
            hideElement("arcadePanel");
            
            showElement("scrollingTextPanel");
            
            break;
        }
    }
}

function changeScrollingText(text)
{
    var modeString = "text?t=" + text;
    
    modeChanged(modeString);
}

function changeScrollingTextSpeed(speed)
{
    var speedString = "text/speed/" + speed;
    
    modeChanged(speedString);
}

function changeScrollingTextColor(color)
{
    var hex = color.substring(1);
    var colorString = "text/color/" + hex;
    
    modeChanged(colorString);
}

function displayImage(imagePath, name)
{
    var mode;
    
    switch(imagePath)
    {
        case "animations/save/":
        {
            mode = "animation/save/";
            break;
        }
        case "animations/":
        {
            mode = "animation/";
            break;
        }
        
        case "arcade/":
        {
            mode = "arcade/";
            break;
        }

        default:
        {
            // still images
            mode = "still/";
        }
    }
    
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        logServerResponse(xmlhttp);
    }
    var url = "/" + mode + name;
    xmlhttp.open("POST", url, true);
    xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    xmlhttp.send("&p=3");    
}

function getLastUpdateOrigin()
{
    
    
    
}

function hideElement(id)
{
    var element = document.getElementById(id);
    element.style.display = 'none';
}

function loadAnimations()
{
    var url = "/animation/list";
    var elementName = "animations";
    var imagePath = "animations/";
    
    loadImageList(url, elementName, imagePath);
}

function loadArcade()
{
    var url = "/arcade/list";
    var elementName = "arcade";
    var imagePath = "arcade/";
    
    loadImageList(url, elementName, imagePath);
}


function loadImageList(url, elementName, imagePath)
{
    logEvent("loading " + elementName + "...");
    
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        if (xmlhttp.readyState==4 && xmlhttp.status==200)      
        {
            var list = xmlhttp.responseText;
            
            var names = list.split("-+-");
            
            var html = "<div class='thumb-holder'>";
            
 //           var c = 0;
            var columns = 4;
            
            for(var n in names)
            {
                var name = names[n].trim();
                
                var mod = parseInt(n) % columns;
                if(mod == 0)
                {
                    html += "<tr>";
                }
                
                if(name != "")
                {
                    html += "<div class='thumb'>";
                    html += "<img src=\"/files/" + imagePath + name + "\" " + 
                                   "width=\"50\" height=\"50\" alt=\"" + name +  "\"" +  
                                   ">";

                    html += "<p>" + name + "</p>";                    
                    html += "<center style=\"margin-bottom: 40px;\">";
                    html += "<button onclick=\"displayImage('" + imagePath + "', '" + name + "')\" style=\"margin-left: auto; margin-right: auto;\">Display</button>";
                    
                    if(imagePath == "animations/")
                    {
                        html += " ";
                        html += "<button onclick=\"displayImage('" + imagePath + "save/" + "', '" + name + "')\" style=\"margin-left: auto; margin-right: auto;\">Save</button>";
                    }

                     if(imagePath == "arcade/")
                    {
                        html += " ";
                        html += "<button onclick=\"displayImage('" + imagePath + "', '" + name + "')\" style=\"margin-left: auto; margin-right: auto;\">Save</button>";
                    }

                    html += "</center>";
                    html += "</div>";
                }
                
                if(mod == 0)
                {
                    html += "</tr>";
                }
            }
            
            html += "<div class=\"spacer\">&nbsp;</div>";
            
            html += "</div>";
            
            var e = document.getElementById(elementName);
            e.innerHTML = html;
            
            logEvent("done loading " + elementName);
        }
    }
    
    xmlhttp.open("POST", url, true);
    xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    xmlhttp.send("&p=3");    
}

function loadImageResources()
{
    loadStillImages();
    loadArcade();
    loadAnimations();
}

function loadStillImages()
{
    var url = "/still/list";
    var elementName = "still";
    var imagePath = "images/";
    
    loadImageList(url, elementName, imagePath);
}

function logServerResponse(xmlhttp)
{
    if (xmlhttp.readyState==4 && xmlhttp.status==200)      
    {
        var s = xmlhttp.responseText;
        logEvent(s);
    }
}

function logEvent(message)
{
    var e = document.getElementById("logs");
    
    var logs = message + "<br/>" + e.innerHTML;
    
    e.innerHTML = logs;
}

function modeChanged(mode, imageName)
{
    if(imageName === null)
    {
        imageName = "";
    }
    
    changeControls(mode);
    
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        logServerResponse(xmlhttp);
    }
    var url = "/" + mode;
    
    if(imageName != "" && !(imageName === undefined))
    {
        url += "/" + imageName;
    }
    
    xmlhttp.open("POST", url, true);
    xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    xmlhttp.send("&p=3");
}

function showElement(id)
{
    var element = document.getElementById(id);
    element.style.display = 'block';
}

function updateMode()
{
//    alert("in updateMode()");
    
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        // display the correct mode UI
        var response = xmlhttp.responseText;
        
        var label = "Scrolling Texttttt";
        
        var o = 2
        
        switch(response)
        {
            case "ANIMATED_GIF":
            {
                modeChanged("animations");

                label = "Animations";
                
                o =0;

                break;
            }
            case "STILL_IMAGE":
            {
                modeChanged("still");        
                
                label = "Still Images";

                o = 1;
                break;
            }
            default:
            {
                
                // scrolling text
                changeScrollingText('Hello, Pixel World');

                break;
            }
        }
        
        document.getElementById('mode').selectedIndex = o;
        
        xmlhttp.responseText += " uploaded";
        
        logServerResponse(xmlhttp);
    }
    var url = "/upload/origin";
    xmlhttp.open("POST", url, true);
    xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    xmlhttp.send("&p=3");
}
