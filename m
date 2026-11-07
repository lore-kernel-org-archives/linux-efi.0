Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794041219;
	b=jLdCqr+E/NFP9GsU6ZNmB2I5RJYS4rGqjamY6PkyqRh+Xo5/1CLat5Reoi8nwIHPD28G
	 +7jRTbVh7Geu1QSpYEViVp2pZlPrb1VdDIoRAPU5QYX4FjjenJzZLJFg51OfNYlgTmoTU
	 2+BQU8qmmJvZGRmXopCXSy9QKeatn6TB9KTBi0bpTlVzoGCLgQYPYYKsiWId71uUsCE34
	 DHdVBScs7mwrP5+yvpdJZj9p4BWpcrN+RF02iLYVREgbp4f42pWftXfH5mcGK1558HlNL
	 aulbljjid7HmON3zspdcqbAkzjlBgQet86DUIE7tw0sytQGadGFwttXGQ7fyXsXuj5w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794041219;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=bAtNJeQQZtV0gJf8mO/hJSLFnMdkjTPe0Tyts98GCi0=;
	b=aKBizN1gOqhUyirb1nOtYdggex1LqPY+s8qwxwwNHJCzj9uU2kx8YzZn816WZTftY305
	 ZwdzKKkQiCcuwH02TlTZSoQh1JYeY+kJ3xssBx8viPnljuTE/FsfyOBFXNFcYVagOE1c/
	 Tyo1YLc35MpBQgC+CwkW9jh5U6dyZxMPv+msIwRUNzqLgwaXAbxeoQFVOfG1FF821BTxj
	 kHnVuo3AVRLahXygQJiN91QlDFS7f1HuFZYXr2xtU8UiLfWxXd6uMU3eftMYIVL8LF7JL
	 S+Ud+hWMH22NL1Xt5sFXsBsuOoXKncDhBR2IQICk0BUf7k4pqvPBXiaskOYSwjvgXSg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FF8RqXYn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A91606A326;
	Sat,  7 Nov 2026 08:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FF8RqXYn
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794041218;
	b=g5jUbZ7i6+5hbtQKE547WWTYXfZ22ih1P5M6ILXhqLR5T5/YbsLTOBv2IZsC5Wg+fXOW
	 VQr+C5ZQk7K5unNodxK7nBpWvu5tBdZCwrZNunAk4gVuShd8QIAHZLtjS6TFALovbdZPb
	 6kIruiE1DdZw0dWLFJR21o3xfxokufcGdvbxGg/lXvIi+Dfz0NXLKUuQfSvVelemFCYx2
	 WTzcz47tAKpNIeybnjQejk0QuKup0vTBj6mEavXjab4WHiVp+GFZS4ESbnnWbxV7/5Rty
	 uk6ozCtipyym++xUKeJ6dDFpFIWvrvDJeodcvaZfVBJ+ueyv92WH04HPd2NPKaYgQFg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794041218;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=bAtNJeQQZtV0gJf8mO/hJSLFnMdkjTPe0Tyts98GCi0=;
	b=SgE43hTHLKfsZmRifaLKmcFPUJWZfW6I4orNVpdr3bkiSuwwCwPqNk01Ldk5JdgL4+E/
	 4HsaDSzahzF9i1QcQqdsUbixxUqGTVdwpgsFAhsJB09M7br4TYAYNRM8WpCbp74fWAjpS
	 +T8AmLfKtBQEI2OXfy8eXGNwgB519X0TiRE+5Vn0mY/dJYK+MbvaLQkFQaN9385B2PdCd
	 tIpV96e9GKPTU2aL5ahnUSNUfkFVteFlA/NW2ByX9yhLKj4uEMDlkDC86BffGWyzsAx+Z
	 NB2IA0UbYD5Xhj5k5RRGDChf8jJivJTpNoKg8RRSlWQfYOgdAzTiy3DcKsRbgWZHtxA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B28671F0089F;
	Sat,  7 Nov 2026 08:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794041218;
	bh=bAtNJeQQZtV0gJf8mO/hJSLFnMdkjTPe0Tyts98GCi0=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=FF8RqXYntGFx92+sfkOztEgA4WIAyQcpfDrN5w6rcRI4PN/aC/aikAS+NjSvOT/0N
	 vJvvYAQRcf7sIzfPnGj5gehP7i3fxpAsDjwL4dTIEJ3Pt35Lp+TCjFg9cHU3TCqeUf
	 Eca9sLD/bKlApKMdYImE6f+1xe68TgiuePOpSja7IEkBc/HmLjWkaY1CSykrcv6kIx
	 QagCqkKMKCYYWh5dBwbrDehR8zjQM9LvnedxhAzOiCRgzJ3rzl+vKa5dYEAFEVgKLu
	 IrfHBjWPon79bxCmQKqlCS7yhMbUjY1qQWvVGr/Qy6YDeGTuD9Y/z97pFk0m+DECiN
	 g7zfpJ7j6KQsg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 10B8B47B20;
	Sat,  7 Nov 2026 08:46:57 +0000 (UTC)
