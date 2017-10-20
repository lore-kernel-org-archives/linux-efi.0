From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 10/27] PCI: Lock down BAR access when the kernel is
 locked down
Date: Fri, 20 Oct 2017 14:42:26 +0800
Message-ID: <20171020064226.GR3285@linux-l9pv.suse>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
 <150842470945.7923.134066103094708461.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <150842470945.7923.134066103094708461.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 19, 2017 at 03:51:49PM +0100, David Howells wrote:
> From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> 
> Any hardware that can potentially generate DMA has to be locked down in
> order to avoid it being possible for an attacker to modify kernel code,
> allowing them to circumvent disabled module loading or module signing.
> Default to paranoid - in future we can potentially relax this for
> sufficiently IOMMU-isolated devices.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Acked-by: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

I have reviewed this patch. Please feel free to add:

Reviewed-by: "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>

Thanks a lot!
Joey Lee

> cc: linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
> 
>  drivers/pci/pci-sysfs.c |    9 +++++++++
>  drivers/pci/proc.c      |    9 ++++++++-
>  drivers/pci/syscall.c   |    3 ++-
>  3 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 1eecfa301f7f..e1a3b0e765c2 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -881,6 +881,9 @@ static ssize_t pci_write_config(struct file *filp, struct kobject *kobj,
>  	loff_t init_off = off;
>  	u8 *data = (u8 *) buf;
>  
> +	if (kernel_is_locked_down("Direct PCI access"))
> +		return -EPERM;
> +
>  	if (off > dev->cfg_size)
>  		return 0;
>  	if (off + count > dev->cfg_size) {
> @@ -1175,6 +1178,9 @@ static int pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
>  	enum pci_mmap_state mmap_type;
>  	struct resource *res = &pdev->resource[bar];
>  
> +	if (kernel_is_locked_down("Direct PCI access"))
> +		return -EPERM;
> +
>  	if (res->flags & IORESOURCE_MEM && iomem_is_exclusive(res->start))
>  		return -EINVAL;
>  
> @@ -1255,6 +1261,9 @@ static ssize_t pci_write_resource_io(struct file *filp, struct kobject *kobj,
>  				     struct bin_attribute *attr, char *buf,
>  				     loff_t off, size_t count)
>  {
> +	if (kernel_is_locked_down("Direct PCI access"))
> +		return -EPERM;
> +
>  	return pci_resource_io(filp, kobj, attr, buf, off, count, true);
>  }
>  
> diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
> index 098360d7ff81..a6c53d855daa 100644
> --- a/drivers/pci/proc.c
> +++ b/drivers/pci/proc.c
> @@ -116,6 +116,9 @@ static ssize_t proc_bus_pci_write(struct file *file, const char __user *buf,
>  	int size = dev->cfg_size;
>  	int cnt;
>  
> +	if (kernel_is_locked_down("Direct PCI access"))
> +		return -EPERM;
> +
>  	if (pos >= size)
>  		return 0;
>  	if (nbytes >= size)
> @@ -195,6 +198,9 @@ static long proc_bus_pci_ioctl(struct file *file, unsigned int cmd,
>  #endif /* HAVE_PCI_MMAP */
>  	int ret = 0;
>  
> +	if (kernel_is_locked_down("Direct PCI access"))
> +		return -EPERM;
> +
>  	switch (cmd) {
>  	case PCIIOC_CONTROLLER:
>  		ret = pci_domain_nr(dev->bus);
> @@ -236,7 +242,8 @@ static int proc_bus_pci_mmap(struct file *file, struct vm_area_struct *vma)
>  	struct pci_filp_private *fpriv = file->private_data;
>  	int i, ret, write_combine = 0, res_bit = IORESOURCE_MEM;
>  
> -	if (!capable(CAP_SYS_RAWIO))
> +	if (!capable(CAP_SYS_RAWIO) ||
> +	    kernel_is_locked_down("Direct PCI access"))
>  		return -EPERM;
>  
>  	if (fpriv->mmap_state == pci_mmap_io) {
> diff --git a/drivers/pci/syscall.c b/drivers/pci/syscall.c
> index 9bf993e1f71e..afa01cc3ceec 100644
> --- a/drivers/pci/syscall.c
> +++ b/drivers/pci/syscall.c
> @@ -92,7 +92,8 @@ SYSCALL_DEFINE5(pciconfig_write, unsigned long, bus, unsigned long, dfn,
>  	u32 dword;
>  	int err = 0;
>  
> -	if (!capable(CAP_SYS_ADMIN))
> +	if (!capable(CAP_SYS_ADMIN) ||
> +	    kernel_is_locked_down("Direct PCI access"))
>  		return -EPERM;
>  
>  	dev = pci_get_bus_and_slot(bus, dfn);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
