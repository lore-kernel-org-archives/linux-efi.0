From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 00/12 v4] kexec kernel efi runtime support v	v4] efi:
 export more efi table variable to sysfs
Date: Mon, 25 Nov 2013 13:22:19 -0800
Message-ID: <5293BF8B.20203@zytor.com>
References: <20131125085630.417850406@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <20131125085630.417850406-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

T24gMTEvMjUvMjAxMyAxMjo1NiBBTSwgZHlvdW5nQHJlZGhhdC5jb20gd3JvdGU6Cj4gCj4gRm9y
IGVmaSBydW50aW1lIG1hcHBpbmcgSSBhZGQgYSBuZXcgZGlyZWN0b3J5IC9zeXMvZmlybXdhcmUv
ZWZpLwo+IHJ1bnRpbWUtbWFwLyBsaWtlIGJlbG93Cj4gW2RhdmVAZGFya3N0YXIgfl0kIHRyZWUg
L3N5cy9maXJtd2FyZS9lZmkvcnVudGltZS1tYXAvCj4gL3N5cy9maXJtd2FyZS9lZmkvcnVudGlt
ZS1tYXAvCj4gw6LigJ3Fk8Oi4oCd4oKsw6LigJ3igqwgMAo+IMOi4oCd4oCaICAgw6LigJ3Fk8Oi
4oCd4oKsw6LigJ3igqwgYXR0cmlidXRlCj4gw6LigJ3igJogICDDouKAncWTw6LigJ3igqzDouKA
neKCrCBudW1fcGFnZXMKPiDDouKAneKAmiAgIMOi4oCdxZPDouKAneKCrMOi4oCd4oKsIHBoeXNf
YWRkcgo+IMOi4oCd4oCaICAgw6LigJ3Fk8Oi4oCd4oKsw6LigJ3igqwgdHlwZQo+IMOi4oCd4oCa
ICAgw6LigJ3igJ3DouKAneKCrMOi4oCd4oKsIHZpcnRfYWRkcgo+IMOi4oCdxZPDouKAneKCrMOi
4oCd4oKsIDEKPiDDouKAneKAmiAgIMOi4oCdxZPDouKAneKCrMOi4oCd4oKsIGF0dHJpYnV0ZQo+
IMOi4oCd4oCaICAgw6LigJ3Fk8Oi4oCd4oKsw6LigJ3igqwgbnVtX3BhZ2VzCj4gw6LigJ3igJog
ICDDouKAncWTw6LigJ3igqzDouKAneKCrCBwaHlzX2FkZHIKPiDDouKAneKAmiAgIMOi4oCdxZPD
ouKAneKCrMOi4oCd4oKsIHR5cGUKPiDDouKAneKAmiAgIMOi4oCd4oCdw6LigJ3igqzDouKAneKC
rCB2aXJ0X2FkZHIKPiBbc25pcF0KPiAgCgpUaGVzZSBwYXRjaGVzIGNhbWUgdGhyb3VnaCBzZXZl
cmVseSBjb3JydXB0ZWQsIHRoZSBhYm92ZSBpcyB0eXBpY2FsLi4uCgkKCS1ocGEKCgoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka2V4ZWMgbWFpbGluZyBs
aXN0CmtleGVjQGxpc3RzLmluZnJhZGVhZC5vcmcKaHR0cDovL2xpc3RzLmluZnJhZGVhZC5vcmcv
bWFpbG1hbi9saXN0aW5mby9rZXhlYwo=
