From: Ingo Molnar <mingo@kernel.org>
Subject: Re: 4.9-rc1 boot regression, ambiguous bisect result
Date: Fri, 21 Oct 2016 09:00:54 +0200
Message-ID: <20161021070054.GA6301@gmail.com>
References: <CAPcyv4gDYcahNJ6CEzf2eUGq8sGqW8Yo09T8cscGWTLoja7PXw@mail.gmail.com>
 <20161020122931.GD19876@codeblueprint.co.uk>
 <CAPcyv4hT+yQvnQzfb49FP-+vVaVKHTYEj1EjNd9Xvu0Wr8T+Bg@mail.gmail.com>
 <CAPcyv4gE0wtoR3Yxh6axiQpPE2MvDgGW=JLEz9b7OMSBQZ_HDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4gE0wtoR3Yxh6axiQpPE2MvDgGW=JLEz9b7OMSBQZ_HDQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Peter Jones <pjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org


* Dan Williams <dan.j.williams@intel.com> wrote:

> On Thu, Oct 20, 2016 at 8:22 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> > On Thu, Oct 20, 2016 at 5:29 AM, Matt Fleming <matt@codeblueprint.co.uk> wrote:
> >> On Wed, 19 Oct, at 09:04:29PM, Dan Williams wrote:
> >>> Hi,
> >>>
> >>> I am currently unable to boot a Yoga 900 with latest mainline, but 4.8 boots.
> >>>
> >>> The symptom is a reboot before the video console is available.
> >>>
> >>> I bisected to commit 816e76129ed5 "efi: Allow drivers to reserve boot
> >>> services forever".  However, that commit is known to be broken.  The
> >>> proposed fix, commit 92dc33501bfb "x86/efi: Round EFI memmap
> >>> reservations to EFI_PAGE_SIZE", also exhibits the reboot problem.
> >>>
> >>> During the bisect some of the stopping points landed on commits that
> >>> caused the boot process to hang rather than cause a reboot.  The
> >>> commits that resulted in a hang are marked "git bisect skip" in this
> >>> log: https://gist.github.com/djbw/1b501daa98192a42ae848f03bb59c30e
> >>>
> >>> I'll try treating those hangs as bad bisect results and re-run the
> >>> full bisect tomorrow.  In the meantime I wonder if the bisect log
> >>> implicates a better regression candidate?
> >>
> >> Could you mail the dmesg output when booting a known working kernel
> >> with efi=debug ?
> >
> > Here it is:
> >
> > https://gist.github.com/djbw/cae05e721b159d5ad7b146d7a93f5fa2
> 
> I am able to build a kernel and boot the platform with the following
> set of reverts:
> 
>       Revert "x86/efi: Round EFI memmap reservations to EFI_PAGE_SIZE"
>       Revert "x86/efi-bgrt: Use efi_mem_reserve() to avoid copying image data"
>       Revert "efi/esrt: Use efi_mem_reserve() and avoid a kmalloc()"
>       Revert "efi: Allow drivers to reserve boot services forever"

Could you please describe the bootup behavior after each revert? I.e. wild guess:

       vanilla kernel:
   # spontaneous reboot
       + Revert "x86/efi: Round EFI memmap reservations to EFI_PAGE_SIZE":
   # spontaneous reboot
       + Revert "x86/efi-bgrt: Use efi_mem_reserve() to avoid copying image data":
   # hang
       + Revert "efi/esrt: Use efi_mem_reserve() and avoid a kmalloc()":
   # hang
       + Revert "efi: Allow drivers to reserve boot services forever":
   == works

?

Thanks,

	Ingo
