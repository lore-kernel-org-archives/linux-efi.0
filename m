From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: [PATCH 2/2] Remove extra mapping code for UV MMRs
Date: Mon, 16 Nov 2015 11:59:41 -0600
Message-ID: <1447696781-159611-2-git-send-email-athorlton@sgi.com>
References: <1447696781-159611-1-git-send-email-athorlton@sgi.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447696781-159611-1-git-send-email-athorlton-sJ/iWh9BUns@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Hedi Berriche <hedi-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

These MMRs get mapped in correctly using the new EFI memmap scheme on
recent BIOSes, so we no longer need to set up these extra mappings for
them.

Signed-off-by: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Acked-by: Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>
Acked-by: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Hedi Berriche <hedi-sJ/iWh9BUns@public.gmane.org>
Cc: Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

---
 arch/x86/kernel/apic/x2apic_uv_x.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index c8d9295..e8db45d 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -712,12 +712,6 @@ static __init void map_mmioh_high(int min_pnode, int max_pnode)
 	}
 }
 
-static __init void map_low_mmrs(void)
-{
-	init_extra_mapping_uc(UV_GLOBAL_MMR32_BASE, UV_GLOBAL_MMR32_SIZE);
-	init_extra_mapping_uc(UV_LOCAL_MMR_BASE, UV_LOCAL_MMR_SIZE);
-}
-
 static __init void uv_rtc_init(void)
 {
 	long status;
@@ -890,7 +884,6 @@ void __init uv_system_init(void)
 		return;
 	}
 	pr_info("UV: Found %s hub\n", hub);
-	map_low_mmrs();
 
 	m_n_config.v = uv_read_local_mmr(UVH_RH_GAM_CONFIG_MMR );
 	m_val = m_n_config.s.m_skt;
-- 
1.8.5.6
