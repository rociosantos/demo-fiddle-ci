const testService = require('./fiddle-mocha');
const path = require('path');
fs = require('fs');

var recv_vcl = fs.readFileSync(path.join(__dirname, '/vcls/recv.vcl'), 'utf8');
// console.log("recv", recv_vcl);

var fetch_vcl = fs.readFileSync(path.join(__dirname,'/vcls/fetch.vcl'), 'utf8');
// console.log("fetch", fetch_vcl);

var error_vcl = fs.readFileSync(path.join(__dirname,'/vcls/error.vcl'), 'utf8');
// console.log("error", error_vcl);

testService('Service: fiddle example test', {
	spec: {
		origins: ["https://httpbin.org", "https://postman-echo.com"],
		vcl: {
			recv: recv_vcl,
			fetch: fetch_vcl,
			error: error_vcl
		}
	},
	scenarios: [
		{
			name: 'Response headers',
			requests: [
				{
					path: "/response-headers",
					tests: [
						'clientFetch.status is 200',
						'originFetches[0].req includes "response-headers?Custom-Header=something"',
						'originFetches[0].resp includes "custom-header: something"',
						'originFetches[0].req includes "postman-echo.com"',
					]
				}
			]
		}, {
			name: "Status",
			requests: [
				{
					path: "/status/200",
					tests: [
						'clientFetch.status is 200',
						'originFetches[0].req includes "httpbin.org"'
					]
				}, {
					path: "/status/400",
					tests: [
						'clientFetch.status is 403',
						'originFetches[0].req includes "httpbin.org"'
					]
				}, {
					path: "/status/500",
					tests: [
						'clientFetch.status is 401',
						'originFetches[0].req includes "httpbin.org"'
					]
				}
			]
		}
	]
});


