set req.http.Custom-Header = beresp.http.Custom-Header;
log beresp.http.Custom-Header;
log beresp.status;

if (beresp.status != 200){
  set req.http.Flow-State = "error";
  error 614;
} else {
  set req.http.Flow-State = "done";
  error 615;
}