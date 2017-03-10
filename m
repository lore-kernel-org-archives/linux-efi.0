From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: kexec regression since 4.9 caused by efi
Date: Fri, 10 Mar 2017 09:42:56 +0800
Message-ID: <20170310014256.GB2995@dhcp-128-65.nay.redhat.com>
References: <20170308201616.GC8598@vader>
 <20170309063806.GB17257@dhcp-128-65.nay.redhat.com>
 <20170309095408.GA17883@vader>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170309095408.GA17883@vader>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 03/09/17 at 01:54am, Omar Sandoval wrote:
> On Thu, Mar 09, 2017 at 02:38:06PM +0800, Dave Young wrote:
> > Add efi/kexec list.
> > 
> > On 03/08/17 at 12:16pm, Omar Sandoval wrote:
> 
> [snip]
> 
> > I have no more clue yet from your provided log, but the runtime value is
> > odd to me. It is set in below code:
> > 
> > arch/x86/platform/efi/efi.c: efi_systab_init()
> > 	efi_systab.runtime = data ?
> > 			     (void *)(unsigned long)data->runtime :
> > 			     (void *)(unsigne long)systab64->runtime;
> > 
> > Here data is the setup_data passed by kexec-tools from normal kernel to
> > kexec kernel, efi_setup_data structure is like below: 
> > struct efi_setup_data {
> >         u64 fw_vendor;
> >         u64 runtime;
> >         u64 tables;
> >         u64 smbios;
> >         u64 reserved[8];
> > };
> > 
> > kexec-tools get the runtime address from /sys/firmware/efi/runtime
> > 
> > So can you do some debuggin on your side, eg. see the sysfs runtime
> > value is correct or not. And add some printk in efi init path etc.
> 
> The attached patch fixes this for me.
> From 4b343f0b0b408469f28c973ea52877797a166313 Mon Sep 17 00:00:00 2001
> Message-Id: <4b343f0b0b408469f28c973ea52877797a166313.1489053164.git.osandov-b10kYP2dOMg@public.gmane.org>
> From: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>
> Date: Thu, 9 Mar 2017 01:46:19 -0800
> Subject: [PATCH] efi: adjust virt_addr when splitting descriptors in
>  efi_memmap_insert()
> 
> When we split efi memory descriptors, we adjust the physical address but
> not the virtual address it maps to. This leads to bogus memory mappings
> later when these virtual addresses are used.
> 
> This fixes a kexec boot regression since 8e80632fb23f ("efi/esrt: Use
> efi_mem_reserve() and avoid a kmalloc()"), although the bug was only
> exposed by that commit.
> 
> Signed-off-by: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>
> ---
>  drivers/firmware/efi/memmap.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/firmware/efi/memmap.c b/drivers/firmware/efi/memmap.c
> index 78686443cb37..ca614db76faf 100644
> --- a/drivers/firmware/efi/memmap.c
> +++ b/drivers/firmware/efi/memmap.c
> @@ -298,6 +298,7 @@ void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
>  			memcpy(new, old, old_memmap->desc_size);
>  			md = new;
>  			md->phys_addr = m_end + 1;
> +			md->virt_addr += md->phys_addr - start;
>  			md->num_pages = (end - md->phys_addr + 1) >>
>  				EFI_PAGE_SHIFT;
>  		}
> @@ -312,6 +313,7 @@ void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
>  			md = new;
>  			md->attribute |= m_attr;
>  			md->phys_addr = m_start;
> +			md->virt_addr += md->phys_addr - start;
>  			md->num_pages = (m_end - m_start + 1) >>
>  				EFI_PAGE_SHIFT;
>  			/* last part */
> @@ -319,6 +321,7 @@ void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
>  			memcpy(new, old, old_memmap->desc_size);
>  			md = new;
>  			md->phys_addr = m_end + 1;
> +			md->virt_addr += md->phys_addr - start;
>  			md->num_pages = (end - m_end) >>
>  				EFI_PAGE_SHIFT;
>  		}
> @@ -333,6 +336,7 @@ void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
>  			memcpy(new, old, old_memmap->desc_size);
>  			md = new;
>  			md->phys_addr = m_start;
> +			md->virt_addr += md->phys_addr - start;
>  			md->num_pages = (end - md->phys_addr + 1) >>
>  				EFI_PAGE_SHIFT;
>  			md->attribute |= m_attr;
> -- 
> 2.12.0
> 

Nice, thanks for the debugging, so the problem is clear now.

Just Runtime areas are not necessarily to be reserved, for boot areas no
need to update the virt address. But I'm not sure about the fakemem
usage of this.

So need comments from Matt..

Thanks
Dave
