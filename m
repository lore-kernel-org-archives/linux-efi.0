From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/8] efi/x86: Use non-blocking SetVariable() for
 efi_delete_dummy_variable()
Date: Mon, 16 Jul 2018 03:02:19 +0200
Message-ID: <20180716010219.GA13742@gmail.com>
References: <20180711094040.12506-1-ard.biesheuvel@linaro.org>
 <20180711094040.12506-3-ard.biesheuvel@linaro.org>
 <20180715223808.GB16209@gmail.com>
 <FFF73D592F13FD46B8700F0A279B802F46A3F83A@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <FFF73D592F13FD46B8700F0A279B802F46A3F83A@ORSMSX114.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org


* Prakhya, Sai Praneeth <sai.praneeth.prakhya@intel.com> wrote:

> > > diff --git a/arch/x86/platform/efi/quirks.c
> > > b/arch/x86/platform/efi/quirks.c index 36c1f8b9f7e0..6af39dc40325
> > > 100644
> > > --- a/arch/x86/platform/efi/quirks.c
> > > +++ b/arch/x86/platform/efi/quirks.c
> > > @@ -105,12 +105,11 @@ early_param("efi_no_storage_paranoia",
> > > setup_storage_paranoia);  */  void efi_delete_dummy_variable(void)  {
> > > -	efi.set_variable((efi_char16_t *)efi_dummy_name,
> > > -			 &EFI_DUMMY_GUID,
> > > -			 EFI_VARIABLE_NON_VOLATILE |
> > > -			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
> > > -			 EFI_VARIABLE_RUNTIME_ACCESS,
> > > -			 0, NULL);
> > > +	efi.set_variable_nonblocking((efi_char16_t *)efi_dummy_name,
> > > +				     &EFI_DUMMY_GUID,
> > > +				     EFI_VARIABLE_NON_VOLATILE |
> > > +				     EFI_VARIABLE_BOOTSERVICE_ACCESS |
> > > +				     EFI_VARIABLE_RUNTIME_ACCESS, 0, NULL);
> > >  }
> > 
> > Just wondering, what is the full stack trace of the splat? It sounds a bit surprising
> > to me that such type of EFI code is used from the idle thread.
> 
> Sorry! for the confusing commit message. Kernel warns about scheduling from idle 
> thread only when "efi_rts_wq" is used to invoke efi_runtime_services(). So, 
> presently, this doesn't happen on mainline kernel. Support for "efi_rts_wq" is 
> added by commit 3eb420e70d87 (efi: Use a work queue to invoke EFI Runtime 
> Services).

Ok, that makes a lot more sense!

Thanks,

	Ingo
