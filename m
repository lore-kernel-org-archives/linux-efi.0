From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v4 26/28] x86: Allow kexec to be used with SME
Date: Wed, 1 Mar 2017 17:25:36 +0800
Message-ID: <20170301092536.GB8353@dhcp-128-65.nay.redhat.com>
References: <20170216154158.19244.66630.stgit@tlendack-t1.amdoffice.net>
	<20170216154755.19244.51276.stgit@tlendack-t1.amdoffice.net>
	<20170217155756.GJ30272@char.us.ORACLE.com>
	<d2f16b24-f2ef-a22b-3c72-2d8ad585553e@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d2f16b24-f2ef-a22b-3c72-2d8ad585553e-5C7GfCeVMHo@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Tom,

On 02/17/17 at 10:43am, Tom Lendacky wrote:
> On 2/17/2017 9:57 AM, Konrad Rzeszutek Wilk wrote:
> > On Thu, Feb 16, 2017 at 09:47:55AM -0600, Tom Lendacky wrote:
> > > Provide support so that kexec can be used to boot a kernel when SME is
> > > enabled.
> > 
> > Is the point of kexec and kdump to ehh, dump memory ? But if the
> > rest of the memory is encrypted you won't get much, will you?
> 
> Kexec can be used to reboot a system without going back through BIOS.
> So you can use kexec without using kdump.
> 
> For kdump, just taking a quick look, the option to enable memory
> encryption can be provided on the crash kernel command line and then

Is there a simple way to get the SME status? Probably add some sysfs
file for this purpose.

> crash kernel can would be able to copy the memory decrypted if the
> pagetable is set up properly. It looks like currently ioremap_cache()
> is used to map the old memory page.  That might be able to be changed
> to a memremap() so that the encryption bit is set in the mapping. That
> will mean that memory that is not marked encrypted (EFI tables, swiotlb
> memory, etc) would not be read correctly.

Manage to store info about those ranges which are not encrypted so that
memremap can handle them?

> 
> > 
> > Would it make sense to include some printk to the user if they
> > are setting up kdump that they won't get anything out of it?
> 
> Probably a good idea to add something like that.

It will break kdump functionality, it should be fixed instead of
just adding printk to warn user..

Thanks
Dave
