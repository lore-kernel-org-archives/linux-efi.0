From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH v4 1/5] efi: Introduce EFI_DIRECT flag
Date: Thu, 22 May 2014 08:26:01 +0100
Message-ID: <20140522072601.GP4798@console-pimps.org>
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
	<1400272904-31121-2-git-send-email-daniel.kiper@oracle.com>
	<537A2A28.4010903@citrix.com>
	<20140519210255.GC3529@olila.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
Content-Disposition: inline
In-Reply-To: <20140519210255.GC3529@olila.local.net-space.pl>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: mjg59@srcf.ucam.org, jeremy@goop.org, linux-efi@vger.kernel.org, ian.campbell@citrix.com, x86@kernel.org, linux-kernel@vger.kernel.org, matt.fleming@intel.com, tglx@linutronix.de, David Vrabel <david.vrabel@citrix.com>, jbeulich@suse.com, hpa@zytor.com, xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com, mingo@redhat.com, stefano.stabellini@eu.citrix.com, eshelton@pobox.com
List-Id: linux-efi@vger.kernel.org

On Mon, 19 May, at 11:02:55PM, Daniel Kiper wrote:
> 
> It is correct. As I said earlier: in case of !efi_enabled(EFI_DIRECT) some
> structures are created artificially and they live in virtual address space.
> So that is why they should not be mapped.
 
So, exploring Jan's idea, is it not possible to store the physical
address and have early_ioremap() just work? Even if they're mapping in
virtual address space they must have a corresponding physical address.

We really need to be keeping these kinds of special code paths to a
minimum. Unless absolutely necessary there should be just one way to do
things.

> I was going to have EFI_DIRECT close to EFI_BOOT which is quite generic
> and platform independent name like EFI_BOOT. However, I do not insist
> on having it in that place.

Right, please don't shuffle these bits.

-- 
Matt Fleming, Intel Open Source Technology Center
