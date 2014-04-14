require.config({
    //baseUrl: '//rawgithub.com/scrapcupcake/Brine/master/lib/brine/prompt/',
    paths: {
        Handlebars: '//cdnjs.cloudflare.com/ajax/libs/handlebars.js/1.3.0/handlebars',
        //text: 'https://rawgithub.com/requirejs/text/master/text',
        text: './text',
        hbars: '//cdnjs.cloudflare.com/ajax/libs/requirejs-handlebars/0.0.2/hbars'
    },
    shim: {
        Handlebars: {
            exports: 'Handlebars'
        }
    }
});

var absolute = {
    css: "text!//rawgithub.com/scrapcupcake/Brine/master/lib/brine/prompt/brine.css",
    hbars: "hbars!//rawgithub.com/scrapcupcake/Brine/master/lib/brine/prompt/brine"
}

var relative = {
    css: "text!brine.css",
    hbars: "hbars!brine"
}

require(["require",relative.hbars,relative.css],function(require,rawTemplate,brineCss){
     console.log(require.toUrl(absolute.css))
     console.log(require.toUrl(absolute.hbars))
     var Brine = {};

     Brine.ensureElement = function(id,type,target){
         type = typeof(type) === "undefined" ? "div" : type;
         target = typeof(target) === "undefined" ? document.body : target;

            var element = document.getElementById(id)
            if(!!!element){
                element = document.createElement(type)
                target.appendChild(element);
            }
            element.id = id
            return element;
        }

       Brine.displayPrompt = function(message){
           var prompt = Brine.ensureElement("BrineTestPrompt")
           prompt.innerHTML = rawTemplate({message: message});
           prompt.style.display = "block";
        }

        Brine.hidePrompt = function(){
            var prompt = Brine.ensureElement("BrineTestPrompt")
            prompt.style.display = "none";
        }

        Brine.ensureCss = function(){
            console.log(brineCss)
            var css = Brine.ensureElement("BrineTestCss", "style",document.head)
            css.innerHTML = brineCss;
        }

        Brine.status = { finished: false }

        Brine.pass = function(){
            Brine.status.result = true;
            Brine.status.finished = true;
            Brine.hidePrompt()
        }

        Brine.fail = function(){
            Brine.status.result = false;
            Brine.status.reason = document.getElementById("BrineTestReason").value
            Brine.status.finished = true;
            Brine.hidePrompt()
        }
        
        Brine.typing = function(){
            if(document.getElementById("BrineTestReason").value.length > 4){
                document.getElementById("BrineFail").disabled = false;
            }else{
                document.getElementById("BrineFail").disabled = true;
            }
        }

        window.Brine = Brine;

        Brine.ensureCss()
    }
);
