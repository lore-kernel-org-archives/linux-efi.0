From: "Chen, Yu C" <yu.c.chen@intel.com>
Subject: RE: [PATCH][RFC v3] ACPI / PM: Fix poweroff issue on HW-full
 platforms without _S5
Date: Mon, 7 Mar 2016 15:53:13 +0000
Message-ID: <36DF59CE26D8EE47B0655C516E9CE640286D329F@shsmsx102.ccr.corp.intel.com>
References: <1457319045-25434-1-git-send-email-yu.c.chen@intel.com>
 <CAJZ5v0iWjW_XJEsVBM1yyimxUQMDaWapQ_OrN45TeFXFySd0rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <CAJZ5v0iWjW_XJEsVBM1yyimxUQMDaWapQ_OrN45TeFXFySd0rw@mail.gmail.com>
Content-Language: en-US
Sender: linux-pm-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Zhang, Rui" <rui.zhang@intel.com>
List-Id: linux-efi@vger.kernel.org

SGkgUmFmYWVsLA0KKHJlc2VuZCBmb3IgYnJva2VuIGNvbnRlbnQpDQoNCj4gLS0tLS1PcmlnaW5h
bCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogcmp3eXNvY2tpQGdtYWlsLmNvbSBbbWFpbHRvOnJqd3lz
b2NraUBnbWFpbC5jb21dIE9uIEJlaGFsZiBPZg0KPiBSYWZhZWwgSi4gV3lzb2NraQ0KPiBTZW50
OiBNb25kYXksIE1hcmNoIDA3LCAyMDE2IDk6MTkgUE0NCj4gVG86IENoZW4sIFl1IEMNCj4gQ2M6
IEFDUEkgRGV2ZWwgTWFsaW5nIExpc3Q7IHg4NkBrZXJuZWwub3JnOyBsaW51eC1lZmlAdmdlci5r
ZXJuZWwub3JnOyBMaW51eA0KPiBLZXJuZWwgTWFpbGluZyBMaXN0OyBsaW51eC1wbUB2Z2VyLmtl
cm5lbC5vcmc7IFJhZmFlbCBKLiBXeXNvY2tpOyBMZW4gQnJvd247DQo+IE1hdHQgRmxlbWluZzsg
VGhvbWFzIEdsZWl4bmVyOyBJbmdvIE1vbG5hcjsgSC4gUGV0ZXIgQW52aW47IFpoYW5nLCBSdWkN
Cj4gU3ViamVjdDogUmU6IFtQQVRDSF1bUkZDIHYzXSBBQ1BJIC8gUE06IEZpeCBwb3dlcm9mZiBp
c3N1ZSBvbiBIVy1mdWxsDQo+IHBsYXRmb3JtcyB3aXRob3V0IF9TNQ0KPiANCltjdXRdDQo+ID4g
IGJvb2wgZWZpX3Bvd2Vyb2ZmX3JlcXVpcmVkKHZvaWQpDQo+ID4gIHsNCj4gPiAtICAgICAgIHJl
dHVybiAhIWFjcGlfZ2JsX3JlZHVjZWRfaGFyZHdhcmU7DQo+ID4gKyAgICAgICByZXR1cm4gYWNw
aV9nYmxfcmVkdWNlZF9oYXJkd2FyZSB8fCAoYWNwaV9ub19zNSAmJg0KPiA+ICsgIXBtX3Bvd2Vy
X29mZik7DQo+IA0KPiBXaGF0IGlmIENPTkZJR19BQ1BJIGlzIG5vdCBzZXQgaGVyZT8NCklmIENP
TkZJR19BQ1BJIGlzIG5vdCBzZXQsIHRoaXMgZmlsZSB3b3VsZCBub3QgDQpiZSBjb21waWxlZCwg
YmVjYXVzZSBDT05GSUdfRUZJIGRlcGVuZHMgb24gQ09ORklHX0FDUEkuDQoNCnRoYW5rcywNCnl1
DQo=
