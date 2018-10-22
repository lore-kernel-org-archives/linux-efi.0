From: "Fan, Chao" <fanc.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v9 5/8] x86/boot: Add get_acpi_rsdp() to parse RSDP in
 cmdlien from kexec
Date: Mon, 22 Oct 2018 05:30:38 +0000
Message-ID: <B74D54765E346E448CD6C7B7B0334C258D955469@G08CNEXMBSHAD01.g08.fujitsu.local>
References: <20181017102012.872-1-fanc.fnst@cn.fujitsu.com>
 <20181017102012.872-6-fanc.fnst@cn.fujitsu.com>
 <20181021022650.GI1885@192.168.1.4>
Mime-Version: 1.0
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181021022650.GI1885@192.168.1.4>
Content-Language: zh-CN
Content-ID: <7527F92A7A5A7F489B913DFE6429EBED@fujitsu.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Baoquan He <bhe@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "bp@alien8.de" <bp@alien8.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "keescook@chromium.org" <keescook@chromium.org>, "msys.mizuma@gmail.com" <msys.mizuma@gmail.com>, "Indoh, Takao" <indou.takao@fujitsu.com>, "Cao, Jin" <caoj.fnst@cn.fujitsu.com>
List-Id: linux-efi@vger.kernel.org

T24gU3VuLCBPY3QgMjEsIDIwMTggYXQgMTA6MjY6NTBBTSArMDgwMCwgQmFv
cXVhbiBIZSB3cm90ZToNCj5PbiAxMC8xNy8xOCBhdCAwNjoyMHBtLCBDaGFv
IEZhbiB3cm90ZToNCj4+IElmIEtFWEVDIHdyaXRlIHRoZSBSU0RQIHBvaW50
ZXIgdG8gY21kbGluZSwgcGFyc2UgdGhlIGNtZGxpbmUNCj4+IGFuZCB1c2Ug
aXQuDQo+PiBJbWl0YXRlIGZyb20gZWFybHlfcGFyYW0gb2YgImFjcGlfcnNk
cCIuDQo+PiANCj4+IFNpZ25lZC1vZmYtYnk6IENoYW8gRmFuIDxmYW5jLmZu
c3RAY24uZnVqaXRzdS5jb20+DQo+PiAtLS0NCj4+ICBhcmNoL3g4Ni9ib290
L2NvbXByZXNzZWQvYWNwaXRiLmMgfCAyMyArKysrKysrKysrKysrKysrKysr
KysrKw0KPj4gIDEgZmlsZSBjaGFuZ2VkLCAyMyBpbnNlcnRpb25zKCspDQo+
PiANCj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9ib290L2NvbXByZXNzZWQv
YWNwaXRiLmMgYi9hcmNoL3g4Ni9ib290L2NvbXByZXNzZWQvYWNwaXRiLmMN
Cj4+IGluZGV4IDUwZmE2NWNmODI0ZC4uMzdiMWY0NDA3YmU4IDEwMDY0NA0K
Pj4gLS0tIGEvYXJjaC94ODYvYm9vdC9jb21wcmVzc2VkL2FjcGl0Yi5jDQo+
PiArKysgYi9hcmNoL3g4Ni9ib290L2NvbXByZXNzZWQvYWNwaXRiLmMNCj4+
IEBAIC04LDYgKzgsOSBAQA0KPj4gICNpbmNsdWRlIDxsaW51eC9udW1hLmg+
DQo+PiAgI2luY2x1ZGUgPGxpbnV4L2FjcGkuaD4NCj4+ICANCj4+ICsjZGVm
aW5lIFNUQVRJQw0KPj4gKyNpbmNsdWRlIDxsaW51eC9kZWNvbXByZXNzL21t
Lmg+DQo+PiArDQo+PiAgLyogU2VhcmNoIEVGSSB0YWJsZSBmb3IgUlNEUCB0
YWJsZS4gKi8NCj4+ICBzdGF0aWMgdm9pZCBlZmlfZ2V0X3JzZHBfYWRkcihh
Y3BpX3BoeXNpY2FsX2FkZHJlc3MgKnJzZHBfYWRkcikNCj4+ICB7DQo+PiBA
QCAtMjAwLDMgKzIwMywyMyBAQCBzdGF0aWMgdm9pZCBiaW9zX2dldF9yc2Rw
X2FkZHIoYWNwaV9waHlzaWNhbF9hZGRyZXNzICpyc2RwX2FkZHIpDQo+PiAg
CQkqcnNkcF9hZGRyID0gKGFjcGlfcGh5c2ljYWxfYWRkcmVzcylhZGRyZXNz
Ow0KPj4gIAl9DQo+PiAgfQ0KPj4gKw0KPj4gK3N0YXRpYyB2b2lkIGdldF9h
Y3BpX3JzZHAoYWNwaV9waHlzaWNhbF9hZGRyZXNzICpyc2RwX2FkZHIpDQo+
PiArew0KPj4gKyNpZmRlZiBDT05GSUdfS0VYRUMNCj4+ICsJdW5zaWduZWQg
bG9uZyBsb25nIHJlczsNCj4+ICsJaW50IGxlbiA9IDA7DQo+PiArCWNoYXIg
KnZhbDsNCj4+ICsNCj4+ICsJdmFsID0gbWFsbG9jKDIwKTsNCj4NCj5XaHkg
aXMgdGhlIGxlbmd0aCAyMD8gRGVmaW5lZCBhIG1hY3JvPw0KPg0KDQpOb3Qg
YSBjYWxjdWxhdGlvbiwgaWYgaXQncyBlbm91Z2ggdG8gc3RvcmUgdGhlIGFk
ZHJlc3MsIHRoYXQgd2lsbCBiZSBPSy4NCg0KVGhhbmtzLA0KQ2hhbyBGYW4N
Cg0KPj4gKwlsZW4gPSBjbWRsaW5lX2ZpbmRfb3B0aW9uKCJhY3BpX3JzZHAi
LCB2YWwsIDIwKTsNCj4+ICsNCj4+ICsJaWYgKGxlbiA9PSAtMSkNCj4+ICsJ
CXJldHVybjsNCj4+ICsNCj4+ICsJaWYgKGxlbiA+IDApIHsNCj4+ICsJCXZh
bFtsZW5dID0gMDsNCj4+ICsJCSpyc2RwX2FkZHIgPSAoYWNwaV9waHlzaWNh
bF9hZGRyZXNzKWtzdHJ0b3VsbCh2YWwsIDAsICZyZXMpOw0KPj4gKwl9DQo+
PiArI2VuZGlmDQo+PiArfQ0KPj4gLS0gDQo+PiAyLjE3LjINCj4+IA0KPj4g
DQo+PiANCj4NCj4NCgoK
