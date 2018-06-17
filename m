From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 1/2] efi/bgrt: Drop __initdata from bgrt_image_size
Date: Sun, 17 Jun 2018 17:32:34 +0200
Message-ID: <20180617153235.16219-2-hdegoede@redhat.com>
References: <20180617153235.16219-1-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20180617153235.16219-1-hdegoede@redhat.com>
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
Y2UgX19pbml0ZGF0YS4KClNpZ25lZC1vZmYtYnk6IEhhbnMgZGUgR29lZGUgPGhkZWdvZWRlQHJl
ZGhhdC5jb20+Ci0tLQogZHJpdmVycy9maXJtd2FyZS9lZmkvZWZpLWJncnQuYyB8IDIgKy0KIDEg
ZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvZmlybXdhcmUvZWZpL2VmaS1iZ3J0LmMgYi9kcml2ZXJzL2Zpcm13YXJlL2VmaS9l
ZmktYmdydC5jCmluZGV4IDUwNzkzZmRhNzgxOS4uYjIyY2NmYjBjOTkxIDEwMDY0NAotLS0gYS9k
cml2ZXJzL2Zpcm13YXJlL2VmaS9lZmktYmdydC5jCisrKyBiL2RyaXZlcnMvZmlybXdhcmUvZWZp
L2VmaS1iZ3J0LmMKQEAgLTIwLDcgKzIwLDcgQEAKICNpbmNsdWRlIDxsaW51eC9lZmktYmdydC5o
PgogCiBzdHJ1Y3QgYWNwaV90YWJsZV9iZ3J0IGJncnRfdGFiOwotc2l6ZV90IF9faW5pdGRhdGEg
YmdydF9pbWFnZV9zaXplOworc2l6ZV90IGJncnRfaW1hZ2Vfc2l6ZTsKIAogc3RydWN0IGJtcF9o
ZWFkZXIgewogCXUxNiBpZDsKLS0gCjIuMTcuMQoKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlz
dHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4v
bGlzdGluZm8vZHJpLWRldmVsCg==
