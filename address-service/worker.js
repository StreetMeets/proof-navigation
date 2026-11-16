// PROOF NEXT address API. Deploy with Cloudflare Workers and bind D1 as DB.
// No scraped Google Maps data. Data source: official Czech RUIAN CSV (ČÚZK).
const cors={"Access-Control-Allow-Origin":"https://streetmeets.github.io","Access-Control-Allow-Methods":"GET, OPTIONS","Access-Control-Allow-Headers":"Content-Type","Vary":"Origin"};
const json=(value,status=200)=>new Response(JSON.stringify(value),{status,headers:{"Content-Type":"application/json; charset=utf-8","Cache-Control":"public, max-age=120",...cors}});
export default {async fetch(request,env){
 const url=new URL(request.url);
 if(request.method==="OPTIONS")return new Response(null,{status:204,headers:cors});
 if(request.method!=="GET")return json({error:"Method not allowed"},405);
 if(url.pathname==="/health")return json({ok:true,source:"RÚIAN / ČÚZK",database:!!env.DB});
 if(url.pathname!=="/search")return json({error:"Not found"},404);
 const q=(url.searchParams.get("q")||"").trim().replace(/\s+/g," ");
 if(q.length<3||q.length>120)return json({error:"Query must contain 3–120 characters"},400);
 if(!env.DB)return json({error:"Address database is not configured"},503);
 const tokens=q.toLocaleLowerCase("cs").normalize("NFD").replace(/[\u0300-\u036f]/g,"").split(/[,\s]+/).filter(Boolean).slice(0,8);
 const clauses=tokens.map(()=>"search_text LIKE ? ESCAPE '\\'").join(" AND ");
 const params=tokens.map(t=>"%"+t.replace(/[\\%_]/g,"\\$&")+"%");
 try{
  const result=await env.DB.prepare("SELECT code,city,street,house,postcode,lat,lon FROM addresses WHERE "+clauses+" LIMIT 20").bind(...params).all();
  return json({results:result.results||[],source:"RÚIAN / ČÚZK"});
 }catch(e){return json({error:"Address search temporarily unavailable"},503)}
}};