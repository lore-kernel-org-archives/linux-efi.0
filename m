From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] efi: Distinguish between "remaining space" and
 actually used space
Date: Wed, 3 Apr 2013 13:48:33 +0000
Message-ID: <1364996911.19098.9.camel@x230>
References: <515150EC.7040203@redhat.com>
	 <1364829240-26475-1-git-send-email-matthew.garrett@nebula.com>
	 <1364829240-26475-2-git-send-email-matthew.garrett@nebula.com>
	 <515C2A86.6070606@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <515C2A86.6070606-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Content-Language: en-US
Content-ID: <C11D2126FC1FDC408E865A6C492E1806-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org" <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, "jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org" <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gV2VkLCAyMDEzLTA0LTAzIGF0IDE0OjExICswMTAwLCBNYXR0IEZsZW1pbmcgd3JvdGU6DQoN
Cj4gVGhpcyBsb29rcyBsaWtlIHNvbWV0aGluZyB0aGF0IHdpbGwgZGlmZmVyIGJldHdlZW4gaW1w
bGVtZW50YXRpb25zLCBhbmQgdGhlDQo+IGZhY3QgdGhhdCBpdCdzIGFwcGVhcmluZyBpbiBvdXIg
Y29kZSBpcyBhIHN1cmUgc2lnbiB0aGF0IHRoaXMgaXNuJ3QgdGhlIHdheSB0bw0KPiBnby4NCg0K
T3VyIGNob2ljZXMgcmlnaHQgbm93IGFyZToNCg0KMSkgQnJlYWsgbWFjaGluZXMgdGhhdCBkb24n
dCBnYXJiYWdlIGNvbGxlY3Qgb24gZXZlcnkgcmVib290DQoyKSBMZWF2ZSBTYW1zdW5ncyAoYW5k
IHNvbWUgTGVub3Zvcz8pIHZ1bG5lcmFibGUgdG8gYnJpY2tpbmcNCjMpIE1haW50YWluIGEgd2hp
dGVsaXN0IG9yIGJsYWNrbGlzdCB0aGF0IHdpbGwgaW5ldml0YWJseSBiZSBpbmFkZXF1YXRlLA0K
ZWl0aGVyIGJyZWFraW5nIG90aGVyd2lzZSB3b3JraW5nIG1hY2hpbmVzIG9yIHJpc2tpbmcgYnJp
Y2tpbmcgb2YgYnJva2VuDQpvbmVzDQo0KSBBdHRlbXB0IHRvIGltcGxlbWVudCBzb21ldGhpbmcg
dGhhdCdsbCB3b3JrIGluIGFsbCBjYXNlcw0KDQpEZWFsaW5nIHdpdGggZmlybXdhcmUgaXMgaGFy
ZC4gVGhpcyBmaXhlcyAoMSkgd2l0aG91dCBsZWF2aW5nIHVzIHdpdGgNCigyKSwgd2hpY2ggc2Vl
bXMgbGlrZSBhIG5ldCB3aW4uDQoNCi0tIA0KTWF0dGhldyBHYXJyZXR0IHwgbWpnNTlAc3JjZi51
Y2FtLm9yZw0K
