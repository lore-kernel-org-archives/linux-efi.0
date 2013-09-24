From: "Borislav Petkov" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Date: Tue, 24 Sep 2013 11:43:39 +0200 (CEST)
Message-ID: <bd9528a453bce9b52ad4be75dcc0f034.squirrel@www.skyhub.de>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
    <1379602494-26684-12-git-send-email-bp@alien8.de>
    <20130921113929.GB1587@pd.tnic>
    <20130922123515.GA7476@dhcp-16-126.nay.redhat.com>
    <20130922133722.GC28718@pd.tnic>
    <1ba7eca6-419c-4181-9927-9ba0927a6abf@email.android.com>
    <20130924025209.GA5561@dhcp-16-126.nay.redhat.com>
    <2d27a1bc-eabf-4d45-8303-27ae58511b11@email.android.com>
    <20130924045705.GB5561@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130924045705.GB5561-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Crap,

I need to send from the web interface since the network here doesn't
somehow let through port 587.

On Tue, September 24, 2013 6:57 am, Dave Young wrote:
> On 09/23/13 at 08:06pm, H. Peter Anvin wrote:
>> Okay... I see two problems.
>>
>> 1. It looks like we subtract the region size after, rather than before,
>> assigning an address.
>>
>> 2. The second region is assigned the same address in the secondary
>> kernel as in the first, implying the size of the first region was
>> somehow set to zero.
>
> I find the reason, efi_reserve_boot_services will reserve the
> BOOT_SERVICE_DATA region
> thus the memmap size is changed to 0, so in 2nd kernel the virtual mapping
> addr after
> the md will be not same as 1st kernel, see below code:
>
> void __init efi_map_region(efi_memory_desc_t *md)
> {
>         unsigned long size = md->num_pages << PAGE_SHIFT;
>
>         efi_va -= size;
>         ^^^^^^^^^^^^^^^

Anyway, yes, this is wrong. We probably want to something like the
following, instead (patch might be whitespace-damaged):

--
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index a235dc95d629..ea0ea4fd3dab 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -85,8 +85,7 @@ void __init efi_map_region(efi_memory_desc_t *md)
 {
 	unsigned long size = md->num_pages << PAGE_SHIFT;

-	efi_va -= size;
-	if (efi_va < EFI_VA_END) {
+	if (efi_va - size < EFI_VA_END) {
 		pr_warning(FW_WARN "VA address range overflow!\n");
 		return;
 	}
@@ -101,6 +100,8 @@ void __init efi_map_region(efi_memory_desc_t *md)
 	/* Do the VA map */
 	__map_region(md, efi_va);
 	md->virt_addr = efi_va;
+
+	efi_va -= size;
 }

 void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long
size,

-- 
Regards/Gruss,
Boris.
