From: Omar Sandoval <osandov@osandov.com>
Subject: Re: kexec regression since 4.9 caused by efi
Date: Thu, 9 Mar 2017 01:54:08 -0800
Message-ID: <20170309095408.GA17883@vader>
References: <20170308201616.GC8598@vader>
 <20170309063806.GB17257@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="3MwIy2ne0vdjdPXF"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170309063806.GB17257@dhcp-128-65.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, kernel-team@fb.com, kexec@lists.infradead.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 09, 2017 at 02:38:06PM +0800, Dave Young wrote:
> Add efi/kexec list.
> 
> On 03/08/17 at 12:16pm, Omar Sandoval wrote:

[snip]

> I have no more clue yet from your provided log, but the runtime value is
> odd to me. It is set in below code:
> 
> arch/x86/platform/efi/efi.c: efi_systab_init()
> 	efi_systab.runtime = data ?
> 			     (void *)(unsigned long)data->runtime :
> 			     (void *)(unsigne long)systab64->runtime;
> 
> Here data is the setup_data passed by kexec-tools from normal kernel to
> kexec kernel, efi_setup_data structure is like below: 
> struct efi_setup_data {
>         u64 fw_vendor;
>         u64 runtime;
>         u64 tables;
>         u64 smbios;
>         u64 reserved[8];
> };
> 
> kexec-tools get the runtime address from /sys/firmware/efi/runtime
> 
> So can you do some debuggin on your side, eg. see the sysfs runtime
> value is correct or not. And add some printk in efi init path etc.

The attached patch fixes this for me.

--3MwIy2ne0vdjdPXF
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-efi-adjust-virt_addr-when-splitting-descriptors-in-e.patch"

>From 4b343f0b0b408469f28c973ea52877797a166313 Mon Sep 17 00:00:00 2001
Message-Id: <4b343f0b0b408469f28c973ea52877797a166313.1489053164.git.osandov@fb.com>
From: Omar Sandoval <osandov@fb.com>
Date: Thu, 9 Mar 2017 01:46:19 -0800
Subject: [PATCH] efi: adjust virt_addr when splitting descriptors in
 efi_memmap_insert()

When we split efi memory descriptors, we adjust the physical address but
not the virtual address it maps to. This leads to bogus memory mappings
later when these virtual addresses are used.

This fixes a kexec boot regression since 8e80632fb23f ("efi/esrt: Use
efi_mem_reserve() and avoid a kmalloc()"), although the bug was only
exposed by that commit.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 drivers/firmware/efi/memmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/firmware/efi/memmap.c b/drivers/firmware/efi/memmap.c
index 78686443cb37..ca614db76faf 100644
--- a/drivers/firmware/efi/memmap.c
+++ b/drivers/firmware/efi/memmap.c
@@ -298,6 +298,7 @@ void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
 			memcpy(new, old, old_memmap->desc_size);
 			md = new;
 			md->phys_addr = m_end + 1;
+			md->virt_addr += md->phys_addr - start;
 			md->num_pages = (end - md->phys_addr + 1) >>
 				EFI_PAGE_SHIFT;
 		}
@@ -312,6 +313,7 @@ void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
 			md = new;
 			md->attribute |= m_attr;
 			md->phys_addr = m_start;
+			md->virt_addr += md->phys_addr - start;
 			md->num_pages = (m_end - m_start + 1) >>
 				EFI_PAGE_SHIFT;
 			/* last part */
@@ -319,6 +321,7 @@ void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
 			memcpy(new, old, old_memmap->desc_size);
 			md = new;
 			md->phys_addr = m_end + 1;
+			md->virt_addr += md->phys_addr - start;
 			md->num_pages = (end - m_end) >>
 				EFI_PAGE_SHIFT;
 		}
@@ -333,6 +336,7 @@ void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
 			memcpy(new, old, old_memmap->desc_size);
 			md = new;
 			md->phys_addr = m_start;
+			md->virt_addr += md->phys_addr - start;
 			md->num_pages = (end - md->phys_addr + 1) >>
 				EFI_PAGE_SHIFT;
 			md->attribute |= m_attr;
-- 
2.12.0


--3MwIy2ne0vdjdPXF--
