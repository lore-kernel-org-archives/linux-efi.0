From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 07/14] rtc-efi: add GMTOFF support to rtc_efi
Date: Fri, 20 Dec 2013 15:11:45 +0000
Message-ID: <1387552304.17961.0.camel@x230>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
	 <1387439515-8926-8-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387439515-8926-8-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Content-Language: en-US
Content-ID: <1B08EDECAD988A4C894B0F7DEF3D9B82-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org" <samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jlee-IBi9RG/b67k@public.gmane.org" <jlee-IBi9RG/b67k@public.gmane.org>, "a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org" <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, "Elliott-VXdhtT5mjnY@public.gmane.org" <Elliott-VXdhtT5mjnY@public.gmane.org>, "werner-IBi9RG/b67k@public.gmane.org" <werner-IBi9RG/b67k@public.gmane.org>, "rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "oneukum-l3A5Bk7waGM@public.gmane.org" <oneukum-l3A5Bk7waGM@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "trenn-l3A5Bk7waGM@public.gmane.org" <trenn-l3A5Bk7waGM@public.gmane.org>, "JBeulich-IBi9RG/b67k@public.gmane.org" <JBeulich-IBi9RG/b67k@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org" <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gVGh1LCAyMDEzLTEyLTE5IGF0IDE1OjUxICswODAwLCBMZWUsIENodW4tWWkgd3JvdGU6DQo+
IFRoaXMgcGF0Y2ggYWRkcyAyIG5ldyBpb3RybDogUlRDX1JEX0dNVE9GRiBhbmQgUlRDX1NFVF9H
TVRPRkYgdG8NCj4gcnRjX2VmaSBzdXBwb3J0IGdldC9zZXQgZ210IG9mZnNldCB0aGF0IG1hcHBp
bmcgdG8gdGhlIEdVTidzIHRtX2dtdG9mZg0KPiBleHRlbnNpb24gKFNlY29uZHMgZWFzdCBvZiBV
VEMpLg0KDQpTaG91bGRuJ3QgdGhpcyBpbmZvcm1hdGlvbiBhbHNvIGJlIGV4cG9ydGVkIHZpYSB0
aGUgcnRjLXN5c2ZzIGludGVyZmFjZT8NCg0KLS0gDQpNYXR0aGV3IEdhcnJldHQgPG1hdHRoZXcu
Z2FycmV0dEBuZWJ1bGEuY29tPg0K
