declare local var.err_id_prefix STRING;

log obj.status;
log req.http.x-err-with-id;

if (obj.status == 614) {

  if (req.http.x-err-with-id == "1") {
    set obj.status = 403;
    set var.err_id_prefix = {"{"id":""} + req.http.target-id + {"", "errors":["errors-array"]"};
    set req.http.x-do-error = var.err_id_prefix;
    set obj.http.Content-Type = "text/plain";
    synthetic req.http.x-do-error;
  } else {
    set obj.status = 401;
    set obj.response = "Forbidden";
    set obj.http.Content-Type = "text/plain";
    synthetic obj.response;
  }
  
  return (deliver);
}
if (obj.status == 615) {
  set obj.status = 200;
  set obj.response = "OK";
  set obj.http.Content-Type = "text/plain";
  synthetic "Authorized";
  set obj.http.Custom-Header = req.http.Custom-Header;
  return (deliver);
}
