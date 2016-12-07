From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 4/4] efi: Skip parsing of EFI_PROPERTIES_TABLE if
 EFI_MEMORY_ATTRIBUTES_TABLE is detected
Date: Wed, 7 Dec 2016 13:36:45 +0000
Message-ID: <20161207133645.GB17720@codeblueprint.co.uk>
References: <1481051763-8705-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1481051763-8705-5-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1481051763-8705-5-git-send-email-sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 06 Dec, at 11:16:03AM, Sai Praneeth Prakhya wrote:
> From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> UEFI specification v2.6 recommends not to use
> "EFI_PROPERTIES_RUNTIME_MEMORY_PROTECTION_NON_EXECUTABLE_PE_DATA"
> attribute of EFI_PROPERTIES_TABLE. Presently, this is the *only* bit
> defined in EFI_PROPERTIES_TABLE. This bit implies that EFI Runtime code
> and data regions of an executable image are separate and are aligned as
> specified in spec. Please refer to "EFI_PROPERTIES_TABLE" in section 4.6
> of UEFI specification v2.6 for more information on this table.
> 
> UEFI v2.6 introduces EFI_MEMORY_ATTRIBUTES_TABLE and is intended to
> replace EFI_PROPERTIES_TABLE. If EFI_MEMORY_ATTRIBUTES_TABLE is found we
> skip updating of efi runtime region mappings based on
> EFI_PROPERTIES_TABLE, so let's also skip parsing of EFI_PROPERTIES_TABLE
> if we find EFI_MEMORY_ATTRIBUTES_TABLE because we are not using this
> table anyways. The only caveat here is, if further versions of UEFI spec
> adds some more bits (hence some more attributes) to EFI_PROPERTIES_TABLE
> then we might need to parse it again, otherwise there is no good in
> doing that. We can also expect that the same attributes might be reflected in
> EFI_MEMORY_ATTRIBUTES_TABLE and hence saving us from parsing
> EFI_PROPERTIES_TABLE again.
> 
> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
> Cc: Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/firmware/efi/efi.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)

I see where you're coming from with this patch, but I think it's
unnecessary. Turning on/off parsing of Table A based on existence of
Table B just seems like extra work.
