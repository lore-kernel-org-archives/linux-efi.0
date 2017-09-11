From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V2 0/3] Use mm_struct and switch_mm() instead of manually
Date: Mon, 11 Sep 2017 07:10:53 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F185C4EF9@ORSMSX114.amr.corp.intel.com>
References: <1503963432-32055-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <CACi5LpMAKotBYeHpFHZKFCbZ5UST3pqFef6ALwH46JJhdhkkQw@mail.gmail.com>
 <CACi5LpOTjBbT7ngiQykTbhUbVoODvxQRj5Ub-fm7yMP8VySkpA@mail.gmail.com>
 <FFF73D592F13FD46B8700F0A279B802F1859E218@ORSMSX114.amr.corp.intel.com>
 <CACi5LpOMD=xAJz+WkHGi7D-d4xjc20Xx6E-YU1MC0UvHpEx1NA@mail.gmail.com>
 <1504664466.4482.25.camel@intel.com> <1504665789.4482.31.camel@intel.com>
 <FFF73D592F13FD46B8700F0A279B802F185ACB0E@ORSMSX114.amr.corp.intel.com>
 <CACi5LpPTD3xXy0hxQHNJVdh4km0Vu5rg4BhNW78G=EEu0SjSyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACi5LpPTD3xXy0hxQHNJVdh4km0Vu5rg4BhNW78G=EEu0SjSyg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "jlee-IBi9RG/b67k@public.gmane.org" <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Neri, Ricardo" <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Shankar, Ravi V" <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

PiBTbywgaW4gc3VtbWFyeSBpdCBzZWVtcyB0aGF0IHRoZSBwcmltYXJ5IGtlcm5lbCBib290IF9m
YWlsc18gd2l0aCB5b3VyDQo+IHYyIHBhdGNoc2V0IG9uIHRoZSByZWFsIGhhcmR3YXJlIGZvciBt
ZSBpcnJlc3BlY3RpdmUgb2Ygd2hldGhlciBJIHVzZSBNYXR0J3MNCj4gdHJlZSBvciBMaW51cydz
IHRyZWU6DQo+IA0KPiBhKSBJIHdvdWxkIHN1Z2dlc3QgdGhhdCB5b3UgcGVyZm9ybSBzb21lIG1v
cmUgY2hlY2tzIG9uIHJlYWwgaGFyZHdhcmUgYXMNCj4gcWVtdSBib290IHRlc3RzIHNvbWV0aW1l
cyBkbyBub3QgZXhwb3NlIHRoZSBwcm9ibGVtcyB3ZSBtaWdodCBzZWUgd2hlbg0KPiBib290aW5n
IGEga2VybmVsIG9uIGVmaSBjYXBhYmxlIGhhcmR3YXJlLg0KPiANCj4gYikgQWxzbyBkbyBub3Rl
IHRoYXQgYm90aCBNYXR0J3MgdHJlZSBhbmQgTGludXMncyB0cmVlIHdvcmsgZmluZSBvbiB0aGlz
IGhhcmR3YXJlDQo+IGZvciBtZSAod2l0aCB0aGUgJ25vcGNpZCcgYWRkZWQgdG8gdGhlIGJvb3Rh
cmdzKQ0KPiANCg0KSGkgQmh1cGVzaCwNCg0KVGhhbmtzIGEgbG90ISBmb3IgdGhlIGRldGFpbGVk
IGV4cGxhbmF0aW9uLiBJIHdpbGwgYWRkcmVzcyB0aGVzZSBpc3N1ZXMgaW4gVjMuDQoNClJlZ2Fy
ZHMsDQpTYWkNCg==
