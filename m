From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 1/8] lib/uuid: Introduce uuid_{be|le}_cmp_p{p}()
 helpers
Date: Sun, 23 Apr 2017 20:20:33 +0000
Message-ID: <1492975128.3570.2.camel@intel.com>
References: <20170421144645.45189-1-andriy.shevchenko@linux.intel.com>
         <5B8DA87D05A7694D9FA63FD143655C1B543E8399@hasmsx108.ger.corp.intel.com>
         <CAHp75VeTgdE=OiRNS6JrH3M-rF+jpPVgmd4G+n321=vhVE4XiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHp75VeTgdE=OiRNS6JrH3M-rF+jpPVgmd4G+n321=vhVE4XiA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <5D6A48AB91F1A947BA5214B76B765CAE-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Koul, Vinod" <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org" <devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org>, "kwankhede-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org" <kwankhede-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org" <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org" <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "mika.westerberg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <mik>
List-Id: linux-efi@vger.kernel.org

T24gU3VuLCAyMDE3LTA0LTIzIGF0IDE1OjQyICswMzAwLCBBbmR5IFNoZXZjaGVua28gd3JvdGU6
DQo+IE9uIFN1biwgQXByIDIzLCAyMDE3IGF0IDE6MjkgUE0sIFdpbmtsZXIsIFRvbWFzIDx0b21h
cy53aW5rbGVyQGludGVsLg0KPiBjb20+IHdyb3RlOg0KPiA+ID4gTmV3IGhlbHBlcnMgdGFrZSBw
b2ludGVycyB0byB1dWlkX3tiZXxsZX0gYXMgcGFyYW1ldGVycy4NCj4gPiA+IA0KPiA+ID4gV2hl
biB1c2luZyB0aGVtIG9uIGEgcmF3IGRhdGEgd2UgZG9uJ3QgbmVlZCB0byBkbyBhbiB1Z2x5DQo+
ID4gPiBkZXJlZmVyZW5jZSBhbmQsDQo+ID4gPiBpbiBzb21lIGNhc2VzLCBhIHR5cGUgY2FzdGlu
Zy4NCj4gPiBJIHRoaW5rIHRoaXMgZ29pbmcgb3ZlcmJvYXJkLCB0aGUgX3BwIHR5cGVzwqDCoGFy
ZSBqdXN0IGVub3VnaC4NCj4gDQo+IEkgbG9va2VkIGF0IGV4aXN0aW5nIHVzZXJzIGFuZCB0aGVy
ZSBhcmUgY2FzZXMgbGlrZQ0KPiAjZGVmaW5lIFhYWF9VVUlEIFVVSURfLi4uKGEsIGIsIGMsIC4u
LikNCj4gDQo+IHV1aWRfLipfY21wKHZhbHVlLCBYWFhfVVVJRCkNCj4gDQo+IEZvciBfcHAgdmFy
aWFudCBpZiB3b3VsZCBiZSBfY21wX3BwKHZhbHVlLCAmWFhYX1VVSUQpIHdoaWNoIGlzDQo+IHNs
aWdodGx5IHdvcnNlIHRoYW4gZm9yIF9wIHZhcmlhbnQuDQoNCg0KTWF5YmUgaXQncyB3b3J0aCB0
byBhY3R1YWxseSByZXBsYWNlIHRoZSBkZWZpbmVzIHdpdGggdmFyaWFibGVzIHRoYW4gdG8NCmNy
ZWF0ZSBhbiBpbnRlcmZhY2Ugd2l0aCBhbGwgdGhlIHBlcm11dGF0aW9ucy4NCg0KVG9tYXMNCg==