From: Han Gao via B4 Relay <devnull+gaohan.iscas.ac.cn@kernel.org>
Date: Sat, 07 Nov 2026 16:46:40 +0800
Subject: [PATCH] firmware/sysfb: Avoid simple-framebuffer behind DT PCI
 host bridges
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261107-sysfb-dt-pci-efifb-v1-1-86d6c598671a@iscas.ac.cn>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqEMAyF4atI1gbaOqjMVQYXto0aFyqNilK8+
 1Rdfg/eH0EoMAl8swiBdhaepwSdZ+CGduoJ2SeDUabUWlUop3QW/YqLY6SOb1SFVbUn/7EG0nE
 JaT+e6K95LZsdya13Ca7rDywKGgR2AAAA
X-Change-ID: 20261107-sysfb-dt-pci-efifb-d73b08ded4b2
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Thomas Zimmermann <tzimmermann@suse.de>, 
 Javier Martinez Canillas <javierm@redhat.com>, Borislav Petkov <bp@suse.de>, 
 Simona Vetter <simona.vetter@ffwll.ch>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-riscv@lists.infradead.org, 
 Han Gao <rabenda.cn@gmail.com>, stable@vger.kernel.org, 
 Han Gao <gaohan@iscas.ac.cn>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794041216; l=3936;
 i=gaohan@iscas.ac.cn; s=20261021; h=from:subject:message-id;
 bh=kYFDOzF/Itut71CnG8RI8WDwvweu0YIXUO3C925lonU=;
 b=f49pP12LVp3nDhY5/qNCdRrn7GKGKv+PAeF7rRNnQhocxFGvzzftFz+q/x/2lTZdiAgXP2VPM
 Spx0r81cSHOD19AjA6XvuruJdovxQmXrcjLGkzR1exrcTYj1jtHjwTP
X-Developer-Key: i=gaohan@iscas.ac.cn; a=ed25519;
 pk=J8WHEK3filS86QaCaIHDGafqhxKyQ4K7+vFgRirTIiY=
X-Endpoint-Received: by B4 Relay for gaohan@iscas.ac.cn/20261021 with
 auth_id=1262
X-Original-From: Han Gao <gaohan@iscas.ac.cn>
Reply-To: gaohan@iscas.ac.cn
Content-Transfer-Encoding: 7bit

From: Han Gao <gaohan@iscas.ac.cn>

With SYSFB_SIMPLEFB, sysfb registers a simple-framebuffer device that
claims the framebuffer memory when it is added. On DT systems, the PCI
host bridge may probe later and then fails to claim its memory window.
On QEMU RISC-V virt with EDK2, a bochs-display and pci-host-generic
built as a module:

  [    0.703813] pci-host-generic 30000000.pci: resource collision: [mem 0x40000000-0x7fffffff] conflicts with BOOTFB [mem 0x40000000-0x403e7fff]

