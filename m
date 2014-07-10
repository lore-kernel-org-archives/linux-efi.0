From: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Subject: [PATCH v2] efi: Fix PE/COFF headers
Date: Thu, 10 Jul 2014 12:26:19 +0100
Message-ID: <1404991581-31210-1-git-send-email-mbrown@fensystems.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Version 2 of this patch series: includes a fix for a build breakage
when CONFIG_EFI_STUB is not enabled.
