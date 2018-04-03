From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] x86/xen/efi: Initialize UEFI secure boot state
 during dom0 boot
Date: Tue, 03 Apr 2018 10:00:52 -0700
Message-ID: <1522774852.4522.25.camel@HansenPartnership.com>
References: <1522766345-4169-1-git-send-email-daniel.kiper@oracle.com>
         <1522770281.4522.14.camel@HansenPartnership.com>
         <20180403160712.GL26100@olila.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180403160712.GL26100@olila.local.net-space.pl>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org, ard.biesheuvel@linaro.org, boris.ostrovsky@oracle.com, eric.snowberg@oracle.com, hpa@zytor.com, jgross@suse.com, konrad.wilk@oracle.com, mingo@redhat.com, tglx@linutronix.de
List-Id: linux-efi@vger.kernel.org

On Tue, 2018-04-03 at 18:07 +0200, Daniel Kiper wrote:
> On Tue, Apr 03, 2018 at 08:44:41AM -0700, James Bottomley wrote:
> > 
> > On Tue, 2018-04-03 at 16:39 +0200, Daniel Kiper wrote:
> > > 
> > > Initialize UEFI secure boot state during dom0 boot. Otherwise the
> > > kernel may not even know that it runs on secure boot enabled
> > > platform.
> > > 
> > > Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> > > ---
> > >  arch/x86/xen/efi.c                        |   57
> > > +++++++++++++++++++++++++++++
> > >  drivers/firmware/efi/libstub/secureboot.c |    3 ++
> > >  2 files changed, 60 insertions(+)
> > > 
> > > diff --git a/arch/x86/xen/efi.c b/arch/x86/xen/efi.c
> > > index a18703b..1804b27 100644
> > > --- a/arch/x86/xen/efi.c
> > > +++ b/arch/x86/xen/efi.c
> > > @@ -115,6 +115,61 @@ static efi_system_table_t __init
> > > *xen_efi_probe(void)
> > >  	return &efi_systab_xen;
> > >  }
> > >  
> > > +/*
> > > + * Determine whether we're in secure boot mode.
> > > + *
> > > + * Please keep the logic in sync with
> > > + *
> > > drivers/firmware/efi/libstub/secureboot.c:efi_get_secureboot().
> > > + */
> > > +static enum efi_secureboot_mode xen_efi_get_secureboot(void)
> > > +{
> > > +	static efi_guid_t efi_variable_guid =
> > > EFI_GLOBAL_VARIABLE_GUID;
> > > +	static efi_guid_t shim_guid = EFI_SHIM_LOCK_GUID;
> > > +	efi_status_t status;
> > > +	u8 moksbstate, secboot, setupmode;
> > > +	unsigned long size;
> > > +
> > > +	size = sizeof(secboot);
> > > +	status = efi.get_variable(L"SecureBoot",
> > > &efi_variable_guid,
> > > +				  NULL, &size, &secboot);
> > > +
> > > +	if (status == EFI_NOT_FOUND)
> > > +		return efi_secureboot_mode_disabled;
> > > +
> > > +	if (status != EFI_SUCCESS)
> > > +		goto out_efi_err;
> > > +
> > > +	size = sizeof(setupmode);
> > > +	status = efi.get_variable(L"SetupMode",
> > > &efi_variable_guid,
> > > +				  NULL, &size, &setupmode);
> > > +
> > > +	if (status != EFI_SUCCESS)
> > > +		goto out_efi_err;
> > > +
> > > +	if (secboot == 0 || setupmode == 1)
> > > +		return efi_secureboot_mode_disabled;
> > > +
> > > +	/* See if a user has put the shim into insecure mode. */
> > > +	size = sizeof(moksbstate);
> > > +	status = efi.get_variable(L"MokSBStateRT", &shim_guid,
> > > +				  NULL, &size, &moksbstate);
> > > +
> > > +	/* If it fails, we don't care why. Default to secure. */
> > > +	if (status != EFI_SUCCESS)
> > > +		goto secure_boot_enabled;
> > > +
> > > +	if (moksbstate == 1)
> > > +		return efi_secureboot_mode_disabled;
> > > +
> > > + secure_boot_enabled:
> > > +	pr_info("UEFI Secure Boot is enabled.\n");
> > > +	return efi_secureboot_mode_enabled;
> > > +
> > > + out_efi_err:
> > > +	pr_err("Could not determine UEFI Secure Boot
> > > status.\n");
> > > +	return efi_secureboot_mode_unknown;
> > > +}
> > > +
> > 
> > This looks like a bad idea: you're duplicating the secure boot
> > check in
> > 
> > drivers/firmware/efi/libstub/secureboot.c
> > 
> > Which is an implementation of policy.  If we have to have policy in
> > the kernel, it should really only be in one place to prevent drift;
> > why can't you simply use the libstub efi_get_secureboot() so we're
> > not duplicating the implementation of policy?
> 
> Well, here is the first version of this patch:
> https://lkml.org/lkml/2018/1/9/496 Ard did not like it. I was not
> happy too. In general both approaches are not perfect. More you can
> find in the discussion around this patchset. If you have better idea
> how to do that I am happy to implement it.

One way might be simply to have the pre exit-boot-services code lay
down a variable containing the state which you pick up, rather than you
calling efi code separately and trying to use the insecure RT
variables.  That way there's a uniform view of the internal kernel
secure boot state that everyone can use.

James
