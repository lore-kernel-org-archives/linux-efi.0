From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v9 05/17] xen: memory : Add new XENMAPSPACE type
	XENMAPSPACE_dev_mmio
Date: Thu, 31 Mar 2016 19:23:33 +0800
Message-ID: <1459423425-1220-6-git-send-email-zhaoshenglong@huawei.com>
References: <1459423425-1220-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <1459423425-1220-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xen.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xen.org>
To: linux-arm-kernel@lists.infradead.org, stefano.stabellini@citrix.com, david.vrabel@citrix.com
Cc: devicetree@vger.kernel.org, sstabellini@kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, xen-devel@lists.xen.org, julien.grall@arm.com, linux-efi@vger.kernel.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com
List-Id: linux-efi@vger.kernel.org

RnJvbTogU2hhbm5vbiBaaGFvIDxzaGFubm9uLnpoYW9AbGluYXJvLm9yZz4KCkFkZCBhIG5ldyB0
eXBlIG9mIFhlbiBtYXAgc3BhY2UgZm9yIERvbTAgdG8gbWFwIGRldmljZSdzIE1NSU8gcmVnaW9u
LgoKU2lnbmVkLW9mZi1ieTogU2hhbm5vbiBaaGFvIDxzaGFubm9uLnpoYW9AbGluYXJvLm9yZz4K
LS0tCiBpbmNsdWRlL3hlbi9pbnRlcmZhY2UvbWVtb3J5LmggfCAxICsKIDEgZmlsZSBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKQoKZGlmZiAtLWdpdCBhL2luY2x1ZGUveGVuL2ludGVyZmFjZS9tZW1v
cnkuaCBiL2luY2x1ZGUveGVuL2ludGVyZmFjZS9tZW1vcnkuaAppbmRleCAyZWNmZTRmLi45YWE4
OTg4IDEwMDY0NAotLS0gYS9pbmNsdWRlL3hlbi9pbnRlcmZhY2UvbWVtb3J5LmgKKysrIGIvaW5j
bHVkZS94ZW4vaW50ZXJmYWNlL21lbW9yeS5oCkBAIC0xNjAsNiArMTYwLDcgQEAgREVGSU5FX0dV
RVNUX0hBTkRMRV9TVFJVQ1QoeGVuX21hY2hwaHlzX21hcHBpbmdfdCk7CiAjZGVmaW5lIFhFTk1B
UFNQQUNFX2dtZm5fZm9yZWlnbiA0IC8qIEdNRk4gZnJvbSBhbm90aGVyIGRvbSwKIAkJCQkgICAg
KiBYRU5NRU1fYWRkX3RvX3BoeXNtYXBfcmFuZ2Ugb25seS4KIAkJCQkgICAgKi8KKyNkZWZpbmUg
WEVOTUFQU1BBQ0VfZGV2X21taW8gICAgIDUgLyogZGV2aWNlIG1taW8gcmVnaW9uICovCiAKIC8q
CiAgKiBTZXRzIHRoZSBHUEZOIGF0IHdoaWNoIGEgcGFydGljdWxhciBwYWdlIGFwcGVhcnMgaW4g
dGhlIHNwZWNpZmllZCBndWVzdCdzCi0tIAoyLjAuNAoKCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpYZW4tZGV2ZWwgbWFpbGluZyBsaXN0Clhlbi1kZXZl
bEBsaXN0cy54ZW4ub3JnCmh0dHA6Ly9saXN0cy54ZW4ub3JnL3hlbi1kZXZlbAo=
