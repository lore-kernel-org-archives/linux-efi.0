From: Andre <andre.muller-S0/GAf8tV78@public.gmane.org>
Subject: Re: [PATCH 1/1] arch/x86: Add better error logging to efi main
Date: Wed, 10 Sep 2014 00:54:36 +0200
Message-ID: <20140910005436.3e111c23@bert>
References: <20140906230251.140a99c9@bert>
	<20140907021133.7184c28c@bert>
	<20140908211856.GC18582@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140908211856.GC18582-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ulf Winkelvos <ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 8 Sep 2014 22:18:56 +0100 Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Sun, 07 Sep, at 02:11:33AM, Andre wrote:
> > On Sat, 6 Sep 2014 23:02:51 +0200
> > Andre <andre.muller-S0/GAf8tV78@public.gmane.org> wrote:
> > > With a Thinkpad T420 (pre-2.0 EFI), I do run into the failure condition for another reason:
> > > 
> > > setup_efi_pci64 gets called,
> > > the loop therein is executed nr_pci=11 (!?) times.
> > > The second call run calls into __setup_efi_pci64 successfully, the memcpy takes place; the free_struct: path is not used. Back in setup_efi_pci64, the non-data path is walked.
> > > 
> > > For all the other 10 runs of the loop, __setup_efi_pci64 fails at
> > > if (!pci->romimage || !pci->romsize)
> > >         return EFI_INVALID_PARAMETER;
> > > so that is the status here for any run but the second.
> 
> Thanks for doing the analysis.
>  
> > Following up with code...
> > 
> > If it is OK to just leave the loop in setup_efi_pci64,
> > this can be done simply by
> > 
> > --- arch/x86/boot/compressed/eboot.c	2014-09-07 01:54:41.761008645 +0200
> > +++ arch/x86/boot/compressed/eboot_break.c	2014-09-07 01:52:06.321004951 +0200
> > @@ -504,6 +504,7 @@
> >  			params->hdr.setup_data = (unsigned long)rom;
> >  
> >  		data = (struct setup_data *)rom;
> > +		break;
> >  
> >  	}
> >  
> > But I've got severe doubts about this.
>  
> Right, we can't do this because we want to add all the PCI devices that
> we can find with EFI, not just the first one.
> 

Yes, I expected that to be by design, 
but I'm basically clueless as to the big picture.

> > A solution limited to this particular failure mode
> > could look like the below. It has all the charm of 
> > introducing a helper var. Hmpf.
[Embarrassing Code]
> 
> The code is generally fine as-is. 

Thanks, but no it's not, it's too ugly to live; a severe case of debugging stupor. That code should rather look like this:


--- arch/x86/boot/compressed/eboot.c	2014-09-07 10:37:47.686001561 +0200
+++ arch/x86/boot/compressed/eboot.c	2014-09-07 11:31:38.233078339 +0200
@@ -474,6 +474,7 @@
 	unsigned long nr_pci;
 	struct setup_data *data;
 	int i;
+	int setup_pci_worked_once = 0;
 
 	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
 
@@ -498,6 +499,8 @@
 		if (status != EFI_SUCCESS)
 			continue;
 
+		setup_pci_worked_once = 1;
+
 		if (data)
 			data->next = (unsigned long)rom;
 		else
@@ -507,6 +510,8 @@
 
 	}
 
+	if (status == EFI_INVALID_PARAMETER && setup_pci_worked_once == 1)
+		status = EFI_SUCCESS;
 	return status;
 }
 

> Where I think we could improve things
> is by adding efi_printk() message in certain error paths. Clearly, not
> all error paths need such messages, e.g. the EFI_INVALID_PARAMETER path
> you highlighted above, but it makes sense for memory allocation and PCI
> read failures.
> 
> Care to take a whack at that?

I gave it a try, will post as a follow-up. The patch adds printks to 
non-success conditions for all pci.read instances and all allocate_pool 
instances within the scope of setup_efi_pci(). 

There are two calls left in the setup_graphics path, one for gop and one 
for uga. Does it make sense to add printks there as well? They won't 
display properly, I guess :-) Also, uga is called as a fallback when 
gop fails. So the uga failure would be the lost final straw to be noisy 
about? 

One more question: In the patch above, I added a helper to print a 
failure only if the __setup_efi_pci64() never succeeded. That's not 
really needed, is it? Because then, the check for setup_efi_pci success, 
the overly noisy bit of Ulf's patch, could go away again, and both your 
and my EFI_SUCCESS tweaks are not needed anymore. 

Thursday ff, I will be offline for a week. I'll happily follow up 
afterwards, but also feel free to run with the bits you see fit.

Regards,
Andre
