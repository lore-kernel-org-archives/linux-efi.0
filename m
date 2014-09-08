From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 1/1] arch/x86: Add better error logging to efi main
Date: Mon, 8 Sep 2014 22:18:56 +0100
Message-ID: <20140908211856.GC18582@console-pimps.org>
References: <20140906230251.140a99c9@bert>
 <20140907021133.7184c28c@bert>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140907021133.7184c28c@bert>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andre <andre.muller-S0/GAf8tV78@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ulf Winkelvos <ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 07 Sep, at 02:11:33AM, Andre wrote:
> On Sat, 6 Sep 2014 23:02:51 +0200
> Andre <andre.muller-S0/GAf8tV78@public.gmane.org> wrote:
> > With a Thinkpad T420 (pre-2.0 EFI), I do run into the failure condition for another reason:
> > 
> > setup_efi_pci64 gets called,
> > the loop therein is executed nr_pci=11 (!?) times.
> > The second call run calls into __setup_efi_pci64 successfully, the memcpy takes place; the free_struct: path is not used. Back in setup_efi_pci64, the non-data path is walked.
> > 
> > For all the other 10 runs of the loop, __setup_efi_pci64 fails at
> > if (!pci->romimage || !pci->romsize)
> >         return EFI_INVALID_PARAMETER;
> > so that is the status here for any run but the second.

Thanks for doing the analysis.
 
> Following up with code...
> 
> If it is OK to just leave the loop in setup_efi_pci64,
> this can be done simply by
> 
> --- arch/x86/boot/compressed/eboot.c	2014-09-07 01:54:41.761008645 +0200
> +++ arch/x86/boot/compressed/eboot_break.c	2014-09-07 01:52:06.321004951 +0200
> @@ -504,6 +504,7 @@
>  			params->hdr.setup_data = (unsigned long)rom;
>  
>  		data = (struct setup_data *)rom;
> +		break;
>  
>  	}
>  
> But I've got severe doubts about this.
 
Right, we can't do this because we want to add all the PCI devices that
we can find with EFI, not just the first one.

> A solution limited to this particular failure mode
> could look like the below. It has all the charm of 
> introducing a helper var. Hmpf.
> 
> --- arch/x86/boot/compressed/eboot.c	2014-09-07 01:54:41.761008645 +0200
> +++ arch/x86/boot/compressed/eboot_preserve.c	2014-09-07 01:56:18.529010945 +0200
> @@ -474,6 +474,7 @@
>  	unsigned long nr_pci;
>  	struct setup_data *data;
>  	int i;
> +	int setup_pci_worked_once = 0;
>  
>  	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
>  
> @@ -495,7 +496,13 @@
>  			continue;
>  
>  		status = __setup_efi_pci64(pci, &rom);
> -		if (status != EFI_SUCCESS)
> +		if (status == EFI_SUCCESS)
> +			setup_pci_worked_once = 1;
> +		else if (status == EFI_INVALID_PARAMETER && setup_pci_worked_once == 1 && i == nr_pci - 1) {
> +			status = EFI_SUCCESS;
> +			continue;
> +		}
> +		else if (status != EFI_SUCCESS)
>  			continue;
>  
>  		if (data)

The code is generally fine as-is. Where I think we could improve things
is by adding efi_printk() message in certain error paths. Clearly, not
all error paths need such messages, e.g. the EFI_INVALID_PARAMETER path
you highlighted above, but it makes sense for memory allocation and PCI
read failures.

Care to take a whack at that?

-- 
Matt Fleming, Intel Open Source Technology Center
