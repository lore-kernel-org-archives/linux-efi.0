From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: EFI: Stash ROMs if they're not in the PCI BAR
Date: Mon, 18 Mar 2013 11:36:03 +0000
Message-ID: <1363606563.15011.333.camel@mfleming-mobl1.ger.corp.intel.com>
References: <20130315082928.GA14520@longonot.mountain>
	 <1363337872.2444.9.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363337872.2444.9.camel-Fexsq3y4057IgHVZqg5X0TlWvGAXklZc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 2013-03-15 at 08:57 +0000, David Woodhouse wrote:
> On Fri, 2013-03-15 at 11:29 +0300, Dan Carpenter wrote:
> > Hello Matthew Garrett,
> > 
> > The patch dd5fc854de5f: "EFI: Stash ROMs if they're not in the PCI 
> > BAR" from Dec 5, 2012, leads to the following warning:
> > "arch/x86/boot/compressed/eboot.c:290 setup_efi_pci()
> > 	 error: potentially dereferencing uninitialized 'pci_handle'."
> > 
> >   254  static efi_status_t setup_efi_pci(struct boot_params *params)
> >   255  {
> >   256          efi_pci_io_protocol *pci;
> >   257          efi_status_t status;
> >   258          void **pci_handle;
> >   259          efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
> >   260          unsigned long nr_pci, size = 0;
> >   261          int i;
> >   262          struct setup_data *data;
> >   263  
> >   264          data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
> >   265  
> >   266          while (data && data->next)
> >   267                  data = (struct setup_data *)(unsigned long)data->next;
> >   268  
> >   269          status = efi_call_phys5(sys_table->boottime->locate_handle,
> >   270                                  EFI_LOCATE_BY_PROTOCOL, &pci_proto,
> >   271                                  NULL, &size, pci_handle);
> >                                                     ^^^^^^^^^^
> > This hasn't been initialized yet.
> 
> True. It probably doesn't *matter* because the size is zero so the
> firmware is just going to ignore the pointer anyway. Although in that
> case I wonder why we couldn't have just passed NULL. Perhaps we expected
> that some firmware might do some validation on the pointer before
> getting to the size check?

I doubt that the firmware checks the validity of pci_handle when size is
zero, and I agree it's worth passing NULL to silence the warning (which
is also more explicit that just initialising pci_handle), unless Matthew
knows of a reason we shouldn't do that?

-- 
Matt Fleming, Intel Open Source Technology Center
