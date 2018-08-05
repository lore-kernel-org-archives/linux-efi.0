From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/6][RFC] Add EFI secure key to key retention service
Date: Sun, 05 Aug 2018 10:47:26 -0700
Message-ID: <1533491246.4087.1.camel@HansenPartnership.com>
References: <20180805032119.20485-1-jlee@suse.com>
         <CAKv+Gu81vEGNggcWv1NyPJsMeK0HRi_DanH2+Z_4metoNG=txA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu81vEGNggcWv1NyPJsMeK0HRi_DanH2+Z_4metoNG=txA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, keyrings@vger.kernel.org, linux-integrity <linux-integrity@vger.kernel.org>, "Lee, Chun-Yi" <jlee@suse.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Pavel Machek <pavel@ucw.cz>, Chen Yu <yu.c.chen@intel.com>, Oliver Neukum <oneukum@suse.com>, Ryan Chen <yu.chen.surf@gmail.com>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>
List-Id: linux-efi@vger.kernel.org

On Sun, 2018-08-05 at 09:25 +0200, Ard Biesheuvel wrote:
> Hello Chun,yi,
> 
> On 5 August 2018 at 05:21, Lee, Chun-Yi <joeyli.kernel@gmail.com>
> wrote:
> > When secure boot is enabled, only signed EFI binary can access
> > EFI boot service variable before ExitBootService. Which means that
> > the EFI boot service variable is secure.
> > 
> 
> No it, isn't, and this is a very dangerous assumption to make.
> 
> 'Secure' means different things to different people. 'Secure boot' is
> a misnomer, since it is too vague: it should be called 'authenticated
> boot', and the catch is that authentication using public-key crypto
> does not involve secrets at all.

Hang on, let's not throw the baby out with the bathwater here.

The design of "secure boot" is to create a boot time environment where
only trusted code may execute.  We rely on this trust guarantee when we
pivot from the EFI to the MoK root of trust in shim.

The reason we in Linux trust this guarantee is that it pertains to the
boot environment only, so any violation would allow Windows boot to be
compromised as well and we trust Microsoft's Business interests in
securing windows far enough to think this would be dealt with very
severely and it's an outcome the ODMs (who also add secure boot keys)
are worried enough about to be very careful.

The rub (and this is where I'm agreeing with Ard) is that any use case
we come up with where a violation wouldn't cause a problem in windows
is a use case where we cannot rely on the guarantee because Microsoft
no longer has a strong business interest in policing it.  This, for
instance, is why we don't populate the Linux trusted keyrings with the
secure boot keys (we may trust them in the boot environment where
compromise would be shared with windows but we can't trust them in the
Linux OS environment where it wouldn't).  So this means we have to be
very careful coming up with uses for secure boot that aren't strictly
rooted in the guarantee as enforced by the business interests of
Microsoft and the ODMs.

>  The UEFI variable store was not designed with confidentiality in
> mind, and assuming [given the reputation of EFI on the implementation
> side] that you can use it to keep secrets is rather unwise imho.

Agree completely here: Microsoft doesn't use UEFI variables for
confidentiality, so we shouldn't either.  If you want confidentiality,
use a TPM (like Microsoft does for the bitlocker key).

James
