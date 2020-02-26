Return-Path: <SRS0=gsoD=4O=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A67BC4BA06
	for <linux-efi@archiver.kernel.org>; Wed, 26 Feb 2020 01:11:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D95B22464
	for <linux-efi@archiver.kernel.org>; Wed, 26 Feb 2020 01:11:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VoB0oeTr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbgBZBKv (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 25 Feb 2020 20:10:51 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:57148 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729346AbgBZBKu (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 25 Feb 2020 20:10:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1582679450; x=1614215450;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=km1VvmnuQj7lRiGCtgFsEfp9xWGhODjFHkqy+jn/5IE=;
  b=VoB0oeTr2Pd0g2h1WKz+c02esZ+OrCYq1449vmHI51e1bV2Rel2KA5FJ
   SMkfB62Ol0BGRnhRvZwA1j/VaBnnaPLGRYxHlEtCx8z6XlB9OTBpJ957B
   6CdiUmfoQaq/Tnqt4Os+C9kjdqOS+dqReeAIiS88E3YGzjdrMzmyLR5/t
   5fxGfTNXTwAmaiGItCEIoOLZasqlKvn7rM6+GBFSL/MkfOJzVP3L+v9Gr
   gxgIGR9ss+nMlqRAdlgPaISLj00cYo2jhID8AIBqANS9HxYYNMJxo6wMd
   r8SaHhAdfwPiXDFVzmWazfAjNDWm/RiyDvfsm8LAu9AgFmu9Yd4oz6AKO
   w==;
IronPort-SDR: RUGwhWHn4x9alqJAPWSj15MinUmrl7948vVrSOkEg/yh+gzWfC2U7ETIcaiZro0dETogXLsF3w
 Kkhmf4cAM3kzVjusl6k4X6RN3nVQQeqoUNJfgNnSaWToBtjM7Xd6nqLWXxQqraFQnFryp4kVPu
 k/ZnDI8zLWEVOGgDHj4fKejjkeoHZh1OYEeZhz5W3e4zx4/f0yKIB2V3bUkh71SE76tDuWoqgC
 E6ZU++cBXWtSx7ya1/Fez6qN0JObu+yI7WgKEaaCmRTmN812l1AKFwffZsYiRdmuyrlf/mpL0P
 ly4=
X-IronPort-AV: E=Sophos;i="5.70,486,1574092800"; 
   d="scan'208";a="131266501"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 26 Feb 2020 09:10:50 +0800
IronPort-SDR: L/xEh/oMCpWFsvBGqwpn28t1qCTykvBwHSj46KuHyeLf+bYc//taHfvkODDDl/6CmHpofuaISv
 4aWz24xB3bZFOn/JDy7oQAYIhOBoyhJ/6ipr995PTajzNF6gFNipKk/wWxPHwlOhyf4SW3rScY
 81QhNVNxOqcgm5cHcsgFLH/rZSPoEDbe1jrNZUmDAebB+AY1/J785JsmdNa1sh+CTogl2IWiOz
 mSpPyvI8kyd+wZfhR6NRddiWi64d48ptGzRsgh7gnCO9U/YJxQYZ1T5gBYZCWL6NQEaQDPNWAN
 TeOLZx0LltdV6xFvTx9iQ0R4
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2020 17:03:15 -0800
IronPort-SDR: DStrW9Vd4utZF1pF2XNWrYK8IPP2TZhl9+LTcQRkI2XPIDXj8PnxMlAk3Am8hTYroeihv50UhV
 4SLEad5jCpjROgGHafrFxWdpgLOdKBO+quj7ooZixI2Qdq3/mXqT9OlNHOWnF4dX6CXw7lsvQv
 Ntinh3nPQdjW1gL0ZicBlLKgRTF/mxMBLmPGWLr5elcBq9iiOto1mc+/YRX/+KIqNK/8NSBVcS
 NufJjHjzNoep/YJ1ImXTyy1FTJPijSNLp0bA+Oaochg6T63sTKC+Rdn+phk0Uey0qqKExobdW9
 XZA=
WDCIronportException: Internal
Received: from jedi-01.sdcorp.global.sandisk.com (HELO jedi-01.int.fusionio.com) ([10.11.143.218])
  by uls-op-cesaip02.wdc.com with ESMTP; 25 Feb 2020 17:10:48 -0800
From:   Atish Patra <atish.patra@wdc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atish.patra@wdc.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <Anup.Patel@wdc.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@suse.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-efi@vger.kernel.org, linux-riscv@lists.infradead.org,
        Mao Han <han_mao@c-sky.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Alexander Graf <agraf@csgraf.de>,
        "leif@nuviainc.com" <leif@nuviainc.com>,
        "Chang, Abner (HPS SW/FW Technologist)" <abner.chang@hpe.com>,
        daniel.schaefer@hpe.com
Subject: [RFC PATCH 2/5] include: pe.h: Add RISC-V related PE definition
Date:   Tue, 25 Feb 2020 17:10:34 -0800
Message-Id: <20200226011037.7179-3-atish.patra@wdc.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200226011037.7179-1-atish.patra@wdc.com>
References: <20200226011037.7179-1-atish.patra@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Define RISC-V related machine types.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
---
 include/linux/pe.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/pe.h b/include/linux/pe.h
index 8ad71d763a77..6a7c497e4b1f 100644
--- a/include/linux/pe.h
+++ b/include/linux/pe.h
@@ -56,6 +56,9 @@
 #define	IMAGE_FILE_MACHINE_POWERPCFP	0x01f1
 #define	IMAGE_FILE_MACHINE_R4000	0x0166
 #define	IMAGE_FILE_MACHINE_SH3		0x01a2
+#define	IMAGE_FILE_MACHINE_RISCV32	0x5032
+#define	IMAGE_FILE_MACHINE_RISCV64	0x5064
+#define	IMAGE_FILE_MACHINE_RISCV128	0x5128
 #define	IMAGE_FILE_MACHINE_SH3DSP	0x01a3
 #define	IMAGE_FILE_MACHINE_SH3E		0x01a4
 #define	IMAGE_FILE_MACHINE_SH4		0x01a6
-- 
2.24.0

