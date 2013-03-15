From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: EFI: Stash ROMs if they're not in the PCI BAR
Date: Fri, 15 Mar 2013 11:29:28 +0300
Message-ID: <20130315082928.GA14520@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hello Matthew Garrett,

The patch dd5fc854de5f: "EFI: Stash ROMs if they're not in the PCI 
BAR" from Dec 5, 2012, leads to the following warning:
"arch/x86/boot/compressed/eboot.c:290 setup_efi_pci()
	 error: potentially dereferencing uninitialized 'pci_handle'."

  254  static efi_status_t setup_efi_pci(struct boot_params *params)
  255  {
  256          efi_pci_io_protocol *pci;
  257          efi_status_t status;
  258          void **pci_handle;
  259          efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
  260          unsigned long nr_pci, size = 0;
  261          int i;
  262          struct setup_data *data;
  263  
  264          data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
  265  
  266          while (data && data->next)
  267                  data = (struct setup_data *)(unsigned long)data->next;
  268  
  269          status = efi_call_phys5(sys_table->boottime->locate_handle,
  270                                  EFI_LOCATE_BY_PROTOCOL, &pci_proto,
  271                                  NULL, &size, pci_handle);
                                                    ^^^^^^^^^^
This hasn't been initialized yet.

  272  
  273          if (status == EFI_BUFFER_TOO_SMALL) {
  274                  status = efi_call_phys3(sys_table->boottime->allocate_pool,
  275                                          EFI_LOADER_DATA, size, &pci_handle);
  276  

regards,
dan carpenter
