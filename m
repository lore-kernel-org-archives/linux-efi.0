From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Fri, 14 Mar 2014 20:43:57 +0000
Message-ID: <1394829836.1286.5.camel@x230>
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
	 <1394825094.1286.1.camel@x230>
	 <alpine.DEB.2.02.1403141335590.12964@nftneq.ynat.uz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1403141335590.12964@nftneq.ynat.uz>
Content-Language: en-US
Content-ID: <A086F10470A9E34BBBB5DA34E7E7168F@namprd05.prod.outlook.com>
Sender: linux-security-module-owner@vger.kernel.org
To: "david@lang.hm" <david@lang.hm>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jmorris@namei.org" <jmorris@namei.org>, "keescook@chromium.org" <keescook@chromium.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>, "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
List-Id: linux-efi@vger.kernel.org

T24gRnJpLCAyMDE0LTAzLTE0IGF0IDEzOjM3IC0wNzAwLCBEYXZpZCBMYW5nIHdyb3RlOg0KPiBP
biBGcmksIDE0IE1hciAyMDE0LCBNYXR0aGV3IEdhcnJldHQgd3JvdGU6DQo+ID4gQXMgYW4gZXhh
bXBsZSwgaW1hZ2luZSBhIHBsYXRmb3JtIHdpdGggdGhlIGJvb3Rsb2FkZXIgYW5kIGtlcm5lbCBv
bg0KPiA+IHJlYWQtb25seSBtZWRpYS4gVGhlIHBsYXRmb3JtIGNhbiBhc3NlcnQgdGhhdCB0aGUg
a2VybmVsIGlzIHRydXN0ZWQgZXZlbg0KPiA+IGlmIHRoZXJlJ3Mgbm8gbWVhc3VyZW1lbnQgb2Yg
dGhlIGtlcm5lbC4NCj4gDQo+IFRydXN0ZWQgYnkgd2hvPw0KDQpUaGUgcGxhdGZvcm0uIElmIHlv
dSBkb24ndCB0cnVzdCB0aGUgcGxhdGZvcm0ncyBhYmlsaXR5IHRvIG1ha2UgdGhhdA0KZGVjaXNp
b24gdGhlbiB0aGF0J3Mgc29tZXRoaW5nIHRoYXQgaW5mb3JtcyB5b3VyIG93biBiZWhhdmlvdXIs
IG5vdCB0aGUNCnBsYXRmb3JtJ3MuDQoNCj4gQWxhbiBpcyBzYXlpbmcgbWVhc3VyZWQgYmVjYXVz
ZSB0aGVuIGlmIGl0IG1hdGNoZXMgd2hhdCB0aGUgb3duZXIgb2YgdGhhdCBkZXZpY2UgDQo+IGlu
dGVuZHMgaXQncyB0cnVzdGVkLCBidXQganVzdCBiZWNhdXNlIHlvdSB0cnVzdCBpdCBkb2Vzbid0
IG1lYW4gdGhhdCBJIHRydXN0IA0KPiBpdCwgYW5kIGl0IGRvZXNuJ3QgbWVhbiB0aGF0IHRoZSBy
dXNzaWFuIGdvdmVybm1lbnQgc2hvdWxkIHRydXN0IGl0LCBldGMuDQoNCiJNZWFzdXJlZCIgaGFz
IGEgc3BlY2lmaWMgbWVhbmluZy4gSWYgeW91IHRydXN0IGEgZmlsZSBiYXNlZCBvbiBpdHMNCnNv
dXJjZSByYXRoZXIgdGhhbiBzb21lIHByb3BlcnR5IG9mIHRoZSBmaWxlIGl0c2VsZiwgeW91J3Jl
IG5vdA0KbWVhc3VyaW5nIGl0Lg0KDQotLSANCk1hdHRoZXcgR2FycmV0dCA8bWF0dGhldy5nYXJy
ZXR0QG5lYnVsYS5jb20+DQo=
