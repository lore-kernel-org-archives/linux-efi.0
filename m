From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/2] efi/bgrt: Drop __initdata from bgrt_image_size
Date: Mon, 18 Jun 2018 08:42:20 +0200
Message-ID: <CAKv+Gu-DVXti+02CZh9ZxW3wZeR2Kgw=6gAsvL_W7V0TO0vLDQ@mail.gmail.com>
References: <20180617153235.16219-1-hdegoede@redhat.com>
 <20180617153235.16219-2-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20180617153235.16219-2-hdegoede@redhat.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: "open list:EFIFB FRAMEBUFFER DRIVER" <linux-fbdev@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
List-Id: linux-efi@vger.kernel.org

T24gMTcgSnVuZSAyMDE4IGF0IDE3OjMyLCBIYW5zIGRlIEdvZWRlIDxoZGVnb2VkZUByZWRoYXQu
Y29tPiB3cm90ZToKPiBiZ3J0X2ltYWdlX3NpemUgaXMgbmVjZXNzYXJ5IHRvIChvcHRpb25hbGx5
KSBzaG93IHRoZSBib290IGdyYXBoaWNzIGZyb20KPiB0aGUgZWZpZmIgY29kZS4gVGhlIGVmaWZi
IGRyaXZlciBpcyBhIHBsYXRmb3JtIGRyaXZlciwgdXNpbmcgYSBub3JtYWwKPiBkcml2ZXIgcHJv
YmUoKSBkcml2ZXIgY2FsbGJhY2suIFNvIGV2ZW4gdGhvdWdoIGl0IGlzIGFsd2F5cyBidWlsdGlu
IGl0Cj4gY2Fubm90IHJlZmVyZW5jZSBfX2luaXRkYXRhLgo+Cj4gU2lnbmVkLW9mZi1ieTogSGFu
cyBkZSBHb2VkZSA8aGRlZ29lZGVAcmVkaGF0LmNvbT4KCkFja2VkLWJ5OiBBcmQgQmllc2hldXZl
bCA8YXJkLmJpZXNoZXV2ZWxAbGluYXJvLm9yZz4KCj4gLS0tCj4gIGRyaXZlcnMvZmlybXdhcmUv
ZWZpL2VmaS1iZ3J0LmMgfCAyICstCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MSBkZWxldGlvbigtKQo+Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvZmlybXdhcmUvZWZpL2VmaS1i
Z3J0LmMgYi9kcml2ZXJzL2Zpcm13YXJlL2VmaS9lZmktYmdydC5jCj4gaW5kZXggNTA3OTNmZGE3
ODE5Li5iMjJjY2ZiMGM5OTEgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9maXJtd2FyZS9lZmkvZWZp
LWJncnQuYwo+ICsrKyBiL2RyaXZlcnMvZmlybXdhcmUvZWZpL2VmaS1iZ3J0LmMKPiBAQCAtMjAs
NyArMjAsNyBAQAo+ICAjaW5jbHVkZSA8bGludXgvZWZpLWJncnQuaD4KPgo+ICBzdHJ1Y3QgYWNw
aV90YWJsZV9iZ3J0IGJncnRfdGFiOwo+IC1zaXplX3QgX19pbml0ZGF0YSBiZ3J0X2ltYWdlX3Np
emU7Cj4gK3NpemVfdCBiZ3J0X2ltYWdlX3NpemU7Cj4KPiAgc3RydWN0IGJtcF9oZWFkZXIgewo+
ICAgICAgICAgdTE2IGlkOwo+IC0tCj4gMi4xNy4xCj4KX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxA
bGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxt
YW4vbGlzdGluZm8vZHJpLWRldmVsCg==
