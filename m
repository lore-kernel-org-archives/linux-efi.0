From: Joseph Salisbury <joseph.salisbury-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [REGRESSION][v4.9.y][v4.10.y] x86/efi: Only map RAM into EFI page
 tables if in mixed-mode
Date: Fri, 3 Feb 2017 09:16:48 -0500
Message-ID: <f8b36e38-c1f6-82f8-0ed9-0c934ace44ac@canonical.com>
References: <31c63945-fa81-de18-941b-9021f3d9f16c@canonical.com>
 <d5f1ba6b-06ed-b5b0-1b0e-58d5f385f7c2@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d5f1ba6b-06ed-b5b0-1b0e-58d5f385f7c2-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: waiman.long-ZPxbGqLxI0U@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, tytso-3s7WtUTddSA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, scott.norton-ZPxbGqLxI0U@public.gmane.org, doug.hatch-ZPxbGqLxI0U@public.gmane.org, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 02/02/2017 03:36 PM, Laura Abbott wrote:
> On 02/02/2017 12:17 PM, Joseph Salisbury wrote:
>> Hi Matt,
>>
>> A kernel bug report was opened against Ubuntu [0].  After a kernel
>> bisect, it was found that reverting the following commit resolved this bug:
>>
>> commit 1297667083d5442aafe3e337b9413bf02b114edb
>> Author: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
>> Date:   Mon Sep 19 13:09:09 2016 +0100
>>
>>     x86/efi: Only map RAM into EFI page tables if in mixed-mode
>>
>>
>> The regression was introduced as of v4.8-rc8.  It also still affects
>> current mainline.
>>
>> I was hoping to get your feedback, since you are the patch author.  Do
>> you think gathering any additional data will help diagnose this issue,
>> or would it be best to submit a revert request?
>>
>>
>> Thanks,
>>
>> Joe
>>
>> [0] http://pad.lv/1659340
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe stable" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> You might try https://marc.info/?l=linux-kernel&m=148553171703761
> which fixed https://bugzilla.redhat.com/show_bug.cgi?id=1384238
>
> Thanks,
> Laura

This patch resolves the bug for multiple users.  Thanks again for the
pointer, Laura and Ard!


Joe
