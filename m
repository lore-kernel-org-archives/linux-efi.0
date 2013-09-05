From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 03/11] x86: Lock down IO port access when module
 security is enabled
Date: Thu, 5 Sep 2013 03:58:45 +0000
Message-ID: <1378353524.13193.26.camel@x230>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-4-git-send-email-matthew.garrett@nebula.com>
	 <5227FFE8.5050102@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5227FFE8.5050102-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <20382F52C93E8C47A347896EBF08F954-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gV2VkLCAyMDEzLTA5LTA0IGF0IDIwOjUyIC0wNzAwLCBILiBQZXRlciBBbnZpbiB3cm90ZToN
Cj4gT24gMDkvMDMvMjAxMyAwNDo1MCBQTSwgTWF0dGhldyBHYXJyZXR0IHdyb3RlOg0KPiA+IElP
IHBvcnQgYWNjZXNzIHdvdWxkIHBlcm1pdCB1c2VycyB0byBnYWluIGFjY2VzcyB0byBQQ0kgY29u
ZmlndXJhdGlvbg0KPiA+IHJlZ2lzdGVycywgd2hpY2ggaW4gdHVybiAob24gYSBsb3Qgb2YgaGFy
ZHdhcmUpIGdpdmUgYWNjZXNzIHRvIE1NSU8gcmVnaXN0ZXINCj4gPiBzcGFjZS4gVGhpcyB3b3Vs
ZCBwb3RlbnRpYWxseSBwZXJtaXQgcm9vdCB0byB0cmlnZ2VyIGFyYml0cmFyeSBETUEsIHNvIGxv
Y2sNCj4gPiBpdCBkb3duIGJ5IGRlZmF1bHQuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogTWF0
dGhldyBHYXJyZXR0IDxtYXR0aGV3LmdhcnJldHRAbmVidWxhLmNvbT4NCj4gDQo+IFNlcmlvdXNs
eS4uLiBqdXN0IGRlbnkgQ0FQX1NZU19SQVdJTyB0byBhbnkgc3lzdGVtIGluIHNlY3VyZSBtb2Rl
Lg0KDQpOby4gQ0FQX1NZU19SQVdJTyBibG9ja3MgdGhpbmdzIHRoYXQgd2UgZG9uJ3Qgd2FudCBi
bG9ja2VkICh4ODYNCm1pY3JvY29kZSB1cGRhdGVzLCB2YXJpb3VzIGRpc2sgaW9jdGxzLCAqZGV2
aWNlIGZpcm13YXJlIHVwbG9hZHMqIGFuZCBhDQpmZXcgb3RoZXJzKSAtIHRoZSBzZW1hbnRpY3Mg
anVzdCBkb24ndCBtYXRjaC4gV2UgY291bGQgcmVsYXggdGhvc2UNCnBlcm1pc3Npb25zLCBidXQg
dGhlbiB3ZSdkIHBvdGVudGlhbGx5IGJyZWFrIHNvbWVvbmUgZWxzZSdzIHNlY3VyaXR5DQpjb25z
aWRlcmF0aW9ucy4NCg0KLS0gDQpNYXR0aGV3IEdhcnJldHQgPG1hdHRoZXcuZ2FycmV0dEBuZWJ1
bGEuY29tPg0K
