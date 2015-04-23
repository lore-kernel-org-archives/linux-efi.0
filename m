From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 2/2] efi: an sysfs interface for user to update efi
 firmware
Date: Thu, 23 Apr 2015 08:30:44 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2CC1259B@PGSMSX102.gar.corp.intel.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429715913.2195.22.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYW1lcyBCb3R0b21sZXkgW21h
aWx0bzpKYW1lcy5Cb3R0b21sZXlASGFuc2VuUGFydG5lcnNoaXAuY29tXQ0KPiBTZW50OiBXZWRu
ZXNkYXksIEFwcmlsIDIyLCAyMDE1IDExOjE5IFBNDQo+IA0KPiANCj4gWWVzLCBJIHRoaW5rIHdl
J3ZlIGFsbCBhZ3JlZWQgd2UgY2FuIGRvIGl0IC4uLiBpdCdzIG5vdyBhIHF1ZXN0aW9uIG9mIHdo
ZXRoZXIgd2UNCj4gY2FuIHN0b21hY2ggdGhlIGljayBmYWN0b3Igb2YgYWN0dWFsbHkgaW5pdGlh
dGluZyBhIHRyYW5zYWN0aW9uIGluIGNsb3NlIC4uLiBJJ20gc3RpbGwNCj4gZmVlbGluZyBxdWVh
c3kuDQoNClRoZSBmaWxlICJjbG9zZSIgaGVyZSBjYW4gSSB1bmRlcnN0YW5kIHRoYXQgdGhlIGZp
bGUgc3lzdGVtIHdpbGwgY2FsbCB0aGUgInJlbGVhc2UiDQpmdW5jdGlvbiBhdCB0aGUgZmlsZV9v
cGVyYXRpb25zIHN0cnVjdD8NCmh0dHA6Ly9seHIuZnJlZS1lbGVjdHJvbnMuY29tL3NvdXJjZS9p
bmNsdWRlL2xpbnV4L2ZzLmgjTDE1MzgNCg0KU28sIEphbWVzIHlvdSBhcmUgbWVhbmluZyB0aGF0
IHdlIGNvdWxkIGluaXRpYXRpbmcgdGhlIHVwZGF0ZSB0cmFuc2FjdGlvbg0KaW5zaWRlIHRoZSBm
X29wcy0+cmVsZWFzZSgpIGFuZCByZXR1cm4gdGhlIGVycm9yIGNvZGUgaWYgdXBkYXRlIGZhaWxl
ZCBpbiB0aGlzDQpmdW5jdGlvbj8NCg0KDQpUaGFua3MgJiBSZWdhcmRzLA0KV2lsc29uDQo=
