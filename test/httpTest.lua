#!/usr/bin/env lua
--[[
A simple HTTP server

If a request is not a HEAD method, then reply with "Hello world!"

Usage: lua examples/server_hello.lua [<port>]
]]

local port = arg[1] or 0 -- 0 means pick one at random

local http_server = require "http.server"
local http_headers = require "http.headers"




--
-- Example self-signed X.509 certificate generation.
--
-- Skips intermediate CSR object, which is just an antiquated way for
-- specifying subject DN and public key to CAs. See API documentation for
-- CSR generation.
--

local keytype = "RSA"




local ssl = require("openssl.ssl.context")

--local ctx = ssl.new("TLS", true)
--ctx:setPrivateKey(piv)
--ctx:setCertificate(crt)
--ctx:setCipherList("TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:DHE-RSA-AES256-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES128-SHA:RSA-PSK-AES256-GCM-SHA384:DHE-PSK-AES256-GCM-SHA384:RSA-PSK-CHACHA20-POLY1305:DHE-PSK-CHACHA20-POLY1305:ECDHE-PSK-CHACHA20-POLY1305:AES256-GCM-SHA384:PSK-AES256-GCM-SHA384:PSK-CHACHA20-POLY1305:RSA-PSK-AES128-GCM-SHA256:DHE-PSK-AES128-GCM-SHA256:AES128-GCM-SHA256:PSK-AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:ECDHE-PSK-AES256-CBC-SHA384:ECDHE-PSK-AES256-CBC-SHA:SRP-RSA-AES-256-CBC-SHA:SRP-AES-256-CBC-SHA:RSA-PSK-AES256-CBC-SHA384:DHE-PSK-AES256-CBC-SHA384:RSA-PSK-AES256-CBC-SHA:DHE-PSK-AES256-CBC-SHA:AES256-SHA:PSK-AES256-CBC-SHA384:PSK-AES256-CBC-SHA:ECDHE-PSK-AES128-CBC-SHA256:ECDHE-PSK-AES128-CBC-SHA:SRP-RSA-AES-128-CBC-SHA:SRP-AES-128-CBC-SHA:RSA-PSK-AES128-CBC-SHA256:DHE-PSK-AES128-CBC-SHA256:RSA-PSK-AES128-CBC-SHA:DHE-PSK-AES128-CBC-SHA:AES128-SHA:PSK-AES128-CBC-SHA256:PSK-AES128-CBC-SHA")

local cqueues = require "cqueues"
local monotime = cqueues.monotime
local ca = require "cqueues.auxlib"
local cc = require "cqueues.condition"
local ce = require "cqueues.errno"
local cs = require "cqueues.socket"
local connection_common = require "http.connection_common"
local onerror = connection_common.onerror
local h1_connection = require "http.h1_connection"
local h2_connection = require "http.h2_connection"
local http_tls = require "http.tls"
local http_util = require "http.util"
local openssl_bignum = require "openssl.bignum"
local pkey = require "openssl.pkey"
local openssl_rand = require "openssl.rand"
local openssl_ssl = require "openssl.ssl"
local openssl_ctx = require "openssl.ssl.context"
local x509 = require "openssl.x509"
local name = require "openssl.x509.name"
local altname = require "openssl.x509.altname"


local host = "localhost"


-- Prefer whichever comes first
local function alpn_select(ssl, protos, version)
	for _, proto in ipairs(protos) do
		if proto == "h2" and (version == nil or version == 2) then
			-- HTTP2 only allows >= TLSv1.2
			-- allow override via version
			if ssl:getVersion() >= openssl_ssl.TLS1_2_VERSION or version == 2 then
				return proto
			end
		elseif (proto == "http/1.1" and (version == nil or version == 1.1))
			or (proto == "http/1.0" and (version == nil or version == 1.0)) then
			return proto
		end
	end
	return nil
end


