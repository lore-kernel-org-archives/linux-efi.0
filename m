From: "Neri, Ricardo" <ricardo.neri@intel.com>
Subject: Re: 4.9-rc1 boot regression, ambiguous bisect result
Date: Thu, 3 Nov 2016 00:41:18 +0000
Message-ID: <1478133678.2513.4.camel@ranerica-desktop>
References: <CAPcyv4gDYcahNJ6CEzf2eUGq8sGqW8Yo09T8cscGWTLoja7PXw@mail.gmail.com>
         <20161020122931.GD19876@codeblueprint.co.uk>
         <CAPcyv4hT+yQvnQzfb49FP-+vVaVKHTYEj1EjNd9Xvu0Wr8T+Bg@mail.gmail.com>
         <CAPcyv4gE0wtoR3Yxh6axiQpPE2MvDgGW=JLEz9b7OMSBQZ_HDQ@mail.gmail.com>
         <20161021154129.GH27807@codeblueprint.co.uk>
         <20161021202022.GI27807@codeblueprint.co.uk>
         <CAPcyv4jkVcBwecxwt1P+p-fMSuen9B9xHEVf0BjM5uJZ4_jAdw@mail.gmail.com>
         <4a73a7d8-599c-eb25-0f78-d921a16bb56f@leemhuis.info>
         <CAPcyv4gNyUMU+r-N-qa6ZrF0zG2AuirR0NqVRu40jAgNqc5MNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4gNyUMU+r-N-qa6ZrF0zG2AuirR0NqVRu40jAgNqc5MNw@mail.gmail.com>
Content-Language: en-US
Content-ID: <60EBEFD677969248A79F9EB82B8EABB1@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "regressions@leemhuis.info" <regressions@leemhuis.info>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "pjones@redhat.com" <pjones@redhat.com>, "mingo@kernel.org" <mingo@kernel.org>
List-Id: linux-efi@vger.kernel.org

T24gU3VuLCAyMDE2LTEwLTMwIGF0IDA4OjU5IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFN1biwgT2N0IDMwLCAyMDE2IGF0IDU6MDggQU0sIFRob3JzdGVuIExlZW1odWlzDQo+IDxy
ZWdyZXNzaW9uc0BsZWVtaHVpcy5pbmZvPiB3cm90ZToNCj4gPiBKRllJOiBJIGFkZGVkIHRoaXMg
cmVwb3J0IHRvIHRoZSBsaXN0IG9mIHJlZ3Jlc3Npb25zIGZvciBMaW51eCA0LjkuIEknbGwNCj4g
PiB3YXRjaCB0aGlzIHRocmVhZCBmb3IgZnVydGhlciB1cGRhdGVzIG9uIHRoaXMgaXNzdWUgdG8g
ZG9jdW1lbnQgcHJvZ3Jlc3MNCj4gPiBpbiBteSB3ZWVrbHkgcmVwb3J0cy4gUGxlYXNlIGxldCBt
ZSBrbm93IHZpYSByZWdyZXNzaW9uc0BsZWVtaHVpcy5pbmZvDQo+ID4gaW4gY2FzZSB0aGUgZGlz
Y3Vzc2lvbiBtb3ZlcyB0byBhIGRpZmZlcmVudCBwbGFjZSAoYnVnemlsbGEgb3IgYW5vdGhlcg0K
PiA+IG1haWwgdGhyZWFkIGZvciBleGFtcGxlKS4gdGlhIQ0KPiA+DQo+ID4gQ3VycmVudCBzdGF0
dXMgKGFmYWljcykgaW4gbXkgcmVwb3J0OiBUaGlzIGxvb2tzIHN0dWNrLiBPciB3YXMgaXMNCj4g
PiBkaXNjdXNzZWQgKG9yIGV2ZW4gZml4ZWQpIHNvbWV3aGVyZSBlbHNlPw0KPiANCj4gVGhhbmtz
LCBhbmQgbm8sIG5vdCBmaXhlZCB5ZXQuIEkndmUgbm90IGZvdW5kIHRoZSB0aW1lIHRvIHJ1biB0
aGUNCj4gZXhwZXJpbWVudHMgTWF0dCBuZWVkcywgYnV0IGEgY29sbGVhZ3VlIGhhcyBvZmZlcmVk
IHRvIGxvb2sgaW50byBpdC4NCj4gLS0NCj4gVG8gdW5zdWJzY3JpYmUgZnJvbSB0aGlzIGxpc3Q6
IHNlbmQgdGhlIGxpbmUgInVuc3Vic2NyaWJlIGxpbnV4LWVmaSIgaW4NCj4gdGhlIGJvZHkgb2Yg
YSBtZXNzYWdlIHRvIG1ham9yZG9tb0B2Z2VyLmtlcm5lbC5vcmcNCj4gTW9yZSBtYWpvcmRvbW8g
aW5mbyBhdCAgaHR0cDovL3ZnZXIua2VybmVsLm9yZy9tYWpvcmRvbW8taW5mby5odG1sDQoNCkRh
biwgd2FzIHRoZXJlIGEgc3BlY2lhbCBjb25maWd1cmF0aW9uIHRoYXQgeW91IGVuYWJsZWQgZm9y
IHRoaXMgYnVnPw0KVGhlIHBlcnNvbiB3b3JraW5nIG9uIHRoZSBidWcgY2FuJ3QgcmVwcm9kdWNl
IHRoZSBidWcgaW4gdjQuOS1yYzEgb3INCnY0LjktcmMzLg0K
