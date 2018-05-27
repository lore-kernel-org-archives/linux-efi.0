From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH V4 0/3] Use efi_rts_wq to invoke EFI Runtime Services
Date: Sun, 27 May 2018 15:47:23 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F3954D5DF@ORSMSX114.amr.corp.intel.com>
References: <1527285903-31799-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <CAKv+Gu_oNUmOwTgM9sAsfMn4WgY+grC2f12vRC4HH9CgxxkfXQ@mail.gmail.com>
 <FFF73D592F13FD46B8700F0A279B802F39481456@ORSMSX114.amr.corp.intel.com>
 <CAKv+Gu_eShqmjkDSXnFs-_Hcay67+JTMdb6TatNZpV2v5_MoaQ@mail.gmail.com>
 <FFF73D592F13FD46B8700F0A279B802F3952F0CF@ORSMSX114.amr.corp.intel.com>
 <CAKv+Gu96gURHioy7hRLW2reyUwYMQDSLHhGE=m_TOz9CYF_Tjw@mail.gmail.com>
 <FFF73D592F13FD46B8700F0A279B802F39539372@ORSMSX114.amr.corp.intel.com>
 <CAKv+Gu9U5Ap37J-56=oDOuUfbcMyGaMnTZh1+JKHDTPU5pteZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9U5Ap37J-56=oDOuUfbcMyGaMnTZh1+JKHDTPU5pteZQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, "Hansen, Dave" <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, Naresh Bhat <naresh.bhat@linaro.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Williams, Dan J" <dan.j.williams@intel.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
List-Id: linux-efi@vger.kernel.org

PiA+IEFub3RoZXIgZm9sbG93IG9uIHF1ZXN0aW9uIGlzLCBkb2VzIGV2ZXJ5IGZpcm13YXJlIHN1
cHBvcnQgYm90aA0KPiA+IGJsb2NraW5nIGFuZCBub24tYmxvY2tpbmcgdmFyaWFudHMgKHNwZWNp
YWxseSBsZWdhY3kgRUZJIGZpcm13YXJlKT8gSQ0KPiA+IGFtIHdvcnJpZWQgYWJvdXQgdGhpcyBi
ZWNhdXNlLCBwcmVzZW50bHkgZWZpX2RlbGV0ZV9kdW1teV92YXJpYWJsZSgpDQo+ID4gdXNlcyBz
ZXRfdmFyaWFibGUoKSBhbmQNCj4gPiBxdWVyeV92YXJpYWJsZV9pbmZvKCkgYnV0IGlmIEkgY2hh
bmdlIGVmaV9kZWxldGVfZHVtbXlfdmFyaWFibGUoKSB0bw0KPiA+IHVzZSBub24tYmxvY2tpbmcg
dmFyaWFudHMgYW5kIGlmIHRoZXkgYXJlbuKAmXQgc3VwcG9ydGVkLCB0aGVuLCBJIGd1ZXNzLA0K
PiA+IGVmaV9kZWxldGVfZHVtbXlfdmFyaWFibGUoKSBtaWdodCBmYWlsIDooDQo+ID4NCj4gPiBT
bywgY291bGQgeW91IHBsZWFzZSBjbGFyaWZ5IG9uIHRoYXQ/DQo+ID4NCj4gDQo+IEkgZG9uJ3Qg
Zm9sbG93LiBXaHkgc2hvdWxkIGl0IG1ha2UgYW55IGRpZmZlcmVuY2UgdG8gdGhlIGZpcm13YXJl
IHdoZXRoZXIgdGhlDQo+IE9TIHJvdXRpbmVzIGJsb2NrcyBvciBnaXZlcyB1cD8gV2UgYWx3YXlz
IGhvbm9yIHRoZSBtdXR1YWwgZXhjbHVzaW9uIGJldHdlZW4NCj4gZGlmZmVyZW50IGludm9jYXRp
b25zIG9mIHJ1bnRpbWUgc2VydmljZXMsIGFuZCB0aGUgZmlybXdhcmUgaXRzZWxmIGhhcyBubw0K
PiBhd2FyZW5lc3Mgb2YgdGhlIGtpbmQgb2Ygc2NoZWR1bGluZyB0aGUgT1MgbmVlZHMgdG8gZG8g
dG8gZW5zdXJlIHRoaXMuDQoNClNvcnJ5ISBteSBiYWQuLiBJIHRob3VnaHQgZmlybXdhcmUgKHdp
dGggRUZJIFN5c3RlbSB0YWJsZSByZXZpc2lvbiA+IDIuMCApIG9mZmVycyB0d28gDQp0eXBlcyBv
ZiBlZmkgcnVuIHRpbWUgc2VydmljZXMsIGEgYmxvY2tpbmcgdmFyaWFudCBhbmQgYSBub24tYmxv
Y2tpbmcgdmFyaWFudC4gQnV0LCBub3cgSSANCm5vdGljZWQgaW4gdGhlIHNwZWMgdGhhdCB0aGVy
ZSBpcyBvbmx5IHNldF92YXJpYWJsZSgpIGJ1dCBfbm9fIHNldF92YXJpYWJsZV9ub25ibG9ja2lu
ZygpLiANClNhbWUgd2l0aCBxdWVyeV92YXJpYWJsZV9pbmZvKCkuIFRoZSBzYW1lIGlzIGFsc28g
c2VlbiBpbiBydW50aW1lLXdyYXBwZXJzLmMgZmlsZS4gDQpCb3RoIHRoZSBibG9ja2luZyBhbmQg
bm9uLWJsb2NraW5nIHZhcmlhbnRzIGNhbGwgdGhlIHNhbWUgZWZpIHJ1bnRpbWUgc2VydmljZS4g
SSBzZWUgdGhhdCANCm5vbi1ibG9ja2luZygpIHZhcmlhbnRzIGFyZSBqdXN0IGFuIGFkZGl0aW9u
YWwgZmVhdHVyZSAoQVBJKSBvZmZlcmVkIGJ5IE9TLg0KDQpSZWdhcmRzLA0KU2FpDQo=
