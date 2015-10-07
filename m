From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: [PATCH v8 1/2] efi: export efi_capsule_supported() function symbol
Date: Thu,  8 Oct 2015 03:13:52 +0800
Message-ID: <1444245233-19229-2-git-send-email-hock.leong.kweh@intel.com>
References: <1444245233-19229-1-git-send-email-hock.leong.kweh@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444245233-19229-1-git-send-email-hock.leong.kweh@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ong Boon Leong <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Fleming Matt <matt.fleming@intel.com>, h.peter.anvin@intel.com
List-Id: linux-efi@vger.kernel.org

From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>

This patch export efi_capsule_supported() function symbol for capsule
kernel module to use.

Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>
---
NOTE:
This patch will be merge into Matt's [PATCH 2/2] efi: Capsule update support
"https://lkml.org/lkml/2014/10/7/391", if he is agreeing to expose the
function interface.

 drivers/firmware/efi/capsule.c |    1
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
index d8cd75c0..738d437 100644
--- a/drivers/firmware/efi/capsule.c
+++ b/drivers/firmware/efi/capsule.c
@@ -101,6 +101,7 @@ out:
 	kfree(capsule);
 	return rv;
 }
+EXPORT_SYMBOL_GPL(efi_capsule_supported);
 
 /**
  * efi_capsule_update - send a capsule to the firmware
-- 
1.7.9.5
