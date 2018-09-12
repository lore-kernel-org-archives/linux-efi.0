From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH V6 2/2] x86/efi: Add efi page fault handler to recover
 from page faults caused by the firmware
Date: Wed, 12 Sep 2018 19:02:58 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F485BB609@ORSMSX114.amr.corp.intel.com>
References: <1536693322-8335-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1536693322-8335-3-git-send-email-sai.praneeth.prakhya@intel.com>
 <alpine.DEB.2.21.1809122055190.1473@nanos.tec.linutronix.de>
 <CAKv+Gu9yDEfUFkTK0orYLjRfs+=WXwPvr44a2q0ALiWMNEpmDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9yDEfUFkTK0orYLjRfs+=WXwPvr44a2q0ALiWMNEpmDg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-efi@vger.kernel.org

PiBPbiAxMiBTZXB0ZW1iZXIgMjAxOCBhdCAyMDo1NiwgVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxp
bnV0cm9uaXguZGU+IHdyb3RlOg0KPiA+IE9uIFR1ZSwgMTEgU2VwIDIwMTgsIFNhaSBQcmFuZWV0
aCBQcmFraHlhIHdyb3RlOg0KPiA+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9maXJtd2FyZS9lZmkv
cnVudGltZS13cmFwcGVycy5jDQo+IGIvZHJpdmVycy9maXJtd2FyZS9lZmkvcnVudGltZS13cmFw
cGVycy5jDQo+ID4+IGluZGV4IGIxOGIyZDg2NGMyYy4uNzQ1NTI3N2EzYjY1IDEwMDY0NA0KPiA+
PiAtLS0gYS9kcml2ZXJzL2Zpcm13YXJlL2VmaS9ydW50aW1lLXdyYXBwZXJzLmMNCj4gPj4gKysr
IGIvZHJpdmVycy9maXJtd2FyZS9lZmkvcnVudGltZS13cmFwcGVycy5jDQo+ID4+IEBAIC02MSw2
ICs2MSwxMSBAQCBzdHJ1Y3QgZWZpX3J1bnRpbWVfd29yayBlZmlfcnRzX3dvcms7DQo+ID4+ICAo
eyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBcDQo+ID4+ICAgICAgIGVmaV9ydHNfd29yay5zdGF0dXMgPSBFRklfQUJPUlRF
RDsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+
ID4+ICsgICAgIGlmICghZWZpX2VuYWJsZWQoRUZJX1JVTlRJTUVfU0VSVklDRVMpKSB7ICAgICAg
ICAgICAgICAgICAgICAgICBcDQo+ID4+ICsgICAgICAgICAgICAgcHJfaW5mbygiQWJvcnRpbmch
IEVGSSBSdW50aW1lIFNlcnZpY2VzIGRpc2FibGVkXG4iKTsgICBcDQo+ID4NCj4gPiBUaGlzIHBy
b2JhYnkgd2FudHMgdG8gYmUgcHJfaW5mb19pbmNlKCkuDQo+ID4NCg0KWWVzLi4gdGhhdCBtYWtl
cyBzZW5zZS4NCg0KPiANCj4gSSBjYW4gZml4IHRoYXQgdXAgd2hlbiBhcHBseWluZy4NCj4NCg0K
VGhhbmtzIGEgbG90ISBBcmQuDQogDQo+ID4gT3RoZXIgdGhhbiB0aGF0Og0KPiA+DQo+ID4gICAg
ICAgUmV2aWV3ZWQtYnk6IFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRlPg0KPiAN
Cj4gVGhhbmtzISBJIHdpbGwgcXVldWUgdGhpcyB1cCBpbiBlZmkvbmV4dA0K
