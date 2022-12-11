# docker-squid-network-proxy
Docker squid network proxy that takes allow list as an environment variable argument.
New lines should be escaped as \n between each entry on the command line.
Each server should have a new line after it, and if you want to include subdomains, the entry should be preceeded by `.`.

## Sample Usage
```
docker run --env ALLOW_LIST=".example.com\n.google.com\n" -p 8080:8080 dylanmtaylor/squid-network-proxy:latest
```

Alternatively, there is another version of this image with a 'passthrough' tag.
It forwards traffic on to the destination and writes connections ot the access log (stdout on the container). The passthrough version is useful for generating an allow list by looking at the traffic going through the proxy before switching to the restrictive container variant.

## Testing the proxy
You can test to see how squid behaves by using curl with the `-x` argument. In this example, I use the run command from above.

When you try to connect to an allowed site, the request goes through as expected:
```
➜  ~ curl -x localhost:8080 google.com
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
```

Here is a site not in the allow list:

```
➜  ~ curl -x localhost:8080 test.com
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html><head>
<meta type="copyright" content="Copyright (C) 1996-2021 The Squid Software Foundation and contributors">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>ERROR: The requested URL could not be retrieved</title>
<style type="text/css"><!--
 /*
 * Copyright (C) 1996-2022 The Squid Software Foundation and contributors
 *
 * Squid software is distributed under GPLv2+ license and includes
 * contributions from numerous individuals and organizations.
 * Please see the COPYING and CONTRIBUTORS files for details.
 */

/*
 Stylesheet for Squid Error pages
 Adapted from design by Free CSS Templates
 http://www.freecsstemplates.org
 Released for free under a Creative Commons Attribution 2.5 License
*/

/* Page basics */
* {
        font-family: verdana, sans-serif;
}

html body {
        margin: 0;
        padding: 0;
        background: #efefef;
        font-size: 12px;
        color: #1e1e1e;
}

/* Page displayed title area */
#titles {
        margin-left: 15px;
        padding: 10px;
        padding-left: 100px;
        background: url('/squid-internal-static/icons/SN.png') no-repeat left;
}

/* initial title */
#titles h1 {
        color: #000000;
}
#titles h2 {
        color: #000000;
}

/* special event: FTP success page titles */
#titles ftpsuccess {
        background-color:#00ff00;
        width:100%;
}

/* Page displayed body content area */
#content {
        padding: 10px;
        background: #ffffff;
}

/* General text */
p {
}

/* error brief description */
#error p {
}

/* some data which may have caused the problem */
#data {
}

/* the error message received from the system or other software */
#sysmsg {
}

pre {
}

/* special event: FTP / Gopher directory listing */
#dirmsg {
    font-family: courier, monospace;
    color: black;
    font-size: 10pt;
}
#dirlisting {
    margin-left: 2%;
    margin-right: 2%;
}
#dirlisting tr.entry td.icon,td.filename,td.size,td.date {
    border-bottom: groove;
}
#dirlisting td.size {
    width: 50px;
    text-align: right;
    padding-right: 5px;
}

/* horizontal lines */
hr {
        margin: 0;
}

/* page displayed footer area */
#footer {
        font-size: 9px;
        padding-left: 10px;
}


body
:lang(fa) { direction: rtl; font-size: 100%; font-family: Tahoma, Roya, sans-serif; float: right; }
:lang(he) { direction: rtl; }
 --></style>
</head><body id=ERR_ACCESS_DENIED>
<div id="titles">
<h1>ERROR</h1>
<h2>The requested URL could not be retrieved</h2>
</div>
<hr>

<div id="content">
<p>The following error was encountered while trying to retrieve the URL: <a href="http://test.com/">http://test.com/</a></p>

<blockquote id="error">
<p><b>Access Denied.</b></p>
</blockquote>

<p>Access control configuration prevents your request from being allowed at this time. Please contact your service provider if you feel this is incorrect.</p>

<p>Your cache administrator is <a href="mailto:webmaster?subject=CacheErrorInfo%20-%20ERR_ACCESS_DENIED&amp;body=CacheHost%3A%20a98e91f0156c%0D%0AErrPage%3A%20ERR_ACCESS_DENIED%0D%0AErr%3A%20%5Bnone%5D%0D%0ATimeStamp%3A%20Sun,%2011%20Dec%202022%2023%3A46%3A11%20GMT%0D%0A%0D%0AClientIP%3A%20172.17.0.1%0D%0A%0D%0AHTTP%20Request%3A%0D%0AGET%20%2F%20HTTP%2F1.1%0AUser-Agent%3A%20curl%2F7.86.0%0D%0AAccept%3A%20*%2F*%0D%0AProxy-Connection%3A%20Keep-Alive%0D%0AHost%3A%20test.com%0D%0A%0D%0A%0D%0A">webmaster</a>.</p>
<br>
</div>

<hr>
<div id="footer">
<p>Generated Sun, 11 Dec 2022 23:46:11 GMT by a98e91f0156c (squid/5.6)</p>
<!-- ERR_ACCESS_DENIED -->
</div>
</body></html>
```

As you can see, squid is blocking anything not explicitly allowed.

