set req.backend = F_origin_0 /* httpbin.org */;

set req.http.Tracer = req.http.Tracer " : not done";
declare local var.path_1 STRING;
declare local var.path_2 STRING;
declare local var.path_3 STRING;

if (req.url ~ "^/([^/^?]+)/?([^/^?]+)/?(.*)") {
  set var.path_1 = re.group.1; # path
  set var.path_2 = re.group.2; # if status
  set var.path_3 = re.group.3; # query params
  log var.path_1 var.path_2 var.path_3;

  if (var.path_1 == "status") {
    set req.http.Tracer = req.http.Tracer " : status";
    set req.http.Flow-State = "done";
    log var.path_2;
    if (var.path_2 != "200" && var.path_2 != "500") {
      set req.http.x-err-with-id = "1";
    }
    log req.http.x-err-with-id;
    return(pass);
  } else {
    
    set req.http.Flow-State = "response-headers";
    set req.http.Tracer = req.http.Tracer " : in response-headers";
    set req.http.parked-url = req.url;
    set req.http.target-id = var.path_1;
    set req.backend = F_origin_1; /* httpbin.org */
    # Append queryparam
    set req.url = regsub(req.url, "(\?|$)", "?Custom-Header=something");
  }
}