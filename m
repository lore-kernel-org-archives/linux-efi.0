From: "Elliott, Robert (Persistent Memory)" <elliott-ZPxbGqLxI0U@public.gmane.org>
Subject: RE: [PATCH 1/4] x86/efi: show actual ending addresses in
 efi_print_memmap
Date: Tue, 22 Dec 2015 20:08:19 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295BEC74CF@G9W0745.americas.hpqcorp.net>
References: <1450402114-3606-1-git-send-email-elliott@hpe.com>
 <1450402114-3606-2-git-send-email-elliott@hpe.com>
 <20151221155038.GD4227@codeblueprint.co.uk>
 <20151221160629.GF4227@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151221160629.GF4227-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



---
Robert Elliott, HPE Persistent Memory


> -----Original Message-----
> From: linux-kernel-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-kernel-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Matt Fleming
> Sent: Monday, December 21, 2015 10:06 AM
> To: Elliott, Robert (Persistent Memory) <elliott-ZPxbGqLxI0U@public.gmane.org>
> Cc: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org; mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org; x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org;
> linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH 1/4] x86/efi: show actual ending addresses in
> efi_print_memmap
> 
> On Mon, 21 Dec, at 03:50:38PM, Matt Fleming wrote:
> > On Thu, 17 Dec, at 07:28:31PM, Robert Elliott wrote:
> > > Adjust efi_print_memmap to print the real end address of each
> > > range, not 1 byte beyond. This matches other prints like those for
> > > SRAT and nosave memory.
> > >
> > > Change the closing ) to ] to match the opening [.
> > >
> > > old:
> > >     efi: mem61: [Persistent Memory  |   |  |  |  |  |  |
> |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c80000000) (16384MB)
> > >
> > > new:
> > >     efi: mem61: [Persistent Memory  |   |  |  |  |  |  |
> |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff] (16384MB)
> > >
> > > Example other address range prints:
> > >     SRAT: Node 1 PXM 1 [mem 0x480000000-0x87fffffff]
> > >     PM: Registered nosave memory: [mem 0x880000000-0xc7fffffff]
> > >
> > > Signed-off-by: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
> > > ---
> > >  arch/x86/platform/efi/efi.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > Is this change purely for aesthetic reasons? We're usually not in the
> > habit of changing the output of print messages without a good reason
> > because people downstream do rely on them being consistent.
> 
> I just noticed the bracket change.
> 
> My comment above only refers to printing the range addresses. Swapping
> ')' for ']' is a perfectly valid change.

While investigating the grub persistent memory corruption
issues, it was helpful to make this table match the ending
address convention used by:
* the kernel's e820 table prints
* the kernel's nosave memory prints
* grub's lsmmap and lsefimmap commands
* the UEFI shell's memmap command

Using the excerpts from the patch, if you grep all the various
logs for c7fffffff, you won't find the line with c80000000.