In that case, register an efi-framebuffer device instead. It claims no
memory before it probes, and commit 64c8a0cd0a53 ("efi/arm: Defer probe
of PCIe backed efifb on DT systems") makes it wait for the host bridge.

Tested on a HiFive Unmatched with EDK2 and a PCIe graphics card, and on
QEMU.

Fixes: 8633ef82f101 ("drivers/firmware: consolidate EFI framebuffer setup for all arches")
Cc: stable@vger.kernel.org
Signed-off-by: Han Gao <gaohan@iscas.ac.cn>
---
In QEMU, efifb takes over with SYSFB_SIMPLEFB and efidrm without it.
With pci-host-generic built in, simpledrm is still used.
---
 drivers/firmware/efi/sysfb_efi.c | 16 ++++++++++++++++
 drivers/firmware/sysfb.c         |  8 +++++++-
 include/linux/sysfb.h            |  6 ++++++
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/sysfb_efi.c b/drivers/firmware/efi/sysfb_efi.c
index 2338de73c62c..5c2cb87178ff 100644
--- a/drivers/firmware/efi/sysfb_efi.c
+++ b/drivers/firmware/efi/sysfb_efi.c
@@ -421,6 +421,22 @@ __init void sysfb_apply_efi_quirks(struct screen_info *si)
 		dmi_check_system(efifb_dmi_swap_width_height);
 }
 
+/* Returns true if the EFI framebuffer is in a DT PCI host bridge window */
+__init bool sysfb_efifb_behind_dt_pci(const struct screen_info *si)
+{
+	struct device_node *np;
+
+	if (si->orig_video_isVGA != VIDEO_TYPE_EFI || !IS_ENABLED(CONFIG_PCI))
+		return false;
+
+	np = find_pci_overlap_node();
+	if (!np)
+		return false;
+
+	of_node_put(np);
+	return true;
+}
+
 __init void sysfb_set_efifb_fwnode(const struct screen_info *si, struct platform_device *pd)
 {
 	if (si->orig_video_isVGA == VIDEO_TYPE_EFI && IS_ENABLED(CONFIG_PCI)) {
diff --git a/drivers/firmware/sysfb.c b/drivers/firmware/sysfb.c
index 8833582c1883..8853a74560b9 100644
--- a/drivers/firmware/sysfb.c
+++ b/drivers/firmware/sysfb.c
@@ -164,8 +164,14 @@ static __init int sysfb_init(void)
 		goto unlock_mutex;
 	}
 
-	/* try to create a simple-framebuffer device */
+	/*
+	 * Try to create a simple-framebuffer device. It claims the memory
+	 * when it is added, so a DT PCI host bridge that probes later would
+	 * fail. Use an efi-framebuffer device there; it waits for the bridge.
+	 */
 	compatible = sysfb_parse_mode(si, &mode);
+	if (compatible && !parent && sysfb_efifb_behind_dt_pci(si))
+		compatible = false;
 	if (compatible) {
 		pd = sysfb_create_simplefb(si, &mode, parent);
 		if (!IS_ERR(pd))
diff --git a/include/linux/sysfb.h b/include/linux/sysfb.h
index ed23d6516223..b136fdebc746 100644
--- a/include/linux/sysfb.h
+++ b/include/linux/sysfb.h
@@ -95,6 +95,7 @@ static inline bool sysfb_handles_screen_info(void)
 
 extern struct efifb_dmi_info efifb_dmi_list[];
 void sysfb_apply_efi_quirks(struct screen_info *si);
+bool sysfb_efifb_behind_dt_pci(const struct screen_info *si);
 void sysfb_set_efifb_fwnode(const struct screen_info *si, struct platform_device *pd);
 
 #else /* CONFIG_EFI */
@@ -103,6 +104,11 @@ static inline void sysfb_apply_efi_quirks(struct screen_info *si)
 {
 }
 
+static inline bool sysfb_efifb_behind_dt_pci(const struct screen_info *si)
+{
+	return false;
+}
+
 static inline void sysfb_set_efifb_fwnode(const struct screen_info *si,
 					  struct platform_device *pd)
 {

---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261107-sysfb-dt-pci-efifb-d73b08ded4b2

Best regards,
--  
Han Gao <gaohan@iscas.ac.cn>


