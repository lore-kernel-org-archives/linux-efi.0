From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v11 05/17] xen: memory : Add new XENMAPSPACE
	type XENMAPSPACE_dev_mmio
Date: Thu, 7 Apr 2016 20:03:22 +0800
Message-ID: <1460030614-16112-6-git-send-email-zhaoshenglong@huawei.com>
References: <1460030614-16112-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <1460030614-16112-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xen.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xen.org>
To: linux-arm-kernel@lists.infradead.org, sstabellini@kernel.org
Cc: devicetree@vger.kernel.org, linux-efi@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, xen-devel@lists.xen.org, julien.grall@arm.com, david.vrabel@citrix.com, peter.huangpeng@huawei.com, shannon.zhao@linaro.org
List-Id: linux-efi@vger.kernel.org

RnJvbTogU2hhbm5vbiBaaGFvIDxzaGFubm9uLnpoYW9AbGluYXJvLm9yZz4KCkFkZCBhIG5ldyB0
eXBlIG9mIFhlbiBtYXAgc3BhY2UgZm9yIERvbTAgdG8gbWFwIGRldmljZSdzIE1NSU8gcmVnaW9u
LgoKU2lnbmVkLW9mZi1ieTogU2hhbm5vbiBaaGFvIDxzaGFubm9uLnpoYW9AbGluYXJvLm9yZz4K
UmV2aWV3ZWQtYnk6IEp1bGllbiBHcmFsbCA8anVsaWVuLmdyYWxsQGFybS5jb20+Ci0tLQogaW5j
bHVkZS94ZW4vaW50ZXJmYWNlL21lbW9yeS5oIHwgMSArCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKykKCmRpZmYgLS1naXQgYS9pbmNsdWRlL3hlbi9pbnRlcmZhY2UvbWVtb3J5LmggYi9p
bmNsdWRlL3hlbi9pbnRlcmZhY2UvbWVtb3J5LmgKaW5kZXggMmVjZmU0Zi4uOWFhODk4OCAxMDA2
NDQKLS0tIGEvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL21lbW9yeS5oCisrKyBiL2luY2x1ZGUveGVu
L2ludGVyZmFjZS9tZW1vcnkuaApAQCAtMTYwLDYgKzE2MCw3IEBAIERFRklORV9HVUVTVF9IQU5E
TEVfU1RSVUNUKHhlbl9tYWNocGh5c19tYXBwaW5nX3QpOwogI2RlZmluZSBYRU5NQVBTUEFDRV9n
bWZuX2ZvcmVpZ24gNCAvKiBHTUZOIGZyb20gYW5vdGhlciBkb20sCiAJCQkJICAgICogWEVOTUVN
X2FkZF90b19waHlzbWFwX3JhbmdlIG9ubHkuCiAJCQkJICAgICovCisjZGVmaW5lIFhFTk1BUFNQ
QUNFX2Rldl9tbWlvICAgICA1IC8qIGRldmljZSBtbWlvIHJlZ2lvbiAqLwogCiAvKgogICogU2V0
cyB0aGUgR1BGTiBhdCB3aGljaCBhIHBhcnRpY3VsYXIgcGFnZSBhcHBlYXJzIGluIHRoZSBzcGVj
aWZpZWQgZ3Vlc3QncwotLSAKMi4wLjQKCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KWGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4tZGV2ZWxAbGlzdHMu
eGVuLm9yZwpodHRwOi8vbGlzdHMueGVuLm9yZy94ZW4tZGV2ZWwK
