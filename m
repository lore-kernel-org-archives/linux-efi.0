From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
Date: Fri, 20 Dec 2013 20:32:12 +0000
Message-ID: <1387571531.17961.6.camel@x230>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
	 <52B309EB.90300@zytor.com> <1387512357.3539.4317.camel@linux-s257.site>
	 <52B3C5F0.1060303@zytor.com> <1387552565.17961.3.camel@x230>
	 <83120989-e634-47c0-9bae-0c7899df64ab@email.android.com>
	 <1387558713.17961.4.camel@x230>
	 <a049daea-a713-4d06-b35f-61f3bec06ba9@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a049daea-a713-4d06-b35f-61f3bec06ba9-2ueSQiBKiTY7tOexoI0I+QC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Content-ID: <5181413D5263A742AE3301DEF7603B38-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org" <samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org>, "jlee-IBi9RG/b67k@public.gmane.org" <jlee-IBi9RG/b67k@public.gmane.org>, "bp-l3A5Bk7waGM@public.gmane.org" <bp-l3A5Bk7waGM@public.gmane.org>, "a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org" <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, "Elliott-VXdhtT5mjnY@public.gmane.org" <Elliott-VXdhtT5mjnY@public.gmane.org>, "werner-IBi9RG/b67k@public.gmane.org" <werner-IBi9RG/b67k@public.gmane.org>, "rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "oneukum-l3A5Bk7waGM@public.gmane.org" <oneukum-l3A5Bk7waGM@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "trenn-l3A5Bk7waGM@public.gmane.org" <trenn-l3A5Bk7waGM@public.gmane.org>, "JBeulich-IBi9RG/b67k@public.gmane.org" <JBeulich-IBi9RG/b67k@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org" <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gRnJpLCAyMDEzLTEyLTIwIGF0IDEyOjI5IC0wODAwLCBILiBQZXRlciBBbnZpbiB3cm90ZToN
Cj4gWWVzLCBidXQgdGhlIFRaIGlzbid0IGFsbCB0aGF0IGNyaXRpY2FsLCBlaXRoZXIuICBJdCBj
ZXJ0YWlubHkgZG9lc24ndCBtYXR0ZXIgYXQgYWxsIGZvciBhIHB1cmUgTGludXggc3lzdGVtLg0K
DQpObywgYnV0IGl0IGRvZXMgbWF0dGVyIGZvciBhIGdyZWF0IG51bWJlciBvZiBkZXBsb3llZCBM
aW51eCBzeXN0ZW1zLg0KRGVhbGluZyB3aXRoIHRoZSB0aW1lem9uZSBvdmVyIERTVCBjaGFuZ2Vz
IGhhcyBiZWVuIGEgcGVycGV0dWFsIHByb2JsZW0sDQphbmQgaWYgd2UgY2FuIG1ha2UgdGhhdCB3
b3JrIHRoZW4gbGlmZSB3aWxsIGJlIHNpZ25pZmljYW50bHkgYmV0dGVyLg0KDQotLSANCk1hdHRo
ZXcgR2FycmV0dCA8bWF0dGhldy5nYXJyZXR0QG5lYnVsYS5jb20+DQo=
