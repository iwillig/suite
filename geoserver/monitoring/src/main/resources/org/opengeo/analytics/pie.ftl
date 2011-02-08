function createDiv(parent, suffix) {
  var el = document.getElementById(parent);
  var div = document.createElement("div");
  div.setAttribute("id", parent + suffix)
  div.setAttribute("class", "pie-chart");
  el.appendChild(div);
}

<#assign sum = 0>
data = [
<#list data as d>
  {
    value: ${d.value},
    label: "${d.label}",
    color: "${d.color}",
    ops: [
   <#list d.ops?keys as op>
     { name: "${op}", value: ${d.ops[op]}}<#if op_has_next>,</#if>
   </#list>
    ]
  }<#if d_has_next>,</#if>
  <#assign sum = sum + d.value>
</#list>
];

createDiv("${container}", "_a");
createDiv("${container}", "_b");

<#assign gut = 10>

var r = Raphael("${container}_a");

var values = [];
var colors = [];
var legend = [];
var detail = [];
for (var prop in data) {
  var val = data[prop];
  values.push(val.value);
  colors.push(val.color);
  //legend.push(val.label + ": " + val.value + " (%%.%%)");
  legend.push(val.label); 
}

var pie = r.g.piechart(${(width+gut)/2}, ${(height+gut)/2}, ${width/2}, values, {
  legend: legend, legendpos: "east", legendmark: "s", 
  colors: colors
});

pie.hover(function () {
    this.sector.stop();
    this.sector.scale(1.05, 1.05, this.cx, this.cy);
    
    this.tags = r.set();
    
    var percent = this.value.value / this.total * 100; 
    this.tags.push(r.g.popup(this.mx, this.my, this.value.value + " (" + percent.toFixed(2) + "%)"));
}, function () {
    this.sector.animate({scale: [1, 1, this.cx, this.cy]}, 500, "bounce");
    this.tags && this.tags.remove();
});

pie.click(function() {
  if (window.subpie) {
     window.subpie.remove();
  }
  var value = data[this.value.order];
  if (value.ops.length > 0) {
     var s = Raphael("${container}_b");
     var values = [];
     var legend = [];
     for (var i in value.ops) {
       var op = value.ops[i];
       values.push(op.value);
       legend.push(op.name + ": " + op.value + " (%%.%%)");
     }
     
     var subpie = s.g.piechart(${(width+gut)/2}, ${(height+gut)/2}, ${width/2}, values, {
        legend: legend, legendpos: "east", legendmark: "s"
     });
     window.subpie = subpie;
  }
  
  
  
});