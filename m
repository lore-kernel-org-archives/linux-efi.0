From: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 2/9] arch/x86: Do not access EFI memory map if it is
 not available
Date: Mon, 23 Jun 2014 16:13:10 +0200
Message-ID: <20140623141310.GI28489@olila.local.net-space.pl>
References: <1403299768-9955-1-git-send-email-daniel.kiper@oracle.com>
 <1403299768-9955-3-git-send-email-daniel.kiper@oracle.com>
 <53A7F8FF.2050309@citrix.com>
 <53A824D1020000780001C630@mail.emea.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <53A824D1020000780001C630-tRfBTM6QL9aeHWOVceGJHFaTQe2KTcn/@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Cc: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Jun 23, 2014 at 12:00:01PM +0100, Jan Beulich wrote:
> >>> On 23.06.14 at 11:53, <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org> wrote:
> > On 20/06/14 22:29, Daniel Kiper wrote:
> >> Do not access EFI memory map if it is not available. At least
> >> Xen dom0 EFI implementation does not have an access to it.
> >
> > Could it make one based on the XENMEM_memory_map or
> > XENMEM_machine_memory_map hypercall?
>
> No, the correct operation to implement this and efi_mem_type()
> similar function is XEN_FW_EFI_INFO, index XEN_FW_EFI_MEM_INFO.

efi_mem_attributes() is used only on IA-64 arch. So, that is why
I completely removed relevant Xen code.

Daniel
