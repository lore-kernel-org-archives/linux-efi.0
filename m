From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Fri, 14 Mar 2014 22:52:56 +0000
Message-ID: <1394837576.1286.27.camel@x230>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	 <CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
	 <alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>
	 <1394686919.25122.2.camel@x230>
	 <CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
	 <alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>
	 <1394726363.25122.16.camel@x230>
	 <20140313212450.67f1de8e@alan.etchedpixels.co.uk>
	 <1394746248.27846.3.camel@x230>
	 <20140313232140.03bdaac3@alan.etchedpixels.co.uk>
	 <1394762250.6416.24.camel@x230.lan>
	 <20140314122231.17b9ca8a@alan.etchedpixels.co.uk>
	 <1394801518.6416.38.camel@x230.lan>
	 <20140314170655.0ce398a3@alan.etchedpixels.co.uk>
	 <1394820664.26846.18.camel@x230.mview.int.nebula.com>
	 <20140314214806.54a3d031@alan.etchedpixels.co.uk>
	 <1394834193.1286.11.camel@x230>
	 <20140314220840.29a12171@alan.etchedpixels.co.uk>
	 <1394835345.1286.22.camel@x230>
	 <20140314223150.0b49723e@alan.etchedpixels.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20140314223150.0b49723e@alan.etchedpixels.co.uk>
Content-Language: en-US
Content-ID: <1DF9F6D16805D64C93E6BA337D63745B@namprd05.prod.outlook.com>
Sender: linux-security-module-owner@vger.kernel.org
To: "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jmorris@namei.org" <jmorris@namei.org>, "keescook@chromium.org" <keescook@chromium.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
List-Id: linux-efi@vger.kernel.org

T24gRnJpLCAyMDE0LTAzLTE0IGF0IDIyOjMxICswMDAwLCBPbmUgVGhvdXNhbmQgR25vbWVzIHdy
b3RlOg0KPiBPbiBGcmksIDE0IE1hciAyMDE0IDIyOjE1OjQ1ICswMDAwDQo+IE1hdHRoZXcgR2Fy
cmV0dCA8bWF0dGhldy5nYXJyZXR0QG5lYnVsYS5jb20+IHdyb3RlOg0KPiA+IFRoZSBnZW5lcmFs
IHByb2JsZW0gaW5jbHVkZXMgaGF2aW5nIHRvIHN1cHBvcnQgdGhpcyBldmVuIHdpdGhvdXQgYW4N
Cj4gPiBzZWxpbnV4IHBvbGljeS4NCj4gDQo+IFllcy4gTm8gZGlzcHV0ZSBhYm91dCB0aGF0LiBC
dXQgZXF1YWxseSB0aGUgZ2VuZXJhbCBzb2x1dGlvbiBzaG91bGQgYWxsb3cNCj4gZm9yIGl0Lg0K
DQpXZWxsLCBzdXJlLiBUaGUgY3VycmVudCBpbXBsZW1lbnRhdGlvbiBkb2Vzbid0IGNvbmZsaWN0
IHdpdGggc2VsaW51eCBpbg0KYW55IHdheS4NCg0KPiA+IHNvbWUgb3RoZXIgd2F5LiBDaHJvbWVP
UyB3aWxsIGxvYWQgdW5tZWFzdXJlZCBrZXJuZWwgbW9kdWxlcyBwcm92aWRlZCBpdA0KPiA+IGNh
biBhdHRlc3QgdG8gdGhlIHRydXN0d29ydGh5bmVzcyBvZiB0aGUgZmlsZXN5c3RlbSBjb250YWlu
aW5nIHRoZW0uDQo+IA0KPiBTZWUgIkhvdyB0byBCeXBhc3MgVmVyaWZpZWQgQm9vdCBTZWN1cml0
eSBpbiBDaHJvbWl1bSBPUyIgOCkNCj4gDQo+IEFuZCBpdCBhdHRlc3RzIHRoZSB0cnVzdHdvcnRo
aW5lc3Mgb2YgdGhlIGZpbGVzeXN0ZW0gYnkgbWVhc3VyaW5nIGl0LiBJZg0KPiB5b3UgaGF2ZSBh
IG1lYXN1cmVtZW50IG9mIG9iamVjdCBYIHRoYXQgc3RhdGVzIGl0IGlzIHVuY2hhbmdlZCB0aGVu
IHlvdQ0KPiBoYXZlIGEgdmFsaWQgbWVhc3VyZW1lbnQgb2YgYW55IHN1YnNldCBvZiBvYmplY3Qg
WCBmb3Igd2hpY2ggdGhlIHNhbWUNCj4gYXNzZXJ0aW9uIGlzIHByb3Zlbi4gSW4gdGhpcyBjYXNl
IHNpbmNlIHlvdSBrbm93IGFsbCB0aGUgYml0cyBpbiB0aGUgcm9vdA0KPiBmcyBhcmUgYXMgYmVm
b3JlLCBzbyB5b3Uga25vdyBhbGwgdGhlIGJpdHMgaW4gdGhlIG1vZHVsZSBhcmUgYXMgYmVmb3Jl
DQoNCllvdSBtYXkgYXR0ZXN0IHRvIHRoZSB0cnVzdHdvcnRoaW5lc3Mgb2YgYSBmaWxlc3lzdGVt
IGJ5IG1lYXN1cmluZyBpdCwNCmJ1dCB5b3UgbWF5IGFsc28gYXR0ZXN0IHRvIGl0IHZpYSBzb21l
IG90aGVyIG1lYW5zIC0gZm9yIGluc3RhbmNlLCBpdCdzDQpyZWFkLW9ubHkgYW5kIHN0b3JlZCBv
biBtZWRpYSB0aGF0IHJlcXVpcmVzIHBoeXNpY2FsIHByZXNlbmNlIHRvDQptb2RpZnkuIA0KDQot
LSANCk1hdHRoZXcgR2FycmV0dCA8bWF0dGhldy5nYXJyZXR0QG5lYnVsYS5jb20+DQo=
