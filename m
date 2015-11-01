From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v9 1/1] efi: a misc char interface for user to update
 efi firmware
Date: Sun, 1 Nov 2015 11:11:23 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C4A879A18@PGSMSX102.gar.corp.intel.com>
References: <1446055138-26047-1-git-send-email-hock.leong.kweh@intel.com>
 <1446055138-26047-2-git-send-email-hock.leong.kweh@intel.com>
 <20151101102944.GA12711@pd.tnic>
 <F54AEECA5E2B9541821D670476DAE19C4A8799FB@PGSMSX102.gar.corp.intel.com>
 <20151101105801.GB12711@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151101105801.GB12711-fF5Pk5pvG8Y@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Anvin, H Peter" <h.peter.anvin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCb3Jpc2xhdiBQZXRrb3YgW21h
aWx0bzpicEBhbGllbjguZGVdDQo+IFNlbnQ6IFN1bmRheSwgTm92ZW1iZXIgMDEsIDIwMTUgNjo1
OCBQTQ0KPiANCj4gT24gU3VuLCBOb3YgMDEsIDIwMTUgYXQgMTA6NTI6NTJBTSArMDAwMCwgS3dl
aCwgSG9jayBMZW9uZyB3cm90ZToNCj4gPiBDb3VsZCB5b3Ugc2hhcmUgbWUgeW91ciBkdW1iIGZp
bGU/IEkgZGlkIHBlcmZvcm0gbmVnYXRpdmUgdGVzdCwgYnV0IEkgZGlkDQo+ID4gbm90IGdldCB0
aGVzZSBkdW1wIHN0YWNrIGluIGRtZXNnLiBUaGFua3MuDQo+IA0KPiBJIHRoaW5rIGFsbW9zdCBh
bnkgZmlsZSB3b3JrczoNCj4gDQo+IGNhdCAvYmluL2xzID4gL2Rldi9lZmlfY2Fwc3VsZV9sb2Fk
ZXINCg0KT2suIFdpbGwgdHJ5IHRoaXMgb3V0Lg0KDQo+IA0KPiA+ID4gPiArI2RlZmluZSBVUExP
QURfRE9ORSAtMQ0KPiA+ID4NCj4gPiA+IElzbid0IHRoZSBmYWN0IHRoYXQgdXBsb2FkIHdhcyBm
aW5pc2hlZCBhIHN1Y2Nlc3MgbWVzc2FnZT8gSWYgc28sIHdoeSBpcyBpdCBhDQo+ID4gPiBuZWdh
dGl2ZSB2YWx1ZT8NCj4gPg0KPiA+IFRoaXMgaXMgdG8gaW5kaWNhdGUgYW4gdXBsb2FkIGlzIGRv
bmUgYW5kIHBlbmRpbmcgZm9yIGNsb3NlKDIpLiBJZiBhDQo+IHN1YnNlcXVlbmNlDQo+ID4gd3Jp
dGUoMikgcGVyZm9ybSwgcmV0dXJuIGVycm9yLiBDb21tZW50cyBpbnB1dHRlZCBieSBNYXR0IGFu
ZCBBbmR5Lg0KPiANCj4gQnV0IGluIHRoYXQgY2FzZSB5b3UgY2FuIHJldHVybiBFUlJfT0NDVVJS
RUQuIFVQTE9BRF9ET05FIHN0aWxsIGRvZXNuJ3QNCj4gbG9vayBsaWtlIGEgbmVnYXRpdmUgdmFs
dWUgdG8gbWUgYXMgaXQgc2lnbmFscyB0aGF0IHRoZSB1cGxvYWQgd2FzIGRvbmUNCj4gYW5kIHRo
dXMgc3VjY2Vzc2Z1bCBhcyBubyBlcnJvcnMgaGFwcGVuZWQgZHVyaW5nIHRoZSB1cGxvYWQuDQo+
IA0KDQpIbW0gLi4uLiBJZiBJIGNvbWJpbmUgdGhlc2UgMiBmbGFncyB0byBiZWNvbWUgb25lIGFz
ICJOT19NT1JFX1dSSVRFX0FDVElPTiINCnRvIGJldHRlciBkZXNjcmliaW5nIHRoZSBzaXR1YXRp
b24sIHlvdSBPa2F5IHdpdGggaXQ/DQoNClJlZ2FyZHMsDQpXaWxzb24NCg0K