local default_tls_options = openssl_ctx.OP_NO_COMPRESSION
	+ openssl_ctx.OP_SINGLE_ECDH_USE
	+ openssl_ctx.OP_NO_SSLv2
	+ openssl_ctx.OP_NO_SSLv3

local ctx = openssl_ctx.new("TLSv1_2", true)
ctx:setCipherList(http_tls.intermediate_cipher_list)
ctx:setOptions(default_tls_options)
if ctx.setGroups then
	ctx:setGroups("P-521:P-384:P-256")
else
	ctx:setEphemeralKey(openssl_pkey.new{ type = "EC", curve = "prime256v1" })
end


--local ctx = http_tls.new_server_context()

if http_tls.has_alpn then
    ctx:setAlpnSelect(alpn_select, version)
end
if version == 2 then
    ctx:setOptions(openssl_ctx.OP_NO_TLSv1 + openssl_ctx.OP_NO_TLSv1_1)
end
local crt = x509.new()
crt:setVersion(3)
-- serial needs to be unique or browsers will show uninformative error messages
crt:setSerial(openssl_bignum.fromBinary(openssl_rand.bytes(16)))
-- use the host we're listening on as canonical name
local dn = name.new()
dn:add("CN", host)
crt:setSubject(dn)
crt:setIssuer(dn) -- should match subject for a self-signed
local alt = altname.new()
alt:add("DNS", host)
crt:setSubjectAlt(alt)
-- lasts for 10 years
crt:setLifetime(os.time(), os.time()+86400*3650)
-- can't be used as a CA
crt:setBasicConstraints{CA=false}
crt:setBasicConstraintsCritical(true)
-- generate a new private/public key pair
local key = pkey.new({bits=2048})
crt:setPublicKey(key)
crt:sign(key)
--assert(ctx:setPrivateKey(key))
--assert(ctx:setCertificate(crt))

local key = pkey.new([[]])

assert(ctx:setPrivateKey(key))

local crt = x509.new([[]])



assert(ctx:setCertificate(crt))





print("1")

local function reply(myserver, stream) -- luacheck: ignore 212
	-- Read in headers
	local req_headers = assert(stream:get_headers())
	local req_method = req_headers:get ":method"

	-- Log request to stdout
	assert(io.stdout:write(string.format('[%s] "%s %s HTTP/%g"  "%s" "%s"\n',
		os.date("%d/%b/%Y:%H:%M:%S %z"),
		req_method or "",
		req_headers:get(":path") or "",
		stream.connection.version,
		req_headers:get("referer") or "-",
		req_headers:get("user-agent") or "-"
	)))

	-- Build response headers
	local res_headers = http_headers.new()
	res_headers:append(":status", "200")
	res_headers:append("content-type", "text/plain")
	-- Send headers to client; end the stream immediately if this was a HEAD request
	assert(stream:write_headers(res_headers, req_method == "HEAD"))
	if req_method ~= "HEAD" then
		-- Send body, ending the stream
		assert(stream:write_chunk("Hello world!\n", true))
	end
end

print("2")

local myserver = assert(http_server.listen {
	--host = "localhost";
    host = "0.0.0.0";
    --host = "home.namelessys.de";
    --host = "88.130.15.166";
    --host = "127.0.0.1";
    --host = host;
	port = port;
	onstream = reply;
	onerror = function(myserver, context, op, err, errno) -- luacheck: ignore 212
        print("ERR")
		local msg = op .. " on " .. tostring(context) .. " failed"
		if err then
			msg = msg .. ": " .. tostring(err)
		end
		assert(io.stderr:write(msg, "\n"))
	end;
    ctx = ctx;
})

print("3")

-- Manually call :listen() so that we are bound before calling :localname()
assert(myserver:listen())
print("4")
do
	local bound_port = select(3, myserver:localname())
	assert(io.stderr:write(string.format("Now listening on port %d\n", bound_port)))
end
-- Start the main server loop
print("Start server")
assert(myserver:loop())
