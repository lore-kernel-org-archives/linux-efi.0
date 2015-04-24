From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 2/2] efi: an sysfs interface for user to update efi
 firmware
Date: Fri, 24 Apr 2015 02:14:47 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2CC12798@PGSMSX102.gar.corp.intel.com>
References: <20150415131906.GC21491@kroah.com>
	 <F54AEECA5E2B9541821D670476DAE19C2B8D2E74@PGSMSX102.gar.corp.intel.com>
	 <20150417134924.GB19794@kroah.com>
	 <20150417143640.GB3671@codeblueprint.co.uk>
	 <F54AEECA5E2B9541821D670476DAE19C2C279176@PGSMSX101.gar.corp.intel.com>
	 <20150420144323.GA7261@kroah.com>
	 <F54AEECA5E2B9541821D670476DAE19C2CC11869@PGSMSX102.gar.corp.intel.com>
	 <20150421075620.GA11000@kroah.com>
	 <1429665679.2207.44.camel@HansenPartnership.com>
	 <CALCETrX9GZmWnfkm-CwKW-2mPvRbNcRaY6tUY=8e0THsPBKMcA@mail.gmail.com>
	 <20150422132734.GB12062@redhat.com>
	 <1429715913.2195.22.camel@HansenPartnership.com>
	 <F54AEECA5E2B9541821D670476DAE19C2CC1259B@PGSMSX102.gar.corp.intel.com>
 <1429798187.2170.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429798187.2170.3.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYW1lcyBCb3R0b21sZXkgW21h
aWx0bzpKYW1lcy5Cb3R0b21sZXlASGFuc2VuUGFydG5lcnNoaXAuY29tXQ0KPiBTZW50OiBUaHVy
c2RheSwgQXByaWwgMjMsIDIwMTUgMTA6MTAgUE0NCj4gDQo+IE9uIFRodSwgMjAxNS0wNC0yMyBh
dCAwODozMCArMDAwMCwgS3dlaCwgSG9jayBMZW9uZyB3cm90ZToNCj4gPiA+IC0tLS0tT3JpZ2lu
YWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9tOiBKYW1lcyBCb3R0b21sZXkNCj4gW21haWx0bzpK
YW1lcy5Cb3R0b21sZXlASGFuc2VuUGFydG5lcnNoaXAuY29tXQ0KPiA+ID4gU2VudDogV2VkbmVz
ZGF5LCBBcHJpbCAyMiwgMjAxNSAxMToxOSBQTQ0KPiA+ID4NCj4gPiA+DQo+ID4gPiBZZXMsIEkg
dGhpbmsgd2UndmUgYWxsIGFncmVlZCB3ZSBjYW4gZG8gaXQgLi4uIGl0J3Mgbm93IGEgcXVlc3Rp
b24gb2Ygd2hldGhlcg0KPiB3ZQ0KPiA+ID4gY2FuIHN0b21hY2ggdGhlIGljayBmYWN0b3Igb2Yg
YWN0dWFsbHkgaW5pdGlhdGluZyBhIHRyYW5zYWN0aW9uIGluIGNsb3NlIC4uLiBJJ20NCj4gc3Rp
bGwNCj4gPiA+IGZlZWxpbmcgcXVlYXN5Lg0KPiA+DQo+ID4gVGhlIGZpbGUgImNsb3NlIiBoZXJl
IGNhbiBJIHVuZGVyc3RhbmQgdGhhdCB0aGUgZmlsZSBzeXN0ZW0gd2lsbCBjYWxsIHRoZQ0KPiAi
cmVsZWFzZSINCj4gPiBmdW5jdGlvbiBhdCB0aGUgZmlsZV9vcGVyYXRpb25zIHN0cnVjdD8NCj4g
PiBodHRwOi8vbHhyLmZyZWUtZWxlY3Ryb25zLmNvbS9zb3VyY2UvaW5jbHVkZS9saW51eC9mcy5o
I0wxNTM4DQo+ID4NCj4gPiBTbywgSmFtZXMgeW91IGFyZSBtZWFuaW5nIHRoYXQgd2UgY291bGQg
aW5pdGlhdGluZyB0aGUgdXBkYXRlIHRyYW5zYWN0aW9uDQo+ID4gaW5zaWRlIHRoZSBmX29wcy0+
cmVsZWFzZSgpIGFuZCByZXR1cm4gdGhlIGVycm9yIGNvZGUgaWYgdXBkYXRlIGZhaWxlZCBpbiB0
aGlzDQo+ID4gZnVuY3Rpb24/DQo+IA0KPiBXZWxsLCB0aGF0J3Mgd2hhdCBJIHdhcyB0aGlua2lu
Zy4gIEhvd2V2ZXIgdGhlIHJldHVybiB2YWx1ZSBvZiAtPnJlbGVhc2UNCj4gZG9lc24ndCBnZXQg
cHJvcGFnYXRlZCBpbiBzeXNfY2xvc2UgKG9yIGluZGVlZCBhbnl3aGVyZSAuLi4gbm8gaWRlYSB3
aHkNCj4gaXQgcmV0dXJucyBhbiBpbnQpIHRoYW5rcyB0byB0aGUgdGFzayB3b3JrIGFkZGl0aW9u
cywgc28gd2UnZCBhY3R1YWxseQ0KPiBoYXZlIHRvIHVzZSB0aGUgb3BlcmF0aW9uIHdob3NlIHZh
bHVlIGlzIHByb3BhZ2F0ZWQgaW4gc3lzX2Nsb3NlKCkgd2hpY2gNCj4gdHVybnMgb3V0IHRvIGJl
IGZsdXNoLg0KPiANCj4gSmFtZXMNCj4gDQoNCk9rYXksIEkgdGhpbmsgSSBnb3QgeW91LiBKdXN0
IHRvIGRvdWJsZSBjaGVjayBmb3IgaW4gY2FzZTogeW91IGFyZSBtZWFuaW5nDQp0byBpbXBsZW1l
bnQgaXQgYXQgZl9vcHMtPmZsdXNoKCkgaW5zdGVhZCBvZiBmX29wcy0+cmVsZWFzZSgpLg0KDQoN
ClRoYW5rcyAmIFJlZ2FyZHMsDQpXaWxzb24NCg0K
