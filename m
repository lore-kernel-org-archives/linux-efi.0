From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH] efi: Free existing memory map before installing new
 memory map
Date: Wed, 27 Jun 2018 07:28:01 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F4605BAD9@ORSMSX111.amr.corp.intel.com>
References: <1529980892-11833-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <CAKv+Gu-_tQsYMUMp4NGrEkRrbFGJvE=vJVciaO6TEAC_u5bmfQ@mail.gmail.com>
 <FFF73D592F13FD46B8700F0A279B802F4605BA0F@ORSMSX111.amr.corp.intel.com>
 <CAKv+Gu982OPp73Tg5Rru3+1ymq6_P8XpFPROQPdZMSUDdwEOmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu982OPp73Tg5Rru3+1ymq6_P8XpFPROQPdZMSUDdwEOmw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Dave Young <dyoung@redhat.com>, Laszlo Ersek <lersek@redhat.com>, Bhupesh Sharma <bhsharma@redhat.com>, "Neri, Ricardo" <ricardo.neri@intel.com>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

PiA+IEFsc28sIGNvdWxkIHlvdSBwbGVhc2UgY2xhcmlmeSBpZiB0aGVyZSBpcyBhbnkgc3BlY2lm
aWMgcmVhc29uIHdoeQ0KPiA+IG1lbW9yeSBhbGxvY2F0ZWQgdXNpbmcgbWVtYmxvY2tfcmVzZXJ2
ZSgpIHNob3VsZG4ndCBiZSBmcmVlZC4gSSBtZWFuLA0KPiA+IG5vdCB3aXRoIG1lbWJsb2NrX2Zy
ZWUoKSBidXQgSSB0aGluayB3ZSBjb3VsZCBtYWtlIGl0IF9hdmFpbGFibGVfDQo+ID4gdXNpbmcg
ZnJlZV9ib290bWVtKCkgKG9yIHNvbWV0aGluZyBzaW1pbGFyLCBwbGVhc2UgY29ycmVjdCBtZSBp
ZiB0aGlzIGlzIG5vdA0KPiB0aGUgcmlnaHQgQVBJKS4NCj4gDQo+IE9uIGFybTY0LCB0aGUgbWVt
b3J5IG1hcCBpcyBwcm92aWRlZCB0byB0aGUgY29yZSBrZXJuZWwgYnkgdGhlIHN0dWIsIGFuZCBh
ZnRlcg0KPiBrZXhlYywgYSBwb2ludGVyIHRvIHRoZSBzYW1lIG1lbW9yeSBtYXAgd2lsbCBiZSBw
YXNzZWQgdG8gdGhlIG5leHQga2VybmVsLiBTbw0KPiB0aGUga2VybmVsIGRvZXMgbm90ICdvd24n
IHRoYXQgYWxsb2NhdGlvbiwgYW5kIGl0IHNob3VsZCBub3QgZnJlZSBpdCBvciBvdmVyd3JpdGUN
Cj4gaXQuDQoNClRoYW5rcyBmb3IgdGhlIHJlcGx5LiBJdCBjb25maXJtcyB0aGF0IHRoZSBpc3N1
ZSBpcyBvbmx5IG9uIHg4NiBzeXN0ZW1zLg0KSSBzZWUgdGhhdCBhcm02NCBkb2Vzbid0IGNhbGwg
ZWZpX21lbW1hcF9hbGxvYygpIGFuZCBoZW5jZSB0aGVyZSBpcyBubyBjb25jZXB0IA0Kb2YgYWxs
b2NhdGluZyBtZW1vcnkgZm9yIG5ldyBtZW1vcnkgbWFwIGFuZCBpbnN0YWxsaW5nIGl0IChzbyBu
byBtZW1vcnkgbGVhaykuDQoNClJlZ2FyZHMsDQpTYWkNCg==
