const fs=require('node:fs');const vm=require('node:vm');const assert=require('node:assert/strict');
const html=fs.readFileSync('index.html','utf8');
const match=html.match(/<script>([\s\S]*?)<\/script>/);
assert(match,'Inline navigation JavaScript missing');
new vm.Script(match[1],{filename:'index.html:inline'});
for(const [name,pattern] of Object.entries({
  gps:/watchPosition\(/,route:/function routeMatch\(/,reroute:/async function recalc\(/,
  rerouteGuard:/proofRerouteBusy/,camera:/map\.easeTo\(/,
  smoothing:/proofLastGpsAt/,czech:/function proofInsideCz\(/,
  mapTheme:/function proofApplyMapTheme\(/,streetBelow:/top:calc\(100% \+ 4px\)/
}))assert(pattern.test(html),'Missing '+name);
console.log('PASS: navigation JavaScript syntax and 9 beta regression checks');
