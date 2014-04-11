From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: "54b52d87268034859191d671505bb1cfce6bd74d - x86/efi: Build our
 own EFI services pointer table" breaks boot on thinkpad t440s
Date: Fri, 11 Apr 2014 08:44:28 +0100
Message-ID: <20140411074428.GA22042@console-pimps.org>
References: <AF4406ED-6B0B-4E15-A329-04162E0ADC8A@dominion.thruhere.net>
 <20140410121146.GA17021@console-pimps.org>
 <20140411072044.GA15418@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140411072044.GA15418-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Zhang Yanfei <zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 11 Apr, at 09:20:44AM, Ingo Molnar wrote:
> 
> Might be prudent to do the same in __file_size32(), instead of 
> truncating silently, especially is that function too has a u64 output 
> AFAICS.
 
This change isn't required for __file_size32() because we only use that
function if the firmware is 32-bit. The signature of
EFI_FILE_PROTOCOL.GetInfo() looks like this,

  EFI_STATUS (*EFI_FILE_GET_INFO) (
	EFI_FILE_PROTOCOL *This,
	EFI_GUID 	  *InformationType,
	UINTN		  *BufferSize,
	void		  *Buffer
  );

UINTN translates to unsigned long, so for 32-bit firmware is u32. The
firmware will never write 64-bits to &info_sz in __file_size32().

> Also, while reviewing the file I noticed that there's "u32 fb_base", 
> which is recovered like:
> 
>                 status = __gop_query64(gop64, &info, &size, &fb_base);
> 
> but ->frame_buffer_base is u64. Is it always guaranteed u32?

Good catch. ->frame_buffer_base isn't always u32, but we only have u32
bits in which to store it (struct screen_info.lfb_base), so we
implicitly truncate it,

static efi_status_t
__gop_query64(struct efi_graphics_output_protocol_64 *gop64,

[...]

        *fb_base = mode->frame_buffer_base;

But you raise a good point - it would probably make more sense to
complain loudly if we get an address above 0xffffffff.

-- 
Matt Fleming, Intel Open Source Technology Center
