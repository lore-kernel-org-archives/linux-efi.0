From: Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH] fix double ;;s in code
Date: Sat, 24 Feb 2018 16:56:27 +0800
Message-ID: <20180224085626.GN3217@dragon>
References: <20180217211955.GE9640@amd> <20180222090932.GJ3217@dragon>
 <20180224085227.GA12996@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20180224085227.GA12996@amd>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: daniel.lezcano@linaro.org, narmstrong@baylibre.com, airlied@linux.ie, Alexey.Brodkin@synopsys.com, will.deacon@arm.com, fbarrat@linux.vnet.ibm.com, kernel list <linux-kernel@vger.kernel.org>, paulus@ozlabs.org, yamada.masahiro@socionext.com, mhocko@suse.com, viresh.kumar@linaro.org, hpa@zytor.com, JinHuiEric.Huang@amd.com, iommu@lists.linux-foundation.org, elfring@users.sourceforge.net, scott.bauer@intel.com, linux-arm-kernel@lists.infradead.org, mpe@ellerman.id.au, x86@kernel.org, Wenjing.Liu@amd.com, linux@armlinux.org.uk, amd-gfx@lists.freedesktop.org, Ding.Wang@amd.com, aik@ozlabs.ru, wens@csie.org, mingo@redhat.com, vbabka@suse.cz, catalin.marinas@arm.com, airlied@redhat.com, ruscur@russell.cc, shli@kernel.org, dan.carpenter@oracle.com, andresx7@gmail.com, linux-arm-msm@vger.kernel.org, linux-efi@vger.kernel.org, alistair@popple.id.au, linuxppc-dev@lists.ozlabs.org
List-Id: linux-efi@vger.kernel.org

T24gU2F0LCBGZWIgMjQsIDIwMTggYXQgMDk6NTI6MjdBTSArMDEwMCwgUGF2ZWwgTWFjaGVrIHdy
b3RlOgo+IEhpIQo+IAo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zb2MvaW14L2dwYy5jIGIv
ZHJpdmVycy9zb2MvaW14L2dwYy5jCj4gPiA+IGluZGV4IDUzZjcyNzUuLmNmYjQyZjUgMTAwNjQ0
Cj4gPiA+IC0tLSBhL2RyaXZlcnMvc29jL2lteC9ncGMuYwo+ID4gPiArKysgYi9kcml2ZXJzL3Nv
Yy9pbXgvZ3BjLmMKPiA+ID4gQEAgLTM0OCw3ICszNDgsNyBAQCBzdGF0aWMgaW50IGlteF9ncGNf
b2xkX2R0X2luaXQoc3RydWN0IGRldmljZSAqZGV2LCBzdHJ1Y3QgcmVnbWFwICpyZWdtYXAsCj4g
PiA+ICAJCWlmIChpID09IDEpIHsKPiA+ID4gIAkJCWRvbWFpbi0+c3VwcGx5ID0gZGV2bV9yZWd1
bGF0b3JfZ2V0KGRldiwgInB1Iik7Cj4gPiA+ICAJCQlpZiAoSVNfRVJSKGRvbWFpbi0+c3VwcGx5
KSkKPiA+ID4gLQkJCQlyZXR1cm4gUFRSX0VSUihkb21haW4tPnN1cHBseSk7Owo+ID4gPiArCQkJ
CXJldHVybiBQVFJfRVJSKGRvbWFpbi0+c3VwcGx5KTsKPiA+ID4gIAo+ID4gPiAgCQkJcmV0ID0g
aW14X3BnY19nZXRfY2xvY2tzKGRldiwgZG9tYWluKTsKPiA+ID4gIAkJCWlmIChyZXQpCj4gPiA+
IAo+ID4gCj4gPiBDb25zaWRlcmluZyB0aGUgY29udHJvdmVyc3kgaG93IHRoZSBjaGFuZ2VzIHNo
b3VsZCBiZSBtZXJnZWQsIEknbSBnb2luZwo+ID4gdG8gc2VuZCBhIHNlcGFyYXRlIHBhdGNoIGp1
c3QgZm9yIElNWCBHUEMgZHJpdmVyIHdpdGggYSByZXBvcnRlZC1ieS15b3UKPiA+IHRhZy4gIFRo
YW5rcyBmb3IgY2F0Y2hpbmcgdGhpcy4KPiAKPiBUaGF0IHdvcmtzIGZvciBtZS4KPiAKPiBBbHRl
cm5hdGl2ZWx5Li4uIEFuZHJldyBNb3J0b24gbWVyZ2VkIHRoZSBwYXRjaCB0byBoaXMgLW1tIHRy
ZWUKPiAodGhhbmtzISksIHNvIHlvdSBkb24ndCBuZWVkIHRvIHRha2UgYW55IGFjdGlvbiwgYW5k
IGl0IHdpbGwgYmUKPiBldmVudHVhbGx5IGZpeGVkLgoKT2theSwgSSdtIGRyb3BwaW5nIG15IHBh
dGNoIGZyb20gSU1YIHRyZWUuCgpTaGF3bgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5m
cmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0
aW5mby9kcmktZGV2ZWwK
