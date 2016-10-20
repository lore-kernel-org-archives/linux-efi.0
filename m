From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: 4.9-rc1 boot regression, ambiguous bisect result
Date: Thu, 20 Oct 2016 13:29:31 +0100
Message-ID: <20161020122931.GD19876@codeblueprint.co.uk>
References: <CAPcyv4gDYcahNJ6CEzf2eUGq8sGqW8Yo09T8cscGWTLoja7PXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4gDYcahNJ6CEzf2eUGq8sGqW8Yo09T8cscGWTLoja7PXw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Peter Jones <pjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ingo Molnar <mingo@kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 19 Oct, at 09:04:29PM, Dan Williams wrote:
> Hi,
> 
> I am currently unable to boot a Yoga 900 with latest mainline, but 4.8 boots.
> 
> The symptom is a reboot before the video console is available.
> 
> I bisected to commit 816e76129ed5 "efi: Allow drivers to reserve boot
> services forever".  However, that commit is known to be broken.  The
> proposed fix, commit 92dc33501bfb "x86/efi: Round EFI memmap
> reservations to EFI_PAGE_SIZE", also exhibits the reboot problem.
> 
> During the bisect some of the stopping points landed on commits that
> caused the boot process to hang rather than cause a reboot.  The
> commits that resulted in a hang are marked "git bisect skip" in this
> log: https://gist.github.com/djbw/1b501daa98192a42ae848f03bb59c30e
> 
> I'll try treating those hangs as bad bisect results and re-run the
> full bisect tomorrow.  In the meantime I wonder if the bisect log
> implicates a better regression candidate?

Could you mail the dmesg output when booting a known working kernel
with efi=debug ?
