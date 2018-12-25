From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] x86/efi: Don't unmap EFI boot services code/data regions
 for EFI_OLD_MEMMAP and EFI_MIXED_MODE
Date: Tue, 25 Dec 2018 10:51:07 +0100
Message-ID: <20181225095107.GA100072@gmail.com>
References: <20181222022234.7573-1-sai.praneeth.prakhya@intel.com>
 <20181222105410.GA130780@gmail.com>
 <CAKv+Gu93dgfXsq_sRzvXBw-h=8pn2BtrQLtpwtjK51potpOtdg@mail.gmail.com>
 <FFF73D592F13FD46B8700F0A279B802F4860813C@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <FFF73D592F13FD46B8700F0A279B802F4860813C@ORSMSX114.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-efi@vger.kernel.org


* Prakhya, Sai Praneeth <sai.praneeth.prakhya@intel.com> wrote:

> > > > +     /*
> > > > +      * To Do: Remove this check after adding functionality to unmap EFI
> > boot
> > > > +      * services code/data regions from direct mapping area because
> > > > +      * "efi=old_map" maps EFI regions in swapper_pg_dir.
> > > > +      */
> > > > +     if (efi_enabled(EFI_OLD_MEMMAP))
> > > > +             return;
> > > > +
> > > > +     /*
> > > > +      * EFI mixed mode has all RAM mapped to access arguments while
> > making
> > > > +      * EFI runtime calls, hence don't unmap EFI boot services code/data
> > > > +      * regions.
> > > > +      */
> > > > +     if (!efi_is_native() && IS_ENABLED(CONFIG_EFI_MIXED))
> > 
> > AFAIK efi_is_native() can only return false is CONFIG_EFI_MIXED is set, so this
> > expression can be simplified.
> 
> Makes sense.
> efi_is_native() returns true for 32-bit machines running 32-bit firmware.

Forgot to mention that I performed this simplification in the commit I 
applied:

+       /*
+        * To Do: Remove this check after adding functionality to unmap EFI boot
+        * services code/data regions from direct mapping area because
+        * "efi=old_map" maps EFI regions in swapper_pg_dir.
+        */
+       if (efi_enabled(EFI_OLD_MEMMAP))
+               return;
+
+       /*
+        * EFI mixed mode has all RAM mapped to access arguments while making
+        * EFI runtime calls, hence don't unmap EFI boot services code/data
+        * regions.
+        */
+       if (!efi_is_native())
+               return;

Thanks,

	Ingo
