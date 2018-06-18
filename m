From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 1/2] efi/bgrt: Drop __initdata from bgrt_image_size
Date: Mon, 18 Jun 2018 17:13:57 +0200
Message-ID: <20180618151358.4830-1-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-fbdev@vger.kernel.org, linux-efi@vger.kernel.org, dri-devel@lists.freedesktop.org
List-Id: linux-efi@vger.kernel.org

YmdydF9pbWFnZV9zaXplIGlzIG5lY2Vzc2FyeSB0byAob3B0aW9uYWxseSkgc2hvdyB0aGUgYm9v
dCBncmFwaGljcyBmcm9tCnRoZSBlZmlmYiBjb2RlLiBUaGUgZWZpZmIgZHJpdmVyIGlzIGEgcGxh
dGZvcm0gZHJpdmVyLCB1c2luZyBhIG5vcm1hbApkcml2ZXIgcHJvYmUoKSBkcml2ZXIgY2FsbGJh
Y2suIFNvIGV2ZW4gdGhvdWdoIGl0IGlzIGFsd2F5cyBidWlsdGluIGl0CmNhbm5vdCByZWZlcmVu
Y2UgX19pbml0ZGF0YS4KCkFja2VkLWJ5OiBBcmQgQmllc2hldXZlbCA8YXJkLmJpZXNoZXV2ZWxA
bGluYXJvLm9yZz4KU2lnbmVkLW9mZi1ieTogSGFucyBkZSBHb2VkZSA8aGRlZ29lZGVAcmVkaGF0
LmNvbT4KLS0tCiBkcml2ZXJzL2Zpcm13YXJlL2VmaS9lZmktYmdydC5jIHwgMiArLQogMSBmaWxl
IGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9maXJtd2FyZS9lZmkvZWZpLWJncnQuYyBiL2RyaXZlcnMvZmlybXdhcmUvZWZpL2VmaS1i
Z3J0LmMKaW5kZXggNTA3OTNmZGE3ODE5Li5iMjJjY2ZiMGM5OTEgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvZmlybXdhcmUvZWZpL2VmaS1iZ3J0LmMKKysrIGIvZHJpdmVycy9maXJtd2FyZS9lZmkvZWZp
LWJncnQuYwpAQCAtMjAsNyArMjAsNyBAQAogI2luY2x1ZGUgPGxpbnV4L2VmaS1iZ3J0Lmg+CiAK
IHN0cnVjdCBhY3BpX3RhYmxlX2JncnQgYmdydF90YWI7Ci1zaXplX3QgX19pbml0ZGF0YSBiZ3J0
X2ltYWdlX3NpemU7CitzaXplX3QgYmdydF9pbWFnZV9zaXplOwogCiBzdHJ1Y3QgYm1wX2hlYWRl
ciB7CiAJdTE2IGlkOwotLSAKMi4xNy4xCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5m
cmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0
aW5mby9kcmktZGV2ZWwK
