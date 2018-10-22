From: "Fan, Chao" <fanc.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v9 6/8] x86/boot: Dig out SRAT table from RSDP and find
 immovable memory
Date: Mon, 22 Oct 2018 05:29:51 +0000
Message-ID: <B74D54765E346E448CD6C7B7B0334C258D95543F@G08CNEXMBSHAD01.g08.fujitsu.local>
References: <20181017102012.872-1-fanc.fnst@cn.fujitsu.com>
 <20181017102012.872-7-fanc.fnst@cn.fujitsu.com>
 <20181021023458.GJ1885@192.168.1.4>
Mime-Version: 1.0
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181021023458.GJ1885@192.168.1.4>
Content-Language: zh-CN
Content-ID: <D7C9B52C65D415418BC53C79C15F89DE@fujitsu.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Baoquan He <bhe@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "bp@alien8.de" <bp@alien8.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "keescook@chromium.org" <keescook@chromium.org>, "msys.mizuma@gmail.com" <msys.mizuma@gmail.com>, "Indoh, Takao" <indou.takao@fujitsu.com>, "Cao, Jin" <caoj.fnst@cn.fujitsu.com>
List-Id: linux-efi@vger.kernel.org

T24gU3VuLCBPY3QgMjEsIDIwMTggYXQgMTA6MzQ6NThBTSArMDgwMCwgQmFv
cXVhbiBIZSB3cm90ZToNCj5PbiAxMC8xNy8xOCBhdCAwNjoyMHBtLCBDaGFv
IEZhbiB3cm90ZToNCj4+ICsJaWYgKCFjbWRsaW5lX2ZpbmRfb3B0aW9uX2Jv
b2woIm1vdmFibGVfbm9kZSIpIHx8DQo+PiArCSAgICBjbWRsaW5lX2ZpbmRf
b3B0aW9uX2FyZygiYWNwaSIsICJvZmYiLCAzKSkNCj4+ICsJCXJldHVybjsN
Cj4+ICsNCj4+ICsJdGFibGVfaGVhZGVyID0gZ2V0X2FjcGlfc3JhdF90YWJs
ZSgpOw0KPj4gKwlpZiAoIXRhYmxlX2hlYWRlcikNCj4+ICsJCXJldHVybjsN
Cj4+ICsNCj4+ICsJdGFibGVfZW5kID0gKHVuc2lnbmVkIGxvbmcpdGFibGVf
aGVhZGVyICsgdGFibGVfaGVhZGVyLT5sZW5ndGg7DQo+PiArDQo+PiArCXRh
YmxlID0gKHN0cnVjdCBhY3BpX3N1YnRhYmxlX2hlYWRlciAqKQ0KPj4gKwkJ
KCh1bnNpZ25lZCBsb25nKXRhYmxlX2hlYWRlciArIHNpemVvZihzdHJ1Y3Qg
YWNwaV90YWJsZV9zcmF0KSk7DQo+PiArDQo+PiArCXdoaWxlICgoKHVuc2ln
bmVkIGxvbmcpdGFibGUpICsNCj4+ICsJCSAgICAgICBzaXplb2Yoc3RydWN0
IGFjcGlfc3VidGFibGVfaGVhZGVyKSA8IHRhYmxlX2VuZCkgew0KPj4gKwkJ
aWYgKHRhYmxlLT50eXBlID09IEFDUElfU1JBVF9UWVBFX01FTU9SWV9BRkZJ
TklUWSkgew0KPj4gKwkJCW1hID0gKHN0cnVjdCBhY3BpX3NyYXRfbWVtX2Fm
ZmluaXR5ICopdGFibGU7DQo+PiArCQkJaWYgKCEobWEtPmZsYWdzICYgQUNQ
SV9TUkFUX01FTV9IT1RfUExVR0dBQkxFKSkgew0KPj4gKwkJCQlpbW1vdmFi
bGVfbWVtW2ldLnN0YXJ0ID0gbWEtPmJhc2VfYWRkcmVzczsNCj4+ICsJCQkJ
aW1tb3ZhYmxlX21lbVtpXS5zaXplID0gbWEtPmxlbmd0aDsNCj4+ICsJCQkJ
aSsrOw0KPj4gKwkJCX0NCj4+ICsNCj4+ICsJCQlpZiAoaSA+PSBNQVhfTlVN
Tk9ERVMqMikNCj4JCU5vIHdhcm5pbmcgbWVzc2FnZSBwcmludGVkIGluIHRo
aXMgY2FzZT8NCg0KSSB3aWxsIGFkZC4gQlRXLCB3aGF0IG1lc3NhZ2UgaXMg
YXBwcm9wcmlhdGU/DQpJIGNhbid0IGZpZ3VyZSBvdXQgaW4gd2hhdCBjb25k
aXRpb24sIGkgPj0gTUFYX05VTU5PREVTKjIuDQoNClRoYW5rcywNCkNoYW8g
RmFuDQoNCj4+ICsJCQkJYnJlYWs7DQo+PiArCQl9DQo+PiArCQl0YWJsZSA9
IChzdHJ1Y3QgYWNwaV9zdWJ0YWJsZV9oZWFkZXIgKikNCj4+ICsJCQkoKHVu
c2lnbmVkIGxvbmcpdGFibGUgKyB0YWJsZS0+bGVuZ3RoKTsNCj4+ICsJfQ0K
Pj4gKwludW1faW1tb3ZhYmxlX21lbSA9IGk7DQo+PiArfQ0KPj4gZGlmZiAt
LWdpdCBhL2FyY2gveDg2L2Jvb3QvY29tcHJlc3NlZC9taXNjLmggYi9hcmNo
L3g4Ni9ib290L2NvbXByZXNzZWQvbWlzYy5oDQo+PiBpbmRleCA0MDM3ODQw
OGQ5ODAuLjcwYzQwM2UxNDQ0YyAxMDA2NDQNCj4+IC0tLSBhL2FyY2gveDg2
L2Jvb3QvY29tcHJlc3NlZC9taXNjLmgNCj4+ICsrKyBiL2FyY2gveDg2L2Jv
b3QvY29tcHJlc3NlZC9taXNjLmgNCj4+IEBAIC0xMjEsMyArMTIxLDEzIEBA
IHN0YXRpYyBpbmxpbmUgdm9pZCBjb25zb2xlX2luaXQodm9pZCkNCj4+ICB2
b2lkIHNldF9zZXZfZW5jcnlwdGlvbl9tYXNrKHZvaWQpOw0KPj4gIA0KPj4g
ICNlbmRpZg0KPj4gKw0KPj4gKy8qIGFjcGl0Yi5jICovDQo+PiArI2lmZGVm
IENPTkZJR19SQU5ET01JWkVfQkFTRQ0KPj4gK2ludCBudW1faW1tb3ZhYmxl
X21lbTsNCj4+ICsjaWZkZWYgQ09ORklHX01FTU9SWV9IT1RSRU1PVkUNCj4+
ICsvKiBTdG9yZSB0aGUgYW1vdW50IG9mIGltbW92YWJsZSBtZW1vcnkgcmVn
aW9ucyAqLw0KPj4gKyNkZWZpbmUgQUNQSV9NQVhfVEFCTEVTICAgICAgICAg
ICAgICAgIDEyOA0KPj4gK3ZvaWQgZ2V0X2ltbW92YWJsZV9tZW0odm9pZCk7
DQo+PiArI2VuZGlmDQo+PiArI2VuZGlmDQo+PiAtLSANCj4+IDIuMTcuMg0K
Pj4gDQo+PiANCj4+IA0KPg0KPg0KCgo=
