From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 0/4] UEFI: EFI_MEMORY_ATTRIBUTES_TABLE support for x86
Date: Wed, 7 Dec 2016 13:26:59 +0000
Message-ID: <20161207132659.GV20785@codeblueprint.co.uk>
References: <1481051763-8705-1-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1481051763-8705-1-git-send-email-sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 06 Dec, at 11:15:59AM, Sai Praneeth Prakhya wrote:
> From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> UEFI v2.6 introduces EFI_MEMORY_ATTRIBUTES_TABLE which describes memory 
> protections that may be applied to EFI Runtime code and data regions by 
> kernel. This helps kernel to map efi runtime regions more strictly and 
> hence allowing only appropriate accesses to these regions. Please refer 
> to "EFI_MEMORY_ATTRIBUTES_TABLE" in section 4.6 of UEFI specification 
> v2.6 for more information on this table.
 
I guess this is v3 of your patch series right? Please be sure to
include a version tag in future like you did for you v2. 
