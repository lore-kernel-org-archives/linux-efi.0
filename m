From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [GIT PULL] EFI changes for v3.18
Date: Mon, 29 Sep 2014 15:07:23 +0100
Message-ID: <20140929140723.GA4788@console-pimps.org>
References: <20140928202702.GB18635@console-pimps.org>
 <20140929124321.GB18825@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140929124321.GB18825@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 29 Sep, at 02:43:21PM, Ingo Molnar wrote:
> 
> * Matt Fleming <matt@console-pimps.org> wrote:
> 
> >  * Implement new EFI runtime lock which is required by the UEFI
> >    specification - Ard Biesheuvel
> 
> Firstly, under what circumstances can EFI call parallelism happen 
> currently? Most of the EFI code runs during early bootup, which 
> is serialized.
 
Access to EFI variables needs to be serialized against each other, which
we currently do with the __efivars->lock spinlock and the accessor
functions in drivers/firmware/efi/vars.c. Additionally on arm64, access
to the EFI time functions needs to be serialized with access to the
variable functions (we don't use the time stuff on x86).

> Secondly, this locking pattern looks pretty disgusting:
> 
> @@ -94,7 +187,17 @@ static efi_status_t virt_efi_set_variable(efi_char16_t *name,
>                                           unsigned long data_size,
>                                           void *data)
>  {
> -       return efi_call_virt(set_variable, name, vendor, attr, data_size, data);
> +       unsigned long flags;
> +       efi_status_t status;
> +       bool __in_nmi = efi_in_nmi();
> +
> +       if (!__in_nmi)
> +               spin_lock_irqsave(&efi_runtime_lock, flags);
> +       status = efi_call_virt(set_variable, name, vendor, attr, data_size,
> +                              data);
> +       if (!__in_nmi)
> +               spin_unlock_irqrestore(&efi_runtime_lock, flags);
> +       return status;
>  }
> 
> and that's repeated in virt_efi_query_variable_info() as well.
> 
> and that's the explanation given:
> 
> +/*
> + * Some runtime services calls can be reentrant under NMI, even if the table
> + * above says they are not. (source: UEFI Specification v2.4A)
> + *
> + * Table 32. Functions that may be called after Machine Check, INIT and NMI
> + * 
> +----------------------------+------------------------------------------+
> + * | Function                  | Called after Machine Check, INIT and NMI |
> + * 
> +----------------------------+------------------------------------------+
> + * | GetTime()                 | Yes, even if previously busy.            |
> + * | GetVariable()             | Yes, even if previously busy             |
> + * | GetNextVariableName()     | Yes, even if previously busy             |
> + * | QueryVariableInfo()       | Yes, even if previously busy             |
> + * | SetVariable()             | Yes, even if previously busy             |
> + * | UpdateCapsule()           | Yes, even if previously busy             |
> + * | QueryCapsuleCapabilities()| Yes, even if previously busy             |
> + * | ResetSystem()             | Yes, even if previously busy             |
> + * 
> +----------------------------+------------------------------------------+
> + *
> + * In order to prevent deadlocks under NMI, the wrappers for these functions
> + * may only grab the efi_runtime_lock or rtc_lock spinlocks if !efi_in_nmi().
> + * However, not all of the services listed are reachable through NMI code paths,
> + * so the the special handling as suggested by the UEFI spec is only implemented
> + * for QueryVariableInfo() and SetVariable(), as these can be reached in NMI
> + * context through efi_pstore_write().
> 
> Are pstore calls into the EFI runtime reentrant?

Yes, the pstore functions are reentrant in the case of being invoked
from the kmsg_dumper callback via pstore_dump(), which for the EFI
pstore backend means we call efi_pstore_write() -> efi_entry_set_safe().

-- 
Matt Fleming, Intel Open Source Technology Center
