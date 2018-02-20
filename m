From: Alex Deucher <alexdeucher@gmail.com>
Subject: Re: [PATCH] fix double ;;s in code
Date: Tue, 20 Feb 2018 11:34:20 -0500
Message-ID: <CADnq5_MY932hPkozosY4ODa5tB3qf7TYNxph1mt_qswkU4tBgw@mail.gmail.com>
References: <20180217211955.GE9640@amd>
 <187435d4-5017-edb5-9b6a-b433a148bfcc@c-s.fr>
 <20180219154135.GV22199@phenom.ffwll.local> <20180219193312.GA3709@amd>
 <87o9kkcck3.fsf@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <87o9kkcck3.fsf@intel.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: daniel.lezcano@linaro.org, narmstrong@baylibre.com, Dave Airlie <airlied@linux.ie>, catalin.marinas@arm.com, Alexey Brodkin <Alexey.Brodkin@synopsys.com>, will.deacon@arm.com, fbarrat@linux.vnet.ibm.com, oleg@redhat.com, paulus@ozlabs.org, yamada.masahiro@socionext.com, mhocko@suse.com, viresh.kumar@linaro.org, Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>, Eric Huang <JinHuiEric.Huang@amd.com>, Rex Zhu <Rex.Zhu@amd.com>, SF Markus Elfring <elfring@users.sourceforge.net>, scott.bauer@intel.com, linux-arm-kernel@lists.infradead.org, mpe@ellerman.id.au, x86@kernel.org, Wenjing Liu <Wenjing.Liu@amd.com>, Russell King <linux@armlinux.org.uk>, amd-gfx list <amd-gfx@lists.freedesktop.org>, Ding Wang <Ding.Wang@amd.com>, aik@ozlabs.ru, wens@csie.org, Ingo Molnar <mingo@redhat.com>, vbabka@suse.cz, Dave Airlie <airlied@redhat.com>, ruscur@russell.cc
List-Id: linux-efi@vger.kernel.org

T24gVHVlLCBGZWIgMjAsIDIwMTggYXQgMzowMyBBTSwgSmFuaSBOaWt1bGEKPGphbmkubmlrdWxh
QGxpbnV4LmludGVsLmNvbT4gd3JvdGU6Cj4gT24gTW9uLCAxOSBGZWIgMjAxOCwgUGF2ZWwgTWFj
aGVrIDxwYXZlbEB1Y3cuY3o+IHdyb3RlOgo+PiBPbiBNb24gMjAxOC0wMi0xOSAxNjo0MTozNSwg
RGFuaWVsIFZldHRlciB3cm90ZToKPj4+IFllYWgsIHBscyBzcGxpdCB0aGlzIGludG8gb25lIHBh
dGNoIHBlciBhcmVhLCB3aXRoIGEgc3VpdGFibGUgcGF0Y2gKPj4+IHN1YmplY3QgcHJlZml4LiBM
b29rIGF0IGdpdCBsb2cgb2YgZWFjaCBmaWxlIHRvIGdldCBhIGZlZWxpbmcgZm9yIHdoYXQncwo+
Pj4gdGhlIHN0YW5kYXJkIGluIGVhY2ggYXJlYS4KPj4KPj4gWWVhaCBJIGNhbiBzcGVuZCBob3Vy
IHNwbGl0aW5nIGl0LCBhbmQgdGhlbiBwZW9wbGUgd2lsbCBpZ25vcmUgaXQKPj4gYW55d2F5Lgo+
Pgo+PiBJZiB5b3UgY2FyZSBhYm91dCBvbmUgb2YgdGhlIGZpbGVzIGJlaW5nIG1vZGlmaWVkLCBw
bGVhc2UgZml4IHRoZQo+PiBidWcsICI7OyIgaXMgYSBjbGVhciBidWcuCj4+Cj4+IElmIHlvdSBk
b24ndCBjYXJlIC4uLiB3ZWxsIEkgZG9uJ3QgY2FyZSBlaXRoZXIuCj4KPiBMb29rLCBpZiB0aGlz
IGNhdXNlcyBqdXN0IG9uZSBjb25mbGljdCBkb3duIHRoZSBsaW5lIGJlY2F1c2UgaXQgdG91Y2hl
cwo+IHRoZSBrZXJuZWwgYWxsIG92ZXIgdGhlIHBsYWNlLCB0aGVuIElNTyBpdCBhbHJlYWR5IHdh
c24ndCB3b3J0aAo+IGl0LiBNZXJnZSBjb25mbGljdHMgYXJlIGluZXZpdGFibGUsIGJ1dCB0aGVy
ZSdzIG5vIHJlYXNvbiB0byBtYWtlIGxpZmUKPiBoYXJkZXIganVzdCB0byBjYXRlciBmb3IgYSBj
bGVhbnVwIHBhdGNoLiBJdCdzIG5vdCB0aGF0IGltcG9ydGFudC4KPgo+IEhhZCBpdCBiZWVuIHNw
bGl0IHVwLCB0aGUgZHJtIHBhcnRzIHdvdWxkJ3ZlIGJlZW4gbWVyZ2VkIGFscmVhZHkuCgpGV0lX
LCB0aGUgYW1kZ3B1IGFuZCBzY2hlZHVsZXIgY2hhbmdlcyBoYXZlIGFscmVhZHkgYmVlbiBmaXhl
ZCBmb3IgLW5leHQuCgpBbGV4Cgo+Cj4gQlIsCj4gSmFuaS4KPgo+IC0tCj4gSmFuaSBOaWt1bGEs
IEludGVsIE9wZW4gU291cmNlIFRlY2hub2xvZ3kgQ2VudGVyCj4gX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KPiBhbWQtZ2Z4IG1haWxpbmcgbGlzdAo+IGFt
ZC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCj4gaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5v
cmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3Rz
LmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xp
c3RpbmZvL2RyaS1kZXZlbAo=
