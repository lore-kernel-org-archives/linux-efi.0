From: Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 12/24] PCI: Lock down BAR access when the kernel is
 locked down
Date: Tue, 18 Apr 2017 12:50:54 -0500
Message-ID: <20170418175054.GA25295@bhelgaas-glaptop.roam.corp.google.com>
References: <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
 <149142337836.5101.13971561682218232219.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <149142337836.5101.13971561682218232219.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 05, 2017 at 09:16:18PM +0100, David Howells wrote:
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
> cc: linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Acked-by: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

> ---
> 
>  drivers/pci/pci-sysfs.c |    9 +++++++++
>  drivers/pci/proc.c      |    8 +++++++-
>  drivers/pci/syscall.c   |    2 +-
>  3 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 25d010d449a3..f70b3668036f 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -727,6 +727,9 @@ static ssize_t pci_write_config(struct file *filp, struct kobject *kobj,
>  	loff_t init_off = off;
>  	u8 *data = (u8 *) buf;
>  
> +	if (kernel_is_locked_down())
> +		return -EPERM;
> +
>  	if (off > dev->cfg_size)
>  		return 0;
>  	if (off + count > dev->cfg_size) {
> @@ -1018,6 +1021,9 @@ static int pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
>  	resource_size_t start, end;
>  	int i;
>  
> +	if (kernel_is_locked_down())
> +		return -EPERM;
> +
>  	for (i = 0; i < PCI_ROM_RESOURCE; i++)
>  		if (res == &pdev->resource[i])
>  			break;
> @@ -1117,6 +1123,9 @@ static ssize_t pci_write_resource_io(struct file *filp, struct kobject *kobj,
>  				     struct bin_attribute *attr, char *buf,
>  				     loff_t off, size_t count)
>  {
> +	if (kernel_is_locked_down())
> +		return -EPERM;
> +
>  	return pci_resource_io(filp, kobj, attr, buf, off, count, true);
>  }
>  
> diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
> index f82710a8694d..139d6f09ae7b 100644
> --- a/drivers/pci/proc.c
> +++ b/drivers/pci/proc.c
> @@ -116,6 +116,9 @@ static ssize_t proc_bus_pci_write(struct file *file, const char __user *buf,
>  	int size = dev->cfg_size;
>  	int cnt;
>  
> +	if (kernel_is_locked_down())
> +		return -EPERM;
> +
>  	if (pos >= size)
>  		return 0;
>  	if (nbytes >= size)
> @@ -195,6 +198,9 @@ static long proc_bus_pci_ioctl(struct file *file, unsigned int cmd,
>  #endif /* HAVE_PCI_MMAP */
>  	int ret = 0;
>  
> +	if (kernel_is_locked_down())
> +		return -EPERM;
> +
>  	switch (cmd) {
>  	case PCIIOC_CONTROLLER:
>  		ret = pci_domain_nr(dev->bus);
> @@ -233,7 +239,7 @@ static int proc_bus_pci_mmap(struct file *file, struct vm_area_struct *vma)
>  	struct pci_filp_private *fpriv = file->private_data;
>  	int i, ret, write_combine;
>  
> -	if (!capable(CAP_SYS_RAWIO))
> +	if (!capable(CAP_SYS_RAWIO) || kernel_is_locked_down())
>  		return -EPERM;
>  
>  	/* Make sure the caller is mapping a real resource for this device */
> diff --git a/drivers/pci/syscall.c b/drivers/pci/syscall.c
> index 9bf993e1f71e..c09524738ceb 100644
> --- a/drivers/pci/syscall.c
> +++ b/drivers/pci/syscall.c
> @@ -92,7 +92,7 @@ SYSCALL_DEFINE5(pciconfig_write, unsigned long, bus, unsigned long, dfn,
>  	u32 dword;
>  	int err = 0;
>  
> -	if (!capable(CAP_SYS_ADMIN))
> +	if (!capable(CAP_SYS_ADMIN) || kernel_is_locked_down())
>  		return -EPERM;
>  
>  	dev = pci_get_bus_and_slot(bus, dfn);
> 
