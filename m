From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: 4.9-rc1 boot regression, ambiguous bisect result
Date: Thu, 20 Oct 2016 12:37:16 -0700
Message-ID: <CAPcyv4gE0wtoR3Yxh6axiQpPE2MvDgGW=JLEz9b7OMSBQZ_HDQ@mail.gmail.com>
References: <CAPcyv4gDYcahNJ6CEzf2eUGq8sGqW8Yo09T8cscGWTLoja7PXw@mail.gmail.com>
 <20161020122931.GD19876@codeblueprint.co.uk> <CAPcyv4hT+yQvnQzfb49FP-+vVaVKHTYEj1EjNd9Xvu0Wr8T+Bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPcyv4hT+yQvnQzfb49FP-+vVaVKHTYEj1EjNd9Xvu0Wr8T+Bg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 20, 2016 at 8:22 AM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, Oct 20, 2016 at 5:29 AM, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
>> On Wed, 19 Oct, at 09:04:29PM, Dan Williams wrote:
>>> Hi,
>>>
>>> I am currently unable to boot a Yoga 900 with latest mainline, but 4.8 boots.
>>>
>>> The symptom is a reboot before the video console is available.
>>>
>>> I bisected to commit 816e76129ed5 "efi: Allow drivers to reserve boot
>>> services forever".  However, that commit is known to be broken.  The
>>> proposed fix, commit 92dc33501bfb "x86/efi: Round EFI memmap
>>> reservations to EFI_PAGE_SIZE", also exhibits the reboot problem.
>>>
>>> During the bisect some of the stopping points landed on commits that
>>> caused the boot process to hang rather than cause a reboot.  The
>>> commits that resulted in a hang are marked "git bisect skip" in this
>>> log: https://gist.github.com/djbw/1b501daa98192a42ae848f03bb59c30e
>>>
>>> I'll try treating those hangs as bad bisect results and re-run the
>>> full bisect tomorrow.  In the meantime I wonder if the bisect log
>>> implicates a better regression candidate?
>>
>> Could you mail the dmesg output when booting a known working kernel
>> with efi=debug ?
>
> Here it is:
>
> https://gist.github.com/djbw/cae05e721b159d5ad7b146d7a93f5fa2

I am able to build a kernel and boot the platform with the following
set of reverts:

      Revert "x86/efi: Round EFI memmap reservations to EFI_PAGE_SIZE"
      Revert "x86/efi-bgrt: Use efi_mem_reserve() to avoid copying image data"
      Revert "efi/esrt: Use efi_mem_reserve() and avoid a kmalloc()"
      Revert "efi: Allow drivers to reserve boot services forever"
