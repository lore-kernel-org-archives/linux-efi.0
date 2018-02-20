From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix double ;;s in code
Date: Tue, 20 Feb 2018 15:47:15 -0800
Message-ID: <20180220154715.2a8ecd75a1c2cc698baefd26@linux-foundation.org>
References: <20180217211955.GE9640@amd>
 <187435d4-5017-edb5-9b6a-b433a148bfcc@c-s.fr>
 <20180219154135.GV22199@phenom.ffwll.local>
 <20180219193312.GA3709@amd> <87o9kkcck3.fsf@intel.com>
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
Cc: daniel.lezcano@linaro.org, narmstrong@baylibre.com, airlied@linux.ie, catalin.marinas@arm.com, Alexey.Brodkin@synopsys.com, will.deacon@arm.com, fbarrat@linux.vnet.ibm.com, oleg@redhat.com, paulus@ozlabs.org, yamada.masahiro@socionext.com, mhocko@suse.com, viresh.kumar@linaro.org, Pavel Machek <pavel@ucw.cz>, hpa@zytor.com, JinHuiEric.Huang@amd.com, Rex.Zhu@amd.com, elfring@users.sourceforge.net, scott.bauer@intel.com, linux-arm-kernel@lists.infradead.org, mpe@ellerman.id.au, x86@kernel.org, Wenjing.Liu@amd.com, linux@armlinux.org.uk, amd-gfx@lists.freedesktop.org, Ding.Wang@amd.com, aik@ozlabs.ru, wens@csie.org, mingo@redhat.com, vbabka@suse.cz, airlied@redhat.com, ruscur@russell.cc, shli@kernel.org, dan.carpenter@oracle.com, andresx7@gmail.com, linux-arm-msm@vger.kernel.org, axboe@kernel.dk, linux-efi@vger.kernel.org, alistair@popple.id.au, linuxppc-dev@lists.ozlabs.org
List-Id: linux-efi@vger.kernel.org

T24gVHVlLCAyMCBGZWIgMjAxOCAxMDowMzo1NiArMDIwMCBKYW5pIE5pa3VsYSA8amFuaS5uaWt1
bGFAbGludXguaW50ZWwuY29tPiB3cm90ZToKCj4gT24gTW9uLCAxOSBGZWIgMjAxOCwgUGF2ZWwg
TWFjaGVrIDxwYXZlbEB1Y3cuY3o+IHdyb3RlOgo+ID4gT24gTW9uIDIwMTgtMDItMTkgMTY6NDE6
MzUsIERhbmllbCBWZXR0ZXIgd3JvdGU6Cj4gPj4gWWVhaCwgcGxzIHNwbGl0IHRoaXMgaW50byBv
bmUgcGF0Y2ggcGVyIGFyZWEsIHdpdGggYSBzdWl0YWJsZSBwYXRjaAo+ID4+IHN1YmplY3QgcHJl
Zml4LiBMb29rIGF0IGdpdCBsb2cgb2YgZWFjaCBmaWxlIHRvIGdldCBhIGZlZWxpbmcgZm9yIHdo
YXQncwo+ID4+IHRoZSBzdGFuZGFyZCBpbiBlYWNoIGFyZWEuCj4gPgo+ID4gWWVhaCBJIGNhbiBz
cGVuZCBob3VyIHNwbGl0aW5nIGl0LCBhbmQgdGhlbiBwZW9wbGUgd2lsbCBpZ25vcmUgaXQKPiA+
IGFueXdheS4KPiA+Cj4gPiBJZiB5b3UgY2FyZSBhYm91dCBvbmUgb2YgdGhlIGZpbGVzIGJlaW5n
IG1vZGlmaWVkLCBwbGVhc2UgZml4IHRoZQo+ID4gYnVnLCAiOzsiIGlzIGEgY2xlYXIgYnVnLgo+
ID4KPiA+IElmIHlvdSBkb24ndCBjYXJlIC4uLiB3ZWxsIEkgZG9uJ3QgY2FyZSBlaXRoZXIuCj4g
Cj4gTG9vaywgaWYgdGhpcyBjYXVzZXMganVzdCBvbmUgY29uZmxpY3QgZG93biB0aGUgbGluZSBi
ZWNhdXNlIGl0IHRvdWNoZXMKPiB0aGUga2VybmVsIGFsbCBvdmVyIHRoZSBwbGFjZSwgdGhlbiBJ
TU8gaXQgYWxyZWFkeSB3YXNuJ3Qgd29ydGgKPiBpdC4gTWVyZ2UgY29uZmxpY3RzIGFyZSBpbmV2
aXRhYmxlLCBidXQgdGhlcmUncyBubyByZWFzb24gdG8gbWFrZSBsaWZlCj4gaGFyZGVyIGp1c3Qg
dG8gY2F0ZXIgZm9yIGEgY2xlYW51cCBwYXRjaC4gSXQncyBub3QgdGhhdCBpbXBvcnRhbnQuCj4g
Cj4gSGFkIGl0IGJlZW4gc3BsaXQgdXAsIHRoZSBkcm0gcGFydHMgd291bGQndmUgYmVlbiBtZXJn
ZWQgYWxyZWFkeS4KCkkganVzdCBzdGFnZSBwYXRjaGVzIGxpa2UgdGhpcyBiZWhpbmQgbGludXgt
bmV4dC4gIFNvIGlmIHlvdXIgc3R1ZmYgaW4KaW4gLW5leHQsIHlvdSdsbCBuZXZlciBub3RpY2Ug
YSB0aGluZy4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
CmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpo
dHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZlbAo=
