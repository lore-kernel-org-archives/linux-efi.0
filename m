From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v3] efi: Request desired alignment via the PE/COFF headers
Date: Fri, 19 Jun 2015 13:21:47 +0100
Message-ID: <20150619122147.GC2776@codeblueprint.co.uk>
References: <1405007963-520-1-git-send-email-mbrown@fensystems.co.uk>
 <loom.20150615T232724-11@post.gmane.org>
 <55804C91.4030000@fensystems.co.uk>
 <20150616173725.GE13153@oranje.fc.hp.com>
 <20150618220241.GA2776@codeblueprint.co.uk>
 <558345EB.8010408@fensystems.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <558345EB.8010408-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Cc: Linn Crosetto <linn-VXdhtT5mjnY@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 18 Jun, at 11:27:55PM, Michael Brown wrote:
> On 18/06/15 23:02, Matt Fleming wrote:
> >On Tue, 16 Jun, at 11:37:25AM, Linn Crosetto wrote:
> >>I have been reverting this patch as a workaround. The fields need to be changed,
> >>but I am not that familiar with the code. Maybe there is a way to use a
> >>heuristic to calculate the best values based on init_sz?
> >
> >Linn, could you please provide some details of the system that you're
> >booting this kernel on? EDK2 does not include any checks for this
> >alignment requirement, which probably explains why no one else ever
> >caught this issue.
> >
> >I can't think of any way to fix this without simply doing a revert of
> >commit aeffc4928ea2 ("x86/efi: Request desired alignment via the PE/COFF
> >headers"). Especially since that patch was an optimisation and not a bug
> >fix.
> 
> I'm pretty sure that patch _is_ a bug fix, not just an optimisation.
> It looks as though the commit log message was changed from what I
> originally wrote:
> 
>    The kernel will align itself to the nearest boundary specified by the
>    kernel_alignment field in the bzImage header.  If the kernel is loaded
>    to an address which is not sufficiently aligned, it will therefore use
>    memory beyond that indicated solely by the init_size field.
> 
>    The PE/COFF headers now include a .bss section to describe the
>    requirements of the init_size field, but do not currently expose the
>    alignment requirement.  Consequently, a kernel loaded via the PE entry
>    point may still end up overwriting unexpected areas of memory.
> 
> to
> 
>    The EFI boot stub goes to great pains to relocate the kernel image to
>    an appropriately aligned address, as indicated by the ->kernel_alignment
>    field in the bzImage header.  However, for the PE stub entry case, we
>    can request that the EFI PE/COFF loader do the work for us.
> 
> If the patch is reverted, then I think it will cause undefined
> behaviour on some platforms (which happen to load the kernel to
> non-preferred alignment, and where the memory immediately after the
> loaded kernel happens to be in use for something).

I thought that we had previously established that this wasn't true?

On Fri, 11 Jul, at 01:18:43AM, Michael Brown wrote:
> > Is this actually true? There is code within the EFI boot stub to
> > allocate space for the kernel image and perform the relocation if it's
> > not already suitably aligned.
> > 
> > Or is the above paragraph referring to the previously merged patch?
> 
> The "...headers now include..." part was referring to the previously
> merged patch to add the .bss section.
> 
> I haven't actually looked at the code which performs the alignment; I
> was going on hpa's concern that merely exposing init_size would be
> insufficient due to the potential for alignment.  My understanding
> (possibly incorrect) was that the alignment was carried out using
> something simple along the lines of:
> 
>   new_kernel_start = align ( kernel_start, kernel_alignment );
>   memmove ( new_kernel_start, kernel_start, kernel_len );
> 
> i.e. that the memory used for alignment was not explicitly allocated.
> If the EFI boot stub instead allocates space for the aligned kernel
> using AllocatePages() (and allocates enough space for the whole of
> init_size), then the problem I described does not exist.

To which I replied with,

> Right, this shouldn't be a problem because we do in fact allocate space
> using the EFI boottime services in efi_relocate_kernel(), taking the
> alignment into account, and then perform the kernel image copy.
> 
> I still think your change makes sense, I'm just inclined to delete the
> paragraph referring to the corruption bug (which we've established
> doesn't exist).

Do we still have a bug?

-- 
Matt Fleming, Intel Open Source Technology Center
