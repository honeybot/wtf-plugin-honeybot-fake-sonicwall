local require = require
local tools = require("wtf.core.tools")
local Plugin = require("wtf.core.classes.plugin")
local route = require "resty.route".new()

local _M = Plugin:extend()
_M.name = "honeybot.fake.sonicwall"
config = {}

function set_headers(hdrs)
  local ngx = ngx
  local pairs = pairs
  ngx.header["Server"] = nil
  
  if hdrs then
    for key,val in pairs(hdrs) do
      ngx.header[key] = val
    end
  end
end

function send_response(state, content)
  ngx.ctx.response_from_lua = 1
  ngx.status = state
  ngx.print(content)
  ngx.exit(state)
end
function get_file_extension(url)
  return url:match("^.+%.(.+)$")
end

function get_ct()
  local ext = get_file_extension(ngx.var.uri)
  local ct = ""
  if ext == "txt" then
    ct = "text/plain"
  elseif ext == "html" then
    ct = "text/html; charset=UTF-8"
  elseif ext == "css" then
    ct = "text/css; charset=utf-8"
  elseif ext == "js" then
    ct = "application/javascript"
  elseif ext == "gif" then
    ct = "image/gif"
  elseif ext == "jpg" or ext == "jpeg" then
    ct = "image/jpg"
  else
    ct = "text/html; charset=UTF-8"
  end
  return ct
end



function set_static_headers()
  local headers = {}
  headers["Date"] = ngx.http_time(ngx.time())
  headers["Server"] = "SonicWALL SSL-VPN Web Server"
  headers["Last-Modified"] = ngx.http_time(ngx.time())
  headers["X-XSS-Protection"] = "1; mode=block"
  headers["Content-Security-Policy"] = "script-src 'self' 'unsafe-inline' 'unsafe-eval'; object-src 'self'; style-src 'self' 'unsafe-inline'"
  headers["Referrer-Policy"] = "strict-origin"
  headers["X-Content-Type-Options"] = "nosniff"
  headers["Accept-Ranges"] = "bytes"
  headers["X-FRAME-OPTIONS"] = "SAMEORIGIN"
  
  headers["Content-Type"] = get_ct()
  set_headers(headers)
end

function set_dynamic_headers()
  local headers = {}
  headers["Date"] = ngx.http_time(ngx.time())
  headers["Server"] = "SonicWALL SSL-VPN Web Server"
  headers["Cache-Control"] = "private, no-cache, no-store, no-transform, proxy-revalidate"
  headers["Pragma"] = "no-cache"
  headers["X-FRAME-OPTIONS"] = "SAMEORIGIN"
  headers["X-XSS-Protection"] = "1; mode=block"
  headers["Content-Security-Policy"] = "script-src 'self' 'unsafe-inline' 'unsafe-eval'; object-src 'self'; style-src 'self' 'unsafe-inline'"
  headers["Referrer-Policy"] = "strict-origin"
  headers["X-Content-Type-Options"] = "nosniff"
  headers["Content-Type"] = "text/html; charset=utf-8"  

  set_headers(headers)
end

function set_ajax_headers()
  local headers = {}
  headers["Date"] = ngx.http_time(ngx.time())
  headers["Server"] = "SonicWALL SSL-VPN Web Server"
  headers["Cache-Control"] = "no-cache, must-revalidate"
  headers["Pragma"] = "no-cache"
  headers["X-FRAME-OPTIONS"] = "SAMEORIGIN"
  headers["X-XSS-Protection"] = "1; mode=block"
  headers["Content-Security-Policy"] = "script-src 'self' 'unsafe-inline' 'unsafe-eval'; object-src 'self'; style-src 'self' 'unsafe-inline'"
  headers["Referrer-Policy"] = "strict-origin"
  headers["X-Content-Type-Options"] = "nosniff"
  headers["Content-Type"] = "application/json; charset=UTF-8"  

  set_headers(headers)
end

function http404()
  ngx.header["Date"] = ngx.http_time(ngx.time())
  ngx.header["Server"] = "SonicWALL SSL-VPN Web Server"
  ngx.header["X-FRAME-OPTIONS"] = "SAMEORIGIN"
  ngx.header["X-XSS-Protection"] = "1; mode=block"
  ngx.header["Content-Security-Policy"] = "script-src 'self' 'unsafe-inline' 'unsafe-eval'; object-src 'self'; style-src 'self' 'unsafe-inline'"
  ngx.header["Referrer-Policy"] = "strict-origin"
  ngx.header["X-Content-Type-Options"] = "nosniff"
  ngx.header["Content-Type"] = "text/html; charset=utf-8" 
  
  local filename = config["datapath"] .. config["version"] .. "/__notfound"
  local template = io.open(filename, "rb")
  if template ~= nil then
    local page = template:read "*a"
    send_response(404, page)
  else
    send_response(404, "Not found")
  end
end

function ajax(response)
  set_ajax_headers()
  send_response(200, response)
end
  
function userLogin_post()
  ajax('{"status":"failure","message":"Login failed - Incorrect username/password"}')
end

function userLogin_get()
  set_static_headers()
  ngx.header["X-NE-message"] = "Please fill in all fields"
  send_response(200, '<HTML><HEAD><META HTTP-EQUIV="Pragma" CONTENT="no-cache"><meta http-equiv="refresh" content="0; URL=/cgi-bin/welcome/VirtualOffice?err=loginIncomplete"></HEAD><BODY></BODY></HTML>')
end

function static(self, path)
  if path == "" or path == "/" then path = "index.html" end
  if path == "cgi-bin/welcome/VirtualOffice" then path = "cgi-bin/welcome" end
  local filename = config["datapath"] .. config["version"] .."/".. path
  local template = io.open(filename, "rb")
  if template ~= nil then
    local page = template:read "*a"
    set_static_headers()
    send_response(200, page)
  else
    http404()
  end
end

function index()
  local filename = config["datapath"] .. config["version"] .. "/index.html"
  local template = io.open(filename, "rb")
  if template ~= nil then
    local page = template:read "*a"
    set_dynamic_headers()
    send_response(200, page)
  else
    http404()
  end
end

function handleWAFRedirect()
  local args, err = ngx.req.get_uri_args()
  for key, val in pairs(args) do
    if key == "hdl" then
      if type(val) ~= "table" then
        if val ~= "../etc/passwd" then
          ngx.sleep(5)
        end
      end
    end
  end
  
  local path = "cgi-bin/handleWAFRedirect"
  local filename = config["datapath"] .. config["version"] .."/".. path
  local template = io.open(filename, "rb")
  if template ~= nil then
    local page = template:read "*a"
    set_static_headers()
    send_response(200, page)
  else
    http404()
  end
end

function _M:init(...)
  local select = select
  local instance = select(1, ...)
  config["version"] = self:get_optional_parameter('version')
  config["datapath"] = self:get_optional_parameter('path')

  route "=/" (index)
  route "=/index.html" (index)
  route "=/cgi-bin/userLogin" {
    get  = (userLogin_get),
    post = (userLogin_post)
  }
  route "=/cgi-bin/handleWAFRedirect" (handleWAFRedirect)
  route "#/(.+)" (static)
  
	return self
end

function _M:content(...)
  route:dispatch(ngx.var.uri, ngx.var.request_method)
end

return _M
