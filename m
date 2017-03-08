From: Dave Young <dyoung@redhat.com>
Subject: Re: [RFC PATCH v4 26/28] x86: Allow kexec to be used with SME
Date: Wed, 8 Mar 2017 16:12:28 +0800
Message-ID: <20170308081228.GD11045@dhcp-128-65.nay.redhat.com>
References: <20170216154158.19244.66630.stgit@tlendack-t1.amdoffice.net>
 <20170216154755.19244.51276.stgit@tlendack-t1.amdoffice.net>
 <20170217155756.GJ30272@char.us.ORACLE.com>
 <d2f16b24-f2ef-a22b-3c72-2d8ad585553e@amd.com>
 <20170301092536.GB8353@dhcp-128-65.nay.redhat.com>
 <998eb58b-eefd-3093-093f-9ae25ddda472@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <998eb58b-eefd-3093-093f-9ae25ddda472@amd.com>
Sender: owner-linux-mm@kvack.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, "Michael S. Tsirkin" <mst@redhat.com>, Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>, Ingo Molnar <mingo@redhat.com>, Alexander Potapenko <glider@google.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa>
List-Id: linux-efi@vger.kernel.org

On 03/06/17 at 11:58am, Tom Lendacky wrote:
> On 3/1/2017 3:25 AM, Dave Young wrote:
> > Hi Tom,
> 
> Hi Dave,
> 
> > 
> > On 02/17/17 at 10:43am, Tom Lendacky wrote:
> > > On 2/17/2017 9:57 AM, Konrad Rzeszutek Wilk wrote:
> > > > On Thu, Feb 16, 2017 at 09:47:55AM -0600, Tom Lendacky wrote:
> > > > > Provide support so that kexec can be used to boot a kernel when SME is
> > > > > enabled.
> > > > 
> > > > Is the point of kexec and kdump to ehh, dump memory ? But if the
> > > > rest of the memory is encrypted you won't get much, will you?
> > > 
> > > Kexec can be used to reboot a system without going back through BIOS.
> > > So you can use kexec without using kdump.
> > > 
> > > For kdump, just taking a quick look, the option to enable memory
> > > encryption can be provided on the crash kernel command line and then
> > 
> > Is there a simple way to get the SME status? Probably add some sysfs
> > file for this purpose.
> 
> Currently there is not.  I can look at adding something, maybe just the
> sme_me_mask value, which if non-zero, would indicate SME is active.
> 
> > 
> > > crash kernel can would be able to copy the memory decrypted if the
> > > pagetable is set up properly. It looks like currently ioremap_cache()
> > > is used to map the old memory page.  That might be able to be changed
> > > to a memremap() so that the encryption bit is set in the mapping. That
> > > will mean that memory that is not marked encrypted (EFI tables, swiotlb
> > > memory, etc) would not be read correctly.
> > 
> > Manage to store info about those ranges which are not encrypted so that
> > memremap can handle them?
> 
> I can look into whether something can be done in this area. Any input
> you can provide as to what would be the best way/place to store the
> range info so kdump can make use of it, would be greatly appreciated.

Previously to support efi runtime in kexec, I passed some efi
infomation via setup_data, see below userspace kexec-tools commit:
e1ffc9e9a0769e1f54185003102e9bec428b84e8, it was what Boris mentioned
about the setup_data use case for kexec.

Suppose you have successfully tested kexec reboot, so the EFI tables you
mentioned should be those area in old mem for copying /proc/vmcore? If
only EFI tables and swiotlb maybe not worth to passing those stuff
across kexec reboot.

I have more idea about this for now..
> 
> > 
> > > 
> > > > 
> > > > Would it make sense to include some printk to the user if they
> > > > are setting up kdump that they won't get anything out of it?
> > > 
> > > Probably a good idea to add something like that.
> > 
> > It will break kdump functionality, it should be fixed instead of
> > just adding printk to warn user..
> 
> I do want kdump to work. I'll investigate further what can be done in
> this area.

Thanks a lot!

Dave

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
