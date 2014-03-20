From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Thu, 20 Mar 2014 17:12:05 +0000
Message-ID: <1395335525.16016.3.camel@x230>
References: <1394762250.6416.24.camel@x230.lan>
	 <20140314122231.17b9ca8a@alan.etchedpixels.co.uk>
	 <1394801518.6416.38.camel@x230.lan>
	 <20140314170655.0ce398a3@alan.etchedpixels.co.uk>
	 <1394820664.26846.18.camel@x230.mview.int.nebula.com>
	 <20140314214806.54a3d031@alan.etchedpixels.co.uk>
	 <1394834193.1286.11.camel@x230>
	 <20140314220840.29a12171@alan.etchedpixels.co.uk>
	 <20140314231832.GA653@thunk.org>
	 <CAGXu5j+JXy4EbHxu+8twWo=3gqyLJ6hZGPbgsdf3t8YhUA-bWw@mail.gmail.com>
	 <20140320145507.GB20618@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140320145507.GB20618-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Content-Language: en-US
Content-ID: <5AD5D3E378B571469A6A3C63FE37928B-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "tytso-3s7WtUTddSA@public.gmane.org" <tytso-3s7WtUTddSA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org" <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org" <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, "gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org" <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gVGh1LCAyMDE0LTAzLTIwIGF0IDEwOjU1IC0wNDAwLCB0eXRzb0BtaXQuZWR1IHdyb3RlOg0K
DQo+IEkgZGlzYWdyZWU7IGl0J3MgaGlnaGx5IGxpa2VseSwgaWYgbm90IGNlcnRhaW4gdGhhdCBX
aW5kb3dzIGJvb3RpbmcNCj4gdW5kZXIgVUVGSSBzZWN1cmUgYm9vdCBpcyBnb2luZyB0byBiZSBh
YmxlIHRvIGRvIHNvbWUgb2YgdGhlIHRoaW5ncw0KPiB0aGF0IHBlb3BsZSBhcmUgcHJvcG9zaW5n
IHRoYXQgd2UgaGF2ZSB0byBwcm9oaWJpdCBpbiB0aGUgbmFtZSBvZg0KPiBzZWN1cml0eS4gIFRo
YXQncyBiZWNhdXNlIHByZXN1bWFibHkgV2luZG93cyB3b24ndCBiZSB3aWxsaW5nIHRvIG1ha2UN
Cj4gY2VydGFpbiB1c2FiaWxpdHkgdHJhZGVvZmZzLCBhbmQgc2luY2UgdGhleSBjb250cm9sIHRo
ZSBzaWduaW5nIGNlcnRzLA0KPiBldmVuIGluIHRoZSB1bmxpa2VseSBjYXNlIHRoYXQgcGVvcGxl
IGNhbiBsZXZlcmFnZSB0aGVzZSAiaG9sZXMiIHRvDQo+IGVuYWJsZSBhIGJvb3Qgc2VjdG9yIHZp
cnVzLCBpdCBzZWVtcyB1bmxpa2VseSB0aGF0IFdpbmRvd3Mgd2lsbCByZXZva2UNCj4gaXRzIG93
biBjZXJ0Lg0KDQpJIGRvbid0IHRoaW5rIGFueSBvZiB0aGUgZnVuY3Rpb25hbGl0eSB3ZSdyZSBk
aXNhYmxpbmcgKHdpdGggdGhlDQphcmd1YWJsZSBleGNlcHRpb24gb2Yga2V4ZWMsIHdoaWNoLCBh
Z2FpbiwgdGhlcmUgaXMgYSBwbGFuIHRvIGhhbmRsZSkgaXMNCnVzZWZ1bCBvbiBtb2Rlcm4gc3lz
dGVtcy4gQW5kLCBzZXJpb3VzbHksIGlmIHRoaXMgZm9yY2VzIHZlbmRvcnMgdG8NCndyaXRlIGFj
dHVhbCBrZXJuZWwgZHJpdmVycyByYXRoZXIgdGhhbiBydW4gYW4gaW8gcG9ydCBiYW5naW5nIElQ
TUkNCmRyaXZlciBpbiB1c2Vyc3BhY2UsIHRoYXQncyBhICpnb29kKiB0aGluZy4NCg0KV2hldGhl
ciBNaWNyb3NvZnQgd291bGQgYWN0dWFsbHkgZm9sbG93IHRocm91Z2ggb24gYmxhY2tsaXN0aW5n
IHRoZWlyDQpvd24gc2lnbmF0dXJlcyBpcyBvYnZpb3VzbHkgYW4gdW5rbm93biAtIHRoZXkndmUg
dG9sZCB1cyB0aGV5IHdvdWxkLCBidXQNCmNvbW1lcmNpYWwgY29uY2VybnMgZXRjIHdobyBrbm93
cy4gVGhleSAqd2lsbCogYmxhY2tsaXN0IG91ciBzaWduYXR1cmVzLg0KDQotLSANCk1hdHRoZXcg
R2FycmV0dCA8bWF0dGhldy5nYXJyZXR0QG5lYnVsYS5jb20+DQo=
