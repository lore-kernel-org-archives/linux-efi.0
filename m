From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 5/9] efi/arm*: libstub: Invoke EFI_RNG_PROTOCOL to seed
 the UEFI RNG table
Date: Mon, 14 Nov 2016 13:23:34 +0000
Message-ID: <20161114132334.GB2373@codeblueprint.co.uk>
References: <20161112213237.8804-1-matt@codeblueprint.co.uk>
 <20161112213237.8804-6-matt@codeblueprint.co.uk>
 <20161113071939.GA31483@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161113071939.GA31483@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 13 Nov, at 08:19:39AM, Ingo Molnar wrote:
> 
> * Matt Fleming <matt@codeblueprint.co.uk> wrote:
> 
> > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > 
> > Invoke the EFI_RNG_PROTOCOL protocol in the context of the stub and
> > install the Linux-specific RNG seed UEFI config table. This will be
> > picked up by the EFI routines in the core kernel to seed the kernel
> > entropy pool.
> > 
> > Cc: Matt Fleming <matt@codeblueprint.co.uk>
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> This commit (and the commits after this one) doesn't have a proper signoff chain, 
> probably due to rebasing?
 
Argh, my bad. This is fallout from moving to the co-maintainer model.
My scripts assume they don't need to append a SoB because that was
handled when applying the patch to the git tree.

But that obviously doesn't hold if Ard applies the patch to git, but I
mail out the patches as part of the pull request (or vice versa).

I guess in future you'd wanna see the SoB of the person mailing the
patches, right?

> I'll apply the patches from email and add your SOB.

Thanks.
