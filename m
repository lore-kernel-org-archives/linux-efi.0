From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 31/32] x86: Add sysfs support for Secure Memory
	Encryption
Date: Fri, 28 Apr 2017 13:32:33 +0800
Message-ID: <20170428053233.GA6149@dhcp-128-65.nay.redhat.com>
References: <20170418211612.10190.82788.stgit@tlendack-t1.amdoffice.net>
	<20170418212212.10190.73484.stgit@tlendack-t1.amdoffice.net>
	<1498ec98-b19d-c47d-902b-a68870a3f860@intel.com>
	<20170427072547.GB15297@dhcp-128-65.nay.redhat.com>
	<1f034974-20e6-b5e9-e6ff-434b634e1522@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1f034974-20e6-b5e9-e6ff-434b634e1522-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEmw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 04/27/17 at 08:52am, Dave Hansen wrote:
> On 04/27/2017 12:25 AM, Dave Young wrote:
> > On 04/21/17 at 02:55pm, Dave Hansen wrote:
> >> On 04/18/2017 02:22 PM, Tom Lendacky wrote:
> >>> Add sysfs support for SME so that user-space utilities (kdump, etc.) can
> >>> determine if SME is active.
> >>>
> >>> A new directory will be created:
> >>>   /sys/kernel/mm/sme/
> >>>
> >>> And two entries within the new directory:
> >>>   /sys/kernel/mm/sme/active
> >>>   /sys/kernel/mm/sme/encryption_mask
> >>
> >> Why do they care, and what will they be doing with this information?
> > 
> > Since kdump will copy old memory but need this to know if the old memory
> > was encrypted or not. With this sysfs file we can know the previous SME
> > status and pass to kdump kernel as like a kernel param.
> > 
> > Tom, have you got chance to try if it works or not?
> 
> What will the kdump kernel do with it though?  We kexec() into that
> kernel so the SME keys will all be the same, right?  So, will the kdump
> kernel be just setting the encryption bit in the PTE so it can copy the
> old plaintext out?

I assume it is for active -> non active case, the new boot need to know
the old memory is encrypted. But I think I did not read all the patches
I may miss things.

> 
> Why do we need both 'active' and 'encryption_mask'?  How could it be
> that the hardware-enumerated 'encryption_mask' changes across a kexec()?

Leave this question to Tom..

Thanks
Dave
