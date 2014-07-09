From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efi: Include a .bss section within the PE/COFF headers
Date: Wed, 09 Jul 2014 15:41:40 -0700
Message-ID: <23bc6890-7eb6-43ef-8e40-6e820f0ae577@email.android.com>
References: <1404942094-29447-1-git-send-email-mbrown@fensystems.co.uk> <53BDC038.1090003@fensystems.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53BDC038.1090003-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

init_size does not include any kind of alignment padding.

On July 9, 2014 3:20:40 PM PDT, Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org> wrote:
>On 09/07/14 22:41, Michael Brown wrote:
>> The PE/COFF headers currently describe only the initialised-data
>> portions of the image, and result in no space being allocated for the
>> uninitialised-data portions.  Consequently, the EFI boot stub will
>end
>> up overwriting unexpected areas of memory, with unpredictable
>results.
>>
>> Fix by including a .bss section in the PE/COFF headers (functionally
>> equivalent to the init_size field in the bzImage header).
>
>Following on from this: hpa mentioned via IRC that we should also take 
>alignment into account.  I am unsure if init_size already includes 
>padding for alignment; on my sample kernel init_size is >16MB (with
>16MB 
>alignment), so it looks plausible to me that alignment is already 
>accounted for.
>
>If not, then the following trivial patch exposes the desired alignment 
>via the PE/COFF headers:
>
>diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
>index 7a6d43a..16ef025 100644
>--- a/arch/x86/boot/header.S
>+++ b/arch/x86/boot/header.S
>@@ -154,7 +154,7 @@ extra_header_fields:
>  #else
>  	.quad	0				# ImageBase
>  #endif
>-	.long	0x20				# SectionAlignment
>+	.long	CONFIG_PHYSICAL_ALIGN		# SectionAlignment
>  	.long	0x20				# FileAlignment
>  	.word	0				# MajorOperatingSystemVersion
>  	.word	0				# MinorOperatingSystemVersion

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
