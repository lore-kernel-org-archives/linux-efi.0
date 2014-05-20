From: "Jan Beulich" <JBeulich@suse.com>
Subject: Re: [PATCH v4 1/5] efi: Introduce EFI_DIRECT flag
Date: Tue, 20 May 2014 07:16:22 +0100
Message-ID: <537B0F560200007800013E3E@mail.emea.novell.com>
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
	<1400272904-31121-2-git-send-email-daniel.kiper@oracle.com>
	<537A23A50200007800013A7F@mail.emea.novell.com>
	<20140519204657.GB3529@olila.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <20140519204657.GB3529@olila.local.net-space.pl>
Content-Disposition: inline
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: mjg59@srcf.ucam.org, jeremy@goop.org, matt.fleming@intel.com, ian.campbell@citrix.com, stefano.stabellini@eu.citrix.com, linux-efi@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, david.vrabel@citrix.com, hpa@zytor.com, xen-devel@lists.xenproject.org, tglx@linutronix.de, boris.ostrovsky@oracle.com, eshelton@pobox.com
List-Id: linux-efi@vger.kernel.org

>>> On 19.05.14 at 22:46, <daniel.kiper@oracle.com> wrote:
> On Mon, May 19, 2014 at 02:30:45PM +0100, Jan Beulich wrote:
>> >>> On 16.05.14 at 22:41, <daniel.kiper@oracle.com> wrote:
>> > @@ -457,6 +460,21 @@ void __init efi_free_boot_services(void)
>> >  	efi_unmap_memmap();
>> >  }
>> >
>> > +static void __init __iomem *efi_early_ioremap(resource_size_t phys_addr,
>> > +							unsigned long size)
>> > +{
>> > +	if (efi_enabled(EFI_DIRECT))
>> > +		return early_ioremap(phys_addr, size);
>> > +
>> > +	return (__force void __iomem *)phys_addr;
>>
>> Now that surely needs some explanation: I can't see how this can
>> ever be correct, Xen or not being completely irrelevant.
> 
> I hope that efi_enabled(EFI_DIRECT) is obvious. However, in case of
> !efi_enabled(EFI_DIRECT) some structures are created artificially
> and they live in virtual address space. So that is why they should
> not be mapped. If you wish I could add relevant comment here.

That would be the very minimum I suppose. But I wonder whether
you wouldn't be better off storing their physical addresses in the
first place (and then decide whether you can stay with early_ioremap()
or want/need to use early_memremap() if !EFI_DIRECT).

Jan
