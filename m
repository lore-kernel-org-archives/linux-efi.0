From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 00/12 v4] kexec kernel efi runtime support v	v4]
 efi: export more efi table variable to sysfs
Date: Tue, 26 Nov 2013 09:35:20 +0800
Message-ID: <20131126013520.GA3706@dhcp-16-126.nay.redhat.com>
References: <20131125085630.417850406@dhcp-16-126.nay.redhat.com>
 <5293BF8B.20203@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5293BF8B.20203-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

T24gMTEvMjUvMTMgYXQgMDE6MjJwbSwgSC4gUGV0ZXIgQW52aW4gd3JvdGU6Cj4gT24gMTEvMjUv
MjAxMyAxMjo1NiBBTSwgZHlvdW5nQHJlZGhhdC5jb20gd3JvdGU6Cj4gPiAKPiA+IEZvciBlZmkg
cnVudGltZSBtYXBwaW5nIEkgYWRkIGEgbmV3IGRpcmVjdG9yeSAvc3lzL2Zpcm13YXJlL2VmaS8K
PiA+IHJ1bnRpbWUtbWFwLyBsaWtlIGJlbG93Cj4gPiBbZGF2ZUBkYXJrc3RhciB+XSQgdHJlZSAv
c3lzL2Zpcm13YXJlL2VmaS9ydW50aW1lLW1hcC8KPiA+IC9zeXMvZmlybXdhcmUvZWZpL3J1bnRp
bWUtbWFwLwo+ID4gw6LigJ3Fk8Oi4oCd4oKsw6LigJ3igqwgMAo+ID4gw6LigJ3igJogICDDouKA
ncWTw6LigJ3igqzDouKAneKCrCBhdHRyaWJ1dGUKPiA+IMOi4oCd4oCaICAgw6LigJ3Fk8Oi4oCd
4oKsw6LigJ3igqwgbnVtX3BhZ2VzCj4gPiDDouKAneKAmiAgIMOi4oCdxZPDouKAneKCrMOi4oCd
4oKsIHBoeXNfYWRkcgo+ID4gw6LigJ3igJogICDDouKAncWTw6LigJ3igqzDouKAneKCrCB0eXBl
Cj4gPiDDouKAneKAmiAgIMOi4oCd4oCdw6LigJ3igqzDouKAneKCrCB2aXJ0X2FkZHIKPiA+IMOi
4oCdxZPDouKAneKCrMOi4oCd4oKsIDEKPiA+IMOi4oCd4oCaICAgw6LigJ3Fk8Oi4oCd4oKsw6Li
gJ3igqwgYXR0cmlidXRlCj4gPiDDouKAneKAmiAgIMOi4oCdxZPDouKAneKCrMOi4oCd4oKsIG51
bV9wYWdlcwo+ID4gw6LigJ3igJogICDDouKAncWTw6LigJ3igqzDouKAneKCrCBwaHlzX2FkZHIK
PiA+IMOi4oCd4oCaICAgw6LigJ3Fk8Oi4oCd4oKsw6LigJ3igqwgdHlwZQo+ID4gw6LigJ3igJog
ICDDouKAneKAncOi4oCd4oKsw6LigJ3igqwgdmlydF9hZGRyCj4gPiBbc25pcF0KPiA+ICAKPiAK
PiBUaGVzZSBwYXRjaGVzIGNhbWUgdGhyb3VnaCBzZXZlcmVseSBjb3JydXB0ZWQsIHRoZSBhYm92
ZSBpcyB0eXBpY2FsLi4uCgpIaSwgUGV0ZXIKCldpbGwgcmVzZW5kIHRoZW0gdG9kYXkgYWdhaW4u
CgotLQpUaGFua3MKRGF2ZQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18Ka2V4ZWMgbWFpbGluZyBsaXN0CmtleGVjQGxpc3RzLmluZnJhZGVhZC5vcmcKaHR0
cDovL2xpc3RzLmluZnJhZGVhZC5vcmcvbWFpbG1hbi9saXN0aW5mby9rZXhlYwo=
