Return-Path: <SRS0=CYU3=YQ=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 775DFCA9EB9
	for <linux-efi@archiver.kernel.org>; Wed, 23 Oct 2019 17:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E54A222C4
	for <linux-efi@archiver.kernel.org>; Wed, 23 Oct 2019 17:32:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TOaj2vgs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbfJWRcG (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 23 Oct 2019 13:32:06 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38176 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728832AbfJWRcF (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 23 Oct 2019 13:32:05 -0400
Received: by mail-wm1-f67.google.com with SMTP id 3so20476776wmi.3
        for <linux-efi@vger.kernel.org>; Wed, 23 Oct 2019 10:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LMJXqmk6RQTbWYCNHCam9h3+n8eYtkpYb5J9t6ynQv4=;
        b=TOaj2vgsemOLgcAdk2Q++vNiURX2IRRaQjRpl/iS81HHZqob6R8ZiNwdCgG9qjhfwu
         j9tRZ7I+4bl0v8HbusUmSBNsjAQdSgt5zfPP70oozlSFSRF5P9i6t6eDf3lz9K1DPg+t
         aBXCFmJv3Rps0Dt8ox3QLKZKvow0rlWkdSkbMoRJ9TUg4NdJeGl37q32xBWeCqwdygjc
         qcAHztoWvtBV7GLuy9/jWjT5RVNCsmeByDVkI7POAI0vNNqp1uYFRtSXbIjfGEoMa7Wk
         oEipeSJ3DyTKYe7fuz67V+lybmXC4owCtfAAdIH+vNqMeK/7dCyTFyoIUvVimHN8uSoN
         ubOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LMJXqmk6RQTbWYCNHCam9h3+n8eYtkpYb5J9t6ynQv4=;
        b=OYBQfygnGN32c9F9pNdED3r/WRp4CKoz19qwZoqOU62cOE/AlXu2Ba6HliGXcdEeX5
         eYm9/2C8MeMdStib5jUVUMKShGge3++xuh/nmSQdNndg47oL0SvalWUNpOVhMYt9ovqy
         MqAjCo6Z4rJnvWdbpjKbnhBjYI7tvtO3m/cF6cdM3SLaIWaWOrfO7RQjirUlHxtTHG6R
         YHoR9ARpA02XaW1xyf+rR9w/AuFbJYPVi8BJktbJGFaFy6IdNBvT8b2YoKF/SQqym2Ax
         r2DpdmJAKumhRYzwefkxwcK0p9AnAlh0SOT+G6OFzXR9jlao4qrugilkVmr64F13mGTB
         s0iw==
X-Gm-Message-State: APjAAAX/pBC2Hv2A62GxSvHQC0SCVKd0hiG/J/SwR9i079nQ8o23NBW4
        rjpuWmjhnL9GE41sp0ulyg8Yxk1SQz2xbibl
X-Google-Smtp-Source: APXvYqyUat3dXQRiNFjrU5irKrTafd3sW3QnMEDo9Yt3J7bOl7M9ejvTRZ7XVwdlw7690zfrBIaa4A==
X-Received: by 2002:a05:600c:21c8:: with SMTP id x8mr861248wmj.123.1571851922155;
        Wed, 23 Oct 2019 10:32:02 -0700 (PDT)
Received: from e123331-lin.home (lfbn-mar-1-643-104.w90-118.abo.wanadoo.fr. [90.118.215.104])
        by smtp.gmail.com with ESMTPSA id f7sm14900374wre.68.2019.10.23.10.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 10:32:01 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Narendra K <Narendra.K@dell.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] efi: Make CONFIG_EFI_RCI2_TABLE selectable on x86 only
Date:   Wed, 23 Oct 2019 19:31:57 +0200
Message-Id: <20191023173201.6607-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191023173201.6607-1-ard.biesheuvel@linaro.org>
References: <20191023173201.6607-1-ard.biesheuvel@linaro.org>
X-ARM-No-Footer: FoSSMail
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Narendra K <Narendra.K@dell.com>

For the EFI_RCI2_TABLE kconfig option, 'make oldconfig' asks the user
for input on platforms where the option may not be applicable. This patch
modifies the kconfig option to ask the user for input only when CONFIG_X86
or CONFIG_COMPILE_TEST is set to y.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Narendra K <Narendra.K@dell.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 178ee8106828..b248870a9806 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -182,6 +182,7 @@ config RESET_ATTACK_MITIGATION
 
 config EFI_RCI2_TABLE
 	bool "EFI Runtime Configuration Interface Table Version 2 Support"
+	depends on X86 || COMPILE_TEST
 	help
 	  Displays the content of the Runtime Configuration Interface
 	  Table version 2 on Dell EMC PowerEdge systems as a binary
-- 
2.17.1

