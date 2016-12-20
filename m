From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi/libstub: arm*: double cast memory_map to hide
 compiler warning
Date: Tue, 20 Dec 2016 14:07:28 +0000
Message-ID: <20161220140728.GE2225@codeblueprint.co.uk>
References: <20161220113956.GB2225@codeblueprint.co.uk>
 <20161220135207.32492-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161220135207.32492-1-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 20 Dec, at 01:52:07PM, James Morse wrote:
> "efi/libstub: arm*: Pass latest memory map to the kernel" added a new
> call to update fdt in-place. This caused a new warning on 32bit ARM:
> 
> ../drivers/firmware/efi/libstub/fdt.c: In function 'allocate_new_fdt_and_exit_boot':
> ../drivers/firmware/efi/libstub/fdt.c:303:9: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>          (u64)memory_map, (u32)map_size);
>          ^
> 
> Cast to an integer of native pointer size first.
> 
> Reported-by: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
> ---
> I guess this too needs to go to stable unless you intend to squash it?
> 
>  drivers/firmware/efi/libstub/fdt.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Thanks James, I've folded this into your previous patch.
