From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 0/3] Use mm_struct and switch_mm() instead of manually
Date: Tue, 19 Dec 2017 06:23:51 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F2E3F763C@ORSMSX114.amr.corp.intel.com>
References: <1513469158-5638-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <CACi5LpOHm_xWodv6qd+b9nk1ivpZyR9rvicmR3UgvxuLSRmuew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACi5LpOHm_xWodv6qd+b9nk1ivpZyR9rvicmR3UgvxuLSRmuew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Neri, Ricardo" <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Shankar, Ravi V" <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

PiA+IENoYW5nZXMgaW4gVjM6DQo+ID4gMS4gV2hlbiBDUFVNQVNLX09GRlNUQUNLIGlzIGVuYWJs
ZWQsIHN3aXRjaF9tbV9pcnFzX29mZigpIHNldHMgY3B1bWFzaw0KPiA+IGJ5IGNhbGxpbmcgY3B1
bWFza19zZXRfY3B1KCkuIFRoaXMgcGFuaWNzIGtlcm5lbCBhcyBlZmlfbW0gaXMgbm90DQo+ID4g
aW5pdGlhbGl6ZWQsIHRoZXJlZm9yZSBpbml0aWFsaXplIGVmaV9tbSBpbiBlZmlfYWxsb2NfcGFn
ZV90YWJsZXMoKS4NCj4gDQo+IFRoYW5rcyBmb3IgdGhlIHYzLg0KPiANCj4gSSBjb25maXJtZWQg
dGhhdCB0aGUgaXNzdWUgSSBzYXcgd2l0aCB0aGUgdjIgd2hlbiBJIGVuYWJsZWQgJ2VmaT1kZWJ1
Zycgb24gdGhlDQo+IHNnaS11diAzMDAgbWFjaGluZSAoaS5lIHRoZSBOVUxMIHBvaW50ZXIgYWNj
ZXNzIHdoaWxlIGFjY2Vzc2luZw0KPiBtbV9jcHVtYXNrKG5leHQpLCBpbiB0aGUgZnVuY3Rpb24g
Y2FsbA0KPiAnc3dpdGNoX21tX2lycXNfb2ZmJykgaXMgZml4ZWQgaW4gdGhlIHYzLg0KPiANCj4g
QWxzbyBhcyBJIG5vdGVkIGR1cmluZyB0aGUgdjIgcmV2aWV3LCBpbnRyb2R1Y2luZyB0aGUgJ2Vm
aV9zd2l0Y2hfbW0oKSAnIGhlbHBlcg0KPiBpbnN0ZWFkIG9mIG1hbnVhbGx5IHR3aWRkbGluZyB3
aXRoICVjcjMgc2VlbXMgbW9yZSBjbGVhbmVyIChoYXZpbmcgcGVyc29uYWxseQ0KPiBkZWJ1Z2dl
ZCB0aGlzIGxlZyBzZXZlcmFsIHRpbWVzIG9uIHRoZSB1bmRlcmx5aW5nIHg4NiBFRkkgbWFjaGlu
ZXMpLg0KPiANCj4gU28gaW4gYWRkaXRpb24gdG8gbWUgdGVzdGluZyB0aGlzIG9uIHRoZSBzZ2kt
dXYzMDAgYW5kIERlbGwgT3B0aXBsZXggRUZJIGVuYWJsZWQNCj4gbWFjaGluZSwgcGxlYXNlIGZl
ZWwgZnJlZSB0byBhZGQ6DQo+IA0KPiBSZXZpZXdlZC1ieTogQmh1cGVzaCBTaGFybWEgPGJoc2hh
cm1hQHJlZGhhdC5jb20+DQo+IA0KDQpIaSAgQmh1cGVzaCwNCg0KVGhhbmtzIGZvciB0aGUgcmV2
aWV3IGFuZCByZS1pdGVyYXRpbmcgdGhlIHVzZWZ1bG5lc3Mgb2YgdGhpcyBwYXRjaCBzZXQuDQoN
ClJlZ2FyZHMsDQpTYWkNCg==
