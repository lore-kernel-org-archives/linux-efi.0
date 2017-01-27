From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 1/4] efi/x86: make efi_memmap_reserve only insert into
 boot mem areas
Date: Fri, 27 Jan 2017 14:48:13 +0000
Message-ID: <20170127144813.GE31613@codeblueprint.co.uk>
References: <20170112094118.815108042@redhat.com>
 <20170112094214.860924858@redhat.com>
 <87r348r0k9.fsf@gmail.com>
 <20170112212952.GB2709@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170112212952.GB2709@dhcp-128-65.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: Nicolai Stange <nicstange@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com, Dan Williams <dan.j.williams@intel.com>, mika.penttila@nextfour.com, bhsharma@redhat.com
List-Id: linux-efi@vger.kernel.org

On Fri, 13 Jan, at 05:29:52AM, Dave Young wrote:
> 
> It sounds reasonable though I'm still not sure about EFI_LOADER*.
> 
> The main purpose of this patch is to address the invalid mem ranges
> case. As Ard mentioned I will test with Peter's patch first, if it works
> fine I would like to either drop this patch as a future improvement or add
> it at the end of the next post.
> 
> Matt, what's your opinion about the boot_only check and the EFI_LOADERS*
> question?

The main reason that efi_mem_reserve() isn't used for EFI_LOADER
regions today is because we already have a mechanism for reserving it
via memblock_reserve(), which we do during a very early stage of boot
when parsing all the different types of SETUP_* objects.

It's questionable whether it would make sense to switch to
efi_mem_reserve() for EFI_LOADER regions because then you'd
potentially have different APIs for different SETUP_* objects.

As things stand today, I would suggest triggering a WARN_ON() if
someone tries to efi_mem_reserve() an EFI_LOADER region, until/unless
the day comes when a user exists in the kernel.
