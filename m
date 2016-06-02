From: Alex Thorlton <athorlton@sgi.com>
Subject: Re: [PATCH 2/3] Update uv_bios_call to use efi_call_virt_generic
Date: Thu, 2 Jun 2016 16:14:03 -0500
Message-ID: <20160602211403.GD242721@stormcage.americas.sgi.com>
References: <1463598701-178201-1-git-send-email-athorlton@sgi.com>
 <1463598701-178201-3-git-send-email-athorlton@sgi.com>
 <20160602194547.GK2658@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160602194547.GK2658@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>, Russ Anderson <rja@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 02, 2016 at 08:45:47PM +0100, Matt Fleming wrote:
> Unless I've missed it, I didn't see an explanation in the changelog of
> why it's OK to switch from using __va(tab->function) to tab->function
> directly, which presumably is a physical address.
> 
> Was that intended?

It was intended.  The motivation is so that we can use the same
"dereference the pointer inside the macro" stuff that we do with the
efi.systab->runtime pointer.  IINM, the reason it works is because we do

/*
 * Make sure the 1:1 mappings are present as a catch-all for b0rked
 * firmware which doesn't update all internal pointers after switching
 * to virtual mode and would otherwise crap on us.
 */
__map_region(md, md->phys_addr);

Inside of efi_map_region, so we know we'll have that physical address
mapped into the EFI page table.

Upon review, I'm wondering if the correct thing to do  here is to
update that pointer during the switch to virtual mode, to avoid the
b0rkage mentioned in the above comment.

Either way, the straigh tab->function dereference should work while
using the EFI page table, but I do wonder if that tab->function address
should have been updated to the __va() version of itself before we reach
this point.

Maybe you can comment on that?

- Alex
