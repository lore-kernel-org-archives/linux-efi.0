From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: EFI stub boots only with setup_efi_pc() commented
Date: Mon, 16 Sep 2013 12:58:55 +0100
Message-ID: <20130916115855.GC2697@console-pimps.org>
References: <CA+n4xYYJhoXp6KSeROda9ErrXZ0hFEBM-x-0Obvk3fmHwABfKw@mail.gmail.com>
 <20130905082924.GI28598@console-pimps.org>
 <CA+n4xYZq3wpY_j+w7BKJ1hV8s1=K-xqqYucZen8os7O_g71gSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+n4xYZq3wpY_j+w7BKJ1hV8s1=K-xqqYucZen8os7O_g71gSg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Clea F. Rees" <reescf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 09 Sep, at 12:45:00PM, Clea F. Rees wrote:
> 2013/9/5 Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>:
> >
> > Sorry for the delay in replying to this.
> >
> > Does your machine hang during setup_efi_pci() or later on in boot?
> 
> I'm not certain. How would I tell this? I think the answer is probably
> during because the tests Matt had me do involved inserting reboot
> instructions into the code and testing where the hang occurred. But
> I'm not sure whether that showed absolutely that the hang occurs
> actually during setup_efi_pci().

Could you try the attached patch and let me know what you observe?

---

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index b7388a4..f4a966d 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -261,30 +261,37 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 	int i;
 	struct setup_data *data;
 
+	efi_printk("1\n");
 	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
 
 	while (data && data->next)
 		data = (struct setup_data *)(unsigned long)data->next;
 
+	efi_printk("2\n");
 	status = efi_call_phys5(sys_table->boottime->locate_handle,
 				EFI_LOCATE_BY_PROTOCOL, &pci_proto,
 				NULL, &size, pci_handle);
 
+	efi_printk("3\n");
 	if (status == EFI_BUFFER_TOO_SMALL) {
 		status = efi_call_phys3(sys_table->boottime->allocate_pool,
 					EFI_LOADER_DATA, size, &pci_handle);
 
+		efi_printk("4\n");
 		if (status != EFI_SUCCESS)
 			return status;
 
+		efi_printk("5\n");
 		status = efi_call_phys5(sys_table->boottime->locate_handle,
 					EFI_LOCATE_BY_PROTOCOL, &pci_proto,
 					NULL, &size, pci_handle);
+		efi_printk("6\n");
 	}
 
 	if (status != EFI_SUCCESS)
 		goto free_handle;
 
+	efi_printk("7\n");
 	nr_pci = size / sizeof(void *);
 	for (i = 0; i < nr_pci; i++) {
 		void *h = pci_handle[i];
@@ -297,13 +304,16 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 		if (status != EFI_SUCCESS)
 			continue;
 
+		efi_printk("8\n");
 		if (!pci)
 			continue;
 
+		efi_printk("9\n");
 #ifdef CONFIG_X86_64
 		status = efi_call_phys4(pci->attributes, pci,
 					EfiPciIoAttributeOperationGet, 0,
 					&attributes);
+		efi_printk("10\n");
 #else
 		status = efi_call_phys5(pci->attributes, pci,
 					EfiPciIoAttributeOperationGet, 0, 0,
@@ -312,43 +322,54 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 		if (status != EFI_SUCCESS)
 			continue;
 
+		efi_printk("11\n");
 		if (!pci->romimage || !pci->romsize)
 			continue;
 
+		efi_printk("12\n");
 		size = pci->romsize + sizeof(*rom);
 
 		status = efi_call_phys3(sys_table->boottime->allocate_pool,
 				EFI_LOADER_DATA, size, &rom);
 
+		efi_printk("13\n");
 		if (status != EFI_SUCCESS)
 			continue;
 
+		efi_printk("14\n");
 		rom->data.type = SETUP_PCI;
 		rom->data.len = size - sizeof(struct setup_data);
 		rom->data.next = 0;
 		rom->pcilen = pci->romsize;
 
+		efi_printk("15\n");
 		status = efi_call_phys5(pci->pci.read, pci,
 					EfiPciIoWidthUint16, PCI_VENDOR_ID,
 					1, &(rom->vendor));
+		efi_printk("16\n");
 
 		if (status != EFI_SUCCESS)
 			goto free_struct;
 
+		efi_printk("17\n");
 		status = efi_call_phys5(pci->pci.read, pci,
 					EfiPciIoWidthUint16, PCI_DEVICE_ID,
 					1, &(rom->devid));
 
+		efi_printk("18\n");
 		if (status != EFI_SUCCESS)
 			goto free_struct;
 
+		efi_printk("19\n");
 		status = efi_call_phys5(pci->get_location, pci,
 					&(rom->segment), &(rom->bus),
 					&(rom->device), &(rom->function));
 
+		efi_printk("20\n");
 		if (status != EFI_SUCCESS)
 			goto free_struct;
 
+		efi_printk("21\n");
 		memcpy(rom->romdata, pci->romimage, pci->romsize);
 
 		if (data)
@@ -358,13 +379,18 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 
 		data = (struct setup_data *)rom;
 
+		efi_printk("22\n");
 		continue;
 	free_struct:
+		efi_printk("23\n");
 		efi_call_phys1(sys_table->boottime->free_pool, rom);
+		efi_printk("24\n");
 	}
 
 free_handle:
+	efi_printk("25\n");
 	efi_call_phys1(sys_table->boottime->free_pool, pci_handle);
+	efi_printk("26\n");
 	return status;
 }
 
-- 
Matt Fleming, Intel Open Source Technology Center
