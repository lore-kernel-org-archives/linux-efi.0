From: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] x86/simplefb: simplefb was broken on Oracle and HP
 system, skip VIDEO_TYPE_EFI
Date: Fri, 5 Jun 2015 11:31:32 +0200
Message-ID: <CANq1E4Sqj6y1ys3z_XtgJj61r+4QQK_FCJFMPZ4v-2Ao-ddmXg@mail.gmail.com>
References: <1432712748-11344-1-git-send-email-ethan.zhao@oracle.com>
	<20150605091713.GD6826@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150605091713.GD6826-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ethan Zhao <ethan.zhao-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ethan.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi

On Fri, Jun 5, 2015 at 11:17 AM, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> (Cc'ing David)
>
> On Wed, 27 May, at 04:45:48PM, Ethan Zhao wrote:
>> As descriped in https://bugzilla.kernel.org/show_bug.cgi?id=98721
>> When kernel 4.0.4 was tested on Oracle and HP system with UEFI mode, no output and
>> login on console.
>>
>> Simplefb was broken on these systems when orig_video_isVGA is VIDEO_TYPE_EFI, so
>> skip it.
>>
>> This patch was tested on Oracle Sun server X5-2 series and HP ProLiant DL380 Gen9
>> with kernel 4.0.4
>>
>> Signed-off-by: Ethan Zhao <ethan.zhao-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Tested-by: Kunlun Lao <kunlun.lao-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>  arch/x86/kernel/sysfb_simplefb.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/sysfb_simplefb.c b/arch/x86/kernel/sysfb_simplefb.c
>> index 764a29f..f833502 100644
>> --- a/arch/x86/kernel/sysfb_simplefb.c
>> +++ b/arch/x86/kernel/sysfb_simplefb.c
>> @@ -36,7 +36,7 @@ __init bool parse_mode(const struct screen_info *si,
>>       unsigned int i;
>>
>>       type = si->orig_video_isVGA;
>> -     if (type != VIDEO_TYPE_VLFB && type != VIDEO_TYPE_EFI)
>> +     if (type != VIDEO_TYPE_VLFB)
>>               return false;
>>
>>       for (i = 0; i < ARRAY_SIZE(formats); ++i) {
>
> This patch makes sense to me, but I'd really like David to fill us in on
> the rationale for including VIDEO_TYPE_EFI in the simplefb list in first
> place, and whether he's aware of any platforms that require simplefb for
> UEFI.

simplefb works perfectly fine on EFI systems. There is no need to use
vesafb nor efifb anymore. If simplefb does not work on a platform, we
should fix it. Hence, I object to this patch. Can you elaborate what
exactly the problem is? Are you sure you have CONFIG_FB_SIMPLE=y?

If you really want to use efifb instead, please set
CONFIG_X86_SYSFB=n. This config option controls whether you want
firmware framebuffers to be converted to the generic
simple-framebuffer interface, or whether you want to use the old
vesa/efi-framebuffer interfaces.

Thanks
David
